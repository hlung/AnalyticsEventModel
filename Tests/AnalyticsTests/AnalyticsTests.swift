import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func test_add_functions() throws {
    let event = Event(.click, .what(.download_button))
    event.add(.page(.home_page))
    event.add(.page_id("123"))
    
    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.dictionary, [
      "what": "download_button",
      "page": "home_page",
      "page_id": "123"
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
