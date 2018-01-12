//
//  RuntimeTool.h
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface RuntimeTool : NSObject

+ (void)replaceForClass:(Class)forClass Selector:(SEL)selector replaceSelector:(SEL)replaceSelector;

+ (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types;

+ (BOOL)ContainSel:(SEL)sel inClass:(Class)class;

+ (IMP)method_getImplementation:(Method)method;

+ (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector;




@end
