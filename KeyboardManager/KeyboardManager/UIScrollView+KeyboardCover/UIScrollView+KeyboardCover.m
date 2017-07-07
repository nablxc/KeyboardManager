//
//  UIScrollView+KeyboardCover.m
//  textview
//
//  Created by 刘星辰 on 2016/12/1.
//  Copyright © 2016年 刘星辰. All rights reserved.
//

#import "UIScrollView+KeyboardCover.h"
#import <objc/runtime.h>
#import "UIViewController+KeyboardNotice.h"

static const NSInteger for_I = 10;


@interface UIScrollView()

@property (nonatomic,assign)CGRect oldFrame;

@end

@implementation UIScrollView (KeyboardCover)
static char *oldFrameKey = "oldFrameKey";
- (void)setOldFrame:(CGRect)oldFrame
{
    NSValue *value = [NSValue valueWithCGRect:oldFrame];
    objc_setAssociatedObject(self, oldFrameKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)oldFrame{
    
    NSValue *value = objc_getAssociatedObject(self, oldFrameKey);
    CGRect oldFrame = [value CGRectValue];
    return oldFrame;
}

static char *keyboardBlockKey = "keyboardBlockKey";
- (void)setKeyboardBlock:(__KeyboardBlock)keyboardBlock
{
     objc_setAssociatedObject(self, keyboardBlockKey, keyboardBlock, OBJC_ASSOCIATION_COPY);
}
- (__KeyboardBlock)keyboardBlock
{
    return objc_getAssociatedObject(self,keyboardBlockKey);
}

#pragma mark 捆绑方法
- (void)automaticSolveKeyboardCover
{
    
    [self bindHandle];
}
#pragma mark 捆绑方法 带键盘弹出的block
- (void)automaticSolveKeyboardCoverWithBlock:(__KeyboardBlock)keyboardBlock
{
    self.keyboardBlock = keyboardBlock;
    
    [self bindHandle];
}

#pragma mark 绑定的方法
- (void)bindHandle
{
    self.oldFrame = self.frame;
    
    [self postBindSuccessNotice];
    
    [self addViewControllerCycleNotice];
    
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark 接收视图控制器生命周期的通知
- (void)addViewControllerCycleNotice
{
    [self removeNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerViewDidAppear:) name:kViewDidAppearNotice object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerViewWiilDisappear:) name:kViewWillDisappearNotice object:nil];
    
}
//视图已经显示
- (void)viewControllerViewDidAppear:(NSNotification *)notification
{
    if ([self viewController] == notification.userInfo[KNoticeKey])
    {
        [self addKeyboardNotification];
    }
}
//视图即将消失
- (void)viewControllerViewWiilDisappear:(NSNotification *)notification
{
    if ([self viewController] == notification.userInfo[KNoticeKey])
    {
        [self removeNotification];
    }
}

//发送绑定成功的通知
- (void)postBindSuccessNotice
{
    UIViewController *vc = [self viewController];
    vc.isNeedLifecycleNotice = YES;
}

#pragma mark 键盘默认触摸模式
- (void)defaultKeyboardDismissMode
{
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
}

#pragma mark 键盘监听
- (void)removeNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark 添加键盘监听
- (void)addKeyboardNotification{
    
    [self removeNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark 键盘即将显示
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    
    void(^animations)() = ^{
        [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:^(BOOL finished) {
        
    }];
    
}

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    BOOL beginFromBotom = (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)?(true):(false);
    BOOL toBottom = (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)?(true):(false);
    id place = [self responderSuperView];
    
    //只要是结束的frame的y等于屏幕底部,就说明是键盘收回
    if (toBottom)
    {
        if (beginFromBotom) return;
        [self _willShowBottomHeight:0];
        
        if (self.keyboardBlock)
        {
            self.keyboardBlock(NO, toFrame);
        }
    }
    else
    {
        [self _willShowBottomHeight:toFrame.size.height];
        if (self.keyboardBlock)
        {
            self.keyboardBlock(YES, toFrame);
        }
    }
    [self scrollToSomeWhere:place];
}

- (void)_willShowBottomHeight:(CGFloat)bottomHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = 0;
        rect.size.height = self.oldFrame.size.height - bottomHeight;
        self.frame = rect;
    }];
    
}



- (id)responderSuperView
{
    UIView *responder = [self getFirstResponder];
    if([responder isKindOfClass:[UITextField class]] || [responder isKindOfClass:[UITextView class]])
    {
        if ([self isKindOfClass:[UITableView class]])
        {
            UITableViewCell * cell = (UITableViewCell *)[self returnCell:responder];
            
            if (cell != nil)
            {
                UITableView *tableView = (UITableView *)self;
                NSIndexPath *index = [tableView indexPathForCell:cell];
                return index;
            }
            else
            {
                UIView *view = [self returnTableViewView:responder];
                if (view != nil)
                {
                    return view;
                }
                
            }
            
        }
        else if([self isKindOfClass:[UIScrollView class]])
        {
            
            if ([self returnScroll:responder] != nil)
            {
                
                return [self returnScroll:responder];
                
            }
        }
    }
    return nil;
    
}

- (void)scrollToSomeWhere:(id)indexOrView
{
    if(indexOrView == nil)
    {
        return;
    }
    
    UIView *view = (UIView *)indexOrView;
    
    if ([self isKindOfClass:[UITableView class]])
    {
        
        if ([indexOrView isKindOfClass:[NSIndexPath class]])
        {
            UITableView *tableView = (UITableView *)self;
            
            NSIndexPath *index = (NSIndexPath *)indexOrView;
            
            [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [self setContentOffset:CGPointMake(0, view.frame.origin.y) animated:YES];
        }
        
    }
    else if([self isKindOfClass:[UIScrollView class]])
    {
        CGRect rect = view.frame;
        
        UIScrollView *scroll = (UIScrollView *)self;
        
        [scroll setContentOffset:CGPointMake(0, rect.origin.y - 20) animated:YES];
        
    }
    
    
}

#pragma mark 找到cell
- (UIView *)returnCell:(UIView *)son{
    NSInteger i = for_I;
    while (i--) {
        if ([son isKindOfClass:[UITableViewCell class]])
        {
            return son;
        }else{
            son = [son superview];
        }
        
    }
    return nil;
}

#pragma mark tableView 的分组 头 尾 视图  tableView的 头 尾 视图
- (UIView *)returnTableViewView:(UIView *)son{
    NSMutableArray *viewArr = [[NSMutableArray alloc] init];
    [viewArr addObject:son];
    NSInteger i = for_I;
    while (i--)
    {
        UIView *view = [[viewArr lastObject] superview];
        if ([view isKindOfClass:[UITableView class]])
        {
            return [viewArr lastObject];
        }
        else
        {
            if (![view isKindOfClass:[UIView class]]) {
                return nil;
            }
            [viewArr addObject: view];
        }
    }
    return nil;
}

#pragma mark 找到 最顶层的scroll
- (UIView *)returnScroll:(UIView *)son{
    NSMutableArray *viewArr = [[NSMutableArray alloc] init];
    [viewArr addObject:son];
    NSInteger i = for_I;
    while (i--)
    {
        UIView *view = [[viewArr lastObject] superview];
        if ([view isKindOfClass:[UIScrollView class]])
        {
            return [viewArr lastObject];
        }
        else
        {
            [viewArr addObject: view];
        }
    }
    return nil;
}



//获取当前第一相应的视图
- (UIView *)getFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    return firstResponder;
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}




@end
