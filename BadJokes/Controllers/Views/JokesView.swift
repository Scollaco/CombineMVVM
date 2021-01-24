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
        Image("emoji_funny")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 150, height: 150, alignment: .top)
          
        Text(self.viewModel.jokeLabelText)
          .foregroundColor(.white)
          .font(.system(size: 21))
          .lineLimit(nil)
          .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        
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
    .background(Color.lightBlue.edgesIgnoringSafeArea(.all))
  }
  
  private func jokeButtonTapped() {
    self.viewModel.inputs.jokeButtonTapped.send(())
  }
}

struct JokeViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<JokeViewController>) -> UIHostingController<JokesView> {
        return UIHostingController(rootView: JokesView())
    }

    func updateUIViewController(_ uiViewController: UIHostingController<JokesView>, context: UIViewControllerRepresentableContext<JokeViewController>) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      JokesView()
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
