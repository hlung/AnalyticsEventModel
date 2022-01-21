import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {
  func testExample() throws {
    let event = Event(.click)
    event.add(.what(.button))

    XCTAssertEqual(event.dictionary, [
      "name": "click",
      "what": "button"
    ])
  }
}
