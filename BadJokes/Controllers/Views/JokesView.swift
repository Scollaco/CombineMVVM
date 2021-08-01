import SwiftUI
import Foundation
import UIKit
import ComposableArchitecture

struct JokeState: Equatable {
  var emojiImage: String = Images.Emoji.sleeping
  var joke: String = "Tap the button for a joke!"
  var isLoading: Bool = false
}

enum JokeAction: Equatable {
  case jokesButtonTapped
  case jokesResponse(Result<Joke, Failure>)
}

struct JokeEnvironment {
  var jokeClient: JokeClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let jokeReducer = Reducer<JokeState, JokeAction, JokeEnvironment> { state, action, environment in
  
  switch action {
  case .jokesButtonTapped:
    struct JokeId: Hashable {}
    state.joke = ""
    state.isLoading = true
    state.emojiImage = Images.Emoji.sleeping
    
    let resource = Resource<Joke>(route: .fetchJoke)
    return environment.jokeClient
      .fetchJoke(resource)
      .receive(on: environment.mainQueue)
      .delay(for: 2, scheduler: environment.mainQueue)
      .catchToEffect()
      .map(JokeAction.jokesResponse)
    
  case .jokesResponse(.failure(let error)):
    state.joke = error.localizedDescription
    state.emojiImage = Images.Emoji.sad
    state.isLoading = false
    return .none
    
  case let .jokesResponse(.success(response)):
    state.joke = response.joke
    state.emojiImage = Images.Emoji.funny
    state.isLoading = false
    return .none
  }
}

struct JokesView: View {

  let store: Store<JokeState, JokeAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        Color.lightBlue
        
          VStack(alignment: .center) {
            Image(viewStore.emojiImage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 130, height: 130, alignment: .top)
            
            ZStack(alignment: .center) {
              Text(viewStore.joke)
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
              
              if viewStore.isLoading {
                ActivityIndicator()
                  .frame(width: 50, height: 50, alignment: .center)
                  .foregroundColor(.white)
              }
            }
            
            Button("Start") { viewStore.send(.jokesButtonTapped) }
              .foregroundColor(.white)
              .frame(width: 90, height: 90, alignment: .center)
              .background(Color.salmon)
              .clipShape(Circle())
              .font(.system(.headline))
              .accessibility(identifier: "startButton")
          }
          .padding([.top, .bottom], 50)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.lightBlue)
    }
  }
}
