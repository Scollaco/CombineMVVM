import Combine

protocol Store {
  associatedtype Object
  
  func insert(_ object: Object) -> Future<Object, Error>
  func update(_ object: Object) -> Future<Object, Error>
  func delete(_ object: Object) -> Future<Object, Error>
  func execute(_ query: Query<Object>) -> Future<[Object], Error>
}

extension Store {
  func filter(where predicate: Predicate<Object>) -> Future<[Object], Error> {
    let query = Query(predicate: predicate)
    return execute(query)
  }
}
