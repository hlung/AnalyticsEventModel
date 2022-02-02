import Foundation

public class Event {
  @Parameter(.name) public var name: Name?
  @Parameter(.what) public var what: String?
  @Parameter(.page) public var page: Page?
  @Parameter(.pageId) public var pageId: String?
  @Parameter(.value) public var value: String?

  public func merge(_ additionalParameters: [Key: String]) {
    parameters.merge(additionalParameters, uniquingKeysWith: { $1 })
  }

  // The source of truth
  public var parameters: [Key: String] = [:]

  public init(_ name: Name, _ parameters: [Key: String] = [:]) {
    self.parameters = parameters
    self.parameters[.name] = name.rawValue
  }

  // MARK: - Parameter constrained initializers

  public static func click(what: String) -> Event {
    Event(.click, [.what: what])
  }

  public static func sv(page: Page) -> Event {
    Event(.sv, [.page: page.rawValue])
  }

}

// MARK: - Models

public extension Event {

  enum Key: String {
    case name
    case what
    case page
    case pageId = "page_id"
    case value
  }

  enum Name: String, RawStringRepresentable {
    case click
    case sv
    case impression
    case error
  }

  enum Page: String, RawStringRepresentable {
    case home
    case downloads
  }

}

@propertyWrapper
public struct Parameter<T: RawStringRepresentable> {
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

  @available(*, unavailable, message: "@Can only be applied to classes")
  public var wrappedValue: T? {
    get { fatalError() }
    set { fatalError() }
  }

  private let key: Event.Key

  init(_ key: Event.Key) {
    self.key = key
  }
}

extension String: RawStringRepresentable {
  public var rawValue: String { self }
  public init?(rawValue: String) { self = rawValue }
}

public protocol RawStringRepresentable {
  var rawValue: String { get }
  init?(rawValue: String)
}
