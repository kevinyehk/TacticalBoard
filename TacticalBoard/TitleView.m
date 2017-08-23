//
//  TitleView.m
//  TacticalBoard
//
//  Created by 葉立誠 on 17/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self itemInitial];
    return self;
    
}

- (void)itemInitial {
    
    self.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    //self.backgroundColor = [UIColor clearColor];
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(979, 39, 22, 22)];
    self.saveButton.titleLabel.text = @"save";
    [self.saveButton setImage:[UIImage imageNamed:@"icon_save.png"] forState:UIControlStateNormal];
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 36, 28, 28)];
    self.backButton.titleLabel.text = @"back";
    [self.backButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(485, 41, 54, 18)];
    self.titleLabel.text = @"战术板";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.backButton];
    [self addSubview:self.saveButton];
    [self addSubview:self.titleLabel];
    [self.saveButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)ButtonClick:(UIButton *)btn {
    
    if([btn.titleLabel.text  isEqualToString: @"save"]) {
            [self.delegate saveButtonClick];
    }
    else if([btn.titleLabel.text isEqualToString:@"back"]) {
        [self.delegate backButtonClick];
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
