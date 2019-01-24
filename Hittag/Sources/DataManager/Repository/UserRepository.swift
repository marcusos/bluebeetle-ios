import RxSwift
import Parse

public protocol UserRepositoryType {
    func current() -> Maybe<User>
    func signIn() -> Single<User>
}

public struct UserCredentials: Codable {
    public let email: String
    public let password: String
}

final class UserRepository: UserRepositoryType {
    func current() -> Maybe<User> {
        return Maybe.create(subscribe: { emitter in
            if let current = PFUser.current(), let username = current.username {
                emitter(.success(User(name: username, image: nil)))
            } else {
                emitter(.completed)
            }
            return Disposables.create {}
        })
    }
    
    func signIn() -> Single<User> {
        return Single.create(subscribe: { emitter in
            PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"])
            { user, error in
                if let current = PFUser.current(), let username = current.username {
                    emitter(.success(User(name: username, image: nil)))
                } else if let error = error {
                    emitter(.error(error))
                } else {
                    emitter(.error(RxError.unknown))
                }
            }
            return Disposables.create {}
        })
    }
}
