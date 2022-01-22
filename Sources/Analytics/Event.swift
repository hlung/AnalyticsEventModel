import Foundation

/**
 A new analytics event model, with better APIs while still compatible with current Vikilitics library.
 Goals:
 - Swifty API - Easy to use at call site.
 - Autocompletion - Suggest for all possible values for each key.
 - Compact - Event initialization and all parameters setting can be done in one line.
 - Composable - Allow adding parameters after init, e.g. in if statements.
 */
class Event {

  let name: Name
  var dictionary: [String: String] = [:]

  init(_ name: Name, _ parameters: Parameter...) {
    self.name = name
    for parameter in parameters {
      dictionary[parameter.key] = parameter.value
    }
  }

  func add(_ parameter: Parameter) {
    dictionary[parameter.key] = parameter.value
  }

  static func click(what: What) -> Event {
    Event(.click, .what(what))
  }

}

extension Event {

  enum Name: String {
    case click
    case sv
    case impression
    case error
  }

  enum What: String, HasStringRawValue {
    case media
    case downloadButton = "download_button"
  }

  enum Page: String, HasStringRawValue {
    case home
  }

  enum Parameter {
    case what(What)
    case page(Page)
    case page_id(String)

    var key: String {
      let mirror = Mirror(reflecting: self)
      return mirror.children.first?.label ?? ""
    }

    var value: String {
      let mirror = Mirror(reflecting: self)
      let value: Any? = mirror.children.first?.value
      if let string = (value as? HasStringRawValue)?.rawValue {
        return string
      }
      else if let string = value as? String {
        return string
      }
      else {
        #if DEBUG
        fatalError("value is invalid")
        #else
        return ""
        #endif
      }
    }
  }

}

private protocol HasStringRawValue {
  var rawValue: String { get }
}
