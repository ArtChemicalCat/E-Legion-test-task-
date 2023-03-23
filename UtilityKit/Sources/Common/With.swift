import Foundation

public protocol WithObject {}
public protocol WithValue {}

public extension WithObject {
    @discardableResult
    func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public extension WithValue {
    func with(_ block: (inout Self) -> Void) -> Self {
        var mutated = self
        block(&mutated)
        return mutated
    }
}

extension NSObject: WithObject { }
