//
//  ColorPickerView.m
//  TacticalBoard
//
//  Created by 葉立誠 on 11/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "ColorPickerView.h"



@implementation ColorPickerView

UIView *thumb;
NSArray *colorArray;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    [self createPicker];
    [self createThumb];
    [self createButton];
    [self createTimeView];
    self.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    
    return self;
}

- (void)createButton {
    
    UIButton *undoButton = [[UIButton alloc]initWithFrame:CGRectMake(950, 23, 34, 34)];
    [undoButton setImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateNormal];
    [self addSubview:undoButton];
    [undoButton addTarget:self action:@selector(undoButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTimeView {
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(650, 25, 240, 30)];
    UIButton *previousSecondButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    UIButton *nextSecondButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 0, 70, 30)];
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 100, 30)];
    previousSecondButton.backgroundColor = [UIColor colorWithRed:0.05 green:0.71 blue:0 alpha:1];
    nextSecondButton.backgroundColor = [UIColor colorWithRed:0.05 green:0.71 blue:0 alpha:1];
    [previousSecondButton setTitle:@"上一秒" forState:UIControlStateNormal];
    [nextSecondButton setTitle:@"下一秒" forState:UIControlStateNormal];
    previousSecondButton.titleLabel.font = [UIFont systemFontOfSize:14];
    nextSecondButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.timeLable.text = @"00:00:00";
    self.timeLable.textColor = [UIColor whiteColor];
    self.timeLable.font = [UIFont systemFontOfSize:14];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    //for button radius corner
    UIBezierPath *maskPath, *maskPath1;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:previousSecondButton.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    previousSecondButton.layer.mask = maskLayer;
    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:previousSecondButton.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(3, 3)];
    maskLayer1.path = maskPath1.CGPath;
    nextSecondButton.layer.mask = maskLayer1;
    //end
    [timeView addSubview:previousSecondButton];
    [timeView addSubview:self.timeLable];
    [timeView addSubview:nextSecondButton];
    
    [previousSecondButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [nextSecondButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [previousSecondButton addTarget:self action:@selector(previousButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [nextSecondButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:timeView];
}

- (void)setTimeLabelText:(NSTimeInterval)imageTime {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:imageTime];
    [formate setDateFormat:@"HH:mm:ss"];
    [formate setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    self.timeLable.text = [formate stringFromDate:date];
    
}

- (void)undoButtonClick {
    
    [self.delegate undoDrawPath];
    
}

- (void)previousButtonClick {
    
    [self.delegate changeImage:-1];
    
}

- (void)nextButtonClick {
    
    [self.delegate changeImage:1];

}

- (void)createPicker {
    
	colorArray = [[NSArray alloc] initWithObjects:
                    [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1],
                    [UIColor colorWithRed:0.96 green:0.20 blue:0.07 alpha:1],
                    [UIColor colorWithRed:1.0 green:0.73 blue:0.29 alpha:1],
                    [UIColor colorWithRed:1.0 green:0.91 blue:0.03 alpha:1],
                    [UIColor colorWithRed:0.77 green:0.99 blue:0.24 alpha:1],
                    [UIColor colorWithRed:0 green:0.72 blue:0 alpha:1],
                    [UIColor colorWithRed:0.15 green:0.83 blue:1.0 alpha:1],
                    [UIColor colorWithRed:0.10 green:0.49 blue:1.0 alpha:1],
                    [UIColor colorWithRed:0.01 green:0.22 blue:0.78 alpha:1],
                    [UIColor colorWithRed:0.59 green:0.35 blue:1.0 alpha:1],
                    [UIColor colorWithRed:0.98 green:0.60 blue:0.98 alpha:1],
                    [UIColor colorWithRed:1.0 green:0.45 blue:0.56 alpha:1],
                    [UIColor colorWithRed:0.97 green:0.16 blue:0.75 alpha:1], nil];
    
    float colorPositionX = 40;
    for(int i = 0; i< 13; i++) {
        UIView *color = [[UIView alloc] initWithFrame:CGRectMake(colorPositionX , 36, 40, 8)];
        color.backgroundColor = [colorArray objectAtIndex:i];
        if( i == 0 ){
            
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:color.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(3, 3)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.path = maskPath.CGPath;
            color.layer.mask = maskLayer;
            
        }
        if( i == 12 ){
            
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:color.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(3, 3)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.path = maskPath.CGPath;
            color.layer.mask = maskLayer;
            
        }
        
        [self addSubview:color];
        colorPositionX += 40;
		
    }
}

- (void)createThumb {
    
    thumb = [[UIView alloc]initWithFrame:CGRectMake(52, 22, 16, 36)];
    thumb.backgroundColor = [UIColor whiteColor];
    thumb.layer.cornerRadius = 8;
    thumb.layer.masksToBounds = YES;
    thumb.layer.borderColor = [[UIColor whiteColor]CGColor];
    thumb.layer.borderWidth = 2.0;
    
    [self addSubview:thumb];
   
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:self];
    if(startPoint.x > 40 && startPoint.x < 560) {
        
        thumb.frame = CGRectMake(startPoint.x, thumb.frame.origin.y, 16, 36);
		thumb.backgroundColor = [colorArray objectAtIndex:(thumb.frame.origin.x/40) - 1];
        //NSLog(@"move x:%f, move y:%f",startPoint.x, startPoint.y);
        //NSLog(@"thumb x:%f, thumb y:%f",thumb.frame.origin.x, thumb.frame.origin.y);
    }
	[self.delegate returnColor:[colorArray objectAtIndex:(thumb.frame.origin.x/40) - 1]];
    if(self.colorOnChange) {
    
        self.colorOnChange([colorArray objectAtIndex:(thumb.frame.origin.x/40) - 1]);
    }
    

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    if(currentPoint.x > 40 && currentPoint.x < 560) {
        
        thumb.frame = CGRectMake(currentPoint.x, thumb.frame.origin.y, 16, 36);
        //thumb.center.x = currentPoint.x;

    }
//    if(thumb.frame.origin.x > 40 && thumb.frame.origin.x < 80) {
//        thumb.backgroundColor = [UIColor colorWithRed:0.96 green:0.20 blue:0.07 alpha:1];
//    }
	thumb.backgroundColor = [colorArray objectAtIndex:(thumb.frame.origin.x/40) - 1];
	[self.delegate returnColor:[colorArray objectAtIndex:(thumb.frame.origin.x/40) - 1]];

    if(self.colorOnChange) {
        
        self.colorOnChange([colorArray objectAtIndex:(thumb.frame.origin.x/40) - 1]);
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}

@end
