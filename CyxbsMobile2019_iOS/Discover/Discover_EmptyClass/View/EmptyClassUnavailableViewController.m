//
//  EmptyClassUnavailableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/11/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "EmptyClassUnavailableViewController.h"

@interface EmptyClassUnavailableViewController ()

@end

@implementation EmptyClassUnavailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    
}

- (void)setupBar{
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    self.VCTitleStr = @"空教室";
    self.topBarView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    self.splitLineColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E4E4E9" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2B2E" alpha:1]];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}

@end