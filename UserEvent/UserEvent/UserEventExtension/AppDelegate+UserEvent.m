//
//  AppDelegate+UserEvent.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "AppDelegate+UserEvent.h"
#import "RuntimeTool.h"
#import "UserEventNetTool.h"

@implementation AppDelegate (UserEvent)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSelector = @selector(applicationDidEnterBackground:);
        SEL replaceSelector = @selector(replaceApplicationDidEnterBackground:);
        [RuntimeTool replaceForClass:[self class] Selector:originSelector replaceSelector:replaceSelector];
    });
}

- (void)replaceApplicationDidEnterBackground:(UIApplication *)application {
   
    [self replaceApplicationDidEnterBackground:application];
    [UserEventNetTool uploadUserEvents];
     
}

@end
