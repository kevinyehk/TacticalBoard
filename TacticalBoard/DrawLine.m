	//
//  DrawLine.m
//  TacticalBoard
//
//  Created by 葉立誠 on 08/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        [self drawLineInit];
    }
    
    return self;
}
- (void)drawLineInit {
    

    self.paths = [[NSMutableArray alloc] init];
    self.pathColor = [UIColor whiteColor];
    self.pathWidth = 4.0f;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //UITouch *touch =  [touches anyObject];
    //CGPoint startPoint = [touch locationInView:touch.view];
    PaintPaths *paintPath = [[PaintPaths alloc]init];
    paintPath.color = [self.pathColor CGColor];
    paintPath.pathWidth = self.pathWidth;
    paintPath.pathPoints = [[NSMutableArray alloc]init];
    [self.paths addObject:paintPath];
  

    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
   
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:touch.view];
    PaintPaths *paintPath = [self.paths lastObject];
    [paintPath.pathPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[self.paths addObject:self.path];
    NSLog(@"%lu",(unsigned long)[self.paths count]);
    PaintPaths *paintPath = [self.paths lastObject];
    if([paintPath.pathPoints count] < 3) {
        NSLog(@"remove path");
        [self.paths removeLastObject];
        [self setNeedsDisplay];
    }
    if([self.paths count] == 100) {
        NSLog(@"full");
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        [self clear];
    }
    if(self.startedDraw) {
        self.startedDraw();
    }

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"cancel");
    [self undo];
}

- (void)drawRect:(CGRect)rect {
    
    //[super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (int i=0; i<self.paths.count; i++) {
        PaintPaths *paintPath = [self.paths objectAtIndex:i];
        CGMutablePathRef path = CGPathCreateMutable();
        for (int j=0; j < paintPath.pathPoints.count; j++) {
            CGPoint point = [[paintPath.pathPoints objectAtIndex:j]CGPointValue] ;
            if (j==0) {
                CGPathMoveToPoint(path, &CGAffineTransformIdentity, point.x,point.y);
            }
            else {
                CGPathAddLineToPoint(path, &CGAffineTransformIdentity, point.x, point.y);
            }
        }
        CGContextSetStrokeColorWithColor(ctx,paintPath.color);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextAddPath(ctx, path);
        CGContextSetLineWidth(ctx,paintPath.pathWidth);
        CGContextStrokePath(ctx);
    }

}

- (void)undo {
    
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

- (void)clear {
    
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}


@end

@implementation PaintPaths



@end
