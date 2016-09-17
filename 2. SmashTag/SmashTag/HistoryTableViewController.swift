//
//  HistoryTableViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/31/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return RecentSearches().values.count
    }
    
    fileprivate struct Storyboard {
        static let CellReuseIdentifier = "History Cell"
        static let SegueIdentifier = "Show Search"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellReuseIdentifier, for: indexPath) 
        cell.textLabel?.text = RecentSearches().values[(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RecentSearches().removeAtIndex((indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    
    @IBAction func unwindToRoot(_ sender: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.SegueIdentifier {
                if let ttvc = segue.destination as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            }
        }
    }

}
