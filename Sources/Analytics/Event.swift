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
  var parameters: [Parameter] = []

  static func click(what: What) -> Event {
    Event(.click, .what(what))
  }

  init(_ name: Name, _ parameters: Parameter...) {
    self.name = name
    for parameter in parameters {
      self.parameters.append(parameter)
    }
  }

  func add(_ parameter: Parameter) {
    parameters.append(parameter)
  }

  var dictionary: [String: String] {
    var result: [String: String] = [:]
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    for parameter in parameters {
      if let data = try? encoder.encode(parameter),
         let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] {
        result.merge(dictionary) { $1 }
      }
    }
    return result
  }

}

extension Event {

  enum Name: String {
    case click
    case sv
    case impression
    case error
  }

  enum What: String {
    case media
    case downloadButton = "download_button"
  }

  enum Page: String {
    case home
  }

  enum Parameter: Encodable {
    case what(What)
    case page(Page)
    case pageId(String)

    private enum CodingKeys: String, CodingKey {
      case what, page, pageId
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .what(let value): try container.encode(value.rawValue, forKey: .what)
      case .page(let value): try container.encode(value.rawValue, forKey: .page)
      case .pageId(let value): try container.encode(value, forKey: .pageId)
      }
    }
  }

}

private protocol HasStringRawValue {
  var rawValue: String { get }
}
