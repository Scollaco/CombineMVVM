import Combine

struct JokesViewModelInput {
  var viewDidLoad: AnyPublisher<Void, Never>
}

protocol JokesViewModelOutput {
  var joke: AnyPublisher<Joke?, Never> { get }
}

protocol JokesViewModelType {
  var outputs: JokesViewModelOutput { get }
  func transform(input: JokesViewModelInput)
}

final class JokesViewModel: JokesViewModelType, JokesViewModelOutput {
  private let service: JokesServiceType
  private var cancellables: [AnyCancellable] = []
  
  init(service: JokesServiceType) {
    self.service = service
  }
  
  func transform(input: JokesViewModelInput) {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    self.joke = input.viewDidLoad
      .flatMap({ [unowned self]  _ in self.service.fetchJoke() })
      .map({ result -> Joke? in
        switch result {
        case .success(let joke):
          return joke.first ?? nil
        case .failure(_):
          return nil
        }
      })
      .eraseToAnyPublisher()
  
  }
  
  var joke: AnyPublisher<Joke?, Never> = .just(nil)
  var outputs: JokesViewModelOutput { return self }
}
