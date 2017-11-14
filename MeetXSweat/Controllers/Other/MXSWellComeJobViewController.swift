//
//  MXSWellComeJobViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/31/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import PickerView



private let kCellHeight: CGFloat = 60


class MXSWellComeJobViewController: MXSViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    
    fileprivate var dataArray       = FireBaseDataManager.sharedInstance.professions
    fileprivate var filteredArray   = [String]()
    
    
    fileprivate var savedJob  = ""
    
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = Strings.NavigationTitle.wellComme
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor.black
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        let backgroundView = UIView(frame: self.view.frame)
        backgroundView.backgroundColor = Constants.MainColor.kBackGroundColor
        self.tableView.backgroundView = backgroundView
        
        self.tableView.rowHeight = kCellHeight
    }
    
    fileprivate func searchIsEmpty() -> Bool
    {
        guard let searchTerm = self.searchController?.searchBar.text else {
            return true
        }
        return searchTerm.isEmpty
    }
}


// MARK: - *** PickerView Delegate ***

extension MXSWellComeJobViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsEmpty() ? dataArray.count : filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Ressources.CellReuseIdentifier.job, for: indexPath)
        
        cell.textLabel?.text = searchIsEmpty() ? dataArray[indexPath.row] : filteredArray[indexPath.row]
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.backgroundColor = UIColor.black
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if savedJob == "" {
            
            savedJob    = searchIsEmpty() ? dataArray[indexPath.row] : filteredArray[indexPath.row]
            searchController.isActive = false
            dataArray   = FireBaseDataManager.sharedInstance.domaines
            self.tableView.reloadData()
        }
        else {
            
            let savedDomaine  = searchIsEmpty() ? dataArray[indexPath.row] : filteredArray[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.JobObserver.notification), object: [savedJob, savedDomaine])
            self.exitViewController(animated: false)
        }
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = dataArray
        
        // Strip out all the leading and trailing spaces.
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        self.filteredArray = searchResults.filter { return $0.contains(strippedString) }
        
        self.tableView.reloadData()
    }
}
