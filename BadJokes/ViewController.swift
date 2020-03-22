import Combine
import UIKit

final class ViewController: UIViewController {
  
  @IBOutlet weak var emojiImageView: UIImageView!
  @IBOutlet weak var jokeLabel: UILabel!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  private var cancellables: [AnyCancellable] = []
  private let viewModel: JokesViewModelType = JokesViewModel(service: JokesService(service: Service()))
  
  private var jokeButtonTappedInput = PassthroughSubject<Void, Never>()
  private let viewDidLoadInput = PassthroughSubject<Void, Never>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bindViewModel()
    self.viewDidLoadInput.send()
  }
  
  func bindViewModel() {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let input = JokesViewModelInput(jokeButtonTappedInput: jokeButtonTappedInput.eraseToAnyPublisher(),
                                    viewDidLoad: self.viewDidLoadInput.eraseToAnyPublisher())
    
    self.viewModel.transform(input: input)
    
    self.viewModel.outputs.joke
      .sink(receiveValue: { [weak self] joke in
        self?.jokeLabel.text = joke?.joke
      }).store(in: &cancellables)
    
    self.viewModel.outputs.emojiName
      .sink(receiveValue: { [weak self] name in
        self?.emojiImageView.image = UIImage(named: name)
      }).store(in: &cancellables)
    
    self.viewModel.outputs.labelIsHidden
      .sink(receiveValue: { [weak self] isHidden in
        self?.jokeLabel.isHidden = isHidden
      }).store(in: &cancellables)
    
    self.viewModel.outputs.loadingIndicatorIsHidden
      .sink(receiveValue: { [weak self] isHidden in
        self?.loadingIndicator.isHidden = isHidden
      }).store(in: &cancellables)
  }
  
  @IBAction func jokeButtonTapped(_ sender: Any) {
    self.jokeButtonTappedInput.send(())
  }
}

