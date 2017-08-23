//
//  TacticalView.h
//  TacticalBoard
//
//  Created by 葉立誠 on 21/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "DrawLine.h"
#import "ColorPickerView.h"
#import "ImageScrollView.h"
#import "FloatView.h"
#import "TitleView.h"

@interface TacticalView : UIView<colorPickerDelegate, imageScrollViewDelegate, TitleViewDelegate>

@property (weak, nonatomic) UIImageView *imageView;
@property AVPlayer *player;
@property DrawLine *custom;
@property ImageScrollView *imageScrollView;
@property UIImage *sliceOfVideoImage;
@property NSTimeInterval timeForImage;

@end
