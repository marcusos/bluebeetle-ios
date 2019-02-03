import Foundation
import SwiftResolver
import RxSwift

public struct DataContainerConfiguration {
    
}

public final class DataContainer {
    private let container = Container()
    
    public init(configuration: DataContainerConfiguration) {
        self.registerDependencies(configuration: configuration)
    }
}

extension DataContainer: ContainerType {
    public func resolve<T>() -> T {
        return self.container.resolve()
    }
    
    public func resolve<T, Specifier>(_ specifier: Specifier) -> T {
        return self.container.resolve(specifier)
    }
}

extension DataContainer {
    private func registerDependencies(configuration: DataContainerConfiguration) {
        self.container.register({
            FeedRepository()
        }).as(FeedRepositoryType.self)
        
        self.container.register(scope: .singleton, {
            UserRepository()
        }).as(UserRepositoryType.self)
        
        self.container.register(scope: .singleton, {
            PostRepository(userRepository: $0)
        }).as(PostRepositoryType.self)
        
        self.container.register({
            AuthRepository()
        }).as(AuthRepositoryType.self)
        
        self.container.register({
            ChallengeRepository()
        }).as(ChallengeRepositoryType.self)
    }
}
