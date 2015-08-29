//
//  NavigationViewController.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/28/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.barTintColor = UIColor(red: (60.0/255.0)-0.12, green: (55.0/255.0)-0.12, blue: (65.0/255.0)-0.12, alpha: 1.0)
        self.navigationBar.tintColor = UIColor.whiteColor()
    }


}
