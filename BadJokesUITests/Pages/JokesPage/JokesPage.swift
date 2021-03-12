import XCTest
@testable import BadJokes

class JokesPage: Page {
  
  var app: XCUIApplication
  var view: XCUIElement {
    return findAll(XCUIElement.ElementType.window).firstMatch
  }
  
  required init(app: XCUIApplication) {
    self.app = app
  }
  
  private var startButton: XCUIElement {
    return app
      .buttons
      .matching(identifier: "startButton")
      .firstMatch
  }
  
  var jokesLabel: XCUIElement {
    return app.staticTexts["jokesLabel"]
      .firstMatch
  }
  
  func tapStartButton() -> JokesPage {
    startButton.tap()
    return JokesPage(app: app)
  }
}
