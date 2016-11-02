//
//  ViewController.swift
//  CAShapLayer_demo
//
//  Created by ddn on 16/7/20.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

var random: CGFloat {
    return CGFloat(arc4random_uniform(256))
}

func randomColor() -> UIColor {
    return UIColor(red: random/255.0, green: random/255.0, blue: random/255.0, alpha: 1)
}

class ViewController: UIViewController {
    
    private lazy var bgView : RotateView = { [weak self] in
        let bgView = RotateView()
        self!.view.addSubview(bgView)
        return bgView
        }()
    
    private lazy var lineView : LineGradientView = { [weak self] in
        let lineView = LineGradientView()
        self!.view.addSubview(lineView)
        return lineView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.backgroundColor = UIColor.blueColor()
        lineView.backgroundColor = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 320)
        lineView.frame = CGRect(x: 0, y: 330, width: view.bounds.size.width, height: 5)
    }

    var pro: CGFloat = 0.0
    var p: CGFloat = 0.0
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pro += 1
        bgView.updateProgress(pro)
        
        p += 0.1
        lineView.updateProgress(p)
    }
    
}



class RotateView: UIView {
    
    private var oAngle = CGFloat(-M_PI * 3 / 4)
    
    private let everyAngle = CGFloat(270.0 / 100.0 * M_PI / 180.0)
    
    private lazy var bgLayer : CAShapeLayer = { [weak self] in
        let bgLayer = CAShapeLayer()
        
        bgLayer.contents = UIImage(named: "血氧")?.CGImage
        
        bgLayer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: self!.bounds.size.width - 40, height: self!.bounds.size.height - 20))
        
        self!.layer.addSublayer(bgLayer)
        
        return bgLayer
        }()
    
    private lazy var circleLayer : CALayer = { [weak self] in
        let circleLayer = CALayer()
        
        circleLayer.contents = UIImage(named: "中心圆")?.CGImage
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        self!.bgLayer.addSublayer(circleLayer)
        
        circleLayer.mask = self!.animationLayer
        
        circleLayer.addSublayer(self!.littleLayer)
        
        circleLayer.transform = CATransform3DMakeRotation(self!.oAngle, 0, 0, 1)
        
        return circleLayer
        }()
    
    private lazy var animationLayer : CAShapeLayer = { [weak self] in
        let animationLayer = CAShapeLayer()
        
        //因为是把animationLayer设为了circleLayer的mask，所以坐标系是想对circleLayer的，如果给animationLayer设置了bounds，则坐标系是想对自己的
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: 70, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
        
        circlePath.moveToPoint(CGPoint(x: 100, y: 0))
        
        circlePath.addLineToPoint(CGPoint(x: 90, y: 40))
        circlePath.addLineToPoint(CGPoint(x: 110, y: 40))
        
        circlePath.closePath()
        
        animationLayer.path = circlePath.CGPath
        
        self!.layer.addSublayer(animationLayer)
        
        return animationLayer
        }()
    
    private lazy var littleLayer : CAShapeLayer = { [weak self] in
        let littleLayer = CAShapeLayer()
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint(x: 100, y: 8))
        path.addLineToPoint(CGPoint(x: 95, y: 27))
        path.addLineToPoint(CGPoint(x: 105, y: 27))
        path.closePath()
        
        littleLayer.path = path.CGPath
        littleLayer.fillColor = UIColor.redColor().CGColor
        
        return littleLayer
        }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgLayer.position = CGPoint(x: center.x, y: center.y + 20)
        circleLayer.position = CGPoint(x: center.x - 20, y: center.y + 20)
    }
    
    
    func updateProgress(progress: CGFloat) {
        
        let newAngle = oAngle + progress * everyAngle
        
        circleLayer.transform = CATransform3DMakeRotation(newAngle, 0, 0, 1)
        
        switch progress {
        case 0...20:
            littleLayer.fillColor = UIColor.redColor().CGColor
        case 20...60:
            littleLayer.fillColor = UIColor.orangeColor().CGColor
        case 60...100:
            littleLayer.fillColor = UIColor.greenColor().CGColor
        default:
            break
        }
    }
}


class LineGradientView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    private var colors: [CGColor]?
    
    private lazy var maskLayer : CALayer = { [weak self] in
        let maskLayer = CALayer()
        
        self!.layer.mask = maskLayer
        maskLayer.anchorPoint = CGPoint.zero
        
        return maskLayer
        }()
    
    private var progress: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layer = self.layer as! CAGradientLayer
        
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        colors = [UIColor.redColor().CGColor, UIColor.greenColor().CGColor, UIColor.magentaColor().CGColor, UIColor.cyanColor().CGColor]
        layer.colors = colors
        
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func performAnimation() {
        let layer = self.layer as! CAGradientLayer
        
        layer.colors = colors
        
        var newColors = layer.colors
        
        let lastColor = newColors!.last
        newColors!.insert(lastColor!, atIndex: 0)
        newColors!.removeLast()
        
        colors = newColors as? [CGColor]
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.toValue = newColors
        animation.duration = 0.8
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        
        layer.addAnimation(animation, forKey: "animationGradient")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        performAnimation()
    }
    
    func updateProgress(progress: CGFloat) {
        self.progress = min(1.0, fabs(progress))
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.bounds = CGRectMake(0, 0, bounds.size.width * progress, bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        performAnimation()
    }
}









