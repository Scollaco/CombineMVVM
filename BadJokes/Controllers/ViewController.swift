import Combine
import UIKit

final class ViewController: UIViewController {
  // MARK: Properties
  
  @IBOutlet weak var emojiImageView: UIImageView!
  @IBOutlet weak var jokeLabel: UILabel!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  private var cancellables: [AnyCancellable] = []
  private let viewModel: JokesViewModelType = JokesViewModel(service: JokesService(service: Service()))
  
  private var jokeButtonTappedInput = PassthroughSubject<Void, Never>()
  private let viewDidLoadInput = PassthroughSubject<Void, Never>()
  
  // MARK: Lyfecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bindViewModel()
    self.viewDidLoadInput.send()
  }
  
  // MARK: View Model
  
  func bindViewModel() {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let input = JokesViewModelInput(jokeButtonTappedInput: jokeButtonTappedInput.eraseToAnyPublisher(),
                                    viewDidLoad: self.viewDidLoadInput.eraseToAnyPublisher())
    
    self.viewModel.transform(input: input)
    
    self.viewModel.outputs.joke
      .assign(to: \.text, on: self.jokeLabel)
      .store(in: &cancellables)
     
    self.viewModel.outputs.labelIsHidden
      .assign(to: \.isHidden, on: self.jokeLabel)
      .store(in: &cancellables)
    
    self.viewModel.outputs.loadingIndicatorIsHidden
     .assign(to: \.isHidden, on: self.loadingIndicator)
      .store(in: &cancellables)
    
    self.viewModel.outputs.emojiName
      .sink(receiveValue: { [weak self] name in
        self?.emojiImageView.image = UIImage(named: name)
      }).store(in: &cancellables)
  }
  
  // MARK: Actions
  
  @IBAction func jokeButtonTapped(_ sender: Any) {
    self.jokeButtonTappedInput.send(())
  }
}
