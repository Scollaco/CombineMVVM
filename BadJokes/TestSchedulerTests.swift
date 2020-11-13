import Combine
import XCTest
@testable import BadJokes

final class TestSchedulerTests: XCTestCase {

    let scheduler = DispatchQueue.testScheduler
    private var cancellables: [AnyCancellable] = []

    func testImmediateScheduledAction() {
        var isExecuted: Bool = false
        scheduler.schedule {
            isExecuted = true
        }

        XCTAssertEqual(isExecuted, false)
        scheduler.advance()
        XCTAssertEqual(isExecuted, true)
    }

    func testMultipleImmediateScheduledActions() {

        var executionCount = 0

        scheduler.schedule {
            executionCount += 1
        }

        scheduler.schedule {
            executionCount += 1
        }

        XCTAssertEqual(executionCount, 0)
        scheduler.advance()
        XCTAssertEqual(executionCount, 2)
    }

    func testImmediateScheduledActionWithPublisher() {
        var output: [Int] = []

        Just(1)
            .receive(on: scheduler)
            .sink(receiveValue: { output.append($0) })
            .store(in: &self.cancellables)

        XCTAssertEqual(output, [])
        scheduler.advance()
        XCTAssertEqual(output, [1])
    }

    func testImmediateScheduledActionWitMultiplePublisher() {
        var output: [Int] = []

        Just(1)
            .receive(on: scheduler)
            .merge(with: Just(2).receive(on: scheduler))
            .sink { output.append($0) }
            .store(in: &self.cancellables)

        XCTAssertEqual(output, [])
        scheduler.advance()
        XCTAssertEqual(output, [1, 2])
    }

    func testScheduledAfterDelay() {
        var isExecuted = false
        scheduler.schedule(after: scheduler.now.advanced(by: 1)) {
            isExecuted = true
        }

        XCTAssertEqual(isExecuted, false)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(isExecuted, false)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(isExecuted, true)
    }

    func testScheduledAfterLongDelay() {
        var isExecuted = false
        scheduler.schedule(after: scheduler.now.advanced(by: 1_000_000)) {
            isExecuted = true
        }

        XCTAssertEqual(isExecuted, false)
        scheduler.advance(by: .seconds(1_000_000))
        XCTAssertEqual(isExecuted, true)
    }
}
