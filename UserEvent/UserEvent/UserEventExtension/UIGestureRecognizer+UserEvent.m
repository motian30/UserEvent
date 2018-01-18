//
//  UIGestureRecognizer+UserEvent.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "UIGestureRecognizer+UserEvent.h"
#import "RuntimeTool.h"
#import "UserEventDataTool.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

static char* CurrentAction = "CurrentAction";
static char* CurrentCls = "CurrentCls";

@implementation UIGestureRecognizer (UserEvent)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSelector = @selector(initWithTarget:action:);
        SEL replaceSelector = @selector(replaceInitWithTarget:action:);
        [RuntimeTool replaceForClass:[self class] Selector:originSelector replaceSelector:replaceSelector];

    });
}

- (instancetype)replaceInitWithTarget:(id)target action:(SEL)action{
    
    NSString *targetClass = NSStringFromClass([target class]);
    NSString *actionName = NSStringFromSelector(action);
    
    if (action && target) {
        
        if (![UserEventDataTool isSystemClassWith:[target class]]) {
            
            [RuntimeTool class_addMethod:[target class]
                                        selector:GET_CLASS_CUSTOM_SEL(action,[target class])
                                             imp:method_getImplementation(class_getInstanceMethod([self class],@selector(replaceRecogniaze:)))
                                           types:"v@:"];
            
            [RuntimeTool replaceForClass:[target class] Selector:action replaceSelector:GET_CLASS_CUSTOM_SEL(action,[target class])];
            
            self.currentAcion = actionName;
            self.currentCls = targetClass;
        }
    }

    return [self replaceInitWithTarget:target action:action];
}

- (void)replaceRecogniaze:(id)sender{
    
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    
    SEL sel = GET_CLASS_CUSTOM_SEL(NSSelectorFromString(gesture.currentAcion),[self class]);
    
    if ([self respondsToSelector:sel]) {
        ((void (*)(void *, SEL,  id ))objc_msgSend)((__bridge void *)(self), sel , sender);
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded &&  ![NSStringFromClass([self class]) containsString:@"IQKeyboardManager"]) {
        if ([UserEventDataTool infoDictWithTarget:gesture.currentCls Action:gesture.currentAcion]) {
            NSMutableDictionary *datadic = [UserEventDataTool infoDictWithTarget:gesture.currentCls Action:gesture.currentAcion];

            [UserEventDataTool saveToPlistWithDictionary:[datadic copy]];
        }
    }
}

- (NSString *)currentAcion{
    return objc_getAssociatedObject(self,CurrentAction);
}

- (void)setCurrentAcion:(NSString *)currentAcion{
    objc_setAssociatedObject(self, CurrentAction, currentAcion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)currentCls{
    return objc_getAssociatedObject(self,CurrentCls);
}

- (void)setCurrentCls:(NSString *)currentCls{
    objc_setAssociatedObject(self, CurrentCls, currentCls, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
