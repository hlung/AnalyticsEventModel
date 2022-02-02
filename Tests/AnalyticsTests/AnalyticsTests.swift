import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func test_basic_functionalities() throws {
    let event = Event.click(what: "download_button")
    event.page = .home
    event.pageId = "123"
    event.merge([.value: "test"])

    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.what, "download_button")
    XCTAssertEqual(event.page, .home)
    XCTAssertEqual(event.pageId, "123")
    XCTAssertEqual(event.value, "test")

    XCTAssertEqual(event.parameters, [
      .page: "home",
      .pageId: "123",
      .what: "download_button",
      .value: "test",
    ])
  }
}
