import SwiftUI

@propertyWrapper public struct Remember<T: Any>: DynamicProperty {
    @StateObject private var wrapper: Wrapper

    private class Wrapper:ObservableObject {
        var value:T
        init(_ value: T) { self.value = value }
    }
    
    public var wrappedValue: T {
        get { wrapper.value }
        nonmutating set { wrapper.value = newValue }
    }

    public init(wrappedValue: @escaping @autoclosure () -> T) {
        self._wrapper = .init(wrappedValue: Wrapper(wrappedValue()))
    }
    
    public init(_ value: @escaping () -> T) {
        self._wrapper = .init(wrappedValue: Wrapper(value()))
    }
    
    public var projectedValue: Binding<T> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}



