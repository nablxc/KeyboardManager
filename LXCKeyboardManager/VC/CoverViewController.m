//
//  CoverViewController.m
//  KeyboardManager
//
//  Created by 刘星辰 on 2017/6/6.
//  Copyright © 2017年 刘星辰. All rights reserved.
//

#import "CoverViewController.h"
#import "TextCell.h"
#import "UIScrollView+KeyboardCover.h"
@interface CoverViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CoverViewController

//必须在这两个里面执行 注册 和 移除
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"键盘自动处理";
    
    
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 668 - 64 + 30, 30, 30)];
    view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view];
    
    [self.tableView automaticSolveKeyboardCoverWithBlock:^(BOOL isShow, CGRect frame) {
        if (isShow)
        {
            view.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }
        else
        {
            view.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    }];
    
//    [self.tableView setKeyboardBlock:^(BOOL isShow,CGRect frame){
//        
//    }];
//    
    //    self.tableView.hidden = YES;
    
}


- (UIView *)tableHeaderView{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 375, 40);
    view.backgroundColor = [UIColor orangeColor];
    
    //
    UITextField * textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(50, 5, 200, 30);
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.secureTextEntry = NO; //密文输入
    textField.returnKeyType = UIReturnKeyGo;//键盘的return效果
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textField];
    
    return view;
}
#pragma mark -
#pragma mark tableView的Delegate和DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 375, 40);
    view.backgroundColor = [UIColor orangeColor];
    
    //
    UITextField * textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(50, 5, 200, 30);
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.secureTextEntry = NO; //密文输入
    textField.returnKeyType = UIReturnKeyGo;//键盘的return效果
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textField];
    
    return textField;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
    {
        //创建复用单元格
        static NSString * ID = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = @"跳转下个控制器";
        return cell;
    }
    else
    {
        //创建xib复用单元格
        static NSString * ID = @"TextCell";
        TextCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TextCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.title.text = [NSString stringWithFormat:@"%lu",indexPath.section];
        return  cell;
    }
    
}

//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

//实际高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
    {
        
    }
}

- (void)dealloc
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
