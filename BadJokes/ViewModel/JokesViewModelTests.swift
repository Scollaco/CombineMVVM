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
        XCTAssertEqual(viewModel.outputs.loadingIndicatorIsHidden, true)
        
      viewModel.inputs.jokeButtonTapped.send()

        XCTAssertEqual(viewModel.outputs.loadingIndicatorIsHidden, false)

        scheduler.advance(by: 2)

        XCTAssertEqual(viewModel.outputs.loadingIndicatorIsHidden, true)
    }

    func testLabelIsHidden() {


    }

    func test_emojiName() {
        XCTAssertEqual(viewModel.outputs.emojiName, "emoji_sleeping")

        viewModel.inputs.jokeButtonTapped.send()

        scheduler.advance(by: 2)
        XCTAssertEqual(viewModel.outputs.emojiName, "emoji_funny")
    }

    func test_jokeLabelText_EmmitsText_WhenButonIsTapped() {
        XCTAssertEqual(viewModel.jokeLabelText, "Tap for a joke!")

        viewModel.inputs.jokeButtonTapped.send(())

        XCTAssertEqual(viewModel.jokeLabelText, "Tap for a joke!")

        scheduler.advance(by: 2)
        XCTAssertEqual(viewModel.jokeLabelText, "My Joke")
    }
}
