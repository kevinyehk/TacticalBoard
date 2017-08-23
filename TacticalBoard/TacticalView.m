//
//  TacticalView.m
//  TacticalBoard
//
//  Created by 葉立誠 on 21/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "TacticalView.h"

@implementation TacticalView

FloatView *floatView;
ColorPickerView *colorPickerView;
NSInteger videoLengthForSecond;
BOOL imageSaveState = NO;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self initMainView];
    return self;
}

- (void)initMainView {
    
    self.timeForImage = 25;
    
    
    
    //scrollview
    self.custom = [[DrawLine alloc]initWithFrame:CGRectMake(0, 0, 1024, 415)];
    self.imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 177, 1024, 415)];
    [self addSubview:self.imageScrollView];
    self.imageScrollView.imageForDrawing.image = [self getImageFromURL];
    [self.imageScrollView.viewForDrawing addSubview:self.custom];
    self.imageScrollView.delegate = self;
    
    
    
    
    
    //floatview
    floatView = [[FloatView alloc] initWithFrame:CGRectMake(0, 20, 360, 145)];
    [self addSubview:floatView];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetect)];
    //[floatView addGestureRecognizer:tap];
    [self addSubview:floatView];
    floatView.hidden = YES;
    
    
    
    //colorpicker
    colorPickerView = [[ColorPickerView alloc]initWithFrame:CGRectMake(0, 688, 1024, 80)];
    [self addSubview:colorPickerView];
    colorPickerView.delegate = self;
    colorPickerView.colorOnChange = ^(UIColor *color) {
        self.custom.pathColor = color;
    };
    [colorPickerView setTimeLabelText:self.timeForImage];
    
    //navigation bar
    TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, 1024, 80)];
    [self addSubview:titleView];
    titleView.delegate = self;
    
    [self bringSubviewToFront:floatView];//bring float view to the front
}

- (UIImage *)getImageFromURL {
    
    //   AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://www.quirksmode.org/html5/videos/big_buck_bunny.mp4"] options:nil];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"big_buck_bunny" withExtension:@"mp4"] options:nil];
    CMTime duration = asset.duration;
    CMTime getImageTime = CMTimeMake((int)self.timeForImage*duration.timescale, duration.timescale);
    videoLengthForSecond = (int)duration.value / duration.timescale;
    //NSLog(@"video length %d",videoLengthForSecond);
    
    NSLog(@"%d, %lld",getImageTime.timescale,getImageTime.value);
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CGImageRef image = [gen copyCGImageAtTime:getImageTime actualTime:nil error:nil];
    
    return [UIImage imageWithCGImage:image];
}

- (void)tapDetect{
    
    NSLog(@"tap");
}


- (void)showAlertViewController:(void (^)())callback {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Image unsaved" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(callback){
            callback();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    //[self presentViewController:alert animated:YES completion:nil];
    [self addSubview:alert];
}

#pragma mark change StatusBarStyle
- (UIStatusBarStyle) preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark ImageScrollView delegate

- (void)passImageToFloatView:(UIImage *)image {
    
    UIImageView *floatImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 360, 145)];
    floatImage.image = image;
    [floatView addSubview:floatImage];
    floatView.hidden = NO;
}

- (void)closeFloatView {
    
    floatView.hidden = YES;
}

- (void)returnColor:(UIColor *)color {
    
    //self.custom.pathColor = color;
    
    //NSLog(@"touched!!!");
}

#pragma mark colorPickerDelegate

- (void)undoDrawPath {
    
    [self.custom undo];
    //NSLog(@"undo click");
    if(imageSaveState == YES) {
        imageSaveState = NO;
    }
}

- (void)changeImage:(NSInteger)adjustSecond {
    
    //NSTimeInterval tmpTime = timeForImage;
    if(self.timeForImage + adjustSecond <= videoLengthForSecond && self.timeForImage + adjustSecond > 0){
        
        if(imageSaveState == NO) {
            [self showAlertViewController:^{
                self.timeForImage += adjustSecond;
                self.imageScrollView.imageForDrawing.image = [self getImageFromURL];
                [colorPickerView setTimeLabelText:(self.timeForImage)];
                [self.custom clear];
                
            }];
        }
    }
}

- (void)saveButtonClickNotification {
    
    UIGraphicsBeginImageContextWithOptions(self.imageScrollView.viewForDrawing.bounds.size, YES, 0.0f);
    [self.imageScrollView.viewForDrawing drawViewHierarchyInRect:self.imageScrollView.viewForDrawing.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.frame = CGRectMake(0, 0, self.imageScrollView.viewForDrawing.bounds.size.width, self.imageScrollView.viewForDrawing.bounds.size.height);
    self.imageView.image =  image;
    imageSaveState = YES;
    //UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    
}

- (IBAction)captureButtonPress:(id)sender {
    
    //NSLog(@"%d",self.custom.opaque);
    UIGraphicsBeginImageContextWithOptions(self.imageScrollView.viewForDrawing.bounds.size, YES, 0.0f);
    [self.imageScrollView.viewForDrawing drawViewHierarchyInRect:self.imageScrollView.viewForDrawing.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.frame = CGRectMake(0, 0, self.imageScrollView.viewForDrawing.bounds.size.width, self.imageScrollView.viewForDrawing.bounds.size.height);
    self.imageView.image =  image;
    //UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
}


#pragma mark touch event
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if([touch view] == floatView) {
        //CGPoint point = [touch locationInView:self.view];
    }
    
}
- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if([touch view] == floatView) {
        
        //floatView.center = point;
        // NSLog(@"x:%f, y:%f",floatView.frame.origin.x, floatView.frame.origin.y);
        [UIView animateWithDuration:0.1 animations:^{
            floatView.center = point;
        }];
    }
    //NSLog(@"move to x:%f  y:%f", point.x,point.y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if([touch view] == floatView) {
        
        if(point.x < 512 && point.y < 384) {
            
            [UIView animateWithDuration:0.1 animations:^{
                floatView.frame = CGRectMake(0, 20, 360, 145);
            }];
        }
        else if(point.x < 512 && point.y >= 384) {
            
            [UIView animateWithDuration:0.1 animations:^{
                floatView.frame = CGRectMake(0, 623, 360, 145);
            }];
        }
        else if(point.x >= 512 && point.y < 384) {
            
            [UIView animateWithDuration:0.1 animations:^{
                floatView.frame = CGRectMake(664, 20, 360, 145);
            }];
        }
        else if(point.x >= 512 && point.y >= 384) {
            
            [UIView animateWithDuration:0.1 animations:^{
                floatView.frame = CGRectMake(664, 623, 360, 145);
            }];
        }
        
    }
    
}

@end

