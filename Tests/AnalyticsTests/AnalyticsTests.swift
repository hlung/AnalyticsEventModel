import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func test_add_functions() throws {
    let event = Event(.click, .what(.download_button))
    event.add(.where(.delete_download_popup))
    event.add([
      .page(.home),
      .page_id("123")
    ])
    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.dictionary, [
      "what": "download_button",
      "where": "delete_download_popup",
      "page": "home",
      "page_id": "123"
    ])
  }

  func test_function_chaining() throws {
    let event = Event(.click)
      .what(.download_button)
      .where(.delete_download_popup)

    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.dictionary, [
      "what": "download_button",
      "where": "delete_download_popup"
    ])
  }

  func test_click_function() throws {
    let event = Event.click(what: .download_button)

    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.dictionary, [
      "what": "download_button"
    ])
  }
}
