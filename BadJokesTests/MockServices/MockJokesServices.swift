import Combine
@testable import BadJokes

final class MockJokesService: JokesServiceType {
  func fetchJoke() -> AnyPublisher<Result<Joke, Error>, Never> {
    return .just(.success(Joke(id: "1", joke: "Awesome joke! :)")))
  }
}
