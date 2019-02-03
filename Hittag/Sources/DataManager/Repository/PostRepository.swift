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
        return Observable.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.fromLocalDatastore()
            do {
                let pfPost = try query.getObjectWithId(postId)
                if let post = Post(pfObject: pfPost) {
                    emitter.on(.next(post))
                } else {
                    emitter.on(.error(RxError.unknown))
                }
            } catch {
                emitter.on(.error(RxError.unknown))
            }
            
            return Disposables.create {}
        }
    }
    
    private func update(postId: PostId, for user: PFUser) -> Observable<Post> {
        return Observable.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.fromLocalDatastore()
            do {
                let pfPost = try query.getObjectWithId(postId)
                var likes = Set(pfPost["likes"] as? [PFObject] ?? [])
                likes.insert(user)
                pfPost["likes"] = Array(likes)
                pfPost.saveEventually()
                if let updated = Post(pfObject: pfPost) {
                    emitter.on(.next(updated))
                } else {
                    emitter.on(.error(RxError.unknown))
                }
            } catch {
                emitter.on(.error(RxError.unknown))
            }
            
            return Disposables.create {}
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
