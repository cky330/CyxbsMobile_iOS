//
//  MineQAController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAController.h"
#import "MineSegmentedView.h"
#import "MineQATableViewController.h"

@interface MineQAController ()

@end

@implementation MineQAController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    
    MineQATableViewController *vc1 = [[MineQATableViewController alloc] init];
    if (@available(iOS 11.0, *)) {
        vc1.tableView.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
    } else {
        // Fallback on earlier versions
    }
    vc1.title = @"已发布";
    
    MineQATableViewController *vc2 = [[MineQATableViewController alloc] init];
    if (@available(iOS 11.0, *)) {
        vc1.tableView.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
    } else {
        // Fallback on earlier versions
    }
    vc2.title = @"草稿箱";
    NSArray *arr = @[vc1, vc2];
    
    
    
    MineSegmentedView *segmentedView = [[MineSegmentedView alloc] initWithChildViewControllers:arr];
    segmentedView.frame = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        segmentedView.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:segmentedView];
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, TOTAL_TOP_HEIGHT)];
    if (@available(iOS 11.0, *)) {
        navigationBar.backgroundColor = [UIColor colorNamed:@"Mine_QA_HeaderBarColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MAIN_SCREEN_W - 85) / 2.0, 7 + STATUSBARHEIGHT, 85, 30)];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 21];
    if (@available(iOS 11.0, *)) {
        titleLabel.textColor = [UIColor colorNamed:@"Mine_QA_TitleLabelColor"];
    } else {
        // Fallback on earlier versions
    }
    [navigationBar addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(17, 12.5 + STATUSBARHEIGHT, 9, 19);
    backButton.backgroundColor = [UIColor blueColor];
    [navigationBar addSubview:backButton];
}

@end
