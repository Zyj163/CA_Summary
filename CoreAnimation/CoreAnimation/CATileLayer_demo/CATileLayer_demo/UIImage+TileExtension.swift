//
//  UIImage+TileExtension.swift
//  CATileLayer_demo
//
//  Created by ddn on 16/8/16.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func saveTileOfSize(size: CGSize, name: String, finish: (() -> ())? = nil) {
        
        let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
        let filePath = "\(cachesPath)/\(name)_0_0.png"
        print(filePath)
        let fileManager = NSFileManager.defaultManager()
        let fileExists = fileManager.fileExistsAtPath(filePath)
        
        if fileExists == false {
            var tileSize = size
            let scale = Float(UIScreen.mainScreen().scale)
            
            if let image = UIImage(named: "\(name).jpg") {
                let imageRef = image.CGImage
                let totalColumns = Int(ceilf(Float(image.size.width / tileSize.width)) * scale)
                let totalRows = Int(ceilf(Float(image.size.height / tileSize.height)) * scale)
                let partialColumnWidth = Int(image.size.width % tileSize.width)
                let partialRowHeight = Int(image.size.height % tileSize.height)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    for y in 0..<totalRows {
                        for x in 0..<totalColumns {
                            if partialRowHeight > 0 && y + 1 == totalRows {
                                tileSize.height = CGFloat(partialRowHeight)
                            }
                            
                            if partialColumnWidth > 0 && x + 1 == totalColumns {
                                tileSize.width = CGFloat(partialColumnWidth)
                            }
                            
                            let xOffset = CGFloat(x) * tileSize.width
                            let yOffset = CGFloat(y) * tileSize.height
                            let point = CGPoint(x: xOffset, y: yOffset)
                            
                            if let tileImageRef = CGImageCreateWithImageInRect(imageRef, CGRect(origin: point, size: tileSize)), imageData = UIImagePNGRepresentation(UIImage(CGImage: tileImageRef)) {
                                let path = "\(cachesPath)/\(name)_\(x)_\(y).png"
                                imageData.writeToFile(path, atomically: false)
                            }
                        }
                    }
                    finish?()
                })
            }
        }
    }
}
