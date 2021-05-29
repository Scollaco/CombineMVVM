import Combine
import Foundation

private enum ImageName {
  static let funny: String = "emoji_funny"
  static let sad: String = "emoji_sad"
  static let sleeping: String = "emoji_sleeping"
}

protocol JokesViewModelInput {
  var addButtonTapped: PassthroughSubject<Void, Never> { get }
  var favoritesButtonTapped: PassthroughSubject<Void, Never> { get }
  var jokeButtonTapped: PassthroughSubject<Void, Never> { get }
  var viewDidLoad: PassthroughSubject<Void, Never> { get }
}

protocol JokesViewModelOutput {
  var addButtonIsActive: Bool { get }
  var favoriteButtonIsActive: Bool { get }
  var loadingIndicatorIsHidden: Bool { get }
  var labelIsHidden: Bool { get }
  var emojiName: String { get }
  var jokeLabelText: String { get }
  var shouldPushFavoritesView: Bool { get }
  var shouldShowAlertView: Bool { get }
}

protocol JokesViewModelType {
  var inputs: JokesViewModelInput { get }
  var outputs: JokesViewModelOutput { get }
}

final class JokesViewModel: ObservableObject, JokesViewModelType, JokesViewModelInput, JokesViewModelOutput {
  private let service: JokesServiceType
  private let scheduler: AnySchedulerOf<DispatchQueue>
  private var cancellables: [AnyCancellable] = []
  
  init(
    service: JokesServiceType,
    scheduler: AnySchedulerOf<DispatchQueue>
  ) {
    self.service = service
    self.scheduler = scheduler
    
    let jokeResponse = jokeButtonTapped
      .flatMap { [weak self] _  in
        self?.service.fetchJoke() ?? .just(.failure(APIError.genericError))
    }
    .delay(for: 2, scheduler: scheduler)
    .eraseToAnyPublisher()
    
    jokeResponse
      .compactMap { result -> String? in
        switch result {
        case .success(let joke):
          return joke.joke
        case .failure(let error):
          return error.localizedDescription
        }
    }
    .assign(to: \.jokeLabelText, on: self)
    .store(in: &cancellables)
    
    let sleepingImage = viewDidLoad
      .merge(with: jokeButtonTapped)
      .map { _ in return ImageName.sleeping }
      .eraseToAnyPublisher()
    
    let jokeImage = jokeResponse
      .filter { $0.isSuccess }
      .map { _ in return ImageName.funny }
      .eraseToAnyPublisher()
    
    let sadImage = jokeResponse
      .filter { $0.isFailure }
      .map { _ in return ImageName.sad }
      .eraseToAnyPublisher()
    
    let image = Publishers.Merge3(sleepingImage, jokeImage, sadImage)
      .eraseToAnyPublisher()
    
    image
      .assign(to: \.emojiName, on: self)
      .store(in: &cancellables)
    
    let didTapButton = jokeButtonTapped
      .map { _ in return true }
      .eraseToAnyPublisher()
    
    let didReceiveResponse = jokeResponse
      .map { _ in return false }
      .eraseToAnyPublisher()
    
    let labelIsHidden = didTapButton
      .merge(with: didReceiveResponse)
      .eraseToAnyPublisher()
    
    labelIsHidden
      .merge(with: didReceiveResponse)
      .assign(to: \.labelIsHidden, on: self)
      .store(in: &cancellables)
    
    labelIsHidden
    .map(negate)
    .assign(to: \.loadingIndicatorIsHidden, on: self)
    .store(in: &cancellables)
    
    favoritesButtonTapped
      .map { _ in return true }
      .assign(to: \.shouldPushFavoritesView, on: self)
      .store(in: &cancellables)
    
    addButtonTapped
      .map { save(joke: self.jokeLabelText) }
      .map { _ in return true }
      .assign(to: \.shouldShowAlertView, on: self)
      .store(in: &cancellables)
    
    jokeResponse
      .filter { $0.isSuccess }
      .map { _ in true }
      .assign(to: \.addButtonIsActive, on: self)
      .store(in: &cancellables)
  }
  
  //MARK: Inputs
  var addButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject()
  var favoritesButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject()
  var jokeButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject()
  var viewDidLoad: PassthroughSubject<Void, Never> = PassthroughSubject()
  
  //MARK: Outputs
  
  @Published var addButtonIsActive: Bool = false
  @Published var emojiName: String = ImageName.sleeping
  @Published var favoriteButtonIsActive: Bool = true
  @Published var jokeLabelText: String = "Tap for a joke!"
  @Published var labelIsHidden: Bool = false
  @Published var loadingIndicatorIsHidden: Bool = true
  @Published var shouldPushFavoritesView: Bool = false
  @Published var shouldShowAlertView: Bool = false
  
  var inputs: JokesViewModelInput { return self }
  var outputs: JokesViewModelOutput { return self }
}

private func save(joke: String) {
  print(joke)
}
