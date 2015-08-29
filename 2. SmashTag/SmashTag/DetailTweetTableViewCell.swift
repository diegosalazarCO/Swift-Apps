//
//  DetailTweetTableViewCell.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/27/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class DetailTweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageUrl: NSURL? { didSet { updateUI() } }
    func updateUI() {
        tweetImage?.image = nil
        if let url = imageUrl {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.tweetImage?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImage?.image = nil
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
}
