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
    
    var url: NSURL? {
        didSet {
            if view.window != nil {
                loadURL()
            }
        }
    }
    
    private func loadURL() {
        if url != nil {
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.scalesPageToFit = true
        loadURL()
    }
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(webView: UIWebView) {
        activeDownloads++
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activeDownloads--
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }

}
