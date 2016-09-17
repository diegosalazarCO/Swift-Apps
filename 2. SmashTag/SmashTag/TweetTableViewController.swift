//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/26/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var tweets = [[Tweet]]()
    var searchText: String? = "#Bogota" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                navigationItem.rightBarButtonItem = nil
            }
        }
        refresh()
    }
    
    fileprivate var lastSuccessfulRequest: TwitterRequest?
    fileprivate var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                var query = searchText!
                if query.hasPrefix("@") {
                    query = "\(query) OR from:\(query)"
                }
                return TwitterRequest(search: query, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    func refresh () {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        if searchText != nil {
            RecentSearches().add(searchText!)
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    DispatchQueue.main.async { () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccessfulRequest = request
                            self.tweets.insert(newTweets, at: 0)
                            self.tableView.reloadData()
                            self.title = self.searchText
                        }
                        sender?.endRefreshing()
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    fileprivate struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
        static let MentionsIdentifier = "Show Mentions"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellReuseIdentifier, for: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]

        return cell
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.MentionsIdentifier {
            if let tweetCell = sender as? TweetTableViewCell {
                if tweetCell.tweet!.urls.count + tweetCell.tweet!.hashtags.count + tweetCell.tweet!.mediaMentions.count + tweetCell.tweet!.media.count + tweetCell.tweet!.userMentions.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    @IBAction func unwindToRoot(_ sender: UIStoryboardSegue) { }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.MentionsIdentifier {
                if let dttvc = segue.destination as? DetailTweetTableViewController {
                    if let tweetCell = sender as? TweetTableViewCell {
                        dttvc.tweet = tweetCell.tweet
                    }
                }
            }
        }
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                return true
            }
        }
        return false
    }

}
