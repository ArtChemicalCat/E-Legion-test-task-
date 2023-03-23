protocol WithObject {}

extension AnyObject: WithObject {}
extension WithObject: AnyObject {
    func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

protocol WithValue {}
extension WithValue {
    func with(_ block: (Self) -> Void) -> Self {
        var mutated = self
        with(block)
    }
    
    func with(_ block: (inout Self) -> Void) {
        block(&self)
    }
}
