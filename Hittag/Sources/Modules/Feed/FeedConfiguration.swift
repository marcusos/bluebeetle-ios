import ModuleArchitecture

struct FeedConfiguration {
    private(set) var dataSource: PostModuleDataSource?
    
    func with(dataSource: PostModuleDataSource) -> FeedConfiguration {
        var this = self
        this.dataSource = dataSource
        return this
    }
}
