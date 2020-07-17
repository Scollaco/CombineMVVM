import Combine
import Foundation

private enum ImageName {
  static let neutral: String = "emoji_neutral"
  static let laugh: String = "emoji_laugh"
}

protocol JokesViewModelInput {
  var jokeButtonTapped: PassthroughSubject<Void, Never> { get }
  var viewDidLoad: PassthroughSubject<Void, Never> { get }
}

protocol JokesViewModelOutput {
  var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> { get }
  var labelIsHidden: AnyPublisher<Bool, Never> { get }
  var emojiName: AnyPublisher<String, Never> { get }
  var joke: AnyPublisher<String?, Never> { get }
}

protocol JokesViewModelType {
  var inputs: JokesViewModelInput { get }
  var outputs: JokesViewModelOutput { get }
}

final class JokesViewModel: JokesViewModelType, JokesViewModelInput, JokesViewModelOutput {
  private let service: JokesServiceType
  private var cancellables: [AnyCancellable] = []
  
  init(service: JokesServiceType) {
    self.service = service
    
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    self.joke = self.jokeButtonTapped
      .flatMap({ [unowned self]  _ in self.service.fetchJoke() })
      .map({ result -> String? in
        switch result {
        case .success(let joke):
          return joke.joke
        case .failure(let error):
          return (error.localizedDescription)
        }
      })
      .delay(for: 2, scheduler: RunLoop.current)
      .eraseToAnyPublisher()
    
    let initialImage = self.viewDidLoad
      .merge(with: self.jokeButtonTapped)
      .map { _ in return ImageName.neutral }
      .eraseToAnyPublisher()
    
    let loadingImage = self.joke
      .map { _ in return ImageName.laugh }
      .eraseToAnyPublisher()
          
    self.emojiName = Publishers.Merge(initialImage, loadingImage)
      .eraseToAnyPublisher()
    
    let didTapButton = self.jokeButtonTapped
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
  
  //MARK: Inputs
  
  var jokeButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject()
  var viewDidLoad: PassthroughSubject<Void, Never> = PassthroughSubject()
  
  //MARK: Outputs
  
  var emojiName: AnyPublisher<String, Never> = .just(ImageName.neutral)
  var joke: AnyPublisher<String?, Never> = .just(nil)
  var labelIsHidden: AnyPublisher<Bool, Never> = .just(false)
  var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> = .just(true)

  var inputs: JokesViewModelInput { return self }
  var outputs: JokesViewModelOutput { return self }
}
