//
//  AppDelegate.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 01.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    let navigationController = UINavigationController()
    let mainViewController = MapController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        
        setupNavBar()
        
        return true
    }
    
    func setupNavBar() {
        navigationController.viewControllers = [mainViewController]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
    }

  

}

