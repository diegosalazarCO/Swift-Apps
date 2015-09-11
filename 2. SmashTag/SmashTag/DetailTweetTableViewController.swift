//
//  DetailTweetTableViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/27/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class DetailTweetTableViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Mentions(title: "Imágenes",
                    data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: "Links",
                    data: urls.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: "Hashtags",
                    data: hashtags.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            if let users = tweet?.userMentions {
                var userItems = [MentionItem.Keyword( "@" + tweet!.user.screenName)]
                if users.count > 0 {
                    userItems += users.map { MentionItem.Keyword($0.keyword) }
                }
                mentions.append(Mentions(title: "Usuarios", data: userItems))
            }
        }
    }
    
    var mentions = [Mentions]()
    
    struct Mentions: Printable {
        var title: String
        var data: [MentionItem]
        var description: String { return "\(title): \(data)"}
    }
    
    enum MentionItem: Printable {
        case Keyword(String)
        case Image(NSURL, Double)
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keywords Cell"
        static let ImageCellReuseIdentifier = "Images Cell"
        static let FromKeywordReuseIdentifier = "From Keywords"
        static let ImageSegueIdentifier = "Zoom Image"
        static let WebSegueIdentifier = "Show URL"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                Storyboard.KeywordCellReuseIdentifier,
                forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                Storyboard.ImageCellReuseIdentifier,
                forIndexPath: indexPath) as! DetailTweetTableViewCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.FromKeywordReuseIdentifier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let tweetCell = sender as? UITableViewCell {
                        ttvc.searchText = tweetCell.textLabel?.text
                    }
                }
            } else if identifier == Storyboard.ImageSegueIdentifier {
                if let zivc = segue.destinationViewController as? ZoomImageViewController {
                    if let cell = sender as? DetailTweetTableViewCell {
                        zivc.imageURL = cell.imageUrl
                        zivc.title = title
                    }
                }
            } else if identifier == Storyboard.WebSegueIdentifier {
                if let wvc = segue.destinationViewController as? WebViewController {
                    if let cell = sender as? UITableViewCell {
                        if let url = cell.textLabel?.text {
                            wvc.url = NSURL(string: url)
                        }
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.FromKeywordReuseIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        performSegueWithIdentifier(Storyboard.WebSegueIdentifier, sender: sender)
                        //UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        return false
                    }
                }
            }
        }
        return true
    }
    

}
