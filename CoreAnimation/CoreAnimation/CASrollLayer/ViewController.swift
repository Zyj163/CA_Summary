//
//  ViewController.swift
//  CASrollLayer
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var s: UIView!

    lazy var scrollLayer : CAScrollLayer = CAScrollLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CoreAnimation_ScrollLayer()
    }

    func CoreAnimation_ScrollLayer() {
        //CAScrollLayer提供了和UIScrollView的基本功能。只不过它是layer，只负责显示，不响应用户事件，也不提供滚动条。
        let subLayer = CALayer()
        subLayer.contents = UIImage.init(named: "564b777817e80d631e94b97f2a86614f")?.CGImage
        subLayer.frame = CGRectMake(0, 0, view.bounds.size.width*2, view.bounds.size.height*2)
        
        scrollLayer.frame = view.bounds
        scrollLayer.addSublayer(subLayer)
        scrollLayer.scrollMode = kCAScrollBoth
        
        view.layer.addSublayer(scrollLayer)
        
        let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(gestureChange(_:)))
        view.addGestureRecognizer(panGes)
    }
    
    func gestureChange(panGes : UIPanGestureRecognizer) {
        let translation = panGes.translationInView(view)
        var origin = scrollLayer.bounds.origin
        origin = CGPointMake(origin.x-translation.x, origin.y-translation.y)
        scrollLayer.scrollToPoint(origin)
        panGes.setTranslation(CGPointZero, inView: view)
    }


}

