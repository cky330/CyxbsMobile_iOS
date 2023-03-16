//
//  AmusementParkVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/2/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AmusementParkVC.h"
#import "foodVC.h"

@interface AmusementParkVC ()

@end

@implementation AmusementParkVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = UIColor.systemBlueColor;
    [btn setTitle:@"美食" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150,60));
    }];
}

-(void)choose{
    NSLog(@"跳转到美食");
    FoodVC * vc = [[FoodVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    //隐藏navBar,之后自定义返回键
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
