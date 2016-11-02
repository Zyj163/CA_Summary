//
//  YJTileView.swift
//  CATileLayer_demo
//
//  Created by ddn on 16/8/16.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class YJTileView: UIView {

    let sideLength: CGFloat = 200
    let fileName = "1-160G3123424"
    let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
    
    override class func layerClass() -> AnyClass {
        return CATiledLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let layer = self.layer as! CATiledLayer
        layer.tileSize = CGSize(width: sideLength, height: sideLength)
    }
    
    override func drawRect(rect: CGRect) {
        
        let firstColumn = Int(rect.minX / sideLength)
        let lastColumn = Int(rect.maxX / sideLength)
        let firstRow = Int(rect.minY / sideLength)
        let lastRow = Int(rect.maxY / sideLength)
        
        for row in firstRow...lastRow {
            for column in firstColumn...lastColumn {
                
                if let tile = imageForTileAtColumn(column, row: row) {
                    
                    let x = sideLength * CGFloat(column)
                    let y = sideLength * CGFloat(row)
                    
                    let point = CGPoint(x: x, y: y)
                    
                    let size = CGSize(width: sideLength, height: sideLength)
                    
                    var tileRect = CGRect(origin: point, size: size)
                    
                    tileRect = bounds.intersect(tileRect)
                    
                    tile.drawInRect(tileRect)
                }
            }
        }
    }
    
    private func imageForTileAtColumn(column: Int, row: Int) -> UIImage? {
        let filePath = "\(cachesPath)/\(fileName)_\(column)_\(row)"
        return UIImage(contentsOfFile: filePath)
    }
    
}



















