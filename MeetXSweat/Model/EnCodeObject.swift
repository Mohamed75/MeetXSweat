//
//  NSObject+Properties.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/25/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation



class EnCodeObject: NSObject, NSCoding {
    
    
    
    func properties() -> [String] {
        
        var returnArray = [String]()
        for keyName in self.propertyNames() {
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                returnArray.append(keyName)
            }
        }
        return returnArray
    }
    
    func typeOfProperty (name: String) -> String? {
        
        if let returnString = getTypeOfProperty(name) {
            if returnString.containsString("Optional<Array<") {
                return returnString.stringByReplacingOccurrencesOfString("Optional<Array<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
            }
            return returnString.stringByReplacingOccurrencesOfString("Array<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
        }
        return nil
    }
    
    // To save
    func encodeWithCoder(aCoder: NSCoder) {
        
        for keyName in properties() {
            if keyName != "ref" {
                aCoder.encodeObject(valueForKey(keyName), forKey: keyName)
            }
        }
    }
    
    // To load
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        for keyName in properties() {
            setValue(aDecoder.decodeObjectForKey(keyName), forKey: keyName)
        }
    }
    
    override init() {
        super.init()
    }
    
    func saveToNSUserDefaults() {
        
        let myEncodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(myEncodedObject, forKey:self.classForCoder.description())
    }
    
    class func loadCustomObjectClassName(value: String) -> AnyObject?
    {
        if let myEncodedObject = NSUserDefaults.standardUserDefaults().objectForKey(value) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(myEncodedObject)
        }
        return nil
    }
}



// Retrieves an array of property names found on the current object
// using Objective-C runtime functions for introspection:
extension EnCodeObject {
    
    // Returns the property type
    private func getTypeOfProperty (name: String) -> String? {
        
        var type: Mirror = Mirror(reflecting: self)
        
        for child in type.children {
            if child.label! == name {
                return String(child.value.dynamicType)
            }
        }
        while let parent = type.superclassMirror() {
            for child in parent.children {
                if child.label! == name {
                    return String(child.value.dynamicType)
                }
            }
            type = parent
        }
        return nil
    }
    
    // Returns the properties names
    private func propertyNames() -> Array<String> {
        
        var klass: AnyClass = object_getClass(self)
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
        while klass.superclass() != NSObject().classForCoder {
            klass = klass.superclass()!
            var superCount: UInt32 = 0
            let superProperties = class_copyPropertyList(klass, &superCount)
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