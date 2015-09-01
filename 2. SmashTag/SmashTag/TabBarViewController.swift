//
//  TabBarViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 9/1/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.barTintColor = UIColor.whiteColor()
        self.tabBar.tintColor = UIColor(red: (60.0/255.0), green: (55.0/255.0), blue: (65.0/255.0), alpha: 1.0)
    }

}
