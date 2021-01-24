import SwiftUI
import UIKit

struct JokesView: View {
  typealias UIViewControllerType = JokeViewController
  
   @ObservedObject var viewModel = JokesViewModel(
      service: JokesService(service: Service()),
      scheduler: DispatchQueue.main.eraseToAnyScheduler()
  )
  
  var body: some View {
    GeometryReader { geometry in
      VStack(alignment: .center) {
        Image(self.viewModel.emojiName)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 130, height: 130, alignment: .top)
          
        ZStack(alignment: .center) {
          Text(self.viewModel.jokeLabelText)
            .foregroundColor(.white)
            .font(.system(size: 21))
            .lineLimit(nil)
            .padding(.horizontal, 20)
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity
            )
            .visibility(hidden: self.$viewModel.labelIsHidden)
          
          ActivityIndicator()
            .frame(width: 50, height: 50, alignment: .center)
            .foregroundColor(.white)
            .visibility(hidden: self.$viewModel.loadingIndicatorIsHidden)
        }
        
        Button("Start", action: self.jokeButtonTapped)
          .foregroundColor(.white)
          .frame(width: 90, height: 90, alignment: .center)
          .background(Color.salmon)
          .clipShape(Circle())
          .font(.system(.headline))
      }
      .padding([.top, .bottom], 50)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(Color.lightBlue)
  }
  
  private func jokeButtonTapped() {
    self.viewModel.inputs.jokeButtonTapped.send(())
  }
}

struct JokeViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<JokeViewController>) -> UIHostingController<JokesView> {
      let viewController = UIHostingController(rootView: JokesView())
      return viewController
    }

    func updateUIViewController(_ uiViewController: UIHostingController<JokesView>, context: UIViewControllerRepresentableContext<JokeViewController>) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      JokesView()
    }
}
