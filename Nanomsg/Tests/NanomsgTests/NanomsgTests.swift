import XCTest
@testable import Nanomsg

final class NanomsgTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Nanomsg().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
