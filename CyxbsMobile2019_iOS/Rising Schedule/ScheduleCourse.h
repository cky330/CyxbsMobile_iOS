//
//  ScheduleCourse.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23
//  Copyright © 2022 Redrock. All rights reserved.
//

/**课表重构测试模型
 * 一节课对应的存储内容
 * 采用WCDB
 */

#import <Foundation/Foundation.h>

#import <IGListDiffable.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ScheduleCourseType;

#pragma mark - SchoolLesson

@interface ScheduleCourse : NSObject <
    IGListDiffable
>

// !!!: Time

/// 在星期几1-7
@property (nonatomic) NSInteger inWeek;

/// 所在周散列表
@property (nonatomic, copy) NSSet <NSNumber *> *inSections;

/// 存储period
@property (nonatomic) NSInteger period_location;
/// 存储period
@property (nonatomic) NSUInteger period_lenth;
/// 第几-几节课，中午为4-5，晚上为8-9
@property (nonatomic, readonly) NSRange period;

// !!!: Source

/// 学号
@property (nonatomic, copy) NSString *sno;

/// 课程名
@property (nonatomic, copy) NSString *course;
/// 课程别名（以后可能要用到）
@property (nonatomic, copy) NSString *courseNike;

/// 地点
@property (nonatomic, copy) NSString *classRoom;
/// 地点别名（以后可能要用到）
@property (nonatomic, copy) NSString *classRoomNike;

/// 课程号
@property (nonatomic, copy) NSString *courseID;

/// 循环周期
@property (nonatomic, copy) NSString *rawWeek;

/// 选修类型
@property (nonatomic, copy) ScheduleCourseType type;

/// 老师
@property (nonatomic, copy) NSString *teacher;

/// @“xx节”
@property (nonatomic, copy) NSString *lesson;

#pragma mark - Method

/// 根据字典来赋值
/// @param dic 字典（这里必须看文档，注意使用）
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

/// 必修
FOUNDATION_EXPORT ScheduleCourseType required;

/// 选修
FOUNDATION_EXPORT ScheduleCourseType elective;

/// 事务
FOUNDATION_EXPORT ScheduleCourseType transaction;

NS_ASSUME_NONNULL_END