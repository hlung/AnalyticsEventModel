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

  static func click(what: Parameter.What) -> Event {
    let event = Event(.click)
    event.add(.what(.download_button))
    return event
  }

}

extension Event {

  // Note: I intentionally use snake case for ALL enums' names because:
  // - it is more searchable
  // - easier to maintain. no need to update every time we add a new key or value
  // - we can use Mirror to directly get the final String to log
  //
  // Open for discussion :)

  enum Name: String {
    case click
    case sv
    case impression
    case error
  }

  enum Parameter {
    case what(What)
    case page(Page)
    case page_id(String)

    enum What: String, HasStringRawValue {
      case download_button
    }

    enum Page: String, HasStringRawValue {
      case home_page
    }

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
