//
//  AppDelegate.swift
//  CleverlanceTest
//
//  Created by Jan Kase on 2019-07-10.
//  Copyright © 2019 Jan Kaše. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Configuration.Colors.applyColorScheme()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = MainScreenView()
    window?.makeKeyAndVisible()
    return false
  }
}
