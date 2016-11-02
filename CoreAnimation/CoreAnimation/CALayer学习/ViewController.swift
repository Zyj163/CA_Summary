//
//  ViewController.swift
//  CALayer学习
//
//  Created by ddn on 16/8/15.
//  Copyright © 2016年 张永俊. All rights reserved.
//

/*
 The following will trigger offscreen rendering:
 
 Any layer with a mask (layer.mask)
 Any layer with layer.masksToBounds / view.clipsToBounds being true
 Any layer with layer.allowsGroupOpacity set to YES and layer.opacity is less than 1.0
 Any layer with a drop shadow (layer.shadow*).
 Any layer with layer.shouldRasterize being true
 Any layer with layer.cornerRadius, layer.edgeAntialiasingMask, layer.allowsEdgeAntialiasing
 Text (any kind, including UILabel, CATextLayer, Core Text, etc).
 Most of the drawing you do with CGContext in drawRect:. Even an empty implementation will be rendered offscreen.
 */

/*
 http://ios.jobbole.com/81897/
 1.阴影绘制:
 使用ShadowPath来替代shadowOffset等属性的设置。
 2.裁剪图片为圆
 在裁剪之前，先绘制一个背景色，可以避免blending
 */
import UIKit

class ViewController: UIViewController {

    let layer = YJLayer()
    
    let animation = CABasicAnimation(keyPath: "bounds")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.blueColor().CGColor
//        layer.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.height)
        layer.position = view.center
        view.layer.addSublayer(layer)
        layer.backgroundColor = UIColor.redColor().CGColor
        layer.delegate = self
        
        layer.contents = UIImage(named: "89b14af960334599f45be8b73c1d95d5")?.CGImage
        //裁剪
        layer.contentsRect = CGRect(x: 0, y: 0, width: 0.5, height: 1)
        
        //右下角，右下角部分被横纵拉伸，其上部横向拉伸，其下部纵向拉伸，左上角不拉伸
        layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)
        
        //drawsAsynchronously默认值也是false。与shouldRasterize相对，该属性适用于图层内容需要反复重绘的情况，此时设成true可能会改善性能，比如需要反复绘制大量粒子的粒子发射器图层
        layer.drawsAsynchronously = false
        
        //shouldRasterize默认为false，设为true可以改善性能，如果图层内容只需要一次渲染。相对画面中移动但自身外观不变的对象效果拔群,实现组透明的效果，如果它被设置为YES，在应用透明度之前，图层及其子图层都会被整合成一个整体的图片，这样就没有透明度混合的问题了,为了启用shouldRasterize属性，我们设置了图层的rasterizationScale属性。默认情况下，所有图层拉伸都是1.0， 所以如果你使用了shouldRasterize属性，你就要确保你设置了rasterizationScale属性去匹配屏幕，以防止出现Retina屏幕像素化的问题。
        layer.shouldRasterize = false
        
        //使用过滤器，过滤器在图像利用contentsGravity放大时发挥作用，可用于改变大小（缩放、比例缩放、填充比例缩放）和位置（中心、上、右上、右等等）。以上属性的改变没有动画效果，另外如果geometryFlipped未设为true，几何位置和阴影会上下颠倒。
        layer.magnificationFilter = kCAFilterLinear
        //修改layer的y轴的方向，默认是false,设置为yes，则子图层或者子视图本来相对于左上角放置 改为 相对于左下角放置；
        layer.geometryFlipped = false
        
        //消除锯齿(会造成离屏渲染)
        layer.allowsEdgeAntialiasing = true
        layer.edgeAntialiasingMask = [.LayerLeftEdge, .LayerBottomEdge, .LayerRightEdge, .LayerTopEdge]
        layer.masksToBounds = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        animation.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 200, height: 200))
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = 10
        layer.addAnimation(animation, forKey: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let runloop = NSRunLoop.currentRunLoop()
            
            //每次runloop返回后，timer会被销毁，所以每次启动都需要重新添加timer
            let timer = NSTimer(timeInterval: 2, target: self, selector: #selector(self.runWithTimer), userInfo: nil, repeats: true)
            runloop.addTimer(timer, forMode: NSDefaultRunLoopMode)
            
            runloop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 10))
            
            //在动画结束时同步p和m
            self.layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        })
    }
    
    func runWithTimer() {
        //presentationLayer返回呈现树上的layer，可以获取动画中间状态的layer属性值
        /*
         在CALayer内部，它控制着两个属性：presentationLayer(以下称为P)和modelLayer（以下称为M）。P只负责显示，M只负责数据的存储和获取。我们对layer的各种属性赋值比如frame，实际上是直接对M的属性赋值，而P将在每一次屏幕刷新的时候回到M的状态。比如此时M的状态是1，P的状态也是1，然后我们把M的状态改为2，那么此时P还没有过去，也就是我们看到的状态P还是1，在下一次屏幕刷新的时候P才变为2。而我们几乎感知不到两次屏幕刷新之间的间隙，所以感觉就是我们一对M赋值，P就过去了。P就像是瞎子，M就像是瘸子，瞎子背着瘸子，瞎子每走一步（也就是每次屏幕刷新的时候）都要去问瘸子应该怎样走（这里的走路就是绘制内容到屏幕上），瘸子没法走，只能指挥瞎子背着自己走。可以简单的理解为：一般情况下，任意时刻P都会回到M的状态。而当一个CAAnimation（以下称为A）加到了layer上面后，A就把M从P身上挤下去了。现在P背着的是A，P同样在每次屏幕刷新的时候去问他背着的那个家伙，A就指挥它从fromValue到toValue来改变值。而动画结束后，A会自动被移除，这时P没有了指挥，就只能大喊“M你在哪”，M说我还在原地没动呢，于是P就顺声回到M的位置了。这就是为什么动画结束后我们看到这个视图又回到了原来的位置，是因为我们看到在移动的是P，而指挥它移动的是A，M永远停在原来的位置没有动，动画结束后A被移除，P就回到了M的怀里。
         
         动画结束后，P会回到M的状态（当然这是有前提的，因为动画已经被移除了，我们可以设置fillMode来继续影响P），但是这通常都不是我们动画想要的效果。我们通常想要的是，动画结束后，视图就停在结束的地方，并且此时我去访问该视图的属性（也就是M的属性），也应该就是当前看到的那个样子。按照官方文档的描述，我们的CAAnimation动画都可以通过设置modelLayer到动画结束的状态来实现P和M的同步。
         
         为了不阻塞主线程,渲染的过程是在单独的进程或线程中进行的,所以你会发现Animation的动画并不会阻塞主线程
         
         removedOnCompletion为true时会在动画结束后自动移除，如果为false则需要手动移除，在移除之前会一直保持动画结束时的状态，直到移除动画才会恢复到modelLayer的状态
         */
        let layer = self.layer.presentationLayer()
        print(layer?.bounds)
        
        let layer2 = self.layer.modelLayer()
        print(layer2.bounds)
    }
    
    /*
     当我们直接对可动画属性赋值的时候，由于有隐式动画存在的可能，CALayer首先会判断此时有没有隐式动画被触发。它会让它的delegate（没错CALayer拥有一个属性叫做delegate）调用actionForLayer:forKey:来获取一个返回值，这个返回值在声明的时候是一个id对象，当然在运行时它可能是任何对象。这时CALayer拿到返回值，将进行判断：如果返回的对象是一个nil，则进行默认的隐式动画；如果返回的对象是一个[NSNull null] ，则CALayer不会做任何动画；如果是一个正确的实现了CAAction协议的对象，则CALayer用这个对象来生成一个CAAnimation，并加到自己身上进行动画。
     */
    override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
        print("======actionForLayer=====")
        print(event)
        
        return nil
    }
}


