//
//  ZoomImageViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/29/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController, UIScrollViewDelegate {

    // our Model
    // publicly settable
    // when it changes (but only if we are on screen)
    //   we'll fetch the image from the imageURL
    // if we're off screen when this happens (view.window == nil)
    //   viewWillAppear will get it for us later
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    // fetches the image at imageURL
    // does so off the main thread
    // then puts a closure back on the main queue
    //   to handle putting the image in the UI
    //   (since we aren't allowed to do UI anywhere but main queue)
    fileprivate func fetchImage()
    {
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(DispatchQoS.QoSClass.userInitiated.rawValue)
            DispatchQueue.global(priority: qos).async { () -> Void in
                let imageData = try? Data(contentsOf: url) // this blocks the thread it is on
                DispatchQueue.main.async {
                    // only do something with this image
                    // if the url we fetched is the current imageURL we want
                    // (that might have changed while we were off fetching this one)
                    if url == self.imageURL { // the variable "url" is capture from above
                        if imageData != nil {
                            // this might be a waste of time if our MVC is out of action now
                            // which it might be if someone hit the Back button
                            // or otherwise removed us from split view or navigation controller
                            // while we were off fetching the image
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // critical to set this!
            scrollView.delegate = self                    // required for zooming
            scrollView.minimumZoomScale = 0.3            // required for zooming
            scrollView.maximumZoomScale = 3.0             // required for zooming
        }
    }
    
    // UIScrollViewDelegate method
    // required for zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    fileprivate var imageView = UIImageView()
    
    // convenience computed property
    // lets us get involved every time we set an image in imageView
    // we can do things like resize the imageView,
    //   set the scroll view's contentSize,
    //   and stop the spinner
    fileprivate var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            scrollViewDidScrollOrZoom = false
            autoScale()
        }
    }
    
    fileprivate var scrollViewDidScrollOrZoom = false
    
    fileprivate func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        }
        if let sv = scrollView {
            if image != nil {
                sv.zoomScale = max(sv.bounds.size.height / image!.size.height,
                    sv.bounds.size.width / image!.size.width)
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                    y: (imageView.frame.size.height - sv.frame.size.height) / 2)
                scrollViewDidScrollOrZoom = false
            }
        }
    }
    
    // put our imageView into the view hierarchy
    // as a subview of the scrollView
    // (will install it into the content area of the scroll view)
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    // for efficiency, we will only actually fetch the image
    // when we know we are going to be on screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }

}
