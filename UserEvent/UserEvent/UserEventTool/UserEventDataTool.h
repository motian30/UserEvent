//
//  UserEventDataTool.h
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

#import <Foundation/Foundation.h>

@interface UserEventDataTool : NSObject

+ (__kindof NSDictionary *)configFromUserEventPlist;

+ (void)saveToPlistWithDictionary:(__kindof NSDictionary*)data;

+ (__kindof NSArray *)readDataFromUserEventPlist;

+ (void)removeDataFromUserEventPlist;

+ (NSMutableDictionary *)infoDictWithTarget:(NSString *)targetStr Action:(NSString *)actionStr;

+ (BOOL )isSystemClassWith:(Class)cls;

@end
