//
//  ImageScrollView.h
//  TacticalBoard
//
//  Created by 葉立誠 on 15/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawLine.h"

@protocol imageScrollViewDelegate <NSObject>

- (void)passImageToFloatView:(UIImage *)image;
- (void)closeFloatView;


@end

@interface ImageScrollView : UIView<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property UIView *viewForDrawing;
@property UIImageView *imageForDrawing;
@property UIScrollView *showImageScrollView;
@property(nonatomic, weak) id<imageScrollViewDelegate> delegate;

@end
