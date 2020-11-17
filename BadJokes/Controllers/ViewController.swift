import Combine
import SwiftUI
import UIKit

final class ViewController: UIViewController {
    // MARK: Properties

    @IBOutlet private weak var emojiImageView: UIImageView!
    @IBOutlet private weak var jokeLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    private var cancellables: [AnyCancellable] = []
    private let viewModel: JokesViewModelType = JokesViewModel(
        service: JokesService(service: Service()),
        scheduler: DispatchQueue.main.eraseToAnyScheduler()
    )

    // MARK: Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindViewModel()
        self.viewModel.inputs.viewDidLoad.send(())
    }

    // MARK: View model

    func bindViewModel() {
        self.viewModel.outputs.jokeLabelText
            .assign(to: \.text, on: self.jokeLabel)
            .store(in: &cancellables)

        self.viewModel.outputs.labelIsHidden
            .assign(to: \.isHidden, on: self.jokeLabel)
            .store(in: &cancellables)

        self.viewModel.outputs.loadingIndicatorIsHidden
            .assign(to: \.isHidden, on: self.loadingIndicator)
            .store(in: &cancellables)

        self.viewModel.outputs.emojiName
            .map { UIImage(named: $0) }
            .assign(to: \.image, on: self.emojiImageView)
            .store(in: &cancellables)
    }

    // MARK: Actions

    @IBAction func jokeButtonTapped(_ sender: Any) {
        self.viewModel.inputs.jokeButtonTapped.send(())
    }
}
