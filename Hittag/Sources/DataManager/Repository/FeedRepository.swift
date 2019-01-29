import RxSwift
import Parse

protocol FeedRepositoryType {
    func post(parameters: PostParameters) -> Completable
    func feed() -> Observable<[Post]>
    func like(post: Post) -> Completable
}

final class FeedRepository: FeedRepositoryType {
    
    private let refreshTrigger = PublishSubject<Void>()
    
    func feed() -> Observable<[Post]> {
        let cached = self.requestFeed(cached: true)
        let feed = self.requestFeed(cached: false)
        
        let refreshableFeed = self.refreshTrigger
            .flatMapLatest { _ in
                self.requestFeed(cached: false)
        }
        
        return cached.asObservable()
            .concat(feed)
            .concat(refreshableFeed)
    }
    
    func post(parameters: PostParameters) -> Completable {
        guard let imageObject = PFFileObject(name: "post.png", data: parameters.image) else {
            return Completable.error(RxError.unknown)
        }
        
        guard let currentUser = PFUser.current() else {
            return Completable.error(RxError.unknown)
        }
        
        let postObject = PFObject(className: "Post")
        postObject["image"] = imageObject
        postObject["parent"] = currentUser
        postObject["user_username"] = currentUser.facebookInfo?.name ?? ""
        postObject["user_email"] = currentUser.facebookInfo?.email ?? ""
        postObject["user_image"] = currentUser.facebookInfo?.image.absoluteString ?? ""
        return postObject.rx.saveInBackground()
            .do(onCompleted: { self.refreshTrigger.onNext(()) })
    }
    
    func like(post: Post) -> Completable {
        return Completable.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.fromLocalDatastore()
            do {
                let pfPost = try query.getObjectWithId(post.id)
                pfPost.incrementKey("number_of_likes")
                pfPost.saveInBackground { (success, error) in
                    if let error = error {
                        emitter(.error(error))
                    } else if success {
                        emitter(.completed)
                    } else {
                        emitter(.error(RxError.unknown))
                    }
                }
            } catch {
                emitter(.error(RxError.unknown))
            }
            
            return Disposables.create {}
        }
    }
    
    private func requestFeed(cached: Bool) -> Single<[Post]> {
        return Single.create { emitter -> Disposable in
            let query = PFQuery(className: "Post")
            query.addDescendingOrder("createdAt")
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

extension Post {
    init?(pfObject: PFObject) {
        guard let urlString = (pfObject["image"] as? PFFileObject)?.url,
            let url = URL(string: urlString) else {
                return nil
        }
        
        guard let username = pfObject["user_username"] as? String else {
            return nil
        }
        
        guard let userImageUrlString = pfObject["user_image"] as? String,
            let userImageUrl = URL(string: userImageUrlString) else {
            return nil
        }
        
        guard let userId = (pfObject["parent"] as? PFObject)?.objectId else {
            return nil
        }
        
        let numberOfLikes = pfObject["number_of_likes"] as? Int ?? 0
        
        self.id = pfObject.objectId ?? ""
        self.text = "Posto"
        self.image = url
        self.hashtags = []
        self.user = User(id: userId, name: username, image: userImageUrl)
        self.numberOfLikes = numberOfLikes
    }
}
