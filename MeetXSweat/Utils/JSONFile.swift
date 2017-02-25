//
//  JSONFile.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/7/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class JSONFile {
    
    
    static func jsonDataFromFile(file: String) -> String {
        
        if let path = NSBundle(forClass: JSONFile.self).pathForResource(file, ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                return String(data: jsonData, encoding: NSUTF8StringEncoding)!
            }
        }
        return ""
    }
    
    // Nothing with json
    static func writeToPlist() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentDirectory = paths.firstObject as! String
        let path = documentDirectory+("myData.plist")
        let fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path)))
        {
            let bundle : NSString = NSBundle.mainBundle().pathForResource("MyData", ofType: "plist")!
            do {
                try fileManager.copyItemAtPath(bundle as String, toPath: path)
            } catch {
                print(error)
            }
        }
        
        let bytes = NSKeyedArchiver.archivedDataWithRootObject(self)
        if !bytes.writeToFile(path, atomically: true) {
            print("succes writing plist")
        }
    }
    // Nothing with json
    class func myloadData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentDirectory = paths.firstObject as! String
        let path = documentDirectory+("myData.plist")
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("load myData.plist is ->\(resultDictionary?.description)")
        
        let myDict = NSDictionary(contentsOfFile: path)
        for dtaa in myDict! {
            print(dtaa)
        }
    }
}
