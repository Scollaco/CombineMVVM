import Combine
@testable import BadJokes

final class MockJokesService: JokesServiceType {

  private var jokeResponse: Result<Joke, Error>?

  init(expectedJokeResponse: Result<Joke, Error>? = nil) {
    jokeResponse = expectedJokeResponse
  }

  func fetchJoke() -> AnyPublisher<Result<Joke, Error>, Never> {
    guard let response = jokeResponse else {
        return .just(.success(Joke(id: "1", joke: "Awesome joke! :)")))
    }
    return .just(response)
  }
}
