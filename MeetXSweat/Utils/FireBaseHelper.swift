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
    
    class func saveImage(_ image: UIImage, fileName: String, completion:@escaping ((_ url: String)->Void)) {
        
        var data    =  Data()
        data        = UIImageJPEGRepresentation(image, 0.8)!
        
        // Create a reference to the file you want to upload
        let riversRef = FIRStorage.storage().reference().child("images").child(fileName + ".png")
        
        let block: ((FIRStorageMetadata?, Error?) -> Void) = { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            completion(metadata.downloadURL()!.absoluteString)
        }
            
        riversRef.put(data, metadata: nil, completion: block)
    }
}
