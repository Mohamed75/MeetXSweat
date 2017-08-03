//
//  MXSTuttorialViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/10/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Tuttorial ViewController with a ContainerView of a CollectionView.
 
 - superClass:  MXSViewController.
 */

class MXSTuttorialViewController: MXSViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    fileprivate var tuttorials = DummyData.getTuttorials()
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    fileprivate var pageControl = UIPageControl(frame: .zero)
    
    fileprivate func setupPageControl() {
        
        pageControl.numberOfPages = tuttorials.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Constants.MainColor.kSpecialColor
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
        
        view.addSubview(pageControl)
        view.addConstraints([leading, trailing, bottom])
        
        pageControl.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
    }
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Strings.NavigationTitle.tuttorial
        
        addValiderButton()
        setupPageControl()
        
        isTabBarEtendedView = true
    }
    
    
    // MARK: - *** NavigationBar Button Actions ***
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        UserDefaults.standard.set([User.currentUser.email: "false"], forKey: "FirstTime")
        self.navigationController?.viewDidLoad()
    }
    
    // MARK: - *** ScrollView Delegate ***
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}


// MARK: - *** CollectionView Delegate ***

extension MXSTuttorialViewController {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Ressources.CellReuseIdentifier.tuttorial, for: indexPath) as! MXSTuttorialCollectionCell
        
        cell.initCell()
        cell.label.text = tuttorials[indexPath.section]
        let imageName = String(format: "Tutto%d", indexPath.section)
        cell.imageView.image = UIImage(named: imageName)
        
        return cell
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tuttorials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
