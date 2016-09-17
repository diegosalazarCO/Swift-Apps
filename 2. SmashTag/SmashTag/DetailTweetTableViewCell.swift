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
    
    var imageUrl: URL? { didSet { updateUI() } }
    func updateUI() {
        tweetImage?.image = nil
        if let url = imageUrl {
            spinner?.startAnimating()
            DispatchQueue.global(priority: Int(DispatchQoS.QoSClass.userInitiated.rawValue)).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async {
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
