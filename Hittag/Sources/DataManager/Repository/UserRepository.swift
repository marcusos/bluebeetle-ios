import RxSwift
import Parse

public protocol UserRepositoryType {
    func current() -> Maybe<User>
    func signUp(credentials: UserCredentials) -> Single<User>
    func signIn(credentials: UserCredentials) -> Single<User>
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
    
    func signUp(credentials: UserCredentials) -> Single<User> {
        return Single<User>.create(subscribe: { emitter in
            let user = PFUser()
            user.email = credentials.email
            user.username = credentials.email
            user.password = credentials.password
            user.signUpInBackground { (success, error) in
                if let current = PFUser.current(), let username = current.username, success {
                    emitter(.success(User(name: username, image: nil)))
                } else if let error = error {
                    emitter(.error(error))
                } else {
                    emitter(.error(RxError.unknown))
                }
            }
            return Disposables.create {}
        })
        .flatMap { _ in self.signIn(credentials: credentials) }
    }
    
    func signIn(credentials: UserCredentials) -> Single<User> {
        return Single.create(subscribe: { emitter in
            PFUser.logInWithUsername(inBackground: credentials.email,
                                     password: credentials.password)
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
