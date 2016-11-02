//
//  ViewController.swift
//  CAShapLayer
//
//  Created by ddn on 16/7/20.
//  Copyright © 2016年 张永俊. All rights reserved.
//
/*
 绘制图形图层路径。如果不喜欢编写生硬的绘图代码的话，你可以尝试PaintCode这款软件，可以利用简便的工具进行可视化绘制，支持导入现有的矢量图（SVG）和Photoshop（PSD）文件，并自动生成代码。
 设置图形图层。路径设为第二步中绘制的CGPath路径，填充色设为第一步中创建的CGColor颜色，填充规则设为非零（non-zero），即默认填充规则。
 填充规则共有两种，另一种是奇偶（even-odd）。不过示例代码中的图形没有相交路径，两种填充规则的结果并无差异。
 非零规则记从左到右的路径为+1，从右到左的路径为-1，累加所有路径值，若总和大于零，则填充路径围成的图形。
 从结果上来讲，非零规则会填充图形内部所有的点。
 奇偶规则计算围成图形的路径交叉数，若结果为奇数则填充。
 */
import UIKit

class ViewController: UIViewController {

    let shap = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shap.bounds = view.bounds
        shap.position = view.center
        shap.backgroundColor = UIColor.blueColor().CGColor
        
        //相当于添加了一个sublayer
        let path = UIBezierPath(arcCenter: view.center, radius: 50, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
        
        shap.path = path.CGPath
        
        shap.fillColor = UIColor.redColor().CGColor
        shap.strokeColor = UIColor.greenColor().CGColor
        shap.lineWidth = 5
        
        shap.strokeStart = 0
        shap.strokeEnd = 0
        
        view.layer.addSublayer(shap)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        CATransaction.lock()
        CATransaction.begin()
        
        CATransaction.setDisableActions(false)
        CATransaction.setAnimationDuration(1)
        CATransaction.setCompletionBlock {
            
            let sublayer = CAShapeLayer()
            
            self.shap.addSublayer(sublayer)
            
            sublayer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 50))
            sublayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            sublayer.position = CGPoint(x: 100, y: 0)
            
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 20, y: 0))
            path.addLineToPoint(CGPoint(x: 0, y: 50))
            path.addLineToPoint(CGPoint(x: 40, y: 50))
            path.closePath()
            
            sublayer.path = path.CGPath
            sublayer.fillColor = UIColor.redColor().CGColor
            
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue = -M_PI * 2
            animation.duration = 2
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeBoth
            
            self.shap.addAnimation(animation, forKey: nil)
        }
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        shap.strokeEnd = 1
        shap.backgroundColor = UIColor.orangeColor().CGColor
        shap.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200))
        shap.cornerRadius = 100
        shap.borderColor = UIColor.magentaColor().CGColor
        shap.borderWidth = 2
        shap.strokeColor = UIColor.purpleColor().CGColor
        shap.fillColor = UIColor.cyanColor().CGColor
        shap.fillRule = kCAFillRuleNonZero
        
        CATransaction.commit()
        CATransaction.unlock()
        
        
        let toPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: 80, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = toPath.CGPath
        animation.duration = 1
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeBoth

        shap.addAnimation(animation, forKey: nil)
    }

}

