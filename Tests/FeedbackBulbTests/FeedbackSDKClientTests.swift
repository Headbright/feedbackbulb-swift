import XCTest
@testable import FeedbackBulb

final class FeedbackSDKClientTests: XCTestCase {
    func testRequestBuilder() async throws {
        let sut = FeedbackSDKClient(appKey: "01b7f627-37c0-43f8-8815-2d730f55134b")
        
        try await sut.submitFeedback(content: "hello from a test")
    }
}
