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

  init(_ name: Name) {
    dictionary["name"] = name.rawValue
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

    enum What: String, StringRepresentable {
      case button
    }

    var key: String {
      let mirror = Mirror(reflecting: self)
      return mirror.children.first?.label ?? ""
    }

    var value: String {
      let mirror = Mirror(reflecting: self)
      return (mirror.children.first?.value as? StringRepresentable)?.string ?? ""
    }
  }

}

protocol StringRepresentable {
  var rawValue: String { get }
}

extension StringRepresentable {
  var string: String { rawValue }
}

@propertyWrapper final class Param<Value> {
    var wrappedValue: Value
    let name: String

    fileprivate init(wrappedValue: Value, name: String) {
        self.wrappedValue = wrappedValue
        self.name = name
    }
}
