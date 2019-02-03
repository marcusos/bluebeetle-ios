import ModuleArchitecture

struct FeedConfiguration {
    private(set) var dataSource: UITableViewDataSource?
    
    func with(dataSource: UITableViewDataSource) -> FeedConfiguration {
        var this = self
        this.dataSource = dataSource
        return this
    }
}
