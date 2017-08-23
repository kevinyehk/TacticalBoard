//
//  DrawLine.h
//  TacticalBoard
//
//  Created by 葉立誠 on 08/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DrawLineEventCallBack)(void);

@interface DrawLine : UIView

@property NSMutableArray *paths;

@property UIColor *pathColor;
@property CGFloat pathWidth;
@property UIImageView *tmpImageView;
@property (nonatomic, copy)DrawLineEventCallBack startedDraw;

- (void)undo;
- (void)clear;

@end

@interface PaintPaths : NSObject

@property NSMutableArray *pathPoints;
@property CGColorRef color;
@property float pathWidth;

@end
