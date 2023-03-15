//
//  food3Model.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/1/25.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "food3Model.h"

@implementation food3Model

- (void)geteat_area_num_prop:(NSArray *)eat_areaArr geteat_num:(NSArray *)eat_numArr geteat_prop:(NSArray *)eat_propertyArr requestSuccess:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure{
    
    NSDictionary *paramters = @{
        @"eat_area":eat_areaArr,
        @"eat_num":eat_numArr,
        @"eat_property":eat_propertyArr
    };
    
    [HttpTool.shareTool
     request:Discover_GET_GPA_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:paramters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"🟢%@:\n%@", self.class, object);
        self.status = [object[@"status"] intValue];
        if (self.status == 10000) {
            NSDictionary *data = object[@"data"];
            self.name = [data[@"name"] stringValue];
            self.pictureURL = [data[@"picture"] stringValue];
            self.introduce = [data[@"introduce"] stringValue];
            self.praise_num = [data[@"praise_num"] intValue];
            self.praise_is = [data[@"praise_is"] boolValue];
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
