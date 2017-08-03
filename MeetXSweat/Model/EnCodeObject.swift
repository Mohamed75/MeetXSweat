//
//  NSObject+Properties.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/25/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


/**
 *  This class was designed and implemented to provide an automatique object encoder to save data to UserDefaults.
 
 - coclass      NSCoding.
 */

class EnCodeObject: NSObject, NSCoding {
    
    
    
    // MARK: - *** Handel object properties ***
    
    internal func properties() -> [String] {
        
        var returnArray = [String]()
        for keyName in self.propertyNames() {
            if (responds(to: NSSelectorFromString(keyName))) {
                returnArray.append(keyName)
            }
        }
        return returnArray
    }
    
    internal func typeOfProperty (_ name: String) -> String? {
        
        if let returnString = getTypeOfProperty(name) {
            if returnString.contains("Optional<Array<") {
                return returnString.replacingOccurrences(of: "Optional<Array<", with: "").replacingOccurrences(of: ">", with: "")
            }
            return returnString.replacingOccurrences(of: "Array<", with: "").replacingOccurrences(of: ">", with: "")
        }
        return nil
    }
    
    // MARK: - *** Encode/Decode ***
    
    // To save
    func encode(with aCoder: NSCoder) {
        
        for keyName in properties() {
            if keyName != "ref" {
                aCoder.encode(value(forKey: keyName), forKey: keyName)
            }
        }
    }
    
    // To load
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        for keyName in properties() {
            setValue(aDecoder.decodeObject(forKey: keyName), forKey: keyName)
        }
    }
    
    // MARK: - *** Initialization ***
    
    override init() {
        super.init()
    }
    
    
    // MARK: - *** Save/Load UserDefaults ***
    
    internal func saveToNSUserDefaults() {
        
        let myEncodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(myEncodedObject, forKey:self.classForCoder.description())
    }
    
    internal class func loadCustomObjectClassName(_ value: String) -> AnyObject?
    {
        if let myEncodedObject = UserDefaults.standard.object(forKey: value) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: myEncodedObject) as AnyObject?
        }
        return nil
    }
}


// MARK: - *** Private Methodes ***

// Retrieves an array of property names found on the current object
// Using Objective-C runtime functions for introspection:
extension EnCodeObject {
    
    // Returns the property type
    fileprivate func getTypeOfProperty (_ name: String) -> String? {
        
        var type: Mirror = Mirror(reflecting: self)
        
        for child in type.children {
            if child.label! == name {
                return String(describing: type(of: (child.value) as AnyObject))
            }
        }
        while let parent = type.superclassMirror {
            for child in parent.children {
                if child.label! == name {
                    return String(describing: type(of: (child.value) as AnyObject))
                }
            }
            type = parent
        }
        return nil
    }
    
    // Returns the properties names
    fileprivate func propertyNames() -> Array<String> {
        
        var klass: AnyClass = object_getClass(self)
        var results: Array<String> = []
        
        // Get the attributes of the current class
        var count: UInt32 = 0
        let properties = class_copyPropertyList(klass, &count)
        if count > 0 {
            // iterate each objc_property_t struct
            for i: UInt32 in 0...count-1 {
                
                let cname = property_getName(properties?[Int(i)])
                // covert the c string into a Swift string
                let name = String(cString: cname!)
                results.append(name);
            }
        }
        
        // Get the attributes of the super class if its not the NSObject
        while klass.superclass() != NSObject().classForCoder {
            klass = klass.superclass()!
            var superCount: UInt32 = 0
            let superProperties = class_copyPropertyList(klass, &superCount)
            if superCount > 0 {
                for i: UInt32 in 0...superCount-1 {
                    
                    let cname = property_getName(superProperties?[Int(i)])
                    // covert the c string into a Swift string
                    let name = String(cString: cname!)
                    results.append(name);
                }
            }
        }
        
        // Release objc_property_t structs
        free(properties);
        
        return results;
    }
}
