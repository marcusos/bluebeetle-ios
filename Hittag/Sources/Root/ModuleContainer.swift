import Foundation
import SwiftResolver
import RxSwift

public struct ModuleContainerConfiguration {
    let dataContainer: ContainerType
}

public final class ModuleContainer {
    private let container = Container()
    
    public init(configuration: ModuleContainerConfiguration) {
        self.registerDependencies(configuration: configuration)
    }
}

extension ModuleContainer: ContainerType {
    public func resolve<T>() -> T {
        return self.container.resolve()
    }
    
    public func resolve<T, Specifier>(_ specifier: Specifier) -> T {
        return self.container.resolve(specifier)
    }
}

extension ModuleContainer {
    private func registerDependencies(configuration: ModuleContainerConfiguration) {
        let dataContainer = configuration.dataContainer
        
        self.container.register({
            ApplicationModule(homeModule: $0, loginModule: $1, authRepository: dataContainer.resolve())
        }).as(ApplicationModuleType.self)
        
        self.container.register({
            LoginModule(authRepository: dataContainer.resolve())
        }).as(LoginModuleType.self)
        
        self.container.register({
            TabModule(feedModule: $0,
                      cameraModule: $1,
                      cameraTabModule: $2,
                      profileModule: $3,
                      feedRepository: dataContainer.resolve())
        }).as(TabModuleType.self)
        
        self.container.register({
            FeedModule(profileModule: $0, postModule: $1, feedRepository: dataContainer.resolve())
        }).as(FeedModuleType.self)
        
        self.container.register({
            CameraModule(challengeRepository: dataContainer.resolve())
        }).as(CameraModuleType.self)
        
        self.container.register({
            CameraTabModule()
        }).as(CameraTabModuleType.self)
        
        self.container.register({
            ProfileModule(postModule: $0, userRepository: dataContainer.resolve())
        }).as(ProfileModuleType.self)
        
        self.container.register({
            PostModule(postRepository: dataContainer.resolve())
        }).as(PostModuleType.self)
    }
}
