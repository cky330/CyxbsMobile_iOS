//
//  SZHSearchEndCv.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 搜索结果页，主要是知识库、搜索结果table
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZHSearchEndCv : UIViewController
/// 相关动态列表的数据源数组
@property (nonatomic, strong) NSArray *tableDataAry;

/// 重邮知识库的内容数组
@property (nonatomic, strong) NSArray *knowlegeAry;

/// 搜索的文字
@property (nonatomic, copy) NSString *searchStr;
@end

NS_ASSUME_NONNULL_END
