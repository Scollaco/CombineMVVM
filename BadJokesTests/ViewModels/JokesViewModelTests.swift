import Combine
import XCTest
@testable import BadJokes

final class JokesViewModelTests: XCTestCase {

  var viewModel: JokesViewModel!
  var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> = .just(true)
  
  override func setUp() {
    super.setUp()
    viewModel = JokesViewModel(service: MockJokesService())
  }

  func testLoadingIndicatorIsHidden() {
    _ = viewModel.outputs.loadingIndicatorIsHidden.map { hidden in
      XCTAssertTrue(hidden, "Indicator should be hidden initially")
      exp.fulfill()
    }
    viewModel.inputs.jokeButtonTapped.send(())
    wait(for: [exp], timeout: 1)
      
  }
}

extension XCTestCase {
  typealias CompetionResult = (expectation: XCTestExpectation,
                               cancellable: AnyCancellable)
func expectCompletion<T: Publisher>(of publisher: T,
                                      timeout: TimeInterval = 2,
                                      file: StaticString = #file,
                                      line: UInt = #line) -> CompetionResult {
    let exp = expectation(description: "Successful completion of " + String(describing: publisher))
    let cancellable = publisher
      .sink(receiveCompletion: { completion in
        if case .finished = completion {
          exp.fulfill()
        }
      }, receiveValue: { _ in })
    return (exp, cancellable)
  }
}
//func testIsOn_completes() {
//  let mock = DeviceMock()
//  let isOnUseCase = IsOnUseCase(device: mock)
//  let result = expectCompletion(of: isOnUseCase.isOn())
//   mock.deviceStateSub.send(completion: .finished)
//   wait(for: [result.expectation], timeout: 1)
//}
