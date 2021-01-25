import XCTest

class JokesUITests: BaseTest {
  
  func testTapJokes() {
    let jokesPage: JokesPage = JokesPage(app: app)

    let label = jokesPage.jokesLabel

    jokesPage
      .assertExists(label)
      
    
     jokesPage
      .tapStartButton()
      .assert {
        XCTAssertEqual(jokesPage.jokesLabel.label, "Welcome, Smith!")
      }
  }
}
