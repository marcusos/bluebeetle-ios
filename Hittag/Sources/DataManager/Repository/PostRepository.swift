import Parse
import RxSwift

protocol PostRepositoryType {
    func like(post: Post) -> Observable<Post>
}

final class PostRepository: PostRepositoryType {
    func like(post: Post) -> Observable<Post> {
        return Observable.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.fromLocalDatastore()
            do {
                let pfPost = try query.getObjectWithId(post.id)
                pfPost.incrementKey("number_of_likes")
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
