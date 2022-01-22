import Foundation

/** New Analytics
 Goals
 - Swifty and fast to call
 - Autocomplete
 - Highly composable
 */

/*
 Example
 -------

 let event = Event(.click)
 event.add(.what(.home))

 */

class Event {

  var dictionary: [String: String] = [:]

  init(_ name: Name, _ parameters: Parameter...) {
    dictionary["name"] = name.rawValue
    for parameter in parameters {
      dictionary[parameter.key] = parameter.value
    }
  }

  func add(_ parameter: Parameter) {
    dictionary[parameter.key] = parameter.value
  }

  func add(_ parameters: [Parameter]) {
    for parameter in parameters {
      dictionary[parameter.key] = parameter.value
    }
  }

}

extension Event {

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
      case home
    }

    var key: String {
      // Option 1
      // We could use Mirror here. But I think having snake case strings improves searchability.
//      switch self {
//      case .what: return "what"
//      case .page: return "page"
//      }

      // Option 2
      // Declare enum in snake case to improve searchability and use Mirror :P
      let mirror = Mirror(reflecting: self)
      return mirror.children.first?.label ?? ""
    }

    var value: String {
      // Option 1
      // Use snake case values defined in enum rawValue
//      switch self {
//      case .what(let value): return value.rawValue
//      case .page(let value): return value.rawValue
//      }

      // Option 2
      // Declare enum in snake case to improve searchability and use Mirror :P
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

protocol HasStringRawValue {
  var rawValue: String { get }
}
