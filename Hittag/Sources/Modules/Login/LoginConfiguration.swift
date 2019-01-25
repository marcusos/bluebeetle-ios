import ModuleArchitecture

struct LoginConfiguration {
    private(set) var loginButtonEnabled: Bool
    
    static var empty: LoginConfiguration {
        return LoginConfiguration(loginButtonEnabled: true)
    }
    
    func with(loginButtonEnabled: Bool) -> LoginConfiguration {
        var this = self
        this.loginButtonEnabled = loginButtonEnabled
        return this
    }
}
