import XCTest

@testable import FeedbackBulb

final class FeedbackSDKClientTests: XCTestCase {
  func testSubmitValue() async throws {
    let sut = FeedbackSDKClient(
      appKey: "my-key", instanceURL: URL(string: "http://localhost:4000")!)
    let result = try await sut.reportValue(content: "Hello world")
    XCTAssertNotNil(result.replyToken)
  }
}
