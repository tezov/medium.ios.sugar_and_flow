import SwiftUI

@propertyWrapper public class Lazy<T: Any> {
    private var initializer: (() -> T)?
    private var value: T? = .none

    public var wrappedValue: T {
        get { 
            value ?? { [unowned self] in
                guard let initializer else { fatalError("Lazy initializer is nil") }
                let value = initializer()
                self.initializer = .none
                self.value = value
                return value
            }()
        }
        set {
            initializer = .none
            value = newValue
        }
    }

    public init(wrappedValue: @escaping @autoclosure () -> T) {
        self.initializer = wrappedValue
    }

    public init(_ value: @escaping () -> T) {
        self.initializer = value
    }
}
