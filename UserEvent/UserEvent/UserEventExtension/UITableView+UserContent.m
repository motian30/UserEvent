//
//  UITableView+UserContent.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "UITableView+UserContent.h"
#import "RuntimeTool.h"
#import "UserEventDataTool.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation UITableView (UserContent)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSel = @selector(setDelegate:);
        SEL replaceSel = @selector(replaceSetDeleagete:);
        
        [RuntimeTool replaceForClass:[self class] Selector:originSel replaceSelector:replaceSel];
        
    });
}

- (void)replaceSetDeleagete:(id<UIScrollViewDelegate>)delegate {
    
    [self replaceSetDeleagete:delegate];
    
    if (![RuntimeTool ContainSel:GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[delegate class]) inClass:[delegate class]]) {
        [(UITableView *)self replace_tableViewDidSelectRowAtIndexPathForClass:delegate];
    }
}

- (void)replace_tableViewDidSelectRowAtIndexPathForClass:(id)object {
    
    SEL sel = @selector(tableView:didSelectRowAtIndexPath:);
    
    [RuntimeTool class_addMethod:[object class]
                 selector:GET_CLASS_CUSTOM_SEL(sel,[object class])
                      imp:method_getImplementation(class_getInstanceMethod([self class],@selector(replace_tableView:didSelectRowAtIndexPath:)))
                    types:"v@:@@"];
    
    if (![RuntimeTool ContainSel:sel inClass:[object class] ]) {
        [RuntimeTool class_addMethod:[object class]
                     selector:sel
                          imp:nil
                        types:"v@:@@"];
    }
    
    [RuntimeTool replaceForClass:[object class] Selector:sel replaceSelector:GET_CLASS_CUSTOM_SEL(sel,[object class])];
}

- (void)replace_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[self class]);
    
    if ([self respondsToSelector:sel]) {
        ((void (*)(void *, SEL,  id ,id ))objc_msgSend)((__bridge void *)(self), sel , tableView,indexPath);
    }
    
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *title = selectCell.textLabel.text;
    
    NSMutableDictionary *datadic = [UserEventDataTool infoDictWithTarget:NSStringFromClass([self class]) Action:IsStrEmpty(title) ? @"Cell点击" : title];
    
    [UserEventDataTool saveToPlistWithDictionary:[datadic copy]];
    
}

@end
