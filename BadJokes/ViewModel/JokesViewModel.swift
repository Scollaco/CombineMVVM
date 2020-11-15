import Combine
import Foundation

private enum ImageName {
    static let funny: String = "emoji_funny"
    static let sad: String = "emoji_sad"
    static let sleeping: String = "emoji_sleeping"
}

protocol JokesViewModelInput {
    var jokeButtonTapped: PassthroughSubject<Void, Never> { get }
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
}

protocol JokesViewModelOutput {
    var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> { get }
    var labelIsHidden: AnyPublisher<Bool, Never> { get }
    var emojiName: AnyPublisher<String, Never> { get }
    var jokeLabelText: AnyPublisher<String?, Never> { get }
}

protocol JokesViewModelType {
    var inputs: JokesViewModelInput { get }
    var outputs: JokesViewModelOutput { get }
}

final class JokesViewModel: JokesViewModelType, JokesViewModelInput, JokesViewModelOutput {
    private let service: JokesServiceType
    private var cancellables: [AnyCancellable] = []

    init<S: Scheduler>(service: JokesServiceType, scheduler: S) {
        self.service = service

        let jokeResponse = self.jokeButtonTapped
            .flatMap { [weak self] _  in
                self?.service.fetchJoke() ?? .just(.failure(APIError.genericError))
            }
            .delay(for: 1, scheduler: scheduler)
            .eraseToAnyPublisher()

        self.jokeLabelText = jokeResponse
            .compactMap { result -> String? in
                switch result {
                case .success(let joke):
                    return joke.joke
                case .failure(let error):
                    return error.localizedDescription
                }
            }
            .eraseToAnyPublisher()

        let sleepingImage = self.viewDidLoad
            .merge(with: self.jokeButtonTapped)
            .map { _ in return ImageName.sleeping }
            .eraseToAnyPublisher()

        let jokeImage = jokeResponse
            .filter(\.isSuccess)
            .map { _ in return ImageName.funny }
            .eraseToAnyPublisher()

        let sadImage = jokeResponse
            .filter(\.isFailure)
            .map { _ in return ImageName.sad }
            .eraseToAnyPublisher()

        self.emojiName = Publishers.Merge3(sleepingImage, jokeImage, sadImage)
            .eraseToAnyPublisher()

        let didTapButton = self.jokeButtonTapped
            .map { _ in return true }
            .eraseToAnyPublisher()

        let didReceiveResponse = jokeResponse
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

    var emojiName: AnyPublisher<String, Never> = .just(ImageName.sleeping)
    var jokeLabelText: AnyPublisher<String?, Never> = .just(nil)
    var labelIsHidden: AnyPublisher<Bool, Never> = .just(false)
    var loadingIndicatorIsHidden: AnyPublisher<Bool, Never> = .just(true)

    var inputs: JokesViewModelInput { return self }
    var outputs: JokesViewModelOutput { return self }
}
