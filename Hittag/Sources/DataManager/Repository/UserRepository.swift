import RxSwift
import Parse

public protocol UserRepositoryType {
    func current() -> Single<PFUser>
    func posts(user: User) -> Observable<[Post]>
}

final class UserRepository: UserRepositoryType {
    func posts(user: User) -> Observable<[Post]> {
        return self.requestUser(user: user)
            .asObservable()
            .flatMap { (user: PFUser) -> Observable<[Post]> in
                let cached = self.requestPosts(cached: true, user: user)
                let live = self.requestPosts(cached: false, user: user)
                return cached.asObservable()
                    .concat(live)
        }
    }
    
    func current() -> Single<PFUser> {
        return Single.deferred {
            if let current = PFUser.current() {
                return Single.just(current)
            }
            return Single.error(RxError.unknown)
        }
    }
    
    private func requestUser(user: User) -> Single<PFUser> {
        return Single.create { emitter in
            PFUser(withoutDataWithObjectId: user.id).fetchInBackground { object, error in
                if let error = error {
                    emitter(.error(error))
                } else if let user = object as? PFUser {
                    emitter(.success(user))
                } else {
                    emitter(.error(RxError.unknown))
                }
            }
            return Disposables.create()
        }
    }
    
    private func requestPosts(cached: Bool, user: PFUser) -> Single<[Post]> {
        return Single.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.addDescendingOrder("createdAt")
            query.whereKey("parent", equalTo: user)
            if cached {
                query.fromLocalDatastore()
            }
            query.findObjectsInBackground { (array, error) in
                if let error = error {
                    emitter(.error(error))
                } else {
                    PFObject.pinAll(inBackground: array)
                    let objects = (array ?? []).map(Post.init).compactMap { $0 }
                    emitter(.success(objects))
                }
            }
            return Disposables.create {
                query.cancel()
            }
        }
    }
}

extension User {
    init(pfUser: PFUser) {
        self.init(id: pfUser.objectId ?? "",
                  name: pfUser.facebookInfo?.name ?? "",
                  image: pfUser.facebookInfo?.image)
    }
}
