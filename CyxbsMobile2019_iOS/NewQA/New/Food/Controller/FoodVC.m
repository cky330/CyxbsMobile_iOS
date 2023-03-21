//
//  FoodVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/2/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "FoodVC.h"
#import "FoodMainPageCollectionViewCell.h"
#import "FootViewController.h"
#import "FoodHomeModel.h"
#import "popUpInformationVC.h"
#import "FoodRefreshModel.h"
#import "FoodHeaderCollectionReusableView.h"

#define SLIDING_HEIGHT 600

@interface FoodVC ()<
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

//背景滚动
@property (nonatomic, strong) UIScrollView *scrollContentView;
@property (nonatomic, strong) FootViewController *footVC;

/// 头视图
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UICollectionView *collectionView;
/// Home数据模型
@property (nonatomic, strong) FoodHomeModel *homeModel;

/// 返回条
@property (nonatomic, strong) UIView *goBackView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FoodVC{
    NSMutableArray <NSArray *> *_homeMary;
}

#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self addContentView];
    [self addCustomTabbarView];
    //获取主页数据,成功加载主页 失败加载失败页
    [self loadHomeData];
    
}

- (void)addContentView {
    [self.view addSubview:self.scrollContentView];
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
    FoodMainPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FoodMainPageCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    [cell.lab setText:[NSString stringWithFormat:@"%@", self._getAry[indexPath.section][indexPath.item]]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    // 区头
    if (kind == UICollectionElementKindSectionHeader) {
        FoodHeaderCollectionReusableView *headerView = (FoodHeaderCollectionReusableView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
                headerView.titleText = @"就餐区域";
                headerView.otherText = @"可多选";
                headerView.refreshBtn.hidden = YES;
                break;
            case 1:
                headerView.titleText = @"就餐人数";
                headerView.otherText = @"仅可选择一个";
                headerView.refreshBtn.hidden = YES;
                break;
            case 2:
                headerView.titleText = @"餐饮特征";
                headerView.otherText = @"可多选";
                headerView.refreshBtn.hidden = NO;
                [headerView.refreshBtn addTarget:self action: @selector(refresh) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        reusableView = headerView;
        return reusableView;
    }
    return nil;
}

- (void)buttonClick {
    NSLog(@"111");
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择了%ld - %ld: %@", indexPath.section, indexPath.item, self._getAry[indexPath.section][indexPath.item]);

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
    //添加主要数据
    [self.scrollContentView addSubview:self.collectionView];
    //添加脚视图
    [self addFootView];
    //将返回条移至最前
    [self.view bringSubviewToFront:self.goBackView];
    [self layoutSubviews];
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
    self.footVC = vc;
    [self addChildViewController:self.footVC];
    [self.scrollContentView addSubview:self.footVC.view];
}

- (void)layoutSubviews {
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goBackView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    //设置为真实高度
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollContentView).offset(24);
        make.height.equalTo(@(self.collectionView.collectionViewLayout.collectionViewContentSize.height + self.topView.frame.size.height));
        make.width.equalTo(self.view);
    }];
    
    [self.footVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.self.collectionView.mas_bottom).offset(51);
        make.height.equalTo(@120);
    }];
    
}

- (void)chooseMark:(UIButton *)sender {
    FoodMainPageCollectionViewCell *cell = [[FoodMainPageCollectionViewCell alloc] init];
    for (NSIndexPath *a in self.collectionView.indexPathsForSelectedItems) {
        cell = (FoodMainPageCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:a];
        switch (a.section) {
            case 0:
                NSLog(@"第一行选择了%@",cell.lab.text);
                break;
            case 1:
                NSLog(@"第二份选择了%@",cell.lab.text);
                break;
            case 2:
                NSLog(@"第三选择了%@",cell.lab.text);
                break;
            default:
                break;
        }
        NSLog(@"选择了%@",cell.lab.text);
    }
}

- (void)getSelection {
    
}

