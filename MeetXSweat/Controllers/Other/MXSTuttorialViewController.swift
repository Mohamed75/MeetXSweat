//
//  MXSTuttorialViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/10/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSTuttorialViewController: MXSViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private var tuttorials = DummyData.getTuttorials()
    
    private var savedTabBarController: UITabBarController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var pageControl = UIPageControl(frame: .zero)
    
    private func setupPageControl() {
        
        pageControl.numberOfPages = tuttorials.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Constants.MainColor.kSpecialColor
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        
        let leading = NSLayoutConstraint(item: pageControl, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -40)
        
        view.addSubview(pageControl)
        view.addConstraints([leading, trailing, bottom])
        
        pageControl.transform = CGAffineTransformMakeScale(1.7, 1.7)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Strings.NavigationTitle.tuttorial
        
        addValiderButton()
        setupPageControl()
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
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    
    // MARK: --- collectionView ---
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.tuttorial, forIndexPath: indexPath) as! MXSTuttorialCollectionCell
        
        cell.initCell()
        cell.label.text = tuttorials[indexPath.section]
        let imageName = String(format: "Tutto%d", indexPath.section)
        cell.imageView.image = UIImage(named: imageName)
        
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