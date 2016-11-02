//
//  ViewController.swift
//  CAGradientLayer
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var aniView: UIView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        //GradientLayer
        CoreAnimation_GradientLayer()
    }
    
    func CoreAnimation_GradientLayer() {
        
        multiColorViewUseGradientLayer()
        
        multiColorLabelUseGradientLayer()
    }

    func multiColorLabelUseGradientLayer() {
        
        //创建label
        let label = UILabel()
        label.text = "渐变颜色的文字"
        label.font = UIFont.systemFontOfSize(23)
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center;
        
        //创建渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = label.frame;
        let colors = [UIColor.clearColor().CGColor, UIColor.redColor().CGColor]
        gradientLayer.colors = colors;
        gradientLayer.startPoint = CGPointMake(0, 1)
        gradientLayer.endPoint = CGPointMake(1, 1)
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.mask = label.layer
        label.frame = gradientLayer.bounds
        
    }
    
    func multiColorViewUseGradientLayer() {
        
        let imageView = UIImageView.init(image: UIImage.init(named: "564b777817e80d631e94b97f2a86614f"))
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        let gradientLayer = CAGradientLayer()
        let colors = [UIColor.clearColor().CGColor, UIColor.redColor().CGColor, UIColor.greenColor().CGColor, UIColor.blueColor().CGColor]
        gradientLayer.colors = colors
        
        //作用范围及方向
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPointMake(1, 1)
        
        //指定范围，在0~0.25(clear~red),0.25~0.5(red~green),0.5~1(green~blue)实现渐变效果
        gradientLayer.locations = [0.0, 0.25, 0.5, 1.0]
        imageView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = imageView.bounds
        gradientLayer.opacity = 0.3
    }
    
}













































