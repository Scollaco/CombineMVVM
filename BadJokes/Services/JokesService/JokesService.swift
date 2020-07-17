import Combine
import Foundation

protocol JokesServiceType {
  func fetchJoke() -> AnyPublisher<Result<Joke, Error>, Never>
}

final class JokesService: JokesServiceType {
  private let service: ServiceType
  
  init(service: ServiceType) {
    self.service = service
  }
  
  func fetchJoke() -> AnyPublisher<Result<Joke, Error>, Never> {
    
    let resource = Resource<Joke>(route: .fetchJoke)
    return self.service
      .load(resource)
      .map { result in
        switch result {
        case .success(let joke):
          return .success(joke)
        case .failure(let error):
          return .failure(error)
      }
    }
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }
}
