import SwiftUI
import ComposableArchitecture

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIHostingController(
      rootView: JokesView(
        store: Store(
          initialState: JokeState(),
          reducer: jokeReducer.debug(),
          environment: JokeEnvironment(
            jokeClient: JokeClient.live,
            mainQueue: AnySchedulerOf<DispatchQueue>(DispatchQueue.main)
          )
        )
      )
    )
    window?.rootViewController?.view.backgroundColor = UIColor.lightBlue
    window?.makeKeyAndVisible()
    return true
  }
}

