//
//  UserEventDataTool.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//
#define ConfigPlist @"KPTUserEvents"
#define DataPlist @"UserEventData1.plist"

#import "UserEventDataTool.h"
#import "ViewControllerTool.h"

@implementation UserEventDataTool

+ (__kindof NSDictionary *)configFromUserEventPlist{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:ConfigPlist ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dic;
}

+ (void)saveToPlistWithDictionary:(__kindof NSDictionary *)data{
    
    NSString *plistPath = [self plistPath];
    
    NSMutableArray *originArr = [self readDataFromUserEventPlist];

    if (IsArrEmpty(originArr)) {
        originArr = [NSMutableArray array];
    }
    [originArr addObject:data];
    [originArr writeToFile:plistPath atomically:YES];
    
    
    NSLog(@"UserEventData.plist whrite --- %@ ",data);
    
}

+ (__kindof  NSArray *)readDataFromUserEventPlist{
    
    NSString *plistPath = [self plistPath];
    NSArray *data = [NSArray arrayWithContentsOfFile:plistPath];
    
    //NSLog(@"UserEventData.plist read --- %@",data);
    return data;
}

+ (void)removeDataFromUserEventPlist{
    
    NSString *plistPath = [self plistPath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager removeItemAtPath:plistPath error:nil]) {
        NSLog(@" UserEventData.plist remove success --- ");
    }
}

+ (__kindof NSString*)plistPath{
    
    NSArray *sandboxpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:DataPlist];
    return plistPath;
}

+ (NSMutableDictionary *)infoDictWithTarget:(NSString *)targetStr Action:(NSString *)actionStr{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
  
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"],@"UserName",currentDateString,@"LocalDateTime",nil];
    
    UIViewController * controller = [ViewControllerTool getCurrentController];
    
    NSString *LoggerName = nil;
    if (controller == nil) {
        LoggerName = [NSString stringWithFormat:@"%@ - %@",targetStr,targetStr];
    }else{
        LoggerName = [NSString stringWithFormat:@"%@ - %@",IsStrEmpty(controller.title) ? NSStringFromClass([controller class]) : controller.title,targetStr];
    }
    
    
    
    [dic setObject:LoggerName forKey:@"LoggerName"];
    [dic setObject:actionStr forKey:@"LogMessage"];
    
    return dic;
}

+ (BOOL )isSystemClassWith:(Class)cls{
    NSBundle *mainB = [NSBundle bundleForClass:[cls class]];
    if (mainB == [NSBundle mainBundle]) {
        return NO;
    }else{
        return YES;
    }

}


@end
