//
//  AppDelegate.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import Firebase
import DrawerController
import UserNotifications


private let FIRSignInblock: FIRAuthResultCallback = { (user, error) in
    if (error != nil) {
        NSLog("signInAnonymously error")
    } else {
        NSLog("signInAnonymously succes")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    /** This methode set the DrawerController as the rootViewController with the a UINavigationViewController as centerViewController and the MXSMenuViewController as leftViewController
     **/
    func __initTheDrawerController() {
        
        let center = window?.rootViewController;
        
        let drawerController = DrawerController(centerViewController: center!, leftDrawerViewController: MXSMenuViewController())
        drawerController.closeDrawerGestureModeMask = CloseDrawerGestureMode.panningCenterView
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
    }
    
    
    func __initPushNotification(application: UIApplication) {
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if PROD
            let filePath = Bundle.main.path(forResource: "GoogleServiceProd-Info", ofType: "plist")
            let options = FIROptions(contentsOfFile: filePath)
            FIRApp.configure(with: options!)
        #else
            FIRApp.configure()
        #endif
        
        FIRDatabase.database().persistenceEnabled = true
        FIRAuth.auth()?.signInAnonymously(completion: FIRSignInblock)
        
        TwitterHelper.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        __initTheDrawerController()
        __initPushNotification(application: application)
    
        return FaceBookHelper.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FaceBookHelper.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation as AnyObject) || GoogleLogInHelper.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation as AnyObject?)
    }
    
    private class func application(_ application: UIApplication, openURL url: URL, options: [String: AnyObject]) -> Bool {
        return GoogleLogInHelper.application(application, openURL: url, options: options)
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        FireBaseDataManager.sharedInstance.loadData()
        ConversationsDataManager.sharedInstance.loadData()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "apnsToken")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }

}

