//
//  MSXFindManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/4/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


enum FindBy: Int {
    case Profile
    case Sport
    case Date
    case ArroundMe
}


class MSXFindManager {
    
    
    static let sharedInstance = MSXFindManager()

    var findBy: FindBy?

}