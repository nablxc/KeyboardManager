//
//  KeyboardX.m
//  自定义键盘
//
//  Created by 刘星辰 on 2016/11/7.
//  Copyright © 2016年 LiuXingChen. All rights reserved.
//

#import "KeyboardX.h"
#import "UITextField+ExtentRange.h"


static NSString *const keyboardXDelete = @"删除";
static const CGFloat keyboardXHeight = 220.0f;
static const NSInteger keyboardMaxNum =  18; //身份证位数

/*16进制颜色*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define BLACK_COLOR [UIColor blackColor]

#define TOPCAIL_COLOR UIColorFromRGB(0x1dc4ad)

@interface KeyboardX()
{
    UITextField *_textField;
    NSArray *_keyArr;
    NSTimer *_timer;
    CGPoint _start;
    CGFloat _line;
}

@end

@implementation KeyboardX

- (instancetype)initWithFrame:(CGRect)frame AndTextField:(UITextField *)textField{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _textField = textField;
        
        _keyArr = @[@[@"1",@"2",@"3"],
                    @[@"4",@"5",@"6"],
                    @[@"7",@"8",@"9"],
                    @[@"X",@"0",keyboardXDelete],];
        
        _textField.inputView = self;
        
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventValueChanged];
        
        _line = 0.4f;
    }
    return self;
}

+ (instancetype)keyboardXAddIn:(UITextField  *)textField{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, keyboardXHeight)AndTextField:textField];
}

- (void)drawRect:(CGRect)rect {
    
    
    for (NSInteger i = 0; i < _keyArr.count; i++)
    {
        for (NSInteger j = 0; j < [_keyArr[i] count]; j++)
        {
            
            CGFloat width = (SCREEN_WIDTH - _line * 2) / 3;
            CGFloat height = (keyboardXHeight - _line * 3) / 4;
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(j * (width + _line), i * (height + _line), width, height);
            [button setTitle:_keyArr[i][j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:23];
            UIImage *backImage = [self createImageWithColor:[UIColor grayColor]];
            [button setBackgroundImage:backImage forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 3 && (j == 2 || j == 0))
            {
                [button setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
//                [button setBackgroundColor:UIColorFromRGB(0xd2d5dc)];
                if (j == 2)
                {
                    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                    [button setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
//                    [button setTitleColor:LINE_COLOR forState:UIControlStateSelected];
                    [button setTitle:_keyArr[i][j] forState:UIControlStateSelected];
                    
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delete:)];
                    longPress.minimumPressDuration = 0.5f;
                    [button addGestureRecognizer:longPress];
                }
            }
            
            button.tag =  i * 10 + j;
            [self addSubview:button];
            
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
            [button addGestureRecognizer:pan];
            
            // 划线操作
            if (i == 0)
            {
                //竖线
                if (j != 0) {
                    [self drawLine:CGRectMake( j * width ,0, _line, self.frame.size.height)];
                }
            }
            else if (j == 0)
            {
                //横线
                 [self drawLine:CGRectMake(0, i * height, SCREEN_WIDTH, _line)];
            }

        }
    }
}

#pragma mark 画线
- (void)drawLine:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [self addSubview:line];
}

#pragma mark -
- (void)buttonClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    NSString *keyStr = _keyArr[tag / 10][tag % 10];
    
    if (!([keyStr isEqualToString:keyboardXDelete]))
    {
        [self addText:keyStr];
    }
    else
    {
        [self deleteText];
    }
}

- (void)move:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        _start = [pan locationInView:self];
//            NSLog(@"开始的手势%lf-%lf",_start.x,_start.y);
    }
    
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint change = [pan locationInView:self];
//        NSLog(@"改变的手势%lf-%lf",change.x,change.y);
        
        [self manageOffset:change.x - _start.x SavePoint:change];
    }
    
    

}

//处理偏移量
- (void)manageOffset:(CGFloat )offset SavePoint:(CGPoint)point{
    
    NSInteger num = fabs(offset) / 15;
    
    if (num > 0) //代表可以移动光标
    {
        if (offset > 0)
        {
            //右偏移
            if (_textField.text.length > _textField.selectedRange.location) {
                _textField.selectedRange = NSMakeRange(_textField.selectedRange.location + 1, 0);
            }
        }
        else
        {
            //左偏移
            _textField.selectedRange = NSMakeRange(_textField.selectedRange.location - 1, 0);
        }
        _start = point;
    }
    
    
    
}

- (void)delete:(UILongPressGestureRecognizer *)longPress{
    
    UIButton *btn = (UIButton *)longPress.view;
    
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        btn.selected = YES;
        
        if (_timer.valid == NO) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteText) userInfo:nil repeats:YES];
        }
        
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        
        btn.selected = NO;
        [_timer invalidate];
    }
    
}

- (void)deleteEnd{
    
}

#pragma mark 添加文字
- (void)addText:(NSString *)keyStr{
    if (_textField.text.length < keyboardMaxNum)
    {
        
        NSMutableString *str = [[NSMutableString alloc] initWithString:_textField.text];
        NSInteger location = _textField.selectedRange.location;
        [str insertString:keyStr atIndex:location];
        _textField.text = str;
        _textField.selectedRange = NSMakeRange(location + 1, 0);
        
    }
}

#pragma mark 删除文字
- (void)deleteText{
    if (_textField.text.length > 0)
    {
        NSMutableString *str = [[NSMutableString alloc] initWithString:_textField.text];
        NSInteger location = _textField.selectedRange.location - 1;
        if (location >= 0) {
            [str deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        _textField.text = str;
        _textField.selectedRange = NSMakeRange(location, 0);
    }
}

- (void)textChange:(UITextField *)textField
{
    
}

#pragma mark 颜色生成图片
- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (CGFloat)lineSize
{
    CGFloat line = 0.5;
    while (line < 2)
    {
        CGFloat width = (SCREEN_WIDTH - line * 2) / 3;
        CGFloat height = (keyboardXHeight - line * 3) / 4;
        if ([self isInteger:width] && [self isInteger:height])
        {
            return line;
        }
        else
        {
            line += 0.01;
        }
    }
    return line;
}

- (BOOL)isInteger:(CGFloat)num
{
    CGFloat i = roundf(num);//对num取整
    if (i == num) {
        return YES;
    }else{
        return NO;
    }
}

@end
