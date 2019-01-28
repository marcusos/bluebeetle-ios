import ModuleArchitecture

struct CameraConfiguration: Equatable {
    private(set) var challengeConfiguration: ChallengeConfiguration
    private(set) var infoLabelText: NSAttributedString?
    private(set) var pictureButtonEnabled: Bool
    
    static var empty: CameraConfiguration = {
        return CameraConfiguration(challengeConfiguration: ChallengeConfiguration(configurations: Set()),
                                   infoLabelText: nil,
                                   pictureButtonEnabled: false)
    }()
    
    var pictureButtonContainerBackgroundColor: UIColor {
        return self.pictureButtonEnabled ? UIColor.main.withAlphaComponent(0.5) : UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    var selectedChallengeText: NSAttributedString {
        let fallback = "Nenhum desafio selecionado"
        let name = self.challengeConfiguration.selectedConfiguration?.challenge.name ?? fallback
        return name.subtitle(.white, weight: .bold)
    }
    
    func with(challenges: [Challenge]) -> CameraConfiguration {
        var this = self
        this.challengeConfiguration = this.challengeConfiguration.with(challenges: challenges)
        return this
    }
    
    func with(selectedItem: ChallengeItemConfiguration) -> CameraConfiguration {
        var this = self
        this.challengeConfiguration = this.challengeConfiguration
            .with(selectedItem: selectedItem)
        this.infoLabelText = selectedItem
            .challenge.name.header(.white, weight: .bold)
            .outlined(color: UIColor.darkGray, width: 2)
        this.pictureButtonEnabled = true
        return this
    }
}
