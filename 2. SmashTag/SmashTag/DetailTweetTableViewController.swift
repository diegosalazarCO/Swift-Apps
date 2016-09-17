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
                    data: media.map { MentionItem.image($0.url as URL, $0.aspectRatio) }))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: "Links",
                    data: urls.map { MentionItem.keyword($0.keyword) }))
                }
            }
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: "Hashtags",
                    data: hashtags.map { MentionItem.keyword($0.keyword) }))
                }
            }
            if let users = tweet?.userMentions {
                var userItems = [MentionItem.keyword( "@" + tweet!.user.screenName)]
                if users.count > 0 {
                    userItems += users.map { MentionItem.keyword($0.keyword) }
                }
                mentions.append(Mentions(title: "Usuarios", data: userItems))
            }
        }
    }
    
    var mentions = [Mentions]()
    
    struct Mentions: CustomStringConvertible {
        var title: String
        var data: [MentionItem]
        var description: String { return "\(title): \(data)"}
    }
    
    enum MentionItem: CustomStringConvertible {
        case keyword(String)
        case image(URL, Double)
        var description: String {
            switch self {
            case .keyword(let keyword): return keyword
            case .image(let url, _): return url.path
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

    fileprivate struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keywords Cell"
        static let ImageCellReuseIdentifier = "Images Cell"
        static let FromKeywordReuseIdentifier = "From Keywords"
        static let ImageSegueIdentifier = "Zoom Image"
        static let WebSegueIdentifier = "Show URL"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let mention = mentions[(indexPath as NSIndexPath).section].data[(indexPath as NSIndexPath).row]
        
        switch mention {
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.KeywordCellReuseIdentifier,
                for: indexPath) 
            cell.textLabel?.text = keyword
            return cell
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.ImageCellReuseIdentifier,
                for: indexPath) as! DetailTweetTableViewCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentions[(indexPath as NSIndexPath).section].data[(indexPath as NSIndexPath).row]
        switch mention {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.FromKeywordReuseIdentifier {
                if let ttvc = segue.destination as? TweetTableViewController {
                    if let tweetCell = sender as? UITableViewCell {
                        ttvc.searchText = tweetCell.textLabel?.text
                    }
                }
            } else if identifier == Storyboard.ImageSegueIdentifier {
                if let zivc = segue.destination as? ZoomImageViewController {
                    if let cell = sender as? DetailTweetTableViewCell {
                        zivc.imageURL = cell.imageUrl
                        zivc.title = title
                    }
                }
            } else if identifier == Storyboard.WebSegueIdentifier {
                if let wvc = segue.destination as? WebViewController {
                    if let cell = sender as? UITableViewCell {
                        if let url = cell.textLabel?.text {
                            wvc.url = URL(string: url)
                        }
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.FromKeywordReuseIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        performSegue(withIdentifier: Storyboard.WebSegueIdentifier, sender: sender)
                        //UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        return false
                    }
                }
            }
        }
        return true
    }
    

}
