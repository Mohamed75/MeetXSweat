//
//  FireBasHelper.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/19/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import FirebaseStorage


class FireBaseHelper {
    
    class func saveImage(image: UIImage, fileName: String, completion:((url: String)->Void)) {
        
        var data =  NSData()
        data        = UIImageJPEGRepresentation(image, 0.8)!
        
        // Create a reference to the file you want to upload
        let riversRef = FIRStorage.storage().reference().child("images").child(fileName + ".png")
        
        let block: ((FIRStorageMetadata?, NSError?) -> Void) = { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            completion(url: metadata.downloadURL()!.absoluteString)
        }
            
        riversRef.putData(data, metadata: nil, completion: block)
    }
}
