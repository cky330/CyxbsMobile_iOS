//
//  FoodVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/2/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "FoodVC.h"
#import "BTCollectionViewCell.h"
#import "FootViewController.h"
#import "FoodHomeModel.h"
#import "popUpInformationVC.h"

@interface FoodVC ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

/// 头视图
@property (nonatomic, strong) UIView *topView;

/// Home数据模型
@property (nonatomic, strong) FoodHomeModel *homeModel;

/// 返回条
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FoodVC{
    NSArray <NSArray *> *_homeAry;
}

#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self addCustomTabbarView];
    //获取主页数据,成功加载主页 失败加载失败页
    [self loadHomeData];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self._getAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self._getAry[section].count;
}

//具体数据
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DemoCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    [cell.lab setText:[NSString stringWithFormat:@"%@", self._getAry[indexPath.section][indexPath.item]]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // 区头
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        UILabel *firstLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 26, 56, 20)];
        firstLab.font = [UIFont fontWithName:PingFangSCMedium size:14];
        firstLab.textColor = [UIColor colorWithHexString:@"#15315B"];
        
        UILabel *secondLab = [[UILabel alloc] initWithFrame:CGRectMake(94, 29, 60, 14)];
        secondLab.font = [UIFont fontWithName:PingFangSCMedium size:10];
        secondLab.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.4];
        
        UIImageView *remindImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提醒"]];
        remindImgView.frame = CGRectMake(78, 29.5, 11, 13);
        
        switch (indexPath.section) {
            case 0:
                firstLab.text = @"就餐区域";
                secondLab.text = @"可多选";
                break;
            case 1:
                firstLab.text = @"就餐人数";
                secondLab.text = @"仅可选择一个";
                break;
            case 2:
                firstLab.text = @"餐饮特征";
                secondLab.text = @"可多选";
                break;
            default:
                break;
        }
        
        [topView addSubview:firstLab];
        [topView addSubview:remindImgView];
        [topView addSubview:secondLab];
        return topView;
    }
    
    return nil;
}

- (void)buttonClick{
    NSLog(@"111");
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择了%ld - %ld: %@", indexPath.section, indexPath.item, self._getAry[indexPath.section][indexPath.item]);
    
    //点击向数组添加
//    if (indexPath.section == 0){
//        [self.Ary1 addObject:self._getAry[indexPath.section][indexPath.item]];
//    }
    
    //设置单选
    //只有section 1是多选
    if (indexPath.section != 1) {
        return;
    }
    NSArray<NSIndexPath*>* selectedIndexes = collectionView.indexPathsForSelectedItems;
    for (int i = 0; i < selectedIndexes.count; i++) {
        NSIndexPath* currentIndex = selectedIndexes[i];
        if (![currentIndex isEqual:indexPath] && currentIndex.section == 1) {
            [collectionView deselectItemAtIndexPath:currentIndex animated:YES];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"取消了%ld - %ld: %@", indexPath.section, indexPath.item, self._getAry[indexPath.section][indexPath.item]);
    
    //再次点击移除
//    if (indexPath.section == 0){
//        [self.Ary1 removeObject:self._getAry[indexPath.section][indexPath.item]];
//    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
// 设置每个cell的尺寸高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(74, 29);
    return size;
}

// 设置区头的尺寸高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(SCREEN_WIDTH, 58);
    return size;
}

#pragma mark - Method
- (void)loadHomeData {
    [self.homeModel requestSuccess:^{
        //加载主页数据
        [self addHomePage];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"美食主页数据获取失败");
    }];
}

- (void)addHomePage {
    //添加头视图
    [self addTopView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    //添加脚视图
    [self addFootView];
}

- (void)addTopView {
    //头视图
    self.collectionView.contentInset = UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0);
    
    CGRect originFrame = self.topView.frame;
    originFrame.origin.y = - self.topView.frame.size.height;
    self.topView.frame = originFrame;
    self.collectionView.alwaysBounceVertical=true;
    [self.collectionView addSubview:self.topView];
}

