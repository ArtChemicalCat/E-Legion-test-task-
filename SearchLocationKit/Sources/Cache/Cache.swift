import Foundation

public final class Cache<Key: Hashable, Value> {
    // MARK: - Properties
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let currentDate: () -> Date
    private let entryLifetime: TimeInterval
    
    // MARK: - Initialiser
    public init(
        dateProvider: @escaping () -> Date = Date.init,
        entryLifetime: TimeInterval = 12 * 60 * 60
    ) {
        self.currentDate = dateProvider
        self.entryLifetime = entryLifetime
    }
    
    // MARK: - CRUD Methods
    public func insert(_ value: Value, for key: Key) {
        wrapped.setObject(
            Entry(
                value: value,
                expirationDate: currentDate().addingTimeInterval(entryLifetime)
            ),
            forKey: WrappedKey(key: key)
        )
    }
    
    public func value(for key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key: key)) else { return nil }
        guard currentDate() < entry.expirationDate else {
            removeValue(for: key)
            return nil
        }
        
        return entry.value
    }
    
    public func removeValue(for key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key: key))
    }
}

// MARK: - Subscript
public extension Cache {
    subscript(key: Key) -> Value? {
        get { value(for: key) }
        set {
            guard let newValue else {
                removeValue(for: key)
                return
            }
            
            insert(newValue, for: key)
        }
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        override var hash: Int { key.hashValue }
        
        init(key: Key) { self.key = key }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false}
            return value.key == key
        }
    }
    
    final class Entry {
        let value: Value
        let expirationDate: Date
        
        init(value: Value, expirationDate: Date) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}
