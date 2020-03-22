import Combine
import UIKit

class ViewController: UIViewController {

  private var cancellables: [AnyCancellable] = []
  private let viewModel: JokesViewModelType = JokesViewModel(service: JokesService(service: Service()))
  private let viewDidLoadInput = PassthroughSubject<Void, Never>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let input = JokesViewModelInput(viewDidLoad: self.viewDidLoadInput.eraseToAnyPublisher())
    
    self.viewModel.transform(input: input)
    self.viewDidLoadInput.send(())
    self.viewModel.outputs.joke
      .sink(receiveValue: { joke in
        print(joke?.joke)
      }).store(in: &cancellables)
    
    viewDidLoadInput.send()
  }
}

