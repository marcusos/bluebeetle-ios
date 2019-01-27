import RxSwift
import Parse

protocol PostRepositoryType {
    func post(parameters: PostParameters) -> Completable
}

final class PostRepository: PostRepositoryType {
    
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
        return postObject.rx.saveInBackground()
    }
}

extension Reactive where Base == PFObject {
    func saveInBackground() -> Completable {
        return Completable.create(subscribe: { emitter -> Disposable in
            self.base.saveInBackground { (success, error) in
                if let error = error {
                    emitter(.error(error))
                } else if success {
                    emitter(.completed)
                } else {
                    emitter(.error(RxError.unknown))
                }
            }
            return Disposables.create {}
        })
    }
}

extension Reactive where Base == PFFileObject {
    func saveInBackground() -> Completable {
        return Completable.create(subscribe: { emitter -> Disposable in
            self.base.saveInBackground { (success, error) in
                if let error = error {
                    emitter(.error(error))
                } else if success {
                    emitter(.completed)
                } else {
                    emitter(.error(RxError.unknown))
                }
            }
            
            return Disposables.create {
                self.base.cancel()
            }
        })
    }
}
