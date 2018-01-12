//
//  UIGestureRecognizer+UserEvent.h
//  demo
//
//  Created by Motian on 2018/1/8.
//  Copyright © 2018年 SH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (UserEvent)

@property (nonatomic, copy) NSString *currentAcion;
@property (nonatomic, copy) NSString *currentCls;

@end
