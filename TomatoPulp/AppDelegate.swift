//
//  AppDelegate.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import QMUIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GeTuiSdk.start(withAppId: "XotSLiKHSX7iswSsQlJir8", appKey: "ZjzdJP5fNH9BSWg8MMHek", appSecret: "7uQsaiZat670rSheNgfdh7", delegate: self as GeTuiSdkDelegate)
        registerRemoteNotification()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white;
        if clientShared.isLogin() {
            toMain()
        } else {
           toLogin()
        }
        window!.makeKeyAndVisible()
       
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        GeTuiSdk.registerDeviceTokenData(deviceToken)
        HttpUtils.default.request("/user/updateClientId", method: .post, params: ["clientId":GeTuiSdk.clientId()!]).response(success: { result in
            print("ClientId更新成功：\(String(describing: result))")
        }, failure: { error in
            print("ClientId更新失败：\(error)")
        })
    }
    
    func registerRemoteNotification() {
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [UNAuthorizationOptions.badge, UNAuthorizationOptions.sound, UNAuthorizationOptions.alert, UNAuthorizationOptions.carPlay]) { (granted, error) in
            print("registerRemoteNotification:\(String(describing: error))")
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func toMain() {
        let indexNav = AppNavigationController(rootViewController: SWIndexViewController())
        indexNav.tabBarItem.title = "index"
        
        let statusNav = AppNavigationController(rootViewController: SWStatusController())
        statusNav.tabBarItem.title = "status"
        
        let messageNav = AppNavigationController(rootViewController: SWMessageController())
        messageNav.tabBarItem.title = "message"
        
        let userNav = AppNavigationController(rootViewController: SWUserInfoViewController())
        userNav.tabBarItem.title = "user"
        
        let appTabs = QMUITabBarViewController.init()
        appTabs.viewControllers = [indexNav, statusNav, messageNav, userNav]
        window!.rootViewController = appTabs;
    }
    
    func toLogin() {
        window!.rootViewController = AppNavigationController(rootViewController: SWLoginViewController())
    }

}

extension AppDelegate : GeTuiSdkDelegate {
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
}