- (void)addFootView {
    FootViewController *vc = [[FootViewController alloc] init];
    vc.view.frame = CGRectMake(0, 700, SCREEN_WIDTH, 103);
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)chooseMark:(UIButton *)sender {
    BTCollectionViewCell *cell = [[BTCollectionViewCell alloc] init];
    for (NSIndexPath *a in self.collectionView.indexPathsForSelectedItems) {
        cell = (BTCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:a];
        NSLog(@"选择了%@",cell.lab.text);
    }
}

#pragma mark - 返回条
//自定义的Tabbar
- (void)addCustomTabbarView {
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    //设置阴影
    UIView *tempView = [[UIView alloc] initWithFrame:self.backgroundView.bounds];
    tempView.backgroundColor = self.backgroundView.backgroundColor;
    self.backgroundView.backgroundColor = UIColor.clearColor;
    self.backgroundView.layer.shadowRadius = 16;
    self.backgroundView.layer.shadowColor = [UIColor Light:UIColor.lightGrayColor Dark:UIColor.darkGrayColor].CGColor;
    self.backgroundView.layer.shadowOpacity = 0.7;
    
    //只切下面的圆角(利用贝塞尔曲线)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = tempView.bounds;
    shapeLayer.path = maskPath.CGPath;
    tempView.layer.mask = shapeLayer;
    [self.backgroundView insertSubview:tempView atIndex:0];

    [self.view addSubview:self.backgroundView];
    
    //addTitleView
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"美食咨询处";
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:20];
    titleLabel.textColor = [UIColor colorWithHexString:@"#112C53"];
    [self.backgroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.top.equalTo(self.view).offset(50);
    }];
    titleLabel.textColor = [UIColor colorWithHexString:@"#15315B" alpha:1];

    //添加返回按钮
    [self addBackButton];
    
    //添加说明按钮
    [self addLearnMoreButton];
}

//添加退出的按钮
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backgroundView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"空教室返回"] forState:UIControlStateNormal];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@9);
        make.height.equalTo(@19);
    }];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
}

//返回的方法
- (void) back {
     [self.navigationController popViewControllerAnimated:YES];
}

//添加查看更多的按钮
- (void)addLearnMoreButton {
    UIButton *learnMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backgroundView addSubview:learnMoreButton];
    [learnMoreButton setImage:[UIImage imageNamed:@"提醒"] forState:UIControlStateNormal];
    [learnMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@20);
        make.height.equalTo(@21);
    }];
    [learnMoreButton addTarget:self action: @selector(learnAbout) forControlEvents:UIControlEventTouchUpInside];
}

//查看更多的方法
- (void)learnAbout{
    popUpInformationVC *vc = [[popUpInformationVC alloc] init];
    vc.contentText = @"美食咨询处的设置，一是为了帮助各位选择综合症的邮子们更好的选择自己的需要的美食，对选择综合症说拜拜！二是为了各位初来学校的新生学子更好的体验学校各处的美食！按照要求通过标签进行选择，卷卷会帮助你选择最符合要求的美食哦！";
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //填充全屏(原视图不会消失)
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma mark - Lazy
- (NSArray <NSArray *> *)_getAry {
    if (!_homeAry) {
        _homeAry = @[
            self.homeModel.eat_areaAry,
            self.homeModel.eat_numAry,
            self.homeModel.eat_propertyAry
        ];
    }
    return _homeAry;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //最小列间距
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 34);
        //最小行间距
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        
        _collectionView.allowsMultipleSelection = YES;
        
        [_collectionView registerClass:BTCollectionViewCell.class forCellWithReuseIdentifier:DemoCollectionViewCellReuseIdentifier];
        // 注册区头
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.245)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_topView.frame];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.homeModel.pictureURL]];
        [_topView addSubview:imgView];
    }
    return _topView;
}

- (FoodHomeModel *)homeModel{
    if(!_homeModel) {
        _homeModel = [[FoodHomeModel alloc] init];
    }
    return _homeModel;
}

- (UIView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NVGBARHEIGHT + STATUSBARHEIGHT)];
    }
    return _backgroundView;
}

@end
