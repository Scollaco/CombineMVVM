import XCTest

protocol Page {
    /// The XCUIApplication for the context of a Page
    var app: XCUIApplication { get }
    /// The UI element that represents the whole page
    var view: XCUIElement { get }

    init(app: XCUIApplication)
}

extension Page {
  func assert(_ f: () -> Void) {
    f()
  }
  
  func assertExists(_ element: XCUIElement) {
    XCTAssert(element.exists)
  }
  
  func findAll(_ type: XCUIElement.ElementType) -> XCUIElementQuery {
     return self.app.descendants(matching: type)
   }
}
