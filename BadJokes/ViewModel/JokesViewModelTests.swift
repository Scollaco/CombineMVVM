import Combine
import XCTest
@testable import BadJokes

final class JokesViewModelTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var viewModel: JokesViewModel!

    override func setUp() {
        super.setUp()

        viewModel = JokesViewModel(
            service: MockJokesService(
                expectedJokeResponse: .success(Joke(id: "1", joke: "My Joke"))
            )
        )
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

    func test_loadingIndicatorIsHidden() {
        var expectedValues: [Bool] = []
        viewModel.outputs.loadingIndicatorIsHidden
            .sink { expectedValues.append($0) }
            .store(in: &cancellables)

        XCTAssertEqual(expectedValues, [])

        viewModel.inputs.jokeButtonTapped.send()

        XCTAssertEqual(expectedValues, [false])

        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 2.1)

        XCTAssertEqual(expectedValues, [false, true])
    }

    func test_emojiName() {
        var expectedValues: [String] = []
        viewModel.outputs.emojiName
            .sink { expectedValues.append($0) }
            .store(in: &cancellables)

        XCTAssertEqual(expectedValues, [])

        viewModel.inputs.viewDidLoad.send()

        XCTAssertEqual(expectedValues, ["emoji_sleeping"])

        // TODO: Create test scheduler to advance in time and simulate server response after 2 seconds
    }

    func test_jokeLabelText_EmmitsText_WhenButonIsTapped() {
        let exp = expectation(description: "Expected value")
        viewModel.outputs.jokeLabelText
            .sink { value in
                XCTAssertEqual(value, "My Joke")
                exp.fulfill()
            }
            .store(in: &cancellables)

        viewModel.inputs.jokeButtonTapped.send(())
        wait(for: [exp], timeout: 2)
    }
}
