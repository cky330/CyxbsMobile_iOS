//
//  FoodResultModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/3/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "FoodResultModel.h"
#import "FoodHeader.h"

@implementation FoodResultModel

- (void)getEat_area:(NSArray *)eat_areaArr getEat_num:(NSString *)eat_numArr getEat_property:(NSArray *)eat_propertyArr requestSuccess:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure{
    
    NSDictionary *paramters = @{
        @"eat_area":eat_areaArr,
        @"eat_num":eat_numArr,
        @"eat_property":eat_propertyArr
    };
    
    [HttpTool.shareTool
     request:NewQA_POST_FoodResult_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:paramters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"🟢%@:\n%@", self.class, object);
        self.status = [object[@"status"] intValue];
        if (self.status == 10000) {
//            "data": [
//                   {
//                       "Picture": "https://www.baidu.com/img/bd_logo1.png",
//                       "Introduce": "在校内为数不多拥有烧烤风味的食物！",
//                       "PraiseNum": 111,
//                       "FoodName": "千喜鹤烤盘饭",
//                       "PraiseIs": false
//                   }
//               ]
            //数组<里面全是字典>
            NSArray <NSDictionary *> *data = object[@"data"];
            NSMutableArray <FoodResultModel *> *ma = NSMutableArray.array;
            for (NSDictionary *a in data) {
                FoodResultModel *result = [[FoodResultModel alloc] init];
                result.name = [a[@"FoodName"] stringValue];
                result.pictureURL = [a[@"Picture"] stringValue];
                result.introduce = [a[@"Introduce"] stringValue];
                result.praise_num = [a[@"PraiseNum"] intValue];
                result.praise_is = [a[@"Praisels"] boolValue];
                [ma addObject:result];
            }
            self.dataArr = ma.copy;
        }
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"🔴%@:\n%@", self.class, error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
