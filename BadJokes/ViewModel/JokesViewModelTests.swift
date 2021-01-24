import Combine
import XCTest
@testable import BadJokes

final class JokesViewModelTests: TestCase {

    var cancellables: Set<AnyCancellable> = []
    var viewModel: JokesViewModel!
  
    override func setUp() {
        super.setUp()
        viewModel = JokesViewModel(
            service: MockJokesService(
                expectedJokeResponse: .success(Joke(id: "1", joke: "My Joke"))
            ), scheduler: scheduler.eraseToAnyScheduler()
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

        scheduler.advance(by: 2)

        XCTAssertEqual(expectedValues, [false, true])
    }

    func testLabelIsHidden() {


    }

    func test_emojiName() {
        var expectedValues: [String] = []
        viewModel.outputs.emojiName
            .sink { expectedValues.append($0) }
            .store(in: &cancellables)

        XCTAssertEqual(expectedValues, [])

        viewModel.inputs.viewDidLoad.send()

        XCTAssertEqual(expectedValues, ["emoji_sleeping"])

        viewModel.inputs.jokeButtonTapped.send()

        scheduler.advance(by: 2)
        XCTAssertEqual(
            expectedValues, [
                "emoji_sleeping",
                "emoji_funny"
            ]
        )
    }

    func test_jokeLabelText_EmmitsText_WhenButonIsTapped() {

        let initialText = viewModel.jokeLabelText

        XCTAssertEqual(initialText, "Tap for a joke!")

        viewModel.inputs.jokeButtonTapped.send(())

        XCTAssertEqual(initialText, "Tap for a joke!")

        scheduler.advance(by: 4)
        let receivedText = viewModel.jokeLabelText
        XCTAssertEqual(receivedText, "My Joke")
    }
}
