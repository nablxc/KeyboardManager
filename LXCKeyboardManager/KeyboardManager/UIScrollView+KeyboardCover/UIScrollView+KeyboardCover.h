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
 绑定方法 默认开启键盘触摸消失 ps:只用调用这一个方法
 方法一定要视图添加到VC上后调用
 */
- (void)automaticSolveKeyboardCover;


/**
 绑定方法 带键盘显示弹出block 已经集成好动画
  方法一定要视图添加到VC上后调用
 */
- (void)automaticSolveKeyboardCoverWithBlock:(__KeyboardBlock)keyboardBlock;


@property (nonatomic,copy)__KeyboardBlock keyboardBlock;

@end
