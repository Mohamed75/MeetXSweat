//
//  NSObject+Properties.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/25/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase

extension NSObject {
    
    class func fromClassName(className : String) -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! NSObject.Type
        return aClass.init()
    }
}


class MXSObject: NSObject, NSCoding {
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        for keyName in propertyNames() {
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                aCoder.encodeObject(valueForKey(keyName), forKey: keyName)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        for keyName in propertyNames() {
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                setValue(aDecoder.decodeObjectForKey(keyName), forKey: keyName)
            }
        }
    }
    
    
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    
    override init() {
        
    }
    
    func allParams() -> String {
        
        var basicInfo = ""
        for keyName in propertyNames() {
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                basicInfo = basicInfo + " " + String(valueForKey(keyName))
            }
        }
        return basicInfo
    }
    
    
    init(dictionary: [String : AnyObject]) {
        
        super.init()
        
        for (key, value) in dictionary {
            let keyName = key 
            
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                setValue(value, forKey: keyName)
            }
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        for keyName in propertyNames() {
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                
                if let value = snapshot.value![keyName] {
                    if let aValue = value {
                        
                        if aValue.isKindOfClass(NSArray) && (aValue as! NSArray).count > 0 {
                            
                            let array = createArrayObjectForProperty(keyName, array: (value as! NSArray) as Array)
                            setValue(array, forKey: keyName)
                        } else {
                            setValue(aValue, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    // used only by the init snapshot
    func createArrayObjectForProperty(propety: String, array: [AnyObject]) -> [AnyObject] {
        
        var returnArray: [AnyObject] = []
        if let className = getTypeOfProperty(propety)?.stringByReplacingOccurrencesOfString("Optional<Array<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "") {
            
            for object: AnyObject in array {
                
                let clazz: MXSObject = NSObject.fromClassName(className) as! MXSObject
                for (key, v) in (object as! [String: AnyObject]) {
                    
                    if (clazz.respondsToSelector(NSSelectorFromString(key))) {
                        clazz.setValue(v, forKey: key)
                    }
                }
                returnArray.append(clazz)
            }
        } else {
            return array
        }
        
        return returnArray
    }
    
    
    func asJson() -> [String: AnyObject] {
        
        var json = [String: AnyObject]()
        for keyName in propertyNames() {
            
            if (keyName != "ref" && respondsToSelector(NSSelectorFromString(keyName))) {
                
                if let value = valueForKey(keyName) {
                    if value.isKindOfClass(NSArray) && (value as! NSArray).count > 0 {
                        json[keyName] = arrayAsJson(value)
                    } else {
                        json[keyName] = value
                    }
                }
            }
        }
        return json
    }
    // return json array 
    // value is an array wich could have simple type as String or complexe object
    private func arrayAsJson(value: AnyObject) -> AnyObject {
        
        let firstElement = (value as! NSArray).firstObject as! NSObject
        if firstElement.isKindOfClass(MXSObject) {
            var jsonArray: [AnyObject] = []
            for elemnt: MXSObject in (value as! [MXSObject]) {
                jsonArray.append(elemnt.asJson())
            }
            return jsonArray
        }
        else {
            return value
        }
    }
    
    
}



extension MXSObject {
    
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