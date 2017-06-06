//
//  UIScrollView+KeyboardCover.h
//  textview
//
//  Created by 刘星辰 on 2016/12/1.
//  Copyright © 2016年 刘星辰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^__KeyboardBlock)(BOOL isShow,CGRect frame);

@interface UIScrollView (KeyboardCover)

/**
 绑定方法 默认开启键盘触摸消失
 */
- (void)automaticSolveKeyboardCover;


/**
 键盘默认触摸模式
 */
- (void)defaultKeyboardDismissMode;

/**
 添加通知
 */
- (void)addNotification;


/**
 移除通知
 */
- (void)removeNotification;

@property (nonatomic,copy)__KeyboardBlock keyboardBlock;

@end
