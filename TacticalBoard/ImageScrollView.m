//
//  ImageScrollView.m
//  TacticalBoard
//
//  Created by 葉立誠 on 15/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "ImageScrollView.h"

@implementation ImageScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self initialScrollView];
    
    return self;
}

- (void)initialScrollView {
    
    self.showImageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 415)];
    self.viewForDrawing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 415)];
    self.imageForDrawing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 415)];
    //self.imageForDrawing.image = [UIImage imageNamed:@"soccer.jpg"];
    [self.viewForDrawing addSubview:self.imageForDrawing];
    [self.showImageScrollView addSubview:self.viewForDrawing];
    [self addSubview:self.showImageScrollView];
    self.showImageScrollView.delegate = self;
    self.showImageScrollView.maximumZoomScale = 4.0;
    self.showImageScrollView.minimumZoomScale = 1.0;
    self.showImageScrollView.zoomScale = 1.0;
    self.showImageScrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
//    self.showImageScrollView.panGestureRecognizer.delaysTouchesBegan = NO;
//    self.showImageScrollView.panGestureRecognizer.delaysTouchesEnded = NO;
    //self.showImageScrollView.scrollEnabled = NO;
    for (UIGestureRecognizer *gestureRecognizer in self.showImageScrollView.gestureRecognizers) {
       // NSLog(@"%@",gestureRecognizer.)
        gestureRecognizer.delaysTouchesBegan = NO;
        gestureRecognizer.delaysTouchesEnded = NO;
    }
    //[self initDrawView];
    UIPanGestureRecognizer *tmp = self.showImageScrollView.panGestureRecognizer;
    [tmp addTarget:self action:@selector(panDetect)];
    
    
}
- (void)panDetect {
    //NSLog(@"pan!!!!");
    //[self.delegate removeLastPath];
}

- (void)initDrawView{
    
    DrawLine *drawView = [[DrawLine alloc] initWithFrame:CGRectMake(0, 0, 1024, 415)];
    [self.viewForDrawing addSubview:drawView];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.viewForDrawing;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    [self.delegate passImageToFloatView:self.imageForDrawing.image];
	if(scale == 1.0){
		[self.delegate closeFloatView];
	}
	
	
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
