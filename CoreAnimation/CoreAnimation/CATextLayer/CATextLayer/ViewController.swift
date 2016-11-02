//
//  ViewController.swift
//  CATextLayer
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textLayer = CoreAnimation_TextLayer()
        
        AddAnimationToProperties(textLayer)
    }
    
    func CoreAnimation_TextLayer() -> CATextLayer {
        let textLayer = CATextLayer()
        
        /* The text to be rendered, should be either an NSString or an
         * NSAttributedString. Defaults to nil. */
        textLayer.string = "text layer text layer text layer text layer text layer text layer text layer text layer text layer text layer text layer "
        
        /* The font to use, currently may be either a CTFontRef, a CGFontRef,
         * or a string naming the font. Defaults to the Helvetica font. Only
         * used when the `string' property is not an NSAttributedString. */
        textLayer.font = "Helvetica"
        
        /* The font size. Defaults to 36. Only used when the `string' property
         * is not an NSAttributedString. Animatable (Mac OS X 10.6 and later.) */
        textLayer.fontSize = 36
        
        /* 文字颜色. Defaults to opaque white.
         * Only used when the `string' property is not an NSAttributedString.
         * Animatable (Mac OS X 10.6 and later.) */
        textLayer.foregroundColor = UIColor.redColor().CGColor
        
        /* 自动换行.
         * Defaults to NO.*/
        textLayer.wrapped = true
        
        /* ...在哪里. Defaults to `none'. */
        textLayer.truncationMode = kCATruncationEnd
        
        /* 对齐方式. Defaults to `natural'. */
        textLayer.alignmentMode = kCAAlignmentLeft
        
        /* Sets allowsFontSubpixelQuantization parameter of CGContextRef
         * passed to the -drawInContext: method. Defaults to NO. */
        textLayer.allowsFontSubpixelQuantization = false
        
        //不仅是CATextLayer，所有图层类的渲染缩放系数都默认为1。在添加到视图时，图层自身的contentsScale缩放系数会自动调整，适应当前画面。你需要为手动创建的图层明确指定contentsScale属性，否则默认的缩放系数1会在Retina显示屏上产生部分模糊
        textLayer.contentsScale = UIScreen.mainScreen().scale
        
        view.layer.addSublayer(textLayer)
        textLayer.anchorPoint = CGPointZero
        textLayer.position = CGPointZero
        textLayer.bounds = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)
        
        return textLayer
    }

    func AddAnimationToProperties(textLayer:CATextLayer) {
        let animator = CABasicAnimation(keyPath: "fontSize")
        animator.toValue = 12
        animator.duration = 2
        textLayer.addAnimation(animator, forKey: nil)
        
        let animator2 = CABasicAnimation(keyPath: "foregroundColor")
        animator2.toValue = UIColor.blueColor().CGColor
        animator2.duration = 2
        textLayer.addAnimation(animator2, forKey: nil)
    }

}


































