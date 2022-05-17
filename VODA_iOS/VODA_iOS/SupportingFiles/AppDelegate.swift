//
//  AppDelegate.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/10.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import GoogleSignIn
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDKCommon.initSDK(appKey: SocialLoginType.kakao.appKey)
        
        checkFirstAppLaunch(application: application)

        if #available(iOS 13, *) {
            print("set in SceneDelegate")
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            if let onBoardingViewController = UIStoryboard(name: Storyboard.onBoarding.name, bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
                window.rootViewController = onBoardingViewController
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = GIDSignIn.sharedInstance.handle(url)
        
        if handled { return true }
        
        return false
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    private func getAppLaunchCount() -> Int {
        let appLaunchCount = UserDefaults.standard.integer(forKey: "appLaunchCount")
        
        return appLaunchCount
    }
    
    private func setAppLaunchCount() {
        let appLaunchCount = getAppLaunchCount()
        UserDefaults.standard.set(appLaunchCount + 1, forKey: "appLaunchCount")
    }
    
    private func checkFirstAppLaunch(application: UIApplication) {
        let appLaunchCount = getAppLaunchCount()
        
        if appLaunchCount < 1 {
            UserDefaults.standard.set(true, forKey: "pushFlag")
            registerNotification(application: application)
        } else {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                registerNotification(application: application)
            }
        }
        
        setAppLaunchCount()
    }
    
    public func registerNotification(application: UIApplication) {
        if FirebaseApp.app() == nil {
          FirebaseApp.configure()
        }
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in })
        application.registerForRemoteNotifications()
    }
}

// MARK: MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: \(fcmToken)")
    }
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("userInfo: \(userInfo)")
        
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfos = response.notification.request.content.userInfo
        print("userInfos: \(userInfos)")
        
        let application = UIApplication.shared
        if application.applicationState == .active {
            pushPushViewController()
        }
        
        if application.applicationState == .background || application.applicationState == .inactive {
            pushPushViewController()
        }
        
        completionHandler()
    }
    
    private func pushPushViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        if let mainViewController = UIStoryboard(name: Storyboard.main.name, bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController,
           let pushViewController = UIStoryboard(name: Storyboard.push.name, bundle: nil).instantiateViewController(withIdentifier: "PushViewController") as? PushViewController {
            sceneDelegate.window?.rootViewController?.setRootViewController(rootViewController: mainViewController)
            mainViewController.homeViewController?.navigationController?.pushViewController(pushViewController, animated: false)
        }
    }
}
