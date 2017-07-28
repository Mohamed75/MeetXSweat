//
//  FireBaseObject.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/5/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


/**
 *  This class was designed and implemented to provide a FireBase Object to generate easly a Json from firebase Object and firebase Object from a Json.
 
 - superClass:  EnCodeObject.
 */

class FireBaseObject: EnCodeObject {
    
    var ref: FIRDatabaseReference?
    
    
    // Mark: ---  Initialization ---
    
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
            
            if (responds(to: NSSelectorFromString(keyName))) {
                setValue(value, forKey: keyName)
            }
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        super.init()
        
        for keyName in properties() {
            
            if let dic = snapshot.value as? NSDictionary, let value = dic[keyName] {
                    
                if value is NSArray && (value as! NSArray).count > 0 {
                    
                    let array = createArrayObjectForProperty(keyName, array: (value as! NSArray) as Array)
                    setValue(array, forKey: keyName)
                } else {
                    setValue(value, forKey: keyName)
                }
            }
        }
        ref = snapshot.ref
    }
    
    // Mark: ---  Copy ---
    
    func copyFromJson(_ dictionary: [String : AnyObject?]) {
        
        for (key, value) in dictionary {
            let keyName = key
            
            if (responds(to: NSSelectorFromString(keyName))) {
                if let aValue = value {
                    setValue(aValue, forKey: keyName)
                }
            }
        }
    }
    
    /*
     Return all properties value as string
     */
    func allParams() -> String {
        
        var basicInfo = ""
        for keyName in properties() {
            if (responds(to: NSSelectorFromString(keyName))) {
                basicInfo = basicInfo + " " + String(describing: value(forKey: keyName))
            }
        }
        return basicInfo
    }
    
    
    // Used only by the init snapshot
    private func createArrayObjectForProperty(_ propety: String, array: [AnyObject]) -> [AnyObject] {
        
        var returnArray: [AnyObject] = []
        if let className = typeOfProperty(propety) {
            
            for object: AnyObject in array {
                
                if object is NSDictionary {
                    
                    if let clazz: FireBaseObject = FireBaseObject.fromClassName(className) as? FireBaseObject {
                        
                        for (key, v) in (object as! [String: AnyObject]) {
                            
                            if clazz.responds(to: NSSelectorFromString(key)) {
                                clazz.setValue(v, forKey: key)
                            }
                        }
                        returnArray.append(clazz)
                    }
                    
                } else {
                    returnArray.append(object)
                }
            }
            
        } else {
            return array
        }
        
        return returnArray
    }
    
    /*
     Return the current object as json dictionarry
     */
    func asJson() -> [String: AnyObject] {
        
        var json = [String: AnyObject]()
        for keyName in properties() {
            
            if (keyName != "ref" && responds(to: NSSelectorFromString(keyName))) {
                
                if let value = value(forKey: keyName) {
                    if value is NSArray && (value as! NSArray).count > 0 {
                        json[keyName] = arrayAsJson(value as AnyObject)
                    } else {
                        json[keyName] = value as AnyObject?
                    }
                }
            }
        }
        return json
    }
    
    /**
     Return json array
     Value is an array wich could have simple type as String or complexe object
     */
    private func arrayAsJson(_ value: AnyObject) -> AnyObject {
        
        let firstElement = (value as! NSArray).firstObject as! NSObject
        if firstElement.isKind(of: FireBaseObject.self) {
            var jsonArray: [AnyObject] = []
            for elemnt: FireBaseObject in (value as! [FireBaseObject]) {
                jsonArray.append(elemnt.asJson() as AnyObject)
            }
            return jsonArray as AnyObject
        }
        else {
            return value
        }
    }
    
}




extension FireBaseObject {
    
    // Get Object from a defined class in the project
    class func fromClassName(_ className : String) -> NSObject? {
        if let aClass      = NSClassFromString(FireBaseObject.className(className)) as? NSObject.Type {
            return aClass.init()
        }
        return nil
    }
    
    class func className(_ className : String) -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
    }
}
