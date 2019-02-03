import Parse
import RxSwift

protocol PostRepositoryType {
    func listenTo(postId: PostId) -> Observable<Post>
    func like(postId: PostId) -> Observable<Post>
}

final class PostRepository: PostRepositoryType {
    private let userRepository: UserRepositoryType
    private var likeObservable: [PostId: BehaviorSubject<Post>] = [:]
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }
    
    func listenTo(postId: PostId) -> Observable<Post> {
        return self.getPost(postId: postId).flatMap { post in
            return self.likeObservable.get(key: postId, orPut: { BehaviorSubject(value: post) })
        }
    }
    
    func like(postId: PostId) -> Observable<Post> {
        return self.userRepository.current()
            .asObservable()
            .flatMap { self.update(postId: postId, for: $0).distinctUntilChanged() }
            .do(onNext: { self.likeObservable[postId]?.onNext($0) })
    }
    
    private func getPost(postId: PostId) -> Observable<Post> {
        return self.getRawPost(postId: postId)
            .map { Post(pfObject: $0) }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    private func getRawPost(postId: PostId) -> Observable<PFObject> {
        return Observable.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.fromLocalDatastore()
            query.whereKey("objectId", equalTo: postId)
            query.findObjectsInBackground { (values, error) in
                if let first = values?.first {
                    emitter.on(.next(first))
                } else if let error = error {
                    emitter.on(.error(error))
                } else {
                    emitter.on(.error(RxError.unknown))
                }
            }
            return Disposables.create {}
        }
    }
    
    private func update(postId: PostId, for user: PFUser) -> Observable<Post> {
        return self.getRawPost(postId: postId)
            .flatMap { pfPost -> Observable<Post> in
                var likes = Set(pfPost["likes"] as? [PFObject] ?? [])
                likes.insert(user)
                pfPost["likes"] = Array(likes)
                pfPost.saveEventually()
                return Observable.just(Post(pfObject: pfPost)!)
        }
    }
}

extension Dictionary {
    mutating func get(key: Key, orPut: () -> Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            let value = orPut()
            self[key] = value
            return value
        }
    }
}
