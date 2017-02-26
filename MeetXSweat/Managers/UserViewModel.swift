//
//  UserViewModel.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/24/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class UserViewModel {
    
    
    class func setUserImageView(_ imageView: UIImageView, person: Person) {
        
        imageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !person.pictureUrl.isEmpty {
            
            imageView.af_setImage(withURL:
                URL(string: person.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .noTransition
            )
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.clipsToBounds = true
        }
    }
    
}
