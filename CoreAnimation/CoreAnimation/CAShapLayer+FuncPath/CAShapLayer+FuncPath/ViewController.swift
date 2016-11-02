//
//  ViewController.swift
//  CAShapLayer+FuncPath
//
//  Created by ddn on 16/9/12.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAShapeLayer()
        
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 5
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint.zero)
        //正弦曲线
        for i in 1..<Int(width) {
            let j = sin(Float(i) * 2 * Float(M_PI) / 100) * Float(height / 2) + Float(height/2)
            let point = CGPoint(x: CGFloat(i), y: CGFloat(height - CGFloat(j)))
            
            path.addLineToPoint(point)
        }
        
        layer.path = path.CGPath
        view.layer.addSublayer(layer)
    }


}

