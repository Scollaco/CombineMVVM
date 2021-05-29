import SwiftUI
import UIKit

struct JokesView: View {
  @ObservedObject var viewModel = JokesViewModel(
    service: JokesService(service: Service()),
    scheduler: DispatchQueue.main.eraseToAnyScheduler()
  )
  
  var body: some View {
    NavigationView {
      ZStack {
        NavigationLink(
          "",
          destination: JokesListView(),
          isActive: $viewModel.shouldPushFavoritesView
        )
        
        GeometryReader { geometry in
          VStack(alignment: .center) {
            EmojiImageView(
              imageName: self.$viewModel.emojiName
            )
            ZStack(alignment: .center) {
              JokeLabel(
                text: self.$viewModel.jokeLabelText,
                isHidden: self.$viewModel.labelIsHidden
              )
              ActivityIndicator()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(.white)
                .visibility(hidden: self.$viewModel.loadingIndicatorIsHidden)
            }
            JokeButton(
              action: self.jokeButtonTapped
            )
          }
          .padding([.top, .bottom], 100)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.lightBlue).edgesIgnoringSafeArea([.all])
      }
      .navigationBarTitle(Text(""), displayMode: .large)
      .navigationBarItems(
        leading:
          Button(action: addButtonTapped) {
            Image(systemName: "icloud.and.arrow.up.fill").imageScale(.large)
          }
          .foregroundColor(
            self.$viewModel.addButtonIsActive.wrappedValue ? Color.white : Color.white.opacity(0.7)
          )
          .disabled(self.$viewModel.addButtonIsActive.wrappedValue),
        trailing:
          Button(action: favoritesButtonTapped) {
            Image(systemName: "star.fill").imageScale(.large)
          }
          .foregroundColor(
            self.$viewModel.addButtonIsActive.wrappedValue ? Color.white : Color.white.opacity(0.7)
          )
          .disabled(self.$viewModel.addButtonIsActive.wrappedValue)
      )
        .alert(isPresented: $viewModel.shouldShowAlertView) {
          Alert(
            title: Text(""),
            message: Text("Joke added to favorites!"),
            dismissButton: .default(Text("OK"))
          )
      }
    }
  }
  
  private func addButtonTapped() {
    self.viewModel.inputs.addButtonTapped.send(())
  }
  
  private func favoritesButtonTapped() {
    self.viewModel.inputs.favoritesButtonTapped.send(())
  }
  
  private func jokeButtonTapped() {
    self.viewModel.inputs.jokeButtonTapped.send(())
  }
}

struct JokeButton: View {
  let action: () -> Void
  
  var body: some View {
    Button("Start", action: action)
      .foregroundColor(.white)
      .frame(width: 90, height: 90, alignment: .center)
      .background(Color.salmon)
      .clipShape(Circle())
      .font(.system(.headline))
      .accessibility(identifier: "startButton")
  }
}

struct JokeLabel: View {
  @Binding var text: String
  @Binding var isHidden: Bool
  
  var body: some View {
    Text(text)
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
      .accessibility(identifier: "jokesLabel")
      .visibility(hidden: $isHidden)
  }
  
  init(text: Binding<String>, isHidden: Binding<Bool>) {
    self._text = text
    self._isHidden = isHidden
  }
}

struct EmojiImageView: View {
  @Binding var imageName: String
  
  var body: some View {
    Image(imageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 130, height: 130, alignment: .top)
  }
  
  init(imageName: Binding<String>) {
    self._imageName = imageName
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    JokesView()
  }
}
