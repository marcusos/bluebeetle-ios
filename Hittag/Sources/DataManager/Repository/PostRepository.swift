import Parse
import RxSwift

protocol PostRepositoryType {
    func like(post: Post) -> Observable<Post>
}

final class PostRepository: PostRepositoryType {
    private let userRepository: UserRepositoryType
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }
    
    func like(post: Post) -> Observable<Post> {
        return self.userRepository.current()
            .asObservable()
            .flatMap { user in
                self.update(post: post, for: user)
            }
    }
    
    private func update(post: Post, for user: PFUser) -> Observable<Post> {
        return Observable.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.fromLocalDatastore()
            do {
                let pfPost = try query.getObjectWithId(post.id)
                var likes = Set(pfPost["likes"] as? [PFObject] ?? [])
                likes.insert(user)
                pfPost["likes"] = Array(likes)
                pfPost.saveEventually()
                if let updated = Post(pfObject: pfPost) {
                    emitter.on(.next(updated))
                } else {
                    emitter.on(.next(post))
                }
            } catch {
                emitter.on(.error(RxError.unknown))
            }
            
            return Disposables.create {}
        }
    }
}
