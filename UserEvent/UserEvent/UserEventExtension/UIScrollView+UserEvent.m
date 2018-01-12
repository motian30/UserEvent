//
//  UIScrollView+UserEvent.m
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "UIScrollView+UserEvent.h"
#import "RuntimeTool.h"
#import "UITableView+UserContent.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])


@implementation UIScrollView (UserEvent)

+ (void)load{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL originSelector = @selector(setDelegate:);
        SEL replaceSelector = @selector(replaceSetDelegate:);
        [RuntimeTool replaceForClass:[self class] Selector:originSelector replaceSelector:replaceSelector];

    });
}

- (void)replaceSetDelegate:(id<UIScrollViewDelegate>)delegate {
    
   
    
    if ([NSStringFromClass([self class]) isEqualToString:@"UITableView"]){
        if (![RuntimeTool ContainSel:GET_CLASS_CUSTOM_SEL(@selector(scrollViewWillBeginDragging:),[delegate class]) inClass:[delegate class]]) {
            [self replaceScrollViewWillBeginDragging:delegate];
        }
        
        if (![RuntimeTool ContainSel:GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[delegate class]) inClass:[delegate class]]) {
            [(UITableView *)self replace_tableViewDidSelectRowAtIndexPathForClass:delegate];
        }
    }
    [self replaceSetDelegate:delegate];
}

- (void)replaceScrollViewWillBeginDragging:(id<UIScrollViewDelegate>)delegate {
    
    [RuntimeTool class_addMethod:[delegate class]
                 selector:GET_CLASS_CUSTOM_SEL(@selector(scrollViewWillBeginDragging:),[delegate class])
                      imp:method_getImplementation(class_getInstanceMethod([self class],@selector(replace_ScrollViewWillBeginDragging:)))
                    types:"v@:@"];
    
    
    if (![RuntimeTool ContainSel:@selector(scrollViewWillBeginDragging:) inClass:[delegate class] ]) {
        [RuntimeTool class_addMethod:[delegate class]
                     selector:@selector(scrollViewWillBeginDragging:)
                          imp:nil
                        types:"v@"];
    }
    
    [RuntimeTool replaceForClass:[delegate class] Selector:@selector(scrollViewWillBeginDragging:) replaceSelector:GET_CLASS_CUSTOM_SEL(@selector(scrollViewWillBeginDragging:),[delegate class])];
   
}



- (void)replace_ScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(scrollViewWillBeginDragging:),[self class]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, sel,scrollView);
    }
}


@end
