import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func test_basic_functionalities() throws {
    let event = Event.click(what: "download_button")
    event.page = .home
    event.pageId = "123"
    event.additionalParameters = [.value: "foo"]

    XCTAssertEqual(event.name, .click)
    XCTAssertEqual(event.parameters, [
      .page: "home",
      .pageId: "123",
      .name: "click",
      .what: "download_button",
      .value: "foo"
    ])
  }
}
