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
        AppConfigurationTemplate.apply()
        GeTuiSdk.start(withAppId: "XotSLiKHSX7iswSsQlJir8", appKey: "ZjzdJP5fNH9BSWg8MMHek", appSecret: "7uQsaiZat670rSheNgfdh7", delegate: self as GeTuiSdkDelegate)
        registerRemoteNotification()
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white;
        if clientShared.isLogin() {
            toMain()
            GeTuiSdk.setBadge(0)
            GeTuiSdk.resetBadge()
        } else {
           toLogin()
        }
        window!.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        GeTuiSdk.registerDeviceTokenData(deviceToken)
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
        
        let indexNav = AppNavigationController(rootViewController: SWASFViewController())
        indexNav.tabBarItem.title = "Index"
        indexNav.tabBarItem = UITabBarItem.init(title: "Index", image: UIImage.init(named: "tabbar_index"), selectedImage: UIImage.init(named: "tabbar_index_selected"))
        
        let statusNav = AppNavigationController(rootViewController: SWStatusController())
        statusNav.tabBarItem.title = "Status"
        statusNav.tabBarItem = UITabBarItem.init(title: "Message", image: UIImage.init(named: "tabbar_status"), selectedImage: UIImage.init(named: "tabbar_status_selected"))
        
        let messageNav = AppNavigationController(rootViewController: SWMessageController())
        messageNav.tabBarItem.title = "Message"
        messageNav.tabBarItem = UITabBarItem.init(title: "Message", image: UIImage.init(named: "tabbar_message"), selectedImage: UIImage.init(named: "tabbar_message_selected"))

        let userNav = AppNavigationController(rootViewController: SWUserInfoViewController())
        userNav.tabBarItem.title = "User"
        userNav.tabBarItem = UITabBarItem.init(title: "User", image: UIImage.init(named: "tabbar_user"), selectedImage: UIImage.init(named: "tabbar_user_selected"))

        let appTabs = QMUITabBarViewController.init()
        appTabs.viewControllers = [indexNav, statusNav, messageNav, userNav]
        window!.rootViewController = appTabs;
    }
    
    func toLogin() {
        window!.rootViewController = AppNavigationController(rootViewController: SWLoginViewController())
    }

}

extension AppDelegate : GeTuiSdkDelegate {
    
    /**
     *  SDK登入成功返回clientId
     *
     *  @param clientId 标识用户的clientId
     *  说明:启动GeTuiSdk后，SDK会自动向个推服务器注册SDK，当成功注册时，SDK通知应用注册成功。
     *  注意: 注册成功仅表示推送通道建立，如果appid/appkey/appSecret等验证不通过，依然无法接收到推送消息，请确保验证信息正确。
     */
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        print("SDK登入成功并返回clientId:\(String(describing: clientId))")
        if clientShared.isLogin() {
            if let clientIdStr = clientId {
                if clientIdStr != clientShared.user.clientId {
                    HttpUtils.default.request("/user/updateClientId", method: .post, params: ["clientId":clientIdStr]).response(success: { result in
                        print("ClientId更新成功：\(String(describing: result))")
                        clientShared.user.clientId = clientIdStr
                        clientShared.saveUserInfo()
                    }, failure: { error in
                        print("ClientId更新失败：\(error)")
                    })
                }
            }
        }
    }
    
    /**
     *  SDK通知收到个推推送的透传消息
     *
     *  @param payloadData 推送消息内容
     *  @param taskId      推送消息的任务id
     *  @param msgId       推送消息的messageid
     *  @param offLine     是否是离线消息，YES.是离线消息
     *  @param appId       应用的appId
     */
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        if let payloadMsg: String = String(data: payloadData, encoding: String.Encoding.utf8) {
            print("SDK通知收到个推推送的透传消息 PayloadData:\(payloadMsg) taskId:\(String(describing: taskId)) msgId:\(String(describing: msgId)) offLine:\(offLine) appId:\(String(describing: appId))")
            // 在线消息 创建Alert提醒
            if offLine == false {
                if let message = SWMessageModel.deserialize(from: payloadMsg) {
                    let alertController = QMUIAlertController.init(title: message.title, message: message.content, preferredStyle: .alert)
                    let dismissAction = QMUIAlertAction.init(title: "知道了", style: .cancel) { (alertController, dismissAction) in
                        alertController?.hideWith(animated: true)
                    }
                    alertController.addAction(dismissAction)
                    alertController.showWith(animated: true)
                }
            }
        }
    }
    
    /**
     * 查询当前绑定tag结果返回
     * @param aTags   当前绑定的 tag 信息
     * @param aSn     返回 queryTag 接口中携带的请求序列码，标识请求对应的结果返回
     * @param aError  成功返回nil,错误返回相应error信息
     */
    func getuiSdkDidQueryTag(_ aTags: [Any]!, sequenceNum aSn: String!, error aError: Error!) {
        print("查询当前绑定tag结果返回")
        print(aTags)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // 仅当应用程序位于前台时，才会在委托上调用该方法。如果未实现该方法或未及时调用处理程序，则不会显示通知。应用程序可以选择将通知显示为声音，徽章，警报和/或通知列表。该决定应基于通知中的信息是否对用户可见。
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("应用程序位于前台时收到推送")
    }
    
    // 当用户通过打开应用程序，解除通知或选择UNNotificationAction来响应通知时，将在代理上调用该方法。在应用程序从应用程序返回之前必须设置委托：didFinishLaunchingWithOptions：。
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        print("用户通过点击通知打开应用程序 response:")
    }
    
    // 响应用户查看应用内通知设置的请求启动应用程序时，将在代理上调用该方法。在requestAuthorizationWithOptions中添加UNAuthorizationOptionProvidesAppNotificationSettings作为选项：completionHandler：将按钮添加到内联通知设置视图和设置中的通知设置视图。从“设置”打开时，通知将为零。
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("响应用户查看应用内通知设置的请求启动应用程序")
    }

}
