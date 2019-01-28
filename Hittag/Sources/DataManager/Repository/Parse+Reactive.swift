import RxSwift
import Parse

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

//protocol PFQueryEquivalent {
//    associatedtype GenericType: PFObject
//    func asPFQuery() -> PFQuery<GenericType>
//}
//
//extension PFQuery: PFQueryEquivalent {
//    func asPFQuery() -> PFQuery<PFGenericObject> {
//        return self
//    }
//}
//
//extension Reactive where Base == PFQuery {
//    
//}
