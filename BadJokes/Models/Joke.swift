import SwiftUI

struct Joke: Decodable, Equatable {
  let joke: String
  
  init(joke: String) {
    self.joke = joke
  }
}
