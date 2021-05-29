import Foundation

enum Predicate<T> {
  case comparison(PartialKeyPath<T>, Operator, Primitive)
}

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