- (void)refresh {
    NSMutableArray *areaMarry = [[NSMutableArray alloc] init];
    NSMutableArray *numMarry = [[NSMutableArray alloc] init];
    
    FoodMainPageCollectionViewCell *cell = [[FoodMainPageCollectionViewCell alloc] init];
    for (NSIndexPath *a in self.collectionView.indexPathsForSelectedItems) {
        cell = (FoodMainPageCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:a];
        switch (a.section) {
            case 0:
                NSLog(@"第一行选择了%@",cell.lab.text);
                [areaMarry addObject:cell.lab.text];
                break;
            case 1:
                NSLog(@"第二份选择了%@",cell.lab.text);
                [numMarry addObject:cell.lab.text];
                break;
            default:
                break;
        }
    }
    
    FoodRefreshModel *refreshModel = [[FoodRefreshModel alloc] init];
    [refreshModel geteat_area:areaMarry geteat_num:numMarry requestSuccess:^{
        [self._getAry removeLastObject];
        [self._getAry addObject:refreshModel.eat_propertyAry];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.collectionView reloadSections:indexSet];
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"美食特征刷新失败");
    }];
}

#pragma mark - 自定义返回条
//自定义的Tabbar
- (void)addCustomTabbarView {
    
    self.goBackView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    //设置阴影
    UIView *tempView = [[UIView alloc] initWithFrame:self.goBackView.bounds];
    tempView.backgroundColor = self.goBackView.backgroundColor;
    self.goBackView.backgroundColor = UIColor.clearColor;
    self.goBackView.layer.shadowRadius = 8;
    self.goBackView.layer.shadowColor = [UIColor Light:UIColor.lightGrayColor Dark:UIColor.darkGrayColor].CGColor;
    self.goBackView.layer.shadowOpacity = 0.3;
    
    //只切下面的圆角(利用贝塞尔曲线)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.goBackView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = tempView.bounds;
    shapeLayer.path = maskPath.CGPath;
    tempView.layer.mask = shapeLayer;
    [self.goBackView insertSubview:tempView atIndex:0];

    [self.view addSubview:self.goBackView];
    
    //addTitleView
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"美食咨询处";
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:20];
    titleLabel.textColor = [UIColor colorWithHexString:@"#112C53"];
    self.titleLabel = titleLabel;
    [self.goBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.top.equalTo(self.goBackView).offset(NVGBARHEIGHT/2 + STATUSBARHEIGHT);
    }];
    titleLabel.textColor = [UIColor colorWithHexString:@"#15315B" alpha:1];

    //添加返回按钮
    [self addBackButton];
    
    //添加说明按钮
    [self addLearnMoreButton];
}

//添加退出的按钮
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goBackView addSubview:backButton];
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
    UIButton *learnMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goBackView addSubview:learnMoreButton];
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
- (void)learnAbout {
    popUpInformationVC *vc = [[popUpInformationVC alloc] init];
    vc.contentText = @"美食咨询处的设置，一是为了帮助\n各位选择综合症的邮子们更好的选\n择自己的需要的美食，对选择综合\n症说拜拜！二是为了各位初来学校\n的新生学子更好的体验学校各处的\n美食！按照要求通过标签进行选\n择，卷卷会帮助你选择最符合要求\n的美食哦！";
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //填充全屏(原视图不会消失)
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma mark - Lazy
- (NSMutableArray <NSArray *> *)_getAry {
    if (!_homeMary) {
        _homeMary = [[NSMutableArray alloc] initWithArray:@[
            self.homeModel.eat_areaAry,
            self.homeModel.eat_numAry,
            self.homeModel.eat_propertyAry
        ]];
    }
    return _homeMary;
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
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.allowsMultipleSelection = YES;
        
        [_collectionView registerClass:FoodMainPageCollectionViewCell.class forCellWithReuseIdentifier:FoodMainPageCollectionViewCellReuseIdentifier];
        // 注册区头
        [_collectionView registerClass:[FoodHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 45, (SCREEN_WIDTH - 45) * 0.2789)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_topView.bounds];
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

- (UIView *)goBackView {
    if(!_goBackView) {
        _goBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.15)];
    }
    return _goBackView;
}

- (UIScrollView *)scrollContentView {
    if(!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        _scrollContentView.delegate = self;
        _scrollContentView.backgroundColor = UIColor.whiteColor;
        _scrollContentView.showsVerticalScrollIndicator = NO;
        _scrollContentView.alwaysBounceVertical = YES;
        self.scrollContentView.contentSize = CGSizeMake(SCREEN_WIDTH, SLIDING_HEIGHT);
    }
    return _scrollContentView;
}

@end
