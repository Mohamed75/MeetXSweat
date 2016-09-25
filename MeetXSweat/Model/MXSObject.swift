//
//  NSObject+Properties.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/25/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation



class MXSObject: NSObject {
    
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    
    private func arrayAsJson(name: String, value: AnyObject) -> AnyObject {
        
        let firstElement = (value as! NSArray).firstObject as! NSObject
        if firstElement.isKindOfClass(MXSObject) {
            var jsonArray: [AnyObject] = []
            for elemnt: MXSObject in (value as! [MXSObject]) {
                jsonArray.append(elemnt.asJson([]))
            }
            return jsonArray
        }
        else {
            return value
        }
    }
    
    func asJson(ignoreAttributes: [String]) -> [String: AnyObject] {
        
        var json = [String: AnyObject]()
        var properties = propertyNames()
        for property in ignoreAttributes {
            let index = properties.indexOf(property)
            properties.removeAtIndex(index!)
        }
        for name in properties {
            
            if let value = valueForKey(name) {
                if value.isKindOfClass(NSArray) && (value as! NSArray).count > 0 {
                    json[name] = arrayAsJson(name, value: value)
                } else {
                    json[name] = value
                }
            }
        }
        return json
    }
    
    
    private func propertyNames() -> Array<String> {
        
        let klass: AnyClass = object_getClass(self)
        var results: Array<String> = []
        
        // get the attributes of the current class
        var count: UInt32 = 0
        let properties = class_copyPropertyList(klass, &count)
        if count > 0 {
            // iterate each objc_property_t struct
            for i: UInt32 in 0...count-1 {
                
                let cname = property_getName(properties[Int(i)])
                // covert the c string into a Swift string
                let name = String.fromCString(cname)
                results.append(name!);
            }
        }
        
        // get the attributes of the super class if its not the NSObject
        if klass.superclass() != NSObject().classForCoder {
            var superCount: UInt32 = 0
            let superProperties = class_copyPropertyList(klass.superclass(), &superCount)
            if superCount > 0 {
                for i: UInt32 in 0...superCount-1 {
                    
                    let cname = property_getName(superProperties[Int(i)])
                    // covert the c string into a Swift string
                    let name = String.fromCString(cname)
                    results.append(name!);
                }
            }
        }
        
        // release objc_property_t structs
        free(properties);
        
        return results;
    }
    
}