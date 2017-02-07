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
}
