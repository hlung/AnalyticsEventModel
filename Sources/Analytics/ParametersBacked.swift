import Foundation

@propertyWrapper
public struct ParametersBacked<T: RawStringRepresentable> {
  public typealias ValueKeyPath = ReferenceWritableKeyPath<Event, T?>
  public typealias SelfKeyPath = ReferenceWritableKeyPath<Event, Self>

  public static subscript(_enclosingInstance instance: Event,
                          wrapped wrappedKeyPath: ValueKeyPath,
                          storage storageKeyPath: SelfKeyPath) -> T? {
    get {
      let propertyWrapper = instance[keyPath: storageKeyPath]
      guard let rawValue = instance.parameters[propertyWrapper.key] else { return nil }
      return T(rawValue: rawValue)
    }
    set {
      let propertyWrapper = instance[keyPath: storageKeyPath]
      instance.parameters[propertyWrapper.key] = newValue?.rawValue
    }
  }

  @available(*, unavailable, message: "Can only be applied to classes")
  public var wrappedValue: T? {
    get { fatalError() }
    set { fatalError() }
  }

  private let key: Event.Key

  init(_ key: Event.Key) {
    self.key = key
  }
}
