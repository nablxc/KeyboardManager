//
//  UIViewController+KeyboardNotice.m
//  KeyboardManager
//
//  Created by 刘星辰 on 2017/6/6.
//  Copyright © 2017年 刘星辰. All rights reserved.
//

#import "UIViewController+KeyboardNotice.h"
#import <objc/runtime.h>

NSNotificationName const kViewDidAppearNotice = @"KeyboardNotice_ViewDidAppear";
NSNotificationName const kViewWillDisappearNotice = @"KeyboardNotice_ViewWillDisappear";
NSString *const KNoticeKey = @"KeyboardNotice_NotcieKey";


@interface UIViewController()

@end

@implementation UIViewController (KeyboardNotice)

+ (void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        [UIViewController useCustomSel:@selector(swiz_viewDidAppear:) exchangeSystemSel:@selector(viewDidAppear:)];
        
        [UIViewController useCustomSel:@selector(swiz_viewWillDisappear:) exchangeSystemSel:@selector(viewWillDisappear:)];

    });
}

+ (void)useCustomSel:(SEL)swizzSel exchangeSystemSel:(SEL)systemSel
{
    Method systemMethod = class_getInstanceMethod([self class], systemSel);
    Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
    //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
    BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
    if (isAdd) {
        //如果成功，说明类中不存在这个方法的实现
        //将被交换方法的实现替换到这个并不存在的实现
        class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        //否则，交换两个方法的实现
        method_exchangeImplementations(systemMethod, swizzMethod);
    }

}
static char *isNeedLifecycleNoticeKey = "isNeedLifecycleNotice";
- (void)setIsNeedLifecycleNotice:(BOOL)isNeedLifecycleNotice
{
    objc_setAssociatedObject(self, isNeedLifecycleNoticeKey, @(isNeedLifecycleNotice), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isNeedLifecycleNotice
{
    NSNumber *number = objc_getAssociatedObject(self, isNeedLifecycleNoticeKey);
    return number.boolValue;
}


- (void)swiz_viewDidAppear:(BOOL)animated
{
    //这时候调用自己，看起来像是死循环
    //但是其实自己的实现已经被替换了
        [self swiz_viewDidAppear:animated];
    if (self.isNeedLifecycleNotice == YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kViewDidAppearNotice object:nil userInfo:@{KNoticeKey:self}];
    }
    
}

- (void)swiz_viewWillDisappear:(BOOL)animated
{
    [self swiz_viewWillDisappear:animated];
    if (self.isNeedLifecycleNotice == YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kViewWillDisappearNotice object:nil userInfo:@{KNoticeKey:self}];
    }
}




@end
