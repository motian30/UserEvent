//
//  ViewControllerTool.m
//  demo
//
//  Created by Motian on 2018/1/11.
//  Copyright © 2018年 SH. All rights reserved.
//

#import "ViewControllerTool.h"

@implementation ViewControllerTool

+ (UIViewController *)getCurrentController{

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
  
    if (window.windowLevel != UIWindowLevelNormal){
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (int i = 0; i < windows.count; i++) {
            UIWindow * tmpWin = windows[i];
            
            if (tmpWin.windowLevel == UIWindowLevelNormal && tmpWin.subviews.count>0){
                window = tmpWin;
                break;
            }
        }
        
    }

    UIView *tempView;
    for (UIView *subview in window.subviews) {
        
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
  
        tempView = [window.subviews lastObject];
        

        
    }
    

    
    id nextResponder = [tempView nextResponder];
    
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
        
    }
    
    return  (UIViewController *)nextResponder;
    
}


@end
