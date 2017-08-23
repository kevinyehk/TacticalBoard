//
//  FloatView.m
//  TacticalBoard
//
//  Created by 葉立誠 on 15/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "FloatView.h"

@implementation FloatView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self initialFloatView];
    return self;
}

- (void)initialFloatView {
    
    self.backgroundColor = [UIColor whiteColor];
    //self.layer.borderWidth = 2.0;
    //self.layer.borderColor = [[UIColor yellowColor] CGColor];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
