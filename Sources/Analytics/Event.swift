import Foundation

public class Event {

  public var name: Name
  @Parameter(.what) public var what: String?
  @Parameter(.page) public var page: Page?
  @Parameter(.pageId) public var pageId: String?
  @Parameter(.value) public var value: String?

  public func merge(_ additionalParameters: [Key: String]) {
    parameters.merge(additionalParameters, uniquingKeysWith: { $1 })
  }

  public var parameters: [Key: String] = [:]

  public init(_ name: Name, _ parameters: [Key: String] = [:]) {
    self.name = name
    self.parameters = parameters
  }

  // MARK: - Parameter constrained initializers

  public static func click(what: String) -> Event {
    let event = Event(.click)
    event.what = what
    return event
  }

  public static func sv(page: Page) -> Event {
    Event(.sv, [.page: page.rawValue])
  }

}

// MARK: - Models

public extension Event {

  enum Key: String {
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

extension String: RawStringRepresentable {
  public var rawValue: String { self }
  public init?(rawValue: String) { self = rawValue }
}

public protocol RawStringRepresentable {
  var rawValue: String { get }
  init?(rawValue: String)
}
