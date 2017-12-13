//
//  UserViewModel.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/24/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let kScale: CGFloat = 1.15
private let kScaleCenter: CGFloat = 15

/**
 *  This class was designed and implemented to provide a simple way to set a data to a view.
 */

class UserViewModel {
    
    
    class func setUserImageView(_ imageView: UIImageView, person: Person) {
        
        imageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !person.pictureUrl.isEmpty {
            
            imageView.af_setImage(withURL:
                URL(string: person.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .noTransition,
                completion: { response in
                    
                    guard (response.result.error == nil) else {
                        return
                    }
                    
                    imageView.center.x += (imageView.frame.size.width/kScaleCenter)+1
                    imageView.center.y += (imageView.frame.size.height/kScaleCenter)+2
                    
                    imageView.frame.size.width /= kScale
                    imageView.frame.size.height /= kScale
                    
                    imageView.layer.cornerRadius = imageView.frame.width/2
                    imageView.clipsToBounds = true
                }
            )
        }
    }
    
}
