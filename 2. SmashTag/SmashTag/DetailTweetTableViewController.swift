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
                if users.count > 0 {
                    mentions.append(Mentions(title: "Usuarios",
                    data: users.map { MentionItem.Keyword($0.keyword) }))
                }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keywords Cell"
        static let ImageCellReuseIdentifier = "Images Cell"
        static let FromKeywordReuseIdentifier = "From Keywords"
        static let ImageSegueIdentifier = "Zoom Image"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == Storyboard.FromKeywordReuseIdentifier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let tweetCell = sender as? UITableViewCell {
                        ttvc.searchText = tweetCell.textLabel?.text
                    }
                }
            } else if identifier == Storyboard.ImageSegueIdentifier {
                if let zivc = segue.destinationViewController as? ZoomImageViewController {
                    
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.FromKeywordReuseIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        return false
                    }
                }
            }
        }
        return true
    }
    

}
