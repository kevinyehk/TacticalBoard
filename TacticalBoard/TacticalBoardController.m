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
NSInteger videoLengthForSecond;
BOOL imageSaveState = YES;

@implementation TacticalBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"https://www.ebookfrenzy.com/ios_book/movie/movie.mov"]];
//    AVPlayerViewController *playerController = [AVPlayerViewController new];
//    playerController.showsPlaybackControls = false;
//    playerController.player = self.player;
//    [self addChildViewController:playerController];
//    [self.view1 addSubview:playerController.view];
//    playerController.view.frame = self.view1.frame;
    //[self.player play];
    
    
//    [ self.path moveToPoint:CGPointMake(10.0, 10.0)];
//    [ self.path addLineToPoint:CGPointMake(100.0, 100.0)];
    
    
    //UIview for drawing section
   self.view.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    
//   UIImageView *imageViewForDrawing = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.subViewForDraw.frame.size.width, self.subViewForDraw.frame.size.height)];
//   imageViewForDrawing.image = [UIImage imageNamed:@"soccer.jpg"];
//   
//   [self.subViewForDraw addSubview:imageViewForDrawing];
//   self.custom = [[DrawLine alloc]initWithFrame:CGRectMake(0, 0, self.subViewForDraw.frame.size.width, self.subViewForDraw.frame.size.height)];
//   [self.subViewForDraw addSubview:self.custom];
//   self.custom.pathWidth = self.pathWidthSlider.value;
//   self.sliderValueLabel.text = [NSString stringWithFormat:@"%.1f",self.pathWidthSlider.value];
//   //[self createColorBord];
//   self.scrollView.delegate = self;
//   self.scrollView.minimumZoomScale = 1.0;
//   self.scrollView.maximumZoomScale = 4.0;
//   self.scrollView.zoomScale = 1.0;
//   self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
//   self.scrollView.hidden = YES;
   
   self.timeForImage = 25;
   self.videoURL = @"https://www.quirksmode.org/html5/videos/big_buck_bunny.mp4";
   

   //scrollview
   self.drawLine = [[DrawLine alloc]initWithFrame:CGRectMake(0, 0, 1024, 415)];
   self.drawLine.startedDraw = ^{
      imageSaveState = NO;
   };
   self.imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 177, 1024, 415)];
   [self.view addSubview:self.imageScrollView];
   self.imageScrollView.imageForDrawing.image = [self getImageFromURL];
   [self.imageScrollView.viewForDrawing addSubview:self.drawLine];
   self.imageScrollView.delegate = self;
   
   
   //floatview
   floatView = [[FloatView alloc] initWithFrame:CGRectMake(0, 20, 360, 145)];
   [self.view addSubview:floatView];
   floatView.hidden = YES;

   
   //colorpicker
   colorPickerView = [[ColorPickerView alloc]initWithFrame:CGRectMake(0, 688, 1024, 80)];
   [self.view addSubview:colorPickerView];
   colorPickerView.delegate = self;
   colorPickerView.colorOnChange = ^(UIColor *color) {
      self.drawLine.pathColor = color;
   };
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
   //AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"big_buck_bunny" withExtension:@"mp4"] options:nil];
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
   
   [self.drawLine undo];
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
            [self.drawLine clear];
            imageSaveState = NO;

         }];
      }
      else {
         self.timeForImage += adjustSecond;
         self.imageScrollView.imageForDrawing.image = [self getImageFromURL];
         [colorPickerView setTimeLabelText:(self.timeForImage)];
         [self.drawLine clear];
         imageSaveState = NO;
         
      }
   }
}

- (void)saveButtonClick {
   
   UIGraphicsBeginImageContextWithOptions(self.imageScrollView.viewForDrawing.bounds.size, YES, 0.0f);
   [self.imageScrollView.viewForDrawing drawViewHierarchyInRect:self.imageScrollView.viewForDrawing.bounds afterScreenUpdates:NO];
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   self.imageView.frame = CGRectMake(0, 0, self.imageScrollView.viewForDrawing.bounds.size.width, self.imageScrollView.viewForDrawing.bounds.size.height);
   self.imageView.image =  image;
   imageSaveState = YES;
   //init date string
   NSDate *imageDate = [NSDate date];
   NSDateFormatter *formate = [[NSDateFormatter alloc] init];
   [formate setDateFormat:@"yyMMdd_HH:mm:ss"];
   [formate setTimeZone:[NSTimeZone localTimeZone]];
   NSString *fileName = [[formate stringFromDate:imageDate] stringByAppendingString:@".jpg"];
   NSLog(@"%@",[formate stringFromDate:imageDate]);
   //get file path
   NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *docDIR = [[filePaths objectAtIndex:0] stringByAppendingString:@"/"];
   NSLog(@"%@",docDIR);
   [UIImageJPEGRepresentation(image, 1.0) writeToFile:[docDIR stringByAppendingString:fileName] atomically:YES];
   //UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
   
}

- (void)backButtonClick {
   
   if(imageSaveState == NO) {
      [self showAlertViewController:^{
      }];
   }
   [self.navigationController popToViewController:self.previousViewController animated:YES];
   
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
