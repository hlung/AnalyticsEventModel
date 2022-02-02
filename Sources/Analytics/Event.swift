import Foundation

public class Event {

  public var parameters: [Key: String] = [:]

  public var additionalParameters: [Key: String] = [:] {
    didSet { parameters.merge(additionalParameters, uniquingKeysWith: { $1 })}
  }

  public var name: Name? {
    get { Name(rawValue: parameters[.name] ?? "") }
    set { parameters[.name] = newValue?.rawValue }
  }

  public var what: String? {
    get { parameters[.what] }
    set { parameters[.what] = newValue }
  }

  public var page: Page? {
    get { Page(rawValue: parameters[.page] ?? "") }
    set { parameters[.page] = newValue?.rawValue }
  }

  public var pageId: String? {
    get { parameters[.pageId] }
    set { parameters[.pageId] = newValue }
  }

  public init(_ name: Name, _ parameters: [Key: String] = [:]) {
    self.parameters = parameters
    self.parameters[.name] = name.rawValue
  }

  @Parameter(.value) var value: String?
  @Parameter(.page) var newPage: Page?

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

  enum Name: String {
    case click
    case sv
    case impression
    case error
  }

  enum Key: String {
    case name
    case what
    case page
    case pageId = "page_id"
    case value
  }

  enum Page: String, RawStringRepresentable {
    case home
    case downloads
  }

}

@propertyWrapper
struct Parameter<T: RawStringRepresentable> {
  typealias ValueKeyPath = ReferenceWritableKeyPath<Event, T?>
  typealias SelfKeyPath = ReferenceWritableKeyPath<Event, Self>

  static subscript(_enclosingInstance instance: Event,
                   wrapped wrappedKeyPath: ValueKeyPath,
                   storage storageKeyPath: SelfKeyPath) -> T? {
    get {
      let propertyWrapper = instance[keyPath: storageKeyPath]
      return instance.parameters[propertyWrapper.key] as? T
    }
    set {
      let propertyWrapper = instance[keyPath: storageKeyPath]
      instance.parameters[propertyWrapper.key] = newValue?.rawValue
    }
  }

  @available(*, unavailable, message: "@Can only be applied to classes")
  var wrappedValue: T? {
    get { fatalError() }
    set { fatalError() }
  }

  private let key: Event.Key

  init(_ key: Event.Key) {
    self.key = key
  }
}

extension String: RawStringRepresentable {
  var rawValue: String { self }
}

protocol RawStringRepresentable {
  var rawValue: String { get }
}
