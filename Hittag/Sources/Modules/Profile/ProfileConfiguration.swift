import ModuleArchitecture

struct HittagImageConfiguration {
    let image: URL
    let icon: URL
}

extension HittagImageConfiguration {
    init(hittag: Hittag) {
        self.image = hittag.image
        self.icon = hittag.icon
    }
}

struct ProfileConfiguration {
    let headerConfiguration: ImageWithTitleAndSubtitleConfiguration
    let hittagConfigurations: [HittagImageConfiguration]
}

extension ProfileConfiguration {
    init(user: User) {
        self.headerConfiguration = ImageWithTitleAndSubtitleConfiguration(user: user)
        self.hittagConfigurations = user.hittags.map(HittagImageConfiguration.init)
    }
}
