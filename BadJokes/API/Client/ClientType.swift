import Foundation
import ComposableArchitecture

protocol ClientType {
  
  func load<T: Decodable>(_ resource: Resource<T>) -> Effect<T, APIError>
}
