//
//  UserImageView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 12/13/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let kScale: CGFloat = 1.3


class UserImageView {
    
    
    class func addImageView(frame: CGRect, toView: UIView) -> UIImageView {
        
        let userPhoto = UIImageView(frame: frame)
        userPhoto.image = UIImage(named: Ressources.Images.userPhoto)
        userPhoto.center.x = toView.center.x
        toView.addSubview(userPhoto)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width/kScale, height: frame.size.height/kScale))
        userPhoto.addSubview(imageView)
        imageView.center.x = (userPhoto.frame.size.width/2)-1
        imageView.center.y = (userPhoto.frame.size.height/2)-2
        
        return imageView
    }
}
