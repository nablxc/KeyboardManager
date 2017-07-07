//
//  IDCardViewController.m
//  KeyboardManager
//
//  Created by 刘星辰 on 2017/6/6.
//  Copyright © 2017年 刘星辰. All rights reserved.
//

#import "IDCardViewController.h"
#import "KeyboardX.h"

@interface IDCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation IDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"身份键盘";
    
    [KeyboardX keyboardXAddIn:self.textfield];
    
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
