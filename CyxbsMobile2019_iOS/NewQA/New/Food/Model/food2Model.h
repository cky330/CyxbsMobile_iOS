//
//  food2Model.h
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/1/25.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface food2Model : NSObject
//状态码
@property (nonatomic, assign) NSInteger status;

///data中包含的
//餐饮特征，返回数量固定八个
@property (nonatomic, copy) NSArray* eat_propertyAry;

- (void)geteat_area:(NSArray*)eat_areaArr geteat_num:(NSArray*)eat_numArr requestSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
