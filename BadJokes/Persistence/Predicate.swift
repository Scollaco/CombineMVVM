import Foundation

enum Predicate<T> {
  case comparison(PartialKeyPath<T>, Operator, Primitive)
}

func == <T, U: Equatable & Primitive> (lhs: KeyPath<T, U>, rhs: U) -> Predicate<T> {
    return .comparison(lhs, .equalTo, rhs)
}
