//
//  ViewController.swift
//  CATransaction
//
//  Created by ddn on 16/9/12.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    private lazy var layer : CALayer = { [weak self] in
        let layer = CALayer()
        
        layer.backgroundColor = UIColor.redColor().CGColor
        layer.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        
        return layer
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(layer)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        start()
        
    }

    func start() {
        CATransaction.lock()
        CATransaction.begin()
        
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        CATransaction.setDisableActions(false)
//        CATransaction.setAnimationDuration(5)
        CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {
            print("done")
        }
        
        layer.backgroundColor = UIColor.orangeColor().CGColor
        layer.bounds = CGRect(x: 100, y: 100, width: 300, height: 300)
        layer.cornerRadius = 150
        layer.masksToBounds = true
        layer.borderColor = UIColor.yellowColor().CGColor
        layer.borderWidth = 5
        
        CATransaction.commit()
        CATransaction.unlock()
        
    }
    
    

}

