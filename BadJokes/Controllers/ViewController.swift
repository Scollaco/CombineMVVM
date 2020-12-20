import Combine
import SnapKit
import SwiftUI
import UIKit

final class ViewController: UIViewController {
  // MARK: Properties
  
  struct Layout {
    struct Button {
      static let width: CGFloat = 80
    }
    
    struct Image {
      static let width: CGFloat = 133
    }
  }
  
  private lazy var rootStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    return stackView
  }()
  
  private lazy var emojiImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var jokeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 0
    label.text = Strings.tapStartForAJoke
    label.textAlignment = .center
    return label
  }()
  
  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .white
    indicator.startAnimating()
    indicator.isHidden = true
    return indicator
  }()
  
  private lazy var jokesButton: UIButton = {
    let button = UIButton(type: .system)
    button.clipsToBounds = true
    button.layer.cornerRadius = Layout.Button.width / 2
    button.setTitle(Strings.start, for: .normal)
    button.tintColor = .white
    button.backgroundColor = UIColor.salmon
    button.addTarget(self, action: #selector(jokeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private var cancellables: [AnyCancellable] = []
  private let viewModel: JokesViewModelType = JokesViewModel(
    service: JokesService(service: Service()),
    scheduler: DispatchQueue.main.eraseToAnyScheduler()
  )
  
  // MARK: Lyfecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    bindViewModel()
    viewModel.inputs.viewDidLoad.send(())
  }
  
  private func setupViews() {
    view.backgroundColor = .systemTeal
      
    view.addSubview(rootStackView)

    rootStackView.addArrangedSubviews(
      emojiImageView,
      jokeLabel,
      loadingIndicator,
      jokesButton
    )
        
    rootStackView.snp.makeConstraints { make in
      make.bottomMargin.leadingMargin.trailingMargin.equalToSuperview()
      make.topMargin.bottomMargin.equalToSuperview().inset(70)
    }
    
    jokesButton.snp.makeConstraints { make in
      make.width.height.equalTo(Layout.Button.width)
    }
    
    emojiImageView.snp.makeConstraints { make in
      make.width.height.equalTo(Layout.Image.width)
    }
    
    jokeLabel.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }
  }
  
  // MARK: View model
  
  func bindViewModel() {
    viewModel.outputs.jokeLabelText
      .assign(to: \.text, on: jokeLabel)
      .store(in: &cancellables)
    
    viewModel.outputs.labelIsHidden
      .assign(to: \.isHidden, on: jokeLabel)
      .store(in: &cancellables)
    
    viewModel.outputs.loadingIndicatorIsHidden
      .assign(to: \.isHidden, on: loadingIndicator)
      .store(in: &cancellables)
    
    viewModel.outputs.emojiName
      .map { UIImage(named: $0) }
      .assign(to: \.image, on: emojiImageView)
      .store(in: &cancellables)
  }
  
  // MARK: Actions
  
  @objc private func jokeButtonTapped(_ sender: Any) {
    viewModel.inputs.jokeButtonTapped.send(())
  }
}

extension UIStackView {
  
  func addArrangedSubviews(_ views: UIView...) {
    views.forEach {
      addArrangedSubview($0)
    }
  }
}
