//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/27/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    var hashtagColor = UIColor(red: 99.0/255.0, green: 57.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    var urlColor = UIColor(red: 85.0/255.0, green: 92.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    var userMentionsColor = UIColor(red: 253.0/255.0, green: 91.0/255.0, blue: 3.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        //tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if var tweet = self.tweet
        {
            var text: String? = tweet.text
            
            for _ in tweet.media {
                text = text!+" 📷"
            }
            
            var attributedText = NSMutableAttributedString(string: text!)
            attributedText.changeKeywordsColor(tweet.hashtags, color: hashtagColor)
            attributedText.changeKeywordsColor(tweet.urls, color: urlColor)
            attributedText.changeKeywordsColor(tweet.userMentions, color: userMentionsColor)
            
            attributedText.changeKeywordsColor(tweet.mediaMentions, color: urlColor)
            
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                /*if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                } */
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if profileImageURL == tweet.user.profileImageURL {
                            if imageData != nil {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                }
            }
            
//            let formatter = NSDateFormatter()
//            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
//                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
//            } else {
//                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//            }
//            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            if tweet.hashtags.count + tweet.urls.count + tweet.userMentions.count + tweet.media.count > 0 {
                accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
}

private extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}
