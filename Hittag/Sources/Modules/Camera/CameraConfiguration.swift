import ModuleArchitecture

struct CameraConfiguration: Equatable {
    private(set) var challengeConfiguration: ChallengeConfiguration
    private(set) var infoLabelText: NSAttributedString?
    
    static var empty: CameraConfiguration = {
        let challenges = [
            Challenge(name: "Dog Challenge!",
                      image: URL(string: "https://img.icons8.com/ios/2x/year-of-dog.png")!),
            Challenge(name: "Waterfall Challenge!",
                      image: URL(string: "https://img.icons8.com/ios/2x/waterfall.png")!),
            Challenge(name: "Pizza Challenge!",
                      image: URL(string: "https://img.icons8.com/ios/2x/pizza.png")!),
        ]

        let configurations = challenges.enumerated().map {
            ChallengeItemConfiguration(challenge: $0.element, index: $0.offset)
        }
        
        let selector = ChallengeConfiguration(configurations: Set(configurations))
        return CameraConfiguration(challengeConfiguration: selector, infoLabelText: nil)
    }()
    
    func with(selectedItem: ChallengeItemConfiguration) -> CameraConfiguration {
        var this = self
        this.challengeConfiguration = this.challengeConfiguration
            .with(selectedItem: selectedItem)
        this.infoLabelText = selectedItem
            .challenge.name.header(.white, weight: .bold)
            .outlined(color: UIColor.darkGray, width: 2)
        return this
    }
}
