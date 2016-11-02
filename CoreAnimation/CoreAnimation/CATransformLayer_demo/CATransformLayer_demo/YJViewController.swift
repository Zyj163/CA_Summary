//
//  ViewController.swift
//  CATransformLayer_demo
//
//  Created by ddn on 16/8/16.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180.0)
}

func radiansToDegrees(radians: Double) -> CGFloat {
    return CGFloat(radians / M_PI * 180.0)
}

class YJViewController: UIViewController {
    @IBOutlet weak var someView: UIView!

    let sideLength:CGFloat = 160.0
    let reduceAlpha: CGFloat = 0.8
    
    var redColor = UIColor.redColor()
    var orangeColor = UIColor.orangeColor()
    var yellowColor = UIColor.yellowColor()
    var greenColor = UIColor.greenColor()
    var blueColor = UIColor.blueColor()
    var purpleColor = UIColor.purpleColor()
    
    var transformLayer = CATransformLayer()
    
    var trackBall: TrackBall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fixColors()
        
        buildCube()
    }
    
    private func fixColors() {
        redColor = alphaColorForColor(redColor, newAlpha: reduceAlpha)
        orangeColor = alphaColorForColor(orangeColor, newAlpha: reduceAlpha)
        yellowColor = alphaColorForColor(yellowColor, newAlpha: reduceAlpha)
        greenColor = alphaColorForColor(greenColor, newAlpha: reduceAlpha)
        blueColor = alphaColorForColor(blueColor, newAlpha: reduceAlpha)
        purpleColor = alphaColorForColor(purpleColor, newAlpha: reduceAlpha)
    }
    
    private func buildCube() {
        //因为每次返回一个新的layer，所以不需要重复声明
        //正面
        var layer = sideLayerWithColor(redColor)
        transformLayer.addSublayer(layer)
        
        //右侧
        layer = sideLayerWithColor(orangeColor)
        transformLayer.addSublayer(layer)
        //因为make后transform都恢复初始状态，所以不需要重复声明
        var transform = CATransform3DMakeTranslation(sideLength / 2, 0.0, -sideLength / 2)
        transform = CATransform3DRotate(transform, degreesToRadians(90), 0, 1, 0)
        layer.transform = transform
        
        //背面
        layer = sideLayerWithColor(yellowColor)
        layer.transform = CATransform3DMakeTranslation(0, 0, -sideLength)
        transformLayer.addSublayer(layer)
        
        //左侧
        layer = sideLayerWithColor(greenColor)
        transform = CATransform3DMakeTranslation(-sideLength / 2, 0, -sideLength / 2)
        transform = CATransform3DRotate(transform, degreesToRadians(90), 0, 1, 0)
        layer.transform = transform
        transformLayer.addSublayer(layer)
        
        //上面
        layer = sideLayerWithColor(blueColor)
        transform = CATransform3DMakeTranslation(0.0, sideLength / -2.0, sideLength / -2.0)
        transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
        layer.transform = transform
        transformLayer.addSublayer(layer)
        
        //下面
        layer = sideLayerWithColor(purpleColor)
        transform = CATransform3DMakeTranslation(0.0, sideLength / 2.0, sideLength / -2.0)
        transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
        layer.transform = transform
        transformLayer.addSublayer(layer)
        
        //将锚点设为立方体的中心
        transformLayer.anchorPointZ = -sideLength / 2
        
        someView.layer.addSublayer(transformLayer)
    }

    private func sideLayerWithColor(color: UIColor) -> CALayer {
        let layer = CALayer()
        
        layer.bounds = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        layer.position = CGPoint(x: someView.bounds.midX, y: someView.bounds.midY)
        layer.backgroundColor = color.CGColor
        
        return layer
    }

    //给现有颜色添加alpha
    private func alphaColorForColor(oldColor: UIColor, newAlpha: CGFloat) -> UIColor {
        var red = CGFloat()
        
        var green = red, blue = red, alpha = red
        
        if oldColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: red, green: green, blue: blue, alpha: newAlpha)
        }
        return oldColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInView(someView) {
            if trackBall != nil {
                trackBall?.setStartPointFromLocation(location)
            }else {
                trackBall = TrackBall(location: location, inRect: someView.bounds)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInView(someView) {
            if let transform = trackBall?.rotationTransformForLocation(location) {
                someView.layer.sublayerTransform = transform
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInView(someView) {
            trackBall?.finalizeTrackBallForLocation(location)
        }
    }
}



postfix operator ^ {}
postfix func ^ (value: CGFloat) -> CGFloat {
    return value * value
}

class TrackBall {
    let tolerance = 0.001
    
    var baseTransform = CATransform3DIdentity
    let trackBallRadius: CGFloat
    let trackBallCenter: CGPoint
    var trackBallStartPoint = (x: CGFloat(0.0), y: CGFloat(0.0), z: CGFloat(0.0))
    
    init(location: CGPoint, inRect bounds: CGRect) {
        if CGRectGetWidth(bounds) > CGRectGetHeight(bounds) {
            trackBallRadius = CGRectGetHeight(bounds) * 0.5
        } else {
            trackBallRadius = CGRectGetWidth(bounds) * 0.5
        }
        
        trackBallCenter = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        setStartPointFromLocation(location)
    }
    
    func setStartPointFromLocation(location: CGPoint) {
        trackBallStartPoint.x = location.x - trackBallCenter.x
        trackBallStartPoint.y = location.y - trackBallCenter.y
        let distance = trackBallStartPoint.x^ + trackBallStartPoint.y^
        trackBallStartPoint.z = distance > trackBallRadius^ ? CGFloat(0.0) : sqrt(trackBallRadius^ - distance)
    }
    
    func finalizeTrackBallForLocation(location: CGPoint) {
        baseTransform = rotationTransformForLocation(location)
    }
    
    func rotationTransformForLocation(location: CGPoint) -> CATransform3D {
        var trackBallCurrentPoint = (x: location.x - trackBallCenter.x, y: location.y - trackBallCenter.y, z: CGFloat(0.0))
        let withinTolerance = fabs(Double(trackBallCurrentPoint.x - trackBallStartPoint.x)) < tolerance && fabs(Double(trackBallCurrentPoint.y - trackBallStartPoint.y)) < tolerance
        
        if withinTolerance {
            return CATransform3DIdentity
        }
        
        let distance = trackBallCurrentPoint.x^ + trackBallCurrentPoint.y^
        
        if distance > trackBallRadius^ {
            trackBallCurrentPoint.z = 0.0
        } else {
            trackBallCurrentPoint.z = sqrt(trackBallRadius^ - distance)
        }
        
        let startPoint = trackBallStartPoint
        let currentPoint = trackBallCurrentPoint
        let x = startPoint.y * currentPoint.z - startPoint.z * currentPoint.y
        let y = -startPoint.x * currentPoint.z + trackBallStartPoint.z * currentPoint.x
        let z = startPoint.x * currentPoint.y - startPoint.y * currentPoint.x
        var rotationVector = (x: x, y: y, z: z)
        
        let startLength = sqrt(Double(startPoint.x^ + startPoint.y^ + startPoint.z^))
        let currentLength = sqrt(Double(currentPoint.x^ + currentPoint.y^ + currentPoint.z^))
        let startDotCurrent = Double(startPoint.x * currentPoint.x + startPoint.y + currentPoint.y + startPoint.z + currentPoint.z)
        let rotationLength = sqrt(Double(rotationVector.x^ + rotationVector.y^ + rotationVector.z^))
        let angle = CGFloat(atan2(rotationLength / (startLength * currentLength), startDotCurrent / (startLength * currentLength)))
        
        let normalizer = CGFloat(rotationLength)
        rotationVector.x /= normalizer
        rotationVector.y /= normalizer
        rotationVector.z /= normalizer
        
        let rotationTransform = CATransform3DMakeRotation(angle, rotationVector.x, rotationVector.y, rotationVector.z)
        return CATransform3DConcat(baseTransform, rotationTransform)
    }

}






