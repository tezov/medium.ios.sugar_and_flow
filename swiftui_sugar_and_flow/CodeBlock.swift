import SwiftUI

public func CodeBlock(_ block: () -> Void) -> EmptyView {
    block()
    return EmptyView()
}
