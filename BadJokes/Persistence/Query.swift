import Foundation

enum Operator {
  case lessThan
  case lessThanOrEqualTo
  case equalTo
  case greaterThanOrEqualTo
  case greaterThan
}

struct Query<T> {
  let predicate: Predicate<T>
}
