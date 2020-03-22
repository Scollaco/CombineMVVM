import Foundation

struct JokeEnvelope: Decodable {
  let results: [Joke]
}

struct Joke: Decodable {
  let id: String
  let joke: String
}
