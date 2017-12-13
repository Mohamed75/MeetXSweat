//
//  MKAnnotationExtension.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 12/13/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import MapKit

extension MKAnnotationView {
    
    open override func layoutSubviews () {
        
        if (!isSelected) {
            return
        }
        super.layoutSubviews()
        for view in subviews {
            searchViewHierarchy(view)
        }
    }
    
    func searchViewHierarchy(_ aPinView: UIView) {
        
        for subView in aPinView.subviews {
            if (subView is UILabel) {
                (subView as! UILabel).textColor = Constants.MainColor.kCustomBlueColor
            } else {
                searchViewHierarchy(subView)
            }
        }
    }
    
}
