//
//  ColorPickerView.h
//  TacticalBoard
//
//  Created by 葉立誠 on 11/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ColorPickerChangeCallback)(UIColor *);

@protocol colorPickerDelegate <NSObject>

- (void)returnColor:(UIColor *)color;
- (void)undoDrawPath;
- (void)changeImage:(NSInteger)adjustSecond;

@end

@interface ColorPickerView : UIView


@property (nonatomic, copy) ColorPickerChangeCallback colorOnChange;
@property (nonatomic, weak) id<colorPickerDelegate> delegate;
@property UILabel *timeLable;

- (void)setTimeLabelText:(NSTimeInterval)imageTime;


@end
 
