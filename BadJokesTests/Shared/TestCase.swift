import Dispatch
import XCTest
@testable import BadJokes

class TestCase: XCTestCase {
    var scheduler: TestScheduler = DispatchQueue.testScheduler
}
