//
//  UIControl+userEvent.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "UIControl+userEvent.h"
#import "RuntimeTool.h"
#import "UserEventDataTool.h"
#import "ViewControllerTool.h"
#import "UIViewController+UserEvent.h"

@implementation UIControl (userEvent)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSelector = @selector(sendAction:to:forEvent:);
        SEL replaceSelector = @selector(replaceSendAction:to:forEvent:);
        [RuntimeTool replaceForClass:[self class] Selector:originSelector replaceSelector:replaceSelector];

    });
}

- (void)replaceSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    [self replaceSendAction:action to:target forEvent:event];
    
    if ([event allTouches].anyObject.phase == UITouchPhaseEnded) {
        
        if (![UserEventDataTool isSystemClassWith:[target class]]) {
            NSString *targetClass = NSStringFromClass([target class]);
            NSString *actionName = NSStringFromSelector(action);
            
            NSString *title = nil;
            if ([self isKindOfClass:[UIButton class]]) {
                UIButton *bt = (UIButton *)self;
                title = bt.titleLabel.text;
            }else if ([NSStringFromClass([self class]) isEqualToString:@"_UIButtonBarButton"]){
                
                for (UIView *view in self.subviews ) {
                    if ([NSStringFromClass([view class]) isEqualToString:@"_UIModernBarButton"]) {
                        UIButton *bt = (UIButton *)view;
                        title = bt.titleLabel.text;
                    }
                }
                
            }
            actionName = IsStrEmpty(title) ? actionName : title;
            
            NSMutableDictionary *datadic = [UserEventDataTool infoDictWithTarget:targetClass Action:actionName];
            
            [UserEventDataTool saveToPlistWithDictionary:[datadic copy]];
        }
        
        
    }
}


@end
