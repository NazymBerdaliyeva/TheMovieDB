//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by mac on 4/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var mainWidth: CGFloat = UIScreen.main.bounds.width
    static var mainHeight: CGFloat = UIScreen.main.bounds.height

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabbar = TabBarViewController()
        let movieNavVC = UINavigationController(rootViewController: MovieViewController())
        let genreNavVc = UINavigationController(rootViewController: GenreViewController())
        
        tabbar.viewControllers = [movieNavVC, genreNavVc]
        window?.rootViewController = tabbar
        
        return true
    }

}

