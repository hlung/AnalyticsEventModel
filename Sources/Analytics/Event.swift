import Foundation

public class Event {

  public let name: Name
  public var parameters: [Key: String] = [:]

  @ParametersBacked(.what) public var what: String?
  @ParametersBacked(.page) public var page: Page?
  @ParametersBacked(.pageId) public var pageId: String?
  @ParametersBacked(.value) public var value: String?

  public init(_ name: Name, _ parameters: [Key: String] = [:]) {
    self.name = name
    self.parameters = parameters
  }

  public func merge(_ additionalParameters: [Key: String]) {
    parameters.merge(additionalParameters, uniquingKeysWith: { $1 })
  }

  // MARK: - Constrained events

  public static func click(what: String, page: Page) -> Event {
    let event = Event(.click)
    event.what = what
    event.page = page
    return event
  }

  public static func sv(page: Page) -> Event {
    let event = Event(.sv)
    event.page = page
    return event
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

  enum Name: String {
    case click
    case sv
    case impression
    case error
  }

  enum Page: String, RawStringRepresentable {
    case home
    case logIn = "sign_in"
    case signUp = "sign_up_page"
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
