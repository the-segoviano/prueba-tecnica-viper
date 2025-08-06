//
//  AppDelegate.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let startViewController = ViewController()
        let navViewController = UINavigationController(rootViewController: startViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navViewController
        window?.makeKeyAndVisible()
        
        return true
    }


}

