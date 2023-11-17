import SwiftUI
import Combine

open class ObservableFlow {
    fileprivate var publishers: [AnyPublisher<Any, Never>] = []
    
    public init() {}
    
    public func publish<T:Any>(_ publisher: Published<T>.Publisher) {
        let typeErasedPublisher = publisher
            .map { $0 as Any }
            .eraseToAnyPublisher()
        publishers.append(typeErasedPublisher)
    }
    
}

@propertyWrapper public struct StateFlow<T: ObservableFlow>: DynamicProperty {
    @StateObject private var wrapper: Wrapper
    
    private class Wrapper:ObservableObject {
        private var _value: T? = .none
        private var initializer: (() -> T)?
        private var cancellables: [AnyCancellable] = []
        
        init(_ initializer: @escaping () -> T) {
            self.initializer = initializer
        }
        
        var value: T {
            get {
                _value ?? {
                    guard let initializer else { fatalError("StateFlow initializer is nil") }
                    let value = initializer()
                    self.initializer = .none
                    self._value = value
                    value.publishers.forEach { publisher in
                        publisher.sink(receiveValue: { [weak self] values in
                                guard let self else { return }
                                objectWillChange.send()
                            }
                        ).store(in: &cancellables)
                    }
                    return value
                }()
            }
            set {
                _value = newValue
            }
        }
        

    }
    
    public var wrappedValue: T {
        get { return wrapper.value }
        nonmutating set { wrapper.value = newValue }
    }
    
    public init(wrappedValue: @escaping @autoclosure () -> T) {
        self._wrapper = .init(wrappedValue: Wrapper(wrappedValue))
    }
    
    public init(_ initializer: @escaping () -> T) {
        self._wrapper = .init(wrappedValue: Wrapper(initializer))
    }
    
    public var projectedValue: Binding<T> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
}



