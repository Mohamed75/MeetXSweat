//
//  Util.swift
//  Zouzous
//
//  Created by Mohamed BOUMANSOUR on 18/01/2016.
//  Copyright © 2016 Tibo. All rights reserved.
//

import UIKit


// MARK: - *** Global Constants ***
let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String


/**
 *  A struct of constants about the device screen width.
 */
struct ScreenWidth {
    /// The current device screen width.
    static let current = UIScreen.mainScreen().bounds.size.width
    /// The iphone5 screen width.
    static let iphone5 = CGFloat(568)
    /// The iphone6 screen width.
    static let iphone6 = CGFloat(667)
}


// MARK: - *** Global Methodes ***

/**
 Schedule a block for execution on a main queue after a specified time.
 
 - parameter delay:   seconds to add.
 - parameter closure: A block to be Schedule.
 */
func dispatch_later(delay: Double, closure:()->()) {
    
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delay) * (NSEC_PER_SEC))),
        dispatch_get_main_queue(), closure)
}

/**
 A simple way to get the key window.
 
 - returns: The key Window.
 */
func getAppDelegateWindow() -> UIWindow {
    return UIApplication.sharedApplication().keyWindow!
}

/**
 A simple way to get the visible ViewController.
 
 - returns: a viewController.
 */
func getVisibleViewController() -> UIViewController {
    return getAppDelegateWindow().visibleViewController!
}

/**
 A simple way to get value of key from the app info plist.
 
 - parameter key: info plist key.
 
 - returns: info plist value.
 */
func getValueFromInfoPlist(key: String) -> AnyObject {
    
    return (NSBundle.mainBundle().objectForInfoDictionaryKey(key))!
}

/**
 Choose between two CGFloat values depending on current device type (iPad/iPhone).
 
 - parameter ipad:   iPad value.
 - parameter iphone: iPhone value.
 
 - returns: The iPad value if current device is an ipad otherwise iPhone value.
 */
func valueForIpad(ipad: CGFloat, iphone: CGFloat) -> CGFloat {
    
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad ? ipad : iphone
}

/**
 Choose between two String values depending on current device type (iPad/iPhone).
 
 - parameter ipad:   iPad value.
 - parameter iphone: iPhone value.
 
 - returns: The iPad value if current device is an ipad otherwise iPhone value.
 */
func valueForIpadString(ipad: String, iphone: String) -> String {
    
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad ? ipad : iphone
}

/**
 Choose between two Int32 values depending on current device type (iPad/iPhone).
 
 - parameter ipad:   iPad value.
 - parameter iphone: iPhone value.
 
 - returns: The iPad value if current device is an ipad otherwise iPhone value.
 */
func valueForIpadInt32(ipad: Int32, iphone: Int32) -> Int32 {
    
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad ? ipad : iphone
}

/**
 Choose between two String values depending on current device Screen width (up to iPhone 5/Not).
 
 - parameter up5:   up to iPhone5 value.
 - parameter lessOr5: less then iPhone5 value.
 
 - returns: The up5 value if current device Screen width is biger than iPhone 5 otherwise lessOr5 value.
 */
func valueForIphoneUp5(up5: CGFloat, lessOr5: CGFloat) -> CGFloat {
    
    return ScreenWidth.current > ScreenWidth.iphone5 ? up5 : lessOr5
}


// MARK: - *** Add more methodes to UIWindow class.
extension UIWindow {
    
    /// get the current presented/top viewController.
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    /**
     Return the Top/Current viewController by checking all kind of sub controllers.
     Used only by the current class recursivly.
     
     - parameter viewController: the rootviewController, could be a (UINavigationController, UITabBarController, UIViewController).
     
     - returns: the last viewController.
     */
    private static func getVisibleViewControllerFrom(viewController: UIViewController?) -> UIViewController? {
        if let nc = viewController as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = viewController as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = viewController?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return viewController
            }
        }
    }
    
    
}

// MARK: - *** Add more methodes to UIImage class.

public extension UIImage {
    
