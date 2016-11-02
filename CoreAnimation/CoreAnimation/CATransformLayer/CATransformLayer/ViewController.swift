//
//  ViewController.swift
//  CATransformLayer
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//
/*
 CATransformLayer用来创建3D的layer结构，而不是CALayer那样的扁平结构。和普通layer不同的地方有：
 
 1、transform layer只渲染sublayers，那些从CALayer继承下来的属性不起作用，包括：backgroundColor, contents, border style properties, stroke style properties等。
 @IBOutlet weak var f: UIView!
 
 2、2D图片的处理属性也不起作用，包括：filters, backgroundFilters, compositingFilter, mask, masksToBounds以及阴影属性。
 
 3、opacity属性会应用到每个sublayer，transform layer并不作为一个整体来实现半透明效果。
 
 4、在transform layer上不可以调用hitTest:方法，因为它并不存在一个2D的坐标空间来定位所测试的点。
 
 在transform layer上设置sublayerTransform的m34值，定位一个透视点，sublayer上应用z轴位置变换的动画，就可以看到3D效果。
 */
import UIKit

class ViewController: UIViewController {

    static var degree : CGFloat = 0.0
    let container = CATransformLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreAnimation_TransformLayer()
    }

    func CoreAnimation_TransformLayer() {
        //创建两个普通layer
        let plane1             = CALayer()
        plane1.anchorPoint     = CGPoint(x: 0.5, y: 0.5)                         // 锚点
        plane1.bounds           = CGRect(x: 0, y: 0, width: 100, height: 100)   // 尺寸
        plane1.position        = CGPoint(x: 200,y: 200)                  // 位置
        plane1.opacity         = 0.6                                       // 背景透明度
        plane1.backgroundColor = UIColor.red.cgColor                     // 背景色
        plane1.borderWidth     = 3                                         // 边框宽度
        plane1.borderColor     = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5).cgColor                    // 边框颜色(设置了透明度)
        plane1.cornerRadius    = 10// 圆角值
        
        let plane2             = CALayer()
        plane2.anchorPoint     = CGPoint(x: 0.5, y: 0.5)                         // 锚点
        plane2.bounds           =  CGRect(x: 0, y: 0, width: 100, height: 100)   // 尺寸
        plane2.position        = CGPoint(x: 200, y: 200)                  // 位置
        plane2.opacity         = 0.6                                       // 背景透明度
        plane2.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 1, blue: 0, alpha: 1).cgColor                      // 背景色
        plane2.borderWidth     = 3                                         // 边框宽度
        plane2.borderColor     = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5).cgColor                    // 边框颜色(设置了透明度)
        plane2.cornerRadius    = 10                                       // 圆角值
        
        // Z轴平移
        var plane1_3D           = CATransform3DIdentity
        plane1_3D               = CATransform3DTranslate(plane1_3D, 0, 0, -10)
        plane1.transform        = plane1_3D
        
        var plane2_3D           = CATransform3DIdentity
        plane2_3D               = CATransform3DTranslate(plane2_3D, 0, 0, -30)
        plane2.transform        = plane2_3D
        
        //创建容器
        container.frame = self.view.bounds
        view.layer.addSublayer(container)
        container.addSublayer(plane1)
        container.addSublayer(plane2)
        //添加动画
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.animationWithTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func animationWithTimer(_: Timer) {
        var fromValue = CATransform3DIdentity
        fromValue.m34 = -1.0/500.0
        fromValue = CATransform3DRotate(fromValue, ViewController.degree, 1, 0, 0)
        
        var toValue = CATransform3DIdentity
        toValue.m34 = -1.0/500.0
        ViewController.degree += 45.0
        toValue = CATransform3DRotate(toValue, ViewController.degree, 1, 0, 0)
        
        let transform3D = CABasicAnimation.init(keyPath: "transform")
        transform3D.duration = 1.0
        transform3D.fromValue = fromValue
        transform3D.toValue = toValue
        
        container.transform = toValue
        
        container.add(transform3D, forKey: nil)
    }

}



















