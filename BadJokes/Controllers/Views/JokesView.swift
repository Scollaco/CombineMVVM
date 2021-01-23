import SwiftUI
import UIKit

struct JokesView: View {
  @State var savedJokes: [Joke] = [Joke(id: "1", joke: "My joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! joke! "), Joke(id: "2", joke: "My joke!")]
  
  var body: some View {
    List {
      ForEach(savedJokes) { joke in
        VStack {
          Text(joke.joke)
          .font(.headline)
        }
      }.onDelete(perform: deleteJokes)
    }
  }
  
  func deleteJokes(at offsets: IndexSet) {
    savedJokes.remove(atOffsets: offsets)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      JokesView()
    }
}