    /**
     Create and return an UIImage instance from a color for defined size.
     
     - parameter color: image color
     - parameter size:  image size
     */
    convenience init(color: UIColor, size: CGSize = CGSize(width:1, height:1)) {
        
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
    
    /**
     A simple way to Scale image to a given size.
     
     - parameter newSize: new image size.
     
     - returns: return new image resized.
     */
    func scaleImage(newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

// MARK: - *** Add more methodes to UIColor class.

extension UIColor {
    
    /// Get the red value of a color.
    var red: CGFloat {
        return CGColorGetComponents(self.CGColor)[0]
    }
    /// Get the green value of a color.
    var green: CGFloat {
        return CGColorGetComponents(self.CGColor)[1]
    }
    /// Get the blue value of a color.
    var blue: CGFloat {
        return CGColorGetComponents(self.CGColor)[2]
    }
    /// Get the alpha value of a color.
    var alpha: CGFloat {
        return CGColorGetComponents(self.CGColor)[3]
    }
}




/**
 *  This class was designed and implemented to provide simple methodes for basic usage.
 
 - superClass:  AnyObject.
 - classdesign  Helper/Utility.
 - coclass      None.
 - helps        Many other classes.
 - helper       None.
 */
class Utils {
    
    /**
      Find_out whether the current device is an iPad or not.
     
     - returns: true if the current device is an iPad otherwise false.
     */
    class func isIpad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad
    }
 
    
    /**
     Create an uiimage from the current screen.
     
     - parameter view: current screen.
     
     - returns: an image of the view.
     */
    class func screenShotMethod(view: UIView) -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.layer.presentationLayer()!.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     This methode allow to Skip files from being saved on the iCloud.
     As by default all DocumentDirectory files are saved on iCloud.
     
     - parameter skipBackup:          true to skip saving files.
     - parameter fileOrDirectoryPath: directory path of the files to skip from saving.
     */
    class func skipBackup(skipBackup: Bool, fileOrDirectoryPath: String) {
        
        let url = NSURL(fileURLWithPath:fileOrDirectoryPath)
        do {
            try url.setResourceValue(skipBackup, forKey: NSURLIsExcludedFromBackupKey)
            
        } catch {
            
        }
    }
    
    /**
     Load all images of an animation in array.
     
     - parameter name:       animation/images name
     - parameter startIndex: The first animation image index.
     - parameter endIndex:   The last animation image index.
     
     - returns: an array off all animation images.
     */
    class func loadAnimeImages(name: String, startIndex: Int, endIndex: Int) -> [CGImage] {
    
        var array = [CGImage]()
        for index in startIndex ..< endIndex {
            var imageName = String(format: "%@00%@", name, String(index))
            if index > 9 {
                imageName = String(format: "%@0%@", name, String(index))
            }
            array.append(UIImage(named:imageName)!.CGImage!)
        }
        return array
    }
    
    /**
     A simple way to add a gradient effect to a view.
     
     - parameter view: a view to wich a gradient will be add.
     */
    class func initGradient(view: UIView, startColor: UIColor, endColor: UIColor) {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame     = view.bounds
        gradientLayer.colors    = [startColor.CGColor, endColor.CGColor]
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    /**
     Find_out whether the app is running UnitTestsTarget/StandarTarget when debug mode.
     
     - returns: true if the current running target is UnitTests, otherwise false.
     */
    class func isRunningUnitTests() -> Bool {
    
        let env = NSProcessInfo.processInfo().environment
        
        // Library tests
        if let envValue: String = env["XCTestConfigurationFilePath"] {
            if envValue.rangeOfString("xctest") != nil {
                return true
            }
        }
        
        return false
    }
    
    
    class func makeHttpsUrlFromString(urlString: String) -> String {
        
        if urlString.componentsSeparatedByString("https").count < 2 {
            
            let index: String.Index = urlString.startIndex.advancedBy(4)
            let urlStringWithoutSchem = urlString.substringFromIndex(index)
            return "https"+urlStringWithoutSchem
        }
        return urlString
    }
}