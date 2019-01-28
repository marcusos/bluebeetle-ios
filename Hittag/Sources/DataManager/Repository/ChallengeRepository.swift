import Parse
import RxSwift

protocol ChallengeRepositoryType {
    func challenges() -> Observable<[Challenge]>
}

final class ChallengeRepository: ChallengeRepositoryType {
    
    func challenges() -> Observable<[Challenge]> {
        let cached = self.requestChallenges(cached: true)
        let live = self.requestChallenges(cached: false)
        
        return cached.asObservable()
            .concat(live)
    }
    
    private func requestChallenges(cached: Bool) -> Single<[Challenge]> {
        return Single.create { emitter -> Disposable in
            let query = PFQuery(className: "Challenge")
            query.whereKey("isActive", equalTo: true)
            if cached {
                query.fromLocalDatastore()
            }
            query.findObjectsInBackground { (array, error) in
                if let error = error {
                    emitter(.error(error))
                } else {
                    PFObject.pinAll(inBackground: array)
                    let objects = (array ?? []).map(Challenge.init).compactMap { $0 }
                    emitter(.success(objects))
                }
            }
            return Disposables.create {
                query.cancel()
            }
        }
    }
}

extension Challenge {
    init?(pfObject: PFObject) {
        guard let urlString = pfObject["image"] as? String,
            let url = URL(string: urlString) else {
                return nil
        }
        
        guard let name = pfObject["name"] as? String else {
            return nil
        }
        
        self.name = name
        self.image = url
    }
}
