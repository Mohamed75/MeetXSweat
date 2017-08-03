//
//  FireBasHelper.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/19/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase


private let FIRSignInblock: AuthResultCallback = { (user, error) in
    if (error != nil) {
        NSLog("signInAnonymously error")
    } else {
        NSLog("signInAnonymously succes")
    }
}


/**
 *  This class was designed and implemented to provide a fireBase helper.
 
 - classdesign  Helper.
 */

class FireBaseHelper {
    
    class func setUp() {
        
        if Utils.isUnitTesting() {

            let options = FirebaseOptions(googleAppID: "1:507333318603:ios:e2db90ecfa14c7a8",gcmSenderID: "507333318603")
            options.databaseURL = "https://fir-meetxsweat.firebaseio.com"
            options.apiKey = "AIzaSyBD6OtjFdI8MUI66KTIxUlauSqW6z_OOPY"
            FirebaseApp.configure(options: options)
            
            Database.database().isPersistenceEnabled = true
            Auth.auth().signInAnonymously(completion: FIRSignInblock)
            return
        }
            
        #if PROD
            let filePath = Bundle.main.path(forResource: "GoogleServiceProd-Info", ofType: "plist")
            let options = FirebaseOptions(contentsOfFile: filePath!)
            FirebaseApp.configure(options: options!)
        #else
            FirebaseApp.configure()
        #endif
        
        Database.database().isPersistenceEnabled = true
        Auth.auth().signInAnonymously(completion: FIRSignInblock)
    }
    
    class func saveImage(_ image: UIImage, fileName: String, completion:@escaping ((_ url: String)->Void)) {
        
        var data    = Data()
        data        = UIImageJPEGRepresentation(image, 0.8)!
        
        // Create a reference to the file you want to upload
        let riversRef = Storage.storage().reference().child("images").child(fileName + ".png")
        
        let block: ((StorageMetadata?, Error?) -> Void) = { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            completion(metadata.downloadURL()!.absoluteString)
        }
        
        riversRef.putData(data, metadata: nil, completion: block)
    }
}
