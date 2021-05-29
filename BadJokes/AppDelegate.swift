import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootVC = UIHostingController.init(rootView: JokesView())
    window?.rootViewController = rootVC
    window?.rootViewController?.view.backgroundColor = UIColor.lightBlue
    window?.makeKeyAndVisible()
    return true
  }
}

