//
//  ViewController.swift
//  CAMediaTiming
//
//  Created by ddn on 16/9/12.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var layer : CALayer = { [weak self] in
        let layer = CALayer()
        
        layer.backgroundColor = UIColor.redColor().CGColor
        layer.frame = CGRect(x: 50, y: 100, width: 300, height: 300)
        
        //消除锯齿(会造成离屏渲染)
        layer.allowsEdgeAntialiasing = true
        layer.edgeAntialiasingMask = [.LayerLeftEdge, .LayerBottomEdge, .LayerRightEdge, .LayerTopEdge]
        layer.masksToBounds = true
        
        self!.view.layer.addSublayer(layer)
        
        return layer
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = M_PI * 2
        animation.duration = 2
        animation.repeatCount = Float.infinity
        
        layer.addAnimation(animation, forKey: nil)
    }
    
    func pauseLayer() {
        //获取当前时间，将layer的时间转换到绝对时间
        let pauseTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0
        //设置时间的偏移量为当前时间
        layer.timeOffset = pauseTime
    }

    func resumeLayer() {
        //获取之前暂停时的时间
        let pauseTime = layer.timeOffset
        layer.speed = 1.0
        //清空偏移量
        layer.timeOffset = 0.0
        //设置开始时间，beginTime是指其父级对象的时间线上的某个时间（这里其实就是绝对时间）
        layer.beginTime = CACurrentMediaTime() - pauseTime
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if layer.timeOffset == 0 {
            pauseLayer()
        }else {
            resumeLayer()
        }
    }

}

