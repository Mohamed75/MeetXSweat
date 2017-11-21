//
//  Util.swift
//  Zouzous
//
//  Created by Mohamed BOUMANSOUR on 18/01/2016.
//  Copyright © 2016 Tibo. All rights reserved.
//

import UIKit


// MARK: - *** Global Constants ***
let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String


/**
 *  A struct of constants about the device screen sizes.
 */
struct ScreenSize {
    /// The current device screen Heigh.
    static let currentHeight    = UIScreen.main.bounds.size.height
    static let currentWidth     = UIScreen.main.bounds.size.width
    
    /// The iphone5 screen Height.
    static let iphone4Height = CGFloat(480)
    /// The iphone5 screen Height.
    static let iphone5Height = CGFloat(568)
    /// The iphone6 screen Height.
    static let iphone6Height = CGFloat(667)
    
    /// The iphone4,5 screen Width.
    static let iphone45Width = CGFloat(320)
    /// The iphone6 screen Width.
    static let iphone6Width = CGFloat(375)
}


/**
 *  A struct of constants about the device screen type.
 */
struct DeviceType
{
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_5 = IS_IPHONE && ScreenSize.currentHeight == 568.0
    static let IS_IPHONE_6_7 = (UIDevice.current.userInterfaceIdiom == .phone) && (ScreenSize.currentHeight == 667.0) && (UIScreen.main.nativeScale >= UIScreen.main.scale)
    private static let IS_STANDARD_IPHONE_6P_7P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.currentHeight == 736.0
    private static let IS_ZOOMED_IPHONE_6P_7P = (UIDevice.current.userInterfaceIdiom == .phone) && (ScreenSize.currentHeight == 667.0) && (UIScreen.main.nativeScale < UIScreen.main.scale)
    static let IS_IPHONE_6P_7P = IS_STANDARD_IPHONE_6P_7P || IS_ZOOMED_IPHONE_6P_7P
}


// MARK: - *** Global Methodes ***

/**
 Schedule a block for execution on a main queue after a specified time.
 
 - parameter delay:   seconds to add.
 - parameter closure: A block to be Schedule.
 */
