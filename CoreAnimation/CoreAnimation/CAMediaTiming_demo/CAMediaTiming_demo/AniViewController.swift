//
//  ViewController.swift
//  CAMediaTiming_demo
//
//  Created by ddn on 16/9/12.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class AniViewController: UIViewController {
    
    @IBOutlet weak var aniView: UIView!
    
    var ani: CABasicAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ani = CABasicAnimation(keyPath: "backgroundColor")
        
        ani!.fromValue = UIColor.greenColor().CGColor
        ani!.toValue = UIColor.redColor().CGColor
        ani!.duration = 1
        
        aniView.layer.addAnimation(ani!, forKey: nil)
        
        aniView.layer.speed = 0
        
    }

    @IBAction func changePro(sender: UISlider) {
        aniView.layer.timeOffset = CFTimeInterval(sender.value)
    }

}

