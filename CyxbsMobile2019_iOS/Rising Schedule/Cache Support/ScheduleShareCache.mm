//
//  ScheduleShareCache.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/22.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleShareCache.h"

#import "CyxbsWidgetSupport.h"

#pragma mark - ScheduleShareCache ()

@interface ScheduleShareCache () <NSCacheDelegate>

@property (nonatomic, strong) NSCache <NSString *, ScheduleCombineItem *> *cache;

@end

#pragma mark - ScheduleShareCache

@implementation ScheduleShareCache

RisingSingleClass_IMPLEMENTATION(Cache)

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
        self.cache.countLimit = 10;
        self.cache.delegate = self;
    }
    return self;
}

#pragma mark - Method

- (void)cacheItem:(ScheduleCombineItem *)item {
    [self.cache setObject:item forKey:item.identifier.key];
}

- (ScheduleCombineItem *)getItemForKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

#pragma mark - <NSCacheDelegate>

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"课表cache将移除:\n%@", obj);
}

@end





#pragma mark - WCDB版

#import "ScheduleCourse+WCTTableCoding.h"

#import "ScheduleIdentifier+WCTTableCoding.h"

@implementation ScheduleShareCache (XXHB)

- (void)setAwakeable:(BOOL)awakeable {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    [userDefaults setBool:awakeable forKey:@"ScheduleShareCache_awakeable"];
}

- (BOOL)awakeable {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    return [userDefaults boolForKey:@"ScheduleShareCache_awakeable"];
}

#ifdef WCDB_h

- (WCTDatabase *)DB {
    static WCTDatabase *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:CyxbsWidgetAppGroups];
        NSString *path1 = [url URLByAppendingPathComponent:@"schedule_WCDB"].path;
        db = [[WCTDatabase alloc] initWithPath:path1];
        [db createTableAndIndexesOfName:@"Cyxbs_key" withClass:ScheduleIdentifier.class];
    });
    return db;
}

- (void)replaceForKey:(NSString *)key {
    ScheduleCombineItem *item = [self.cache objectForKey:key];
    if (!item) {
        NSLog(@"Use -cacheItem: before");
        return;
    }
    if (![self.DB isTableExists:key]) {
        [self.DB createTableAndIndexesOfName:key withClass:ScheduleCourse.class];
    }
    [self.DB deleteAllObjectsFromTable:key];
    [self.DB insertObjects:item.value into:key];
    [self.DB insertOrReplaceObject:item.identifier into:@"Cyxbs_key"];
}

- (ScheduleCombineItem *)awakeForIdentifier:(ScheduleIdentifier *)identifier {
    if (![self.DB isTableExists:identifier.key]) {
        return nil;
    }
    ScheduleIdentifier *idl = [self.DB getObjectsOfClass:ScheduleIdentifier.class fromTable:@"Cyxbs_key" where:ScheduleIdentifier.sno == identifier.sno && ScheduleIdentifier.type == identifier.type].lastObject;
    NSArray *value = [self.DB getAllObjectsOfClass:ScheduleCourse.class fromTable:identifier.key];
    ScheduleCombineItem *item = [ScheduleCombineItem combineItemWithIdentifier:idl value:value];
    return item;
}

#else // MARK: - Archiver版

- (NSString *(^)(NSString *key))fileBy {
    NSURL *url = [NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:CyxbsWidgetAppGroups];
    NSString *base = [url URLByAppendingPathComponent:@"schedule_Archiver/"].path;
    return ^NSString *(NSString *key) {
        return [base stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", key]];
    };
}

- (void)replaceForKey:(NSString *)key {
    ScheduleCombineItem *item = [self.cache objectForKey:key];
    if (!item) {
        NSLog(@"Use -cacheItem: before");
        return;
    }
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
    [archiver encodeObject:item.value forKey:key];
    [archiver finishEncoding];
    [archiver.encodedData writeToFile:self.fileBy(key) atomically:YES];
    
    NSMutableData *keyData = [NSData dataWithContentsOfFile:self.fileBy(@"key")].mutableCopy;
    keyData ?: keyData = NSMutableData.data;
    [keyData appendData:[NSKeyedArchiver archivedDataWithRootObject:item.identifier]];
    [keyData writeToFile:self.fileBy(key) atomically:YES];
}

- (ScheduleCombineItem *)awakeForIdentifier:(ScheduleIdentifier *)identifier {
    NSData *data = [NSData dataWithContentsOfFile:self.fileBy(identifier.key)];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *value = [unarchiver decodeObjectOfClass:NSArray.class forKey:identifier.key];
    ScheduleCombineItem *item = [ScheduleCombineItem combineItemWithIdentifier:identifier.copy value:value];
    return item;
}

#endif

@end