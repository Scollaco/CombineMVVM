import Foundation

struct Resource<T: Decodable> {
  
  private let route: Route
  private var url: URL? {
    return URL(string: ApiConstants.baseUrl + self.route.properties.path)
  }
  
  var request: URLRequest? {
    guard let url = self.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return nil
    }
    
    let parameters = self.route.properties.parameters
    
    components.queryItems = parameters.keys.map { key in
      URLQueryItem(name: key, value: parameters[key]?.description)
    }
    guard let componentsURL = components.url else {
      return nil
    }
    return URLRequest(url: componentsURL)
  }
  
  init(route: Route) {
    self.route = route
  }
}
