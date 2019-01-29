import ModuleArchitecture

struct FeedConfiguration {
    private(set) var posts: [Post]
    
    func with(posts: [Post]) -> FeedConfiguration {
        var this = self
        this.posts = posts
        return this
    }
}
