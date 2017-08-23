//
//  TestViewController.m
//  TacticalBoard
//
//  Created by 葉立誠 on 16/08/2017.
//  Copyright © 2017 葉立誠. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
	
	[self setNeedsStatusBarAppearanceUpdate];// set status bar style

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonClick:(id)sender {
    
    
    TacticalBoardController *viewController = [[TacticalBoardController alloc] init];
    viewController.timeForImage = 10;
	viewController.videoURL = @"https://www.quirksmode.org/html5/videos/big_buck_bunny.mp4";
	viewController.previousViewController = self;

    
    [self.navigationController pushViewController:viewController animated:YES];

    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
	
	return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
