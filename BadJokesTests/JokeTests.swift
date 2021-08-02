import Combine
import ComposableArchitecture
import XCTest

@testable import BadJokes

class JokesTests: XCTestCase {
  let scheduler = DispatchQueue.test
  
  
  func testJokeRequest_Failure() {
    let store = TestStore(
      initialState: .init(),
      reducer: jokeReducer,
      environment: JokeEnvironment(
        jokeClient: JokeClient.mock(fetchJoke: { _ in Effect(error: .init(error: APIError.genericError)) }),
        mainQueue: scheduler.eraseToAnyScheduler()
      )
    )

    store.send(.jokesButtonTapped) {
      $0.emojiImage = Images.Emoji.sleeping
      $0.joke = ""
      $0.isLoading = true
    }
    
    scheduler.advance(by: 2)
    
    store.receive(.jokesResponse(.failure(.init(error: APIError.genericError)))) {
      $0.emojiImage = Images.Emoji.sad
      $0.isLoading = false
      $0.joke = "The operation couldn’t be completed. (BadJokes.Failure error 1.)"
    }
  }
  
  func testJokeRequest_Success() {
    let store = TestStore(
      initialState: .init(),
      reducer: jokeReducer,
      environment: JokeEnvironment(
        jokeClient: JokeClient.mock(fetchJoke: { _ in Effect(value: .template) }),
        mainQueue: scheduler.eraseToAnyScheduler()
      )
    )

    store.send(.jokesButtonTapped) {
      $0.emojiImage = Images.Emoji.sleeping
      $0.joke = ""
      $0.isLoading = true
    }
    
    scheduler.advance(by: 2)
    
    store.receive(.jokesResponse(.success(.template))) {
      $0.emojiImage = Images.Emoji.funny
      $0.isLoading = false
      $0.joke = "Test joke!"
    }
  }
}
