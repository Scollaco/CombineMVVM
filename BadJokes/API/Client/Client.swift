import ComposableArchitecture

final class Client {
  
  func load<T>(_ resource: Resource<T>) -> Effect<T, Failure> where T: Decodable {
    guard let request = resource.request else {
      assertionFailure("Request should not be nil.")
      return .none
    }

    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { response in
        return response.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError(Failure.init)
      .map { $0 }
      .eraseToEffect()
  }
}
