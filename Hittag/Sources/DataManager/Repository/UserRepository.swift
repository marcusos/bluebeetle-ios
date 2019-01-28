import RxSwift
import Parse

public protocol UserRepositoryType {
    func current() -> Single<User>
    func posts() -> Observable<(User, [Post])>
}

final class UserRepository: UserRepositoryType {
    func current() -> Single<User> {
        return Single.create(subscribe: { emitter in
            if let current = PFUser.current() {
                emitter(.success(User(pfUser: current)))
            } else {
                emitter(.error(RxError.unknown))
            }
            return Disposables.create {}
        })
    }
    
    func posts() -> Observable<(User, [Post])> {
        let cached = self.requestPosts(cached: true)
        let live = self.requestPosts(cached: false)
        let user = self.current()
        
        let posts = cached.asObservable()
            .concat(live)
        
        return Observable.combineLatest(user.asObservable(), posts)
    }
    
    private func requestPosts(cached: Bool) -> Single<[Post]> {
        guard let user = PFUser.current() else { return Single.error(RxError.unknown) }
        
        return Single.create { emitter -> Disposable in
            let query = PFQuery(className:"Post")
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
        self.init(name: pfUser.facebookInfo?.name ?? "", image: pfUser.facebookInfo?.image)
    }
}
