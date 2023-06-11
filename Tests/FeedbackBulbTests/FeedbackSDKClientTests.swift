import XCTest
@testable import FeedbackBulb

final class FeedbackSDKClientTests: XCTestCase {
    func testRequestBuilder() async throws {
        let sut = FeedbackSDKClient(appKey: "c71e5cb5-4a78-460f-949b-6f98c4df36da", instanceURL: URL(string: "http://localhost:4000")!)
        
        try await sut.submitFeedback(content: "hello from a test")
    }
}
