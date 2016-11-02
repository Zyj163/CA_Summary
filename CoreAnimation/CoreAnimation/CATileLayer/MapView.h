//
//  MapView.h
//  TiledLayer_iphone
//
//  Created by jimneylee on 10-9-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface MapView : UIImageView {
    CATiledLayer *tiledLayer;
    CGPDFDocumentRef sfMuni;
    CGPDFPageRef map;
}
@property(nonatomic, readonly) CGPDFDocumentRef sfMuni;
@property(nonatomic, readonly) CGPDFPageRef map;

@end
