import ModuleArchitecture

struct FeedConfiguration {
    private(set) var postConfigurations: [PostConfiguration]
    
    func with(postConfigurations: [PostConfiguration]) -> FeedConfiguration {
        var this = self
        this.postConfigurations = postConfigurations
        return this
    }
}
