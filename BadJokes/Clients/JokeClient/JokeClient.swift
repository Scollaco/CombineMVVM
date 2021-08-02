import Combine
import ComposableArchitecture
import Foundation

public struct JokeClient {
  var fetchJoke: (Resource<Joke>) -> Effect<Joke, Failure>
}

public struct Failure: Error, Equatable {
  let error: Error

  public static func == (lhs: Failure, rhs: Failure) -> Bool {
    return lhs.error.localizedDescription == rhs.error.localizedDescription
  }
}

extension JokeClient {
  
  static let live = JokeClient(
    fetchJoke: { resource in
      return client.load(resource)
        .map { $0 }
        .eraseToEffect()
    })
}

// MARK: - Private helpers
private let client: Client = {
  return Client()
}()

private let jsonDecoder: JSONDecoder = {
  let d = JSONDecoder()
  return d
}()


// MARK: - Mock API implementations

public extension JokeClient {
  static func mock(
    fetchJoke: @escaping (Resource<Joke>) -> Effect<Joke, Failure>) -> Self {
      return Self(fetchJoke: fetchJoke)
  }
}
