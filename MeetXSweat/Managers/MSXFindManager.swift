//
//  MSXFindManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/4/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import MapKit


enum FindBy: Int {
    case profile
    case sport
    case date
    case arroundMe
}


class MSXFindManager {
    
    
    static let sharedInstance = MSXFindManager()

    var findBy: FindBy
    
    init() {
        findBy = FindBy.sport
    }
}
