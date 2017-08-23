//
//  TacticalBoardController.h
//  TacticalBoard
//
//  Created by 葉立誠 on 03/08/2017.
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


@interface TacticalBoardController : UIViewController<colorPickerDelegate, imageScrollViewDelegate, TitleViewDelegate>


@property (nonatomic) NSTimeInterval timeForImage;
@property (nonatomic) NSString *videoURL;
@property (nonatomic) UIViewController *previousViewController;

@end

