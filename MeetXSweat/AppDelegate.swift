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
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    /** This methode set the DrawerController as the rootViewController with the a UINavigationViewController as centerViewController and the MXSMenuViewController as leftViewController
     **/
    func __initTheDrawerController() {
        
        let center = self.window?.rootViewController;
        
        let drawerController = DrawerController(centerViewController: center!, leftDrawerViewController: MXSMenuViewController())
        drawerController.closeDrawerGestureModeMask = CloseDrawerGestureMode.PanningCenterView
        self.window!.rootViewController = drawerController
        self.window!.makeKeyAndVisible()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user, error) in
            if (error != nil) {
                NSLog("signInAnonymously error")
            } else {
               NSLog("signInAnonymously succes") 
            }
        })
        
        TwitterHelper.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        __initTheDrawerController()
        
        
        GMSServices.provideAPIKey("AIzaSyD_HmPgaGABrV7jG2n9b3SrBJUrRR6bovc")
        
        
        return FaceBookHelper.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FaceBookHelper.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) || GoogleLogInHelper.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    class func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GoogleLogInHelper.application(application, openURL: url, options: options)
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