/*掉用顺序
 1.actionForKey
 2.如果设置了代理，掉用代理的actionForLayer
 3.在actions字典中查找
 4.defaultActionForKey
 
 如果返回的对象是一个[NSNull null] ，则CALayer不会做任何动画；如果是一个正确的实现了CAAction协议的对象，则CALayer用这个对象来生成一个CAAnimation，并加到自己身上进行动画。
 如果都返回了nil对象，如果开启了隐式动画，会默认返回一个CABasicAnimation对象，默认动画时间 0.25秒，时间函数为渐入渐出 kCAMediaTimingFunctionEaseInEaseOut。
 */

class YJLayer: CALayer {
    //修改layer的任意一个属性都会掉用这个方法，只有支持动画的属性才会创建动画
    
    /* onOrderIn
     *      Invoked when the layer is made visible, i.e. either its
     *      superlayer becomes visible, or it's added as a sublayer of a
     *      visible layer
     *
     * onOrderOut
     *      Invoked when the layer becomes non-visible. */
    override func actionForKey(event: String) -> CAAction? {
        print("======actionForKey=====")
        print(event)
        return super.actionForKey(event)
    }
    
    override class func defaultActionForKey(event: String) -> CAAction? {
        print("======defaultActionForKey=====")
        print(event)
        return nil
    }
    
    override func addAnimation(anim: CAAnimation, forKey key: String?) {
        super.addAnimation(anim, forKey: key)
        print("======addAnimation=====")
        print(key)
    }
    
    override class func needsDisplayForKey(key: String) -> Bool {
        let re = super.needsDisplayForKey(key)
        
        print(re, key)
        
        return re
    }
}

class Tem: CAAction {
    @objc func runActionForKey(event: String, object anObject: AnyObject, arguments dict: [NSObject : AnyObject]?) {
        
    }
}


