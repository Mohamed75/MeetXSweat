//
//  UIViewController+Custom.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController


class MXSViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        let imageView = UIImageView(image: UIImage(named: Ressources.Images.logo))
        imageView.frame = CGRect(x: 0, y: 20, width: 40, height: 40)
        imageView.contentMode = .ScaleAspectFit
        navigationItem.titleView = imageView
        
        super.viewDidLoad()
    }
    
    func addBarButtonItem() {
        navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self, action: #selector(togleMenuButton))
    }
    
    func togleMenuButton() {
        
        if self.evo_drawerController!.openSide == .None {
            
            self.evo_drawerController?.openDrawerSide(DrawerSide.Left, animated: true, completion: nil)
        } else {
            self.evo_drawerController?.closeDrawerAnimated(true, completion: nil)
        }
    }
    
}