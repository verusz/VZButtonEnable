//
//  ViewController.m
//  VZButtonEnableDemo
//
//  Created by verus on 2017/3/17.
//
//

#import "ViewController.h"
#import "UIButton+EnabledCondition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button setTitle:@"enable" forState:UIControlStateNormal];
    [button setTitle:@"disable" forState:UIControlStateDisabled];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidSelect) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 10.f;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 160, 200, 40)];
    [self.view addSubview:textField];
    [button addEnabledCondition:[[VZButtonEnabledCondition alloc] initWithTextField:textField maxLength:11 minLength:1]];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField becomeFirstResponder];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:selectBtn];
    [selectBtn setImage:[UIImage imageNamed:@"login_check_unselected"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"login_check_selected"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame = CGRectMake(260, 160, 50, 50);
    
    VZButtonEnabledCondition *condition =[[VZButtonEnabledCondition alloc] initWithBlock:^BOOL(id object, NSString *property) {
        return ((UIButton *)object).selected;
    } object:selectBtn property:@"selected"];
    [button addEnabledCondition:condition];
}

- (void)selectBtnDidSelect:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)buttonDidSelect {
    NSLog(@"button did select");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
