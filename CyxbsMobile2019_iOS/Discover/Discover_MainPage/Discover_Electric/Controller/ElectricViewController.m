//
//  ElectricViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/4/12.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ElectricFeeModel.h"
#import "ElectricityView.h"
#import "ElectricViewController.h"
#import "PickerDormitoryModel.h"
#import "PickerDormitoryViewController.h"

@interface ElectricViewController () <
    ElectricityViewDelegate
    >

/// 电费View
@property (nonatomic, strong) ElectricityView *eleView;
/// 电费Model
@property (nonatomic, strong) ElectricFeeModel *elecModel;

@end

@implementation ElectricViewController

#pragma mark- life cicrle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    //只切上面的圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, 1000) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    //设置阴影
    self.view.layer.shadowOpacity = 0.33f;
    self.view.layer.shadowColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AEB6D3" alpha:0.16] darkColor:[UIColor colorWithHexString:@"#AEB6D3" alpha:0.16]].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, -5);

    [self addEleView];
    [self requestData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotifications];
}

#pragma mark - Lazy
- (ElectricityView *)eleView {
    if (!_eleView) {
        _eleView = [[ElectricityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
        _eleView.delegate = self;
    }
    return _eleView;
}

- (ElectricFeeModel *)elecModel {
    if (!_elecModel) {
        _elecModel = [[ElectricFeeModel alloc] init];
    }
    return _elecModel;
}

#pragma mark - Method
- (void)addEleView {
    [self.view addSubview:self.eleView];
}

- (void)requestData {
    [self.elecModel requestSuccess:^{
        if (self.elecModel.electricFeeItem) {
            if (self.elecModel.electricFeeItem.buildAndRoom) {
                NSString *buildAndRoom = self.elecModel.electricFeeItem.buildAndRoom;
                [UserItem defaultItem].building = [buildAndRoom substringToIndex:2];
                [UserItem defaultItem].room = [buildAndRoom substringFromIndex:3];
                NSLog(@"%@,%@", [UserItem defaultItem].building, [UserItem defaultItem].room);
                [self updateElectricFeeUI];
            } else {
                NSLog(@"可能是房间号输入错误");
                //提醒用户重新绑定
                [self bindingRoomFailed];
            }
        }
    }
    failure:^(NSError *_Nonnull error) {
        [self requestElectricFeeFailed];
    }];
}

- (void)touchElectrictyView {
    PickerDormitoryViewController *vc = [[PickerDormitoryViewController alloc] init];

    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //填充全屏(原视图不会消失)
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)bindingRoomFailed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:(MBProgressHUDModeText)];
    hud.labelText = @"绑定的宿舍号可能有问题哦，请重新绑定";
    [UserItem defaultItem].building = nil;
    [UserItem defaultItem].room = nil;
    [hud hide:YES afterDelay:1.2];
}

- (void)requestElectricFeeFailed {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setMode:(MBProgressHUDModeText)];
//    hud.labelText = @"电费查询服务器开小差了哦，请稍后重试";
//    [hud hide:YES afterDelay:1];
//    return;
//    [NewQAHud showHudWith:@"电费查询服务器开小差了哦，请稍后重试" AddView:self.view];
}

- (void)updateElectricFeeUI {
    //先写入缓存
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.money forKey:@"ElectricFee_money"];
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.degree forKey:@"ElectricFee_degree"];
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.time forKey:@"ElectricFee_time"];
    [self.eleView refreshViewIfNeeded];
    [self.eleView.electricFeeMoney setText:self.elecModel.electricFeeItem.money];
//    [self.eleView.electricFeeMoney setTitle:self.elecModel.electricFeeItem.money forState:UIControlStateNormal];
    //self.eleView.electricFeeDegree.text = self.elecModel.electricFeeItem.degree;
    //这里读缓存以后日期的样式就改回去了，所以先屏蔽
}

#pragma mark - 通知中心
/// 添加通知中心
- (void)addNotifications {
    //绑定成功后重新请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"electricFeeRoomChange" object:nil];
}

//移除通知中心
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"electricFeeRoomChange" object:nil];
}

@end
