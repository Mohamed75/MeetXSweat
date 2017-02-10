//
//  MXSTuttorialViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/10/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSTuttorialViewController: MXSViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var tuttorials = DummyData.getTuttorials()
    
    var savedTabBarController: UITabBarController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Ressources.NavigationTitle.tuttorial
        
        addValiderButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        savedTabBarController = self.tabBarController
        if (savedTabBarController != nil) {
            var frame = savedTabBarController.view.frame
            frame.size.height += 50
            savedTabBarController.view.frame = frame
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (savedTabBarController != nil) {
            var frame = savedTabBarController.view.frame
            frame.size.height -= 50
            savedTabBarController.view.frame = frame
            savedTabBarController = nil
        }
    }
    
    
    override func validatButtonClicked(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject([User.currentUser.email: "false"], forKey: "FirstTime")
        self.navigationController?.viewDidLoad()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.tuttorial, forIndexPath: indexPath) as! MXSTuttorialCollectionCell
        
        cell.initCell()
        cell.label.text = tuttorials[indexPath.section]
        cell.imageView.image = UIImage(named: "TuttorialTop")
        
        return cell
    }
    
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return tuttorials.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}