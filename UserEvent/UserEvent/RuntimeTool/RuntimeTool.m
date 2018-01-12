//
//  RuntimeTool.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "RuntimeTool.h"


@implementation RuntimeTool
+ (void)replaceForClass:(Class)forClass Selector:(SEL)selector replaceSelector:(SEL)replaceSelector{
    
    Class class = forClass;
    
    
    Method method = class_getInstanceMethod(class, selector);
    Method replaceMethod = class_getInstanceMethod(class, replaceSelector);
    
    if (class_addMethod(class,
                        selector,
                        method_getImplementation(replaceMethod),
                        method_getTypeEncoding(replaceMethod))) {
        class_replaceMethod(class,
                            replaceSelector,
                            method_getImplementation(method),
                            method_getTypeEncoding(method));
        
    }else{
        method_exchangeImplementations(method, replaceMethod);
    }
    
}

+ (BOOL)ContainSel:(SEL)sel inClass:(Class)class{
    
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types{
    return class_addMethod(class,selector,imp,types);
}


+ (IMP)method_getImplementation:(Method)method {
    return method_getImplementation(method);
}

+ (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector {
    return class_getInstanceMethod(class, selector);
}

@end
