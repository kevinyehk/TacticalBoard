//
//  TacticalBoardController.m
//  TacticalBoard
//
//  Created by 葉立誠 on 03/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "TacticalBoardController.h"


@interface TacticalBoardController ()

@end

FloatView *floatView;
ColorPickerView *colorPickerView;
ImageScrollView *imageScrollView;
UIImageView *imageView;
DrawLine *drawLine;
NSInteger videoLengthForSecond;
BOOL imageSaveState = YES;

@implementation TacticalBoardController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    
    if(!self.timeForImage) {
        self.timeForImage = 25;
        self.videoURL = @"https://www.quirksmode.org/html5/videos/big_buck_bunny.mp4";
    }
    self.navigationController.navigationBarHidden = YES;

    drawLine = [[DrawLine alloc]initWithFrame:CGRectMake(0, 0, 1024, 415)];
    drawLine.startedDraw = ^{
        imageSaveState = NO;
    };
    imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 177, 1024, 415)];
    [self.view addSubview:imageScrollView];
    imageScrollView.imageForDrawing.image = [self getImageFromURL];
    [imageScrollView.viewForDrawing addSubview:drawLine];
    imageScrollView.delegate = self;
    
   
   
   //floatview
    floatView = [[FloatView alloc] initWithFrame:CGRectMake(0, 20, 360, 145)];
    [self.view addSubview:floatView];
    floatView.hidden = YES;

   
   //colorpicker
    colorPickerView = [[ColorPickerView alloc]initWithFrame:CGRectMake(0, 688, 1024, 80)];
    [self.view addSubview:colorPickerView];
    colorPickerView.delegate = self;
    [colorPickerView setTimeLabelText:self.timeForImage];
   
   //navigation bar
    TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, 1024, 80)];
    [self.view addSubview:titleView];
    titleView.delegate = self;
   
    [self.view bringSubviewToFront:floatView];//bring float view to the front
   
    [self setNeedsStatusBarAppearanceUpdate];// set status bar style
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (UIImage *)getImageFromURL {
   
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:self.videoURL] options:nil];
    CMTime duration = asset.duration;
    CMTime getImageTime = CMTimeMake((int)self.timeForImage*duration.timescale, duration.timescale);
    videoLengthForSecond = (int)duration.value / duration.timescale;
    NSLog(@"%d, %lld",getImageTime.timescale,getImageTime.value);
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CGImageRef image = [gen copyCGImageAtTime:getImageTime actualTime:nil error:nil];
    
    return [UIImage imageWithCGImage:image];
}

#pragma mark showAlertController

- (void)showAlertViewController:(void (^)())callback {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Image Unsaved" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callback){
                callback();
            }
        });
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark change StatusBarStyle
- (UIStatusBarStyle) preferredStatusBarStyle {
   
   return UIStatusBarStyleLightContent;
}

#pragma mark ImageScrollView delegate

- (void)passImageToFloatView:(UIImage *)image {
   
    floatView.floatImage.image = image;
    floatView.hidden = NO;
}

- (void)closeFloatView {
   
    floatView.hidden = YES;
}

- (void)returnColor:(UIColor *)color {
   
    drawLine.pathColor = color;
}

#pragma mark colorPickerDelegate

- (void)undoDrawPath {
   
    [drawLine undo];
    imageSaveState = NO;

}

- (void)changeImage:(NSInteger)adjustSecond {
   
   //NSTimeInterval tmpTime = timeForImage;
    if(self.timeForImage + adjustSecond <= videoLengthForSecond && self.timeForImage + adjustSecond > 0){
        self.timeForImage += adjustSecond;
        imageScrollView.imageForDrawing.image = [self getImageFromURL];
        [colorPickerView setTimeLabelText:(self.timeForImage)];
    }
}

#pragma mark TitleView delegate

- (void)saveButtonClick {
   
    UIGraphicsBeginImageContextWithOptions(imageScrollView.viewForDrawing.bounds.size, YES, 0.0f);
    [imageScrollView.viewForDrawing drawViewHierarchyInRect:imageScrollView.viewForDrawing.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.frame = CGRectMake(0, 0, imageScrollView.viewForDrawing.bounds.size.width, imageScrollView.viewForDrawing.bounds.size.height);
    imageView.image =  image;
    imageSaveState = YES;
    //init date string
    NSDate *imageDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyMMdd_HH:mm:ss"];
    [formate setTimeZone:[NSTimeZone localTimeZone]];
    NSString *fileName = [[formate stringFromDate:imageDate] stringByAppendingString:@".jpg"];
    //get file path
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDIR = [[filePaths objectAtIndex:0] stringByAppendingString:@"/"];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[docDIR stringByAppendingString:fileName] atomically:YES];
    //UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
   
}

- (void)backButtonClick {
   
    if(imageSaveState == NO) {
        [self showAlertViewController:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else if(imageSaveState == YES){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    CGPoint point = [touch locationInView:self.view];
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
    CGPoint point = [touch locationInView:self.view];
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

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
    //[self touchesEnded:touches withEvent:event];
}


@end
