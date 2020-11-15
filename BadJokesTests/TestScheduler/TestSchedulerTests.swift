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

    func testSchedulerInterval() {
        var executionCount = 0

        scheduler.schedule(after: scheduler.now, interval: 1) {
            executionCount += 1
        }
        .store(in: &self.cancellables)

        XCTAssertEqual(executionCount, 0)
        scheduler.advance()
        XCTAssertEqual(executionCount, 1)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(executionCount, 1)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(executionCount, 2)
        scheduler.advance(by: .seconds(5))
        XCTAssertEqual(executionCount, 7)
    }

    func testSchedulerIntervalCancellation() {
        var executionCount = 0

        scheduler.schedule(after: scheduler.now, interval: 1) {
            executionCount += 1
        }
        .store(in: &self.cancellables)

        XCTAssertEqual(executionCount, 0)
        scheduler.advance()
        XCTAssertEqual(executionCount, 1)
        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(executionCount, 2)

        cancellables.removeAll()

        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(executionCount, 2)
    }

    func testScheduledTwoIntervals_fail() {
        var values: [String] = []

        scheduler.schedule(after: scheduler.now.advanced(by: 1), interval: 1) {
            values.append("Hello")
        }
        .store(in: &self.cancellables)

        scheduler.schedule(after: scheduler.now.advanced(by: 2), interval: 2) {
            values.append("World")
        }
        .store(in: &self.cancellables)

        XCTAssertEqual(values, [])
        scheduler.advance(by: 2)
        XCTAssertEqual(values, ["Hello", "Hello", "World"])
    }

    func testSchedulerNow() {
        var times: [UInt64] = []

        scheduler.schedule(after: scheduler.now, interval: 1) {
            times.append(self.scheduler.now.dispatchTime.uptimeNanoseconds)
        }
        .store(in: &self.cancellables)

        XCTAssertEqual(times, [])
        scheduler.advance(by: 3)
        XCTAssertEqual(times, [1, 1_000_000_001, 2_000_000_001, 3_000_000_001])
    }
}
