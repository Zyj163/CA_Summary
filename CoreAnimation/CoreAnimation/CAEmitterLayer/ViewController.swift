//
//  ViewController.swift
//  CAEmitterLayer
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var someView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CoreAnimation_EmitterLayer()
    }

    func CoreAnimation_EmitterLayer() {
        let snowEmitter = CAEmitterLayer()
        snowEmitter.emitterPosition = CGPointMake(view.bounds.size.width/2, -30)//设置发射位置，这个和emitterMode有关
        snowEmitter.emitterZPosition = 50//发射点z的位置，这个和emitterMode有关
        snowEmitter.emitterSize = CGSizeMake(view.bounds.size.width*2, 0.0)//发射点的范围，这个和emitterMode有关
        snowEmitter.emitterDepth = 100
        //从线上发射
        //    snowEmitter.emitterMode        = kCAEmitterLayerOutline;
        //   snowEmitter.emitterShape    = kCAEmitterLayerLine;
        //从一个立方体内发射出，这样的话雪花会有不同的大小在3D的情况下
        snowEmitter.emitterMode      = kCAEmitterLayerVolume;
        snowEmitter.emitterShape    = kCAEmitterLayerCuboid;
        
        let snowCell = CAEmitterCell()
        snowCell.birthRate = 3.0//每3秒发生1个
        snowCell.lifetime = 60.0//生存时间
        snowCell.velocity = 20//初始速度
        snowCell.velocityRange = 10//初始速度的随机范围
        snowCell.yAcceleration = 10//y轴加速度，当然还有z,x轴
        snowCell.emissionRange = -0.5 * CGFloat(M_PI)// 发射角度范围 ,这个参数一设置，似乎方向只能朝屏幕内，就是z的负轴
        snowCell.spin = 0.0
        snowCell.spinRange = -0.25 * CGFloat(M_PI)// 自旋转范围
        snowCell.contents = UIImage.init(named: "wheel")?.CGImage
        snowCell.color = UIColor.init(red: 0.6, green: 0.658, blue: 0.743, alpha: 1).CGColor
        
        snowEmitter.shadowOpacity = 1
        snowEmitter.shadowRadius = 0
        snowEmitter.shadowOffset = CGSizeMake(0, 1)
        snowEmitter.shadowColor = UIColor.whiteColor().CGColor
        
        //        snowCell.emissionLatitude = CGFloat(-M_PI_2)//按照Z轴旋转
        snowEmitter.preservesDepth = true
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/300.0
        view.layer.transform = transform
        
        snowEmitter.emitterCells = [snowCell]
        view.layer.insertSublayer(snowEmitter, atIndex: 0)
        
    }


}

