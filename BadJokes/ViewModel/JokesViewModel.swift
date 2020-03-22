import Combine
import Foundation

private enum ImageName {
  static let neutral: String = "emoji_neutral"
  static let laugh: String = "emoji_laugh"
}

struct JokesViewModelInput {
  var jokeButtonTappedInput: AnyPublisher<Void, Never>
  var viewDidLoad: AnyPublisher<Void, Never>
}

protocol JokesViewModelOutput {
  var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> { get }
  var labelIsHidden: AnyPublisher<Bool, Never> { get }
  var emojiName: AnyPublisher<String, Never> { get }
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
    
    self.joke = input.jokeButtonTappedInput
      .flatMap({ [unowned self]  _ in self.service.fetchJoke() })
      .map({ result -> Joke? in
        switch result {
        case .success(let joke):
          return joke.randomElement()
        case .failure(_):
          return nil
        }
      })
      .delay(for: 2, scheduler: RunLoop.current)
      .eraseToAnyPublisher()
    
    let initialImage = input.viewDidLoad
      .merge(with: input.jokeButtonTappedInput)
      .map { _ in return ImageName.neutral }
      .eraseToAnyPublisher()
    
    let loadingImage = self.joke
      .map { _ in return ImageName.laugh }
      .eraseToAnyPublisher()
          
    self.emojiName = Publishers.Merge(initialImage, loadingImage)
      .eraseToAnyPublisher()
    
    let didTapButton = input.jokeButtonTappedInput
      .map { _ in return true }
      .eraseToAnyPublisher()
    
    let didReceiveResponse = self.joke
      .map { _ in return false }
      .eraseToAnyPublisher()
    
    self.labelIsHidden = didTapButton
      .merge(with: didReceiveResponse)
      .eraseToAnyPublisher()
    
    self.loadingIndicatorIsHidden = self.labelIsHidden
      .map { value in
        return value == true ? false : true
      }
      .eraseToAnyPublisher()
  }
  
  var emojiName: AnyPublisher<String, Never> = .just(ImageName.neutral)
  var joke: AnyPublisher<Joke?, Never> = .just(nil)
  var labelIsHidden: AnyPublisher<Bool, Never> = .just(false)
  var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> = .just(true)
  
  var outputs: JokesViewModelOutput { return self }
}
