//
//  JSONFile.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/7/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


/**
 *  This class was designed and implemented to provide a JsonFile helper.
 
 */

class JSONFile {
    
    
    class func jsonDataFromFile(_ file: String) -> String {
        
        if let path = Bundle(for: JSONFile.self).path(forResource: file, ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                return String(data: jsonData, encoding: String.Encoding.utf8)!
            }
        }
        return ""
    }
    
}
