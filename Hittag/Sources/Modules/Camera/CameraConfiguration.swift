import ModuleArchitecture

struct CameraConfiguration: Equatable {
    private(set) var challengeSelectorConfiguration: ChallengeConfiguration
    
    static var empty: CameraConfiguration = {
        let challenges = [
            Challenge(id: "A@asd",
                      name: "dog",
                      image: URL(string: "https://img.icons8.com/ios/2x/year-of-dog.png")!),
            Challenge(id: "B@asd",
                      name: "dog",
                      image: URL(string: "https://img.icons8.com/ios/2x/year-of-dog.png")!),
            Challenge(id: "C@asd",
                      name: "dog",
                      image: URL(string: "https://img.icons8.com/ios/2x/year-of-dog.png")!),
            Challenge(id: "D@asd",
                      name: "dog",
                      image: URL(string: "https://img.icons8.com/ios/2x/year-of-dog.png")!),
        ]

        let configurations = challenges.enumerated().map { ChallengeItemConfiguration(challenge: $0.element, index: $0.offset) }
        
        let selector = ChallengeConfiguration(configurations: Set(configurations))
        return CameraConfiguration(challengeSelectorConfiguration: selector)
    }()
    
    func with(selectedChallengeItemConfiguration: ChallengeItemConfiguration) -> CameraConfiguration {
        var this = self
        this.challengeSelectorConfiguration = this.challengeSelectorConfiguration
            .with(selectedChallengeItemConfiguration: selectedChallengeItemConfiguration)
        return this
    }
}
