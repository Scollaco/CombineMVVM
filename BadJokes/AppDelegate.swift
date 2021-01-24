//
//  AppDelegate.swift
//  BadJokes
//
//  Created by Saturnino Collaco Teixeria Filho on 3/21/20.
//  Copyright © 2020 Saturnino. All rights reserved.
//
import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootVC = UIHostingController.init(rootView: JokeViewController())
    window?.rootViewController = rootVC
    window?.makeKeyAndVisible()
    
    return true
  }
}

