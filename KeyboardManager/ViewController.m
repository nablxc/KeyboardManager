//
//  ViewController.m
//  KeyboardManager
//
//  Created by 刘星辰 on 2017/6/6.
//  Copyright © 2017年 刘星辰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_menuArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    _menuArr = @[@{@"title":@"键盘监听处理",@"vc":@"CoverViewController"},
                 @{@"title":@"带X的身份键盘",@"vc":@"IDCardViewController"}];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.title = @"主页";
}

#pragma mark -
#pragma mark tableView的Delegate和DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建复用单元格
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = _menuArr[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}

//实际高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = _menuArr[indexPath.row];
    NSString *className = dict[@"title"];
    if (className == nil) return;
    Class class = NSClassFromString(dict[@"vc"]);
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
