//
//  UIViewController+UserEvent.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "UIViewController+UserEvent.h"
#import "RuntimeTool.h"
#import "UserEventDataTool.h"

@implementation UIViewController (UserEvent)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL appearOriginSelector = @selector(viewDidAppear:);
        SEL appearReplaceSelector = @selector(replaceViewDidAppear:);
        [RuntimeTool replaceForClass:[self class] Selector:appearOriginSelector replaceSelector:appearReplaceSelector];
        
        SEL disAppearOriginSelector = @selector(viewWillDisappear:);
        SEL disAppearReplaceSelector = @selector(replaceViewWillDisAppear:);
        [RuntimeTool replaceForClass:[self class] Selector:disAppearOriginSelector replaceSelector:disAppearReplaceSelector];
    
    });
}

- (void)replaceViewDidAppear:(BOOL)animate{
    
    [self replaceViewDidAppear:animate];
    [self saveDataWith:YES];
    
}

- (void)replaceViewWillDisAppear:(BOOL)animate{
    
    [self replaceViewWillDisAppear:animate];
    [self saveDataWith:NO];
    
}

- (__kindof NSString *)isUserEventController{
    
    NSString *targetClass = NSStringFromClass([self class]);
    if([targetClass containsString:@"_" ]|| [targetClass containsString:@"UI"]){
        return @"";
    }

    return targetClass ;
}

- (void)saveDataWith:(BOOL )access{
    
    NSString *str = [self isUserEventController];
    
    if(!IsStrEmpty(str)){
        NSMutableDictionary *data = [UserEventDataTool infoDictWithTarget:str Action:access ? @"进入" : @"离开"];
        
        [UserEventDataTool saveToPlistWithDictionary:[data copy]];
    }
}


@end
