//
//  FireBaseObject.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/5/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase



class FireBaseObject: EnCodeObject {
    
    var ref: FIRDatabaseReference?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        
        ref = nil
        super.init()
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
        
        for keyName in properties() {
            
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
        ref = snapshot.ref
    }
    
    
    func copyFromJson(dictionary: [String : AnyObject]) {
        
        for (key, value) in dictionary {
            let keyName = key
            
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                setValue(value, forKey: keyName)
            }
        }
    }
    
    /*
     return all properties value as string
     */
    func allParams() -> String {
        
        var basicInfo = ""
        for keyName in properties() {
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                basicInfo = basicInfo + " " + String(valueForKey(keyName))
            }
        }
        return basicInfo
    }
    
    
    // used only by the init snapshot
    private func createArrayObjectForProperty(propety: String, array: [AnyObject]) -> [AnyObject] {
        
        var returnArray: [AnyObject] = []
        if let className = typeOfProperty(propety) {
            
            for object: AnyObject in array {
                
                if object is NSDictionary {
                    
                    let clazz: FireBaseObject = FireBaseObject.fromClassName(className) as! FireBaseObject
                    for (key, v) in (object as! [String: AnyObject]) {
                        
                        if (clazz.respondsToSelector(NSSelectorFromString(key))) {
                            clazz.setValue(v, forKey: key)
                        }
                    }
                    returnArray.append(clazz)
                }
            }
        } else {
            return array
        }
        
        return returnArray
    }
    
    /*
     return the current object as json dictionarry
     */
    func asJson() -> [String: AnyObject] {
        
        var json = [String: AnyObject]()
        for keyName in properties() {
            
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
    func arrayAsJson(value: AnyObject) -> AnyObject {
        
        let firstElement = (value as! NSArray).firstObject as! NSObject
        if firstElement.isKindOfClass(FireBaseObject) {
            var jsonArray: [AnyObject] = []
            for elemnt: FireBaseObject in (value as! [FireBaseObject]) {
                jsonArray.append(elemnt.asJson())
            }
            return jsonArray
        }
        else {
            return value
        }
    }
    
}


extension FireBaseObject {
    
    // get Object from a defined class in the project
    class func fromClassName(className : String) -> NSObject {
        let aClass      = NSClassFromString(FireBaseObject.className(className)) as! NSObject.Type
        return aClass.init()
    }
    
    class func className(className : String) -> String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + className
    }
}
