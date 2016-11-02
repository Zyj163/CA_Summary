//
//  ViewController.swift
//  CAReplicatorLayer
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        CoreAnimation_ReplicatorLayer()
        demo()
    }

    func CoreAnimation_ReplicatorLayer() {
        
        //创建需要复制的Layer
        let layerCell = CALayer()
        layerCell.anchorPoint = CGPointMake(0, 0)
        layerCell.position = CGPointMake(0, 0)
        layerCell.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)
        layerCell.contents = UIImage.init(named: "Redocn")?.CGImage
        //3d旋转
        
        //创建父容器
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 2//复制个数
        //        replicatorLayer.instanceColor = UIColor.init(colorLiteralRed: 0.5, green: 0.5, blue: 0, alpha: 0.5).CGColor//什么作用？
        //        replicatorLayer.instanceDelay = 0.0//instanceDelay这个属性使CAReplicatorLayer中的每个子Layer的动画起始时间逐个递增（动画相关）
        replicatorLayer.instanceRedOffset = -0.1//红色偏移量
        replicatorLayer.instanceGreenOffset = -0.1//绿色偏移量
        replicatorLayer.instanceBlueOffset = -0.1//蓝色偏移量
        replicatorLayer.instanceAlphaOffset = -0.5//透明的偏移量
        var instanceTransform = CATransform3DIdentity
        instanceTransform = CATransform3DMakeTranslation(0, layerCell.bounds.size.height*2, 0)
        instanceTransform = CATransform3DRotate(instanceTransform, CGFloat(M_PI), 1, 0, 0)
        replicatorLayer.instanceTransform = instanceTransform//元素间位移偏移量
        replicatorLayer.addSublayer(layerCell)
        
        //        replicatorLayer.preservesDepth = true//superLayer是否启用3D景深计算
        //        //设置景深
        //        var transform = CATransform3DIdentity
        //        transform.m34 = -1.0/2000.0
        //        replicatorLayer.transform = transform
        
        view.layer.addSublayer(replicatorLayer)
    }

    func demo() {
        // 1
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 00, y: 20, width: view.bounds.size.width, height: view.bounds.size.height / 2)
        
        // 2
        replicatorLayer.instanceCount = 31
        replicatorLayer.instanceDelay = CFTimeInterval(1 / 31.0)
        replicatorLayer.preservesDepth = false
        replicatorLayer.instanceColor = UIColor.whiteColor().CGColor
        
        // 3
        replicatorLayer.instanceRedOffset = 0.0
        replicatorLayer.instanceGreenOffset = -0.5
        replicatorLayer.instanceBlueOffset = -0.5
        replicatorLayer.instanceAlphaOffset = 0.0
        
        // 4
        let angle = Float(M_PI * 2.0) / 30
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        view.layer.addSublayer(replicatorLayer)
        
        // 5
        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 10.0
        let midX = CGRectGetMidX(view.bounds) - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(instanceLayer)
        
        // 6
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float(Int.max)
        
        // 7
        instanceLayer.opacity = 0.0
        instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
    }

}

