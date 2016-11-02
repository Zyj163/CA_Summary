//
//  ViewController.m
//  sdf
//
//  Created by zhangyongjun on 16/5/26.
//  Copyright © 2016年 张永俊. All rights reserved.
//

#import "ViewController.h"
#import "MapView.h"

@interface ViewController () <UIScrollViewDelegate>
{
    MapView *mapView;
}
@end

@implementation ViewController

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return mapView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapView = [[MapView alloc] initWithFrame:CGRectZero];
    
    //create& add scrollView
    UIScrollView* myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    myScrollView.contentSize = mapView.bounds.size;
    myScrollView.minimumZoomScale = 1.0;
    myScrollView.maximumZoomScale = 50.0;
    myScrollView.clipsToBounds = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    //add image view to scrollView
    [myScrollView addSubview:mapView];
    
}

@end
