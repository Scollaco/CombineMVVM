import Combine

protocol Store {
  associatedtype Object
  
  func insert(_ object: Object) -> Future<Object, Error>
  func update(_ object: Object) -> Future<Object, Error>
  func delete(_ object: Object) -> Future<Object, Error>
  func execute(_ query: Query<Object>) -> Future<[Object], Error>
}
