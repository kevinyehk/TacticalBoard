//
//  TitleView.h
//  TacticalBoard
//
//  Created by 葉立誠 on 17/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleViewDelegate <NSObject>

- (void)saveButtonClick;
- (void)backButtonClick;

@end

@interface TitleView : UIView

@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic, weak) id<TitleViewDelegate> delegate;

@end
