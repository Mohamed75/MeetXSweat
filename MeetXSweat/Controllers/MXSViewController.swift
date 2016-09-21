//
//  UIViewController+Custom.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.frame = CGRect(x: 0, y: 20, width: 40, height: 40)
        imageView.contentMode = .ScaleAspectFit
        navigationItem.titleView = imageView
        
        super.viewDidLoad()
    }
}