import RxSwift

protocol ContainerType {
    func resolve<T>() -> T
    func resolve<T, Specifier>(_ specifier: Specifier) -> T
}
