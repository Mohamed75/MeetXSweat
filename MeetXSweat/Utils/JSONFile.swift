//
//  JSONFile.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/7/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class JSONFile {
    
    
    static func jsonDataFromFile(_ file: String) -> String {
        
        if let path = Bundle(for: JSONFile.self).path(forResource: file, ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                return String(data: jsonData, encoding: String.Encoding.utf8)!
            }
        }
        return ""
    }
    
    // Nothing with json
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
    // Nothing with json
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
}
