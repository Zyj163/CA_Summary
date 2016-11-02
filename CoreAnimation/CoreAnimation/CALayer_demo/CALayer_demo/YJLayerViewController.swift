//
//  YJLayerViewController.swift
//  CALayer_demo
//
//  Created by ddn on 16/8/16.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class YJLayerViewController: UIViewController {
    @IBOutlet weak var someView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1
        let layer = CALayer()
        layer.frame = someView.bounds
        
        // 2
        layer.contents = UIImage(named: "star_540px_1201372_easyicon.net")?.CGImage
        layer.contentsGravity = kCAGravityCenter
        layer.contentsScale = UIScreen.mainScreen().scale
        
        // 3
        layer.magnificationFilter = kCAFilterLinear
        layer.geometryFlipped = false
        
        // 4
        layer.backgroundColor = UIColor(red: 11/255.0, green: 86/255.0, blue: 14/255.0, alpha: 1.0).CGColor
        layer.opacity = 1.0
        layer.hidden = false
        layer.masksToBounds = false
        
        // 5
        layer.cornerRadius = 100.0
        layer.borderWidth = 10.0
        layer.borderColor = UIColor.whiteColor().CGColor
        
        // 6
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3.0
        
        //7
        layer.shouldRasterize = true
        someView.layer.addSublayer(layer)
    }

}
