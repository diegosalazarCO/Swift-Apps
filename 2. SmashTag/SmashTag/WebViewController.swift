//
//  WebViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 9/11/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url: URL? {
        didSet {
            if view.window != nil {
                loadURL()
            }
        }
    }
    
    fileprivate func loadURL() {
        if url != nil {
            webView.loadRequest(URLRequest(url: url!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.scalesPageToFit = true
        loadURL()
    }
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activeDownloads += 1
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activeDownloads -= 1
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        webView.goBack()
    }

}
