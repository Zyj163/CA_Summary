//
//  ViewController.swift
//  CATileLayer_demo
//
//  Created by ddn on 16/8/16.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIImage.saveTileOfSize(CGSize(width: 200, height: 200), name: "1-160G3123424") { 
            self.view.subviews.first?.setNeedsDisplay()
        }
    }


}


