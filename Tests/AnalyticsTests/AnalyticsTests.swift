import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func testExample() throws {
    let event = Event(.click, .page(.home), .page_id("123"))
    event.add(.what(.download_button))

    XCTAssertEqual(event.dictionary, [
      "name": "click",
      "what": "download_button",
      "page": "home",
      "page_id": "123"
    ])
  }
}
