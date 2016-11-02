//
//  MapView.m
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
/*
 levelsOfDetail是指，从UIScrollView的1倍zoomScale开始，能够支持细节刷新的缩小级数。每一级是上一级的1/2，所以假设levelsOfDetail = n，levelsOfDetailBias不指定的话，CATiledLayer将会在UIScrollView的zoomScale为以下数字时重新drawLayer
 2^-1 -> 2^-2 -> ... -> 2^-n
 也就是
 1/2, 1/4, 1/8, 1/16, ... , 1/2^n
 
 在levelsOfDetailBias不指定的情况下，zoomScale大于0.5后就不会再drawLayer，所以若继续放大UIScrollView的话，画面将越来越模糊。
 
 这个时候levelsOfDetailBias就有用了。
 levelsOfDetailBias = m表示，将原来的1/2，移到2^m倍的位置。
 假设levelsOfDetail = n，levelsOfDetailBias = m的话，会有如下队列：
 2^m * 2^-1 -> 2^m * 2^-2 -> ... -> 2^m * 2^-n
 简化一下即
 2^(m - 1) -> 2^(m - 2) -> 2^(m - 3) ->... -> 2^(m - n)
 
 举例，levelsOfDetail = 3，levelsOfDetailBias = 3，则你的UIScrollView将会在以下zoomScale时drawLayer
 2^(3 - 1) -> 2^(3 - 2) -> 2^(3 - 3)
 即4 -> 2 -> 1
 
 特例是，levelsOfDetailBias > levelsOfDetail时，则每相差2倍就会drawLayer一下。
 
 可以简单理解成：
 levelsOfDetail表示一共有多少个drawLayer的位置
 levelsOfDetailBias表示比1大的位置里有多少个drawLayer的位置（包括1）
 */

#import "MapView.h"


@implementation MapView

+ (Class)layerClass
{
    return [CATiledLayer class];
}

- (CGPDFDocumentRef)sfMuni {
    if(NULL == sfMuni) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sf_muni" ofType:@"pdf"];
        NSURL *docURL = [NSURL fileURLWithPath:path];
        sfMuni = CGPDFDocumentCreateWithURL((CFURLRef)docURL);
    }
    return sfMuni;
}

- (CGPDFPageRef)map {
    if(NULL == map) {
        map = CGPDFDocumentGetPage(self.sfMuni, 1);
    }
    return map;
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		
        tiledLayer = (CATiledLayer *)self.layer;
		
		// get tiledLayer size
		CGRect pageRect = CGPDFPageGetBoxRect(self.map, kCGPDFCropBox);
		int w = pageRect.size.width;
		int h = pageRect.size.height;
		
		// get level count
		int levels = 1;
		while (w > 1 && h > 1) {
			levels++;
			w = w >> 1;
			h = h >> 1;
		}
		// set the levels of detail
		tiledLayer.levelsOfDetail = levels;
		// set the bias for how many 'zoom in' levels there are
		tiledLayer.levelsOfDetailBias = 5;
		
		// set self w h
		[self setFrame:pageRect];
		
		//self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGSize size = layer.bounds.size;
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -size.height);
    CGContextDrawPDFPage(ctx, self.map);
    CGContextRestoreGState(ctx);
}


@end
