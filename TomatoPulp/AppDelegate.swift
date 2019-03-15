//
//  AppDelegate.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import QMUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white;
        if clientShared.isLogin() {
            toMain()
            clientShared.refreshToekn()
        } else {
            toLogin()
        }
        window!.makeKeyAndVisible()
        return true
    }
    
    func toLogin() {
        window!.rootViewController = AppNavigationController(rootViewController: SWLoginViewController())
    }
    
    func toMain() {
        let indexNav = AppNavigationController(rootViewController: SWIndexViewController())
        indexNav.tabBarItem.title = "index"

    
        let statusNav = AppNavigationController(rootViewController: SWStatusController())
        statusNav.tabBarItem.title = "status"
        
        let userNav = AppNavigationController(rootViewController: SWUserInfoViewController())
        userNav.tabBarItem.title = "user"
        
        let appTabs = QMUITabBarViewController.init()
        appTabs.viewControllers = [statusNav, indexNav, userNav]
        window!.rootViewController = appTabs;
    }

}