func dispatch_later(_ delay: Double, closure:@escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/**
 A simple way to get the key window.
 
 - returns: The key Window.
 */
func getAppDelegateWindow() -> UIWindow {
    return UIApplication.shared.keyWindow!
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
func getValueFromInfoPlist(_ key: String) -> AnyObject {
    
    return (Bundle.main.object(forInfoDictionaryKey: key))! as AnyObject
}

/**
 Choose between two CGFloat values depending on current device type (iPad/iPhone).
 
 - parameter ipad:   iPad value.
 - parameter iphone: iPhone value.
 
 - returns: The iPad value if current device is an ipad otherwise iPhone value.
 */
func valueForIpad(_ ipad: CGFloat, iphone: CGFloat) -> CGFloat {
    
    return UIDevice.current.userInterfaceIdiom == .pad ? ipad : iphone
}

/**
 Choose between two String values depending on current device type (iPad/iPhone).
 
 - parameter ipad:   iPad value.
 - parameter iphone: iPhone value.
 
 - returns: The iPad value if current device is an ipad otherwise iPhone value.
 */
func valueForIpadString(_ ipad: String, iphone: String) -> String {
    
    return UIDevice.current.userInterfaceIdiom == .pad ? ipad : iphone
}

/**
 Choose between two Int32 values depending on current device type (iPad/iPhone).
 
 - parameter ipad:   iPad value.
 - parameter iphone: iPhone value.
 
 - returns: The iPad value if current device is an ipad otherwise iPhone value.
 */
func valueForIpadInt32(_ ipad: Int32, iphone: Int32) -> Int32 {
    
    return UIDevice.current.userInterfaceIdiom == .pad ? ipad : iphone
}

/**
 Choose between two String values depending on current device Screen width (up to iPhone 5/Not).
 
 - parameter up5:   up to iPhone5 value.
 - parameter lessOr5: less then iPhone5 value.
 
 - returns: The up5 value if current device Screen width is biger than iPhone 5 otherwise lessOr5 value.
 */
func valueForIphoneUp5(_ up5: CGFloat, lessOr5: CGFloat) -> CGFloat {
    
    return ScreenSize.currentHeight > ScreenSize.iphone5Height ? up5 : lessOr5
}

/**
 A simple way to know if the system verion is greater the a given version.
 
 - version: a given version value.
 
 - returns: true if the system version is greater the a given version, otherwise false.
 */
func isIOSVersionGReaterThan(version: Float) -> Bool {
    
    var systemVersion   = UIDevice.current.systemVersion
    let systemVersions  = systemVersion.components(separatedBy: ".")
    if systemVersions.count > 2 {
        systemVersion = systemVersions.first! + "." + systemVersions[1]
    }
    print(systemVersion)
    if let aSystemVersion = Float(systemVersion), aSystemVersion > version {
        print("true")
        return true
    }
    print("false")
    return false
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
    fileprivate static func getVisibleViewControllerFrom(_ viewController: UIViewController?) -> UIViewController? {
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
        self.init(cgImage: (image?.cgImage!)!)
    }
    
    /**
     A simple way to Scale image to a given size.
     
     - parameter newSize: new image size.
     
     - returns: return new image resized.
     */
    func scaleImage(_ newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

// MARK: - *** Add more methodes to UIColor class.

extension UIColor {
    
    /// Get the red value of a color.
    var aRed: CGFloat {
        return self.cgColor.components![0]
    }
    /// Get the green value of a color.
    var green: CGFloat {
        return self.cgColor.components![1]
    }
    /// Get the blue value of a color.
    var blue: CGFloat {
        return self.cgColor.components![2]
    }
    /// Get the alpha value of a color.
    var alpha: CGFloat {
        return self.cgColor.components![3]
    }
}


// MARK: - *** Add more methodes to String class.

extension String {
    
    // Check if the email is valid
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
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
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
 
    
    /**
     Create an uiimage from the current screen.
     
     - parameter view: current screen.
     
     - returns: an image of the view.
     */
    class func screenShotMethod(_ view: UIView) -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.layer.presentation()!.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /**
     This methode allow to Skip files from being saved on the iCloud.
     As by default all DocumentDirectory files are saved on iCloud.
     
     - parameter skipBackup:          true to skip saving files.
     - parameter fileOrDirectoryPath: directory path of the files to skip from saving.
     */
    class func skipBackup(_ skipBackup: Bool, fileOrDirectoryPath: String) {
        
        let url = URL(fileURLWithPath:fileOrDirectoryPath)
        do {
            try (url as NSURL).setResourceValue(skipBackup, forKey: URLResourceKey.isExcludedFromBackupKey)
            
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
    class func loadAnimeImages(_ name: String, startIndex: Int, endIndex: Int) -> [CGImage] {
    
        var array = [CGImage]()
        for index in startIndex ..< endIndex {
            var imageName = String(format: "%@00%@", name, String(index))
            if index > 9 {
                imageName = String(format: "%@0%@", name, String(index))
            }
            array.append(UIImage(named:imageName)!.cgImage!)
        }
        return array
    }
    
    /**
     A simple way to add a gradient effect to a view.
     
     - parameter view: a view to wich a gradient will be add.
     */
    class func initGradient(_ view: UIView, startColor: UIColor, endColor: UIColor) {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame     = view.bounds
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /**
     Find_out whether the app is running UnitTestsTarget/StandarTarget when debug mode.
     
     - returns: true if the current running target is UnitTests, otherwise false.
     */
    class func isRunningUnitTests() -> Bool {
    
        let env = ProcessInfo.processInfo.environment
        
        // Library tests
        if let envValue: String = env["XCTestConfigurationFilePath"] {
            if envValue.range(of: "xctest") != nil {
                return true
            }
        }
        
        return false
    }
    
    /**
     Replace http with https for string url.
     
     - returns: an https string url.
     */
    class func makeHttpsUrlFromString(_ urlString: String) -> String {
        
        if urlString.components(separatedBy: "https").count < 2 {
            
            let index: String.Index = urlString.characters.index(urlString.startIndex, offsetBy: 4)
            let urlStringWithoutSchem = urlString.substring(from: index)
            return "https"+urlStringWithoutSchem
        }
        return urlString
    }
    
    /**
     Add a tapGestureRecognizer to a view.
     */
    class func addTapGestureToView(_ view: UIView, target: AnyObject, selectorString: String) {
    
        let tapGesture = UITapGestureRecognizer(target: target, action: NSSelectorFromString(selectorString))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    /**
     Load a viewController from a story board.
     
     - returns: the viewController.
     */
    class func loadViewControllerFromStoryBoard(_ stroyBoard: String, viewControllerId: String) -> UIViewController {
        return UIStoryboard(name: stroyBoard, bundle: nil).instantiateViewController(withIdentifier: viewControllerId)
    }
    
    
    
    
    /**
     Show a social ActivityViewController on top of the current ViewController.
     */
    class func sharing(shareItems: [Any], onController: UIViewController) {
        
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll]
        onController.present(activityViewController, animated: true, completion: nil)
    }
    
    // Wrtite to plist
    static func writeToPlist() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths.firstObject as! String
        let path = documentDirectory+("myData.plist")
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            let bundle : NSString = Bundle.main.path(forResource: "MyData", ofType: "plist")! as NSString
            do {
                try fileManager.copyItem(atPath: bundle as String, toPath: path)
            } catch {
                print(error)
            }
        }
        
        let bytes = NSKeyedArchiver.archivedData(withRootObject: self)
        if !((try? bytes.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil) {
            print("succes writing plist")
        }
    }
    
    // Load from plist
    class func myloadData() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths.firstObject as! String
        let path = documentDirectory+("myData.plist")
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("load myData.plist is ->\(String(describing: resultDictionary?.description))")
        
        let myDict = NSDictionary(contentsOfFile: path)
        for dtaa in myDict! {
            print(dtaa)
        }
    }
    
    class func saveDeviceTokenInUserDefault(deviceToken: Data) {
        
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "apnsToken")
    }
    
    class func getDeviceTokenFromUserDefault() -> String {
        
        guard let token = UserDefaults.standard.object(forKey: "apnsToken") as? String else {
            return ""
        }
        return token
    }
    
    class func isUnitTesting() -> Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
