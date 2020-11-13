import Foundation
import Combine

protocol ServiceType {
  
  func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<Result<T, APIError>, Never>
}
