import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func test_add_functions() throws {
    let event = Event(.click)
    event.add(.what(.downloadButton))
    event.add(.page(.home))
    event.add(.pageId("123"))

    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.dictionary["what"]!, "download_button")
    XCTAssertEqual(event.dictionary["page"]!, "home")
    XCTAssertEqual(event.dictionary["page_id"]!, "123")
  }

  func test_click_function() throws {
    let event = Event.click(what: .media)

    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.dictionary["what"]!, "media")
  }
}
