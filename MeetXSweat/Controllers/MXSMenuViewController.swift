//
//  MXSMenuViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/29/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let menuItemsTitle = ["Messages", "Log out"]


class MXSMenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(Ressources.CellReuseIdentifier.menu)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: Ressources.CellReuseIdentifier.menu)
        }
        cell?.textLabel?.text = menuItemsTitle[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 1:
            User.currentUser.isConnected = false
            User.saveCustomObject(User.currentUser)
            self.evo_drawerController?.centerViewController!.viewDidLoad()
            self.evo_drawerController?.closeDrawerAnimated(true, completion: nil)
            break
        default:
            break
        }
    }
}
