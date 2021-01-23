import SwiftUI

struct Joke: Decodable, Identifiable {
  let id: String
  let joke: String
  
  init(id: String, joke: String) {
    self.id = id
    self.joke = joke
  }
}
