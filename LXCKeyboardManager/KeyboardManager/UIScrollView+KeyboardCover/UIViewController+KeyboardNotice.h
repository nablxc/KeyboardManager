//
//  UIViewController+KeyboardNotice.h
//  KeyboardManager
//
//  Created by 刘星辰 on 2017/6/6.
//  Copyright © 2017年 刘星辰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  */
extern NSNotificationName const  kViewDidAppearNotice;
extern NSNotificationName const kViewWillDisappearNotice;
extern NSString *const KNoticeKey;


@interface UIViewController (KeyboardNotice)

/**
 是否需要发通知 优化操作,让系统只发一次通知
 */
@property (nonatomic,assign)BOOL isNeedLifecycleNotice;

@end
