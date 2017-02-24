//
//  UserViewModel.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/24/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class UserViewModel {
    
    class func setUserImage(imageView: UIImageView, person: Person) {
        
        imageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !person.pictureUrl.isEmpty {
            
            imageView.af_setImageWithURL(
                NSURL(string: person.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .None
            )
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.clipsToBounds = true
        }
    }
    
}