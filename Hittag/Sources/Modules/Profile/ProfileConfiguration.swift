import ModuleArchitecture

struct HittagImageConfiguration {
    let post: Post
    
    var image: URL {
        return self.post.image
    }
}

struct ProfileConfiguration {
    let title: String
    let headerConfiguration: ImageWithTitleAndSubtitleConfiguration
    let hittagConfigurations: [HittagImageConfiguration]
}

extension ProfileConfiguration {
    init(user: User, posts: [Post]) {
        self.title = user.name
        self.headerConfiguration = ImageWithTitleAndSubtitleConfiguration(user: user)
        self.hittagConfigurations = posts.map(HittagImageConfiguration.init)
    }
}
