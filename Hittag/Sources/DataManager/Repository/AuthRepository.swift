import RxSwift
import Parse

protocol AuthRepositoryType {
    func current() -> Maybe<User>
    func signIn() -> Single<User>
}

final class AuthRepository: AuthRepositoryType {
    func current() -> Maybe<User> {
        return Maybe.create(subscribe: { emitter in
            if let current = PFUser.current() {
                emitter(.success(User(pfUser: current)))
            } else {
                emitter(.completed)
            }
            return Disposables.create {}
        })
    }
    
    func signIn() -> Single<User> {
        return self.loginIntoFacebook()
            .flatMap { user in
                self.facebookInfo().flatMap { info in
                    self.merge(user: user, info: info)
                }
            }
            .do(onError: { _ in PFUser.logOut() })
    }
    
    private func merge(user: PFUser, info: FacebookInfo) -> Single<User> {
        return Single.deferred {
            user.facebookInfo = info
            return Single.just(User(pfUser: user))
        }
    }
    
    private func loginIntoFacebook() -> Single<PFUser> {
        return Single.create(subscribe: { emitter in
            PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"])
            { user, error in
                if let current = PFUser.current() {
                    emitter(.success(current))
                } else if let error = error {
                    emitter(.error(error))
                } else {
                    emitter(.error(RxError.unknown))
                }
            }
            return Disposables.create {}
        })
    }
    
    private func facebookInfo() -> Single<FacebookInfo> {
        return Single.create(subscribe: { emitter in
            let token = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(large)"])?
                .start { (connection, result, error) in
                    if let info = FacebookInfo(result: result) {
                        emitter(.success(info))
                    } else {
                        emitter(.error(RxError.unknown))
                    }
            }
            return Disposables.create {
                token?.cancel()
            }
        })
    }
}

struct FacebookInfo: Codable {
    let name: String
    let email: String
    let image: URL
    
    init?(result: Any?) {
        guard let dictionary = result as? [String: Any] else {
            return nil
        }
        
        guard let pictureDictionary = dictionary["picture"] as? [String: Any],
            let pictureData = pictureDictionary["data"] as? [String: Any],
            let pictureUrlString = pictureData["url"] as? String,
            let pictureUrl = URL(string: pictureUrlString) else {
                return nil
        }
        
        guard let email = dictionary["email"] as? String else {
            return nil
        }
        
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.image = pictureUrl
    }
}

extension Encodable {
    func asJson() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
    }
}

extension Decodable {
    static func from(json: [String: Any]) throws -> Self {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}

extension PFUser {
    var facebookInfo: FacebookInfo? {
        get {
            guard let json = self.value(forKey: "facebookInfo") as? [String: Any] else { return nil }
            do {
                return try FacebookInfo.from(json: json)
            } catch {
                return nil
            }
        }
        set {
            do {
                try self.setValue(newValue.asJson(), forKey: "facebookInfo")
                self.saveInBackground()
            }
            catch {}
        }
    }
}
