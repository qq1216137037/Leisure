//
//  BaseViewController.m
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UITextFieldDelegate>

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UITextField *textfield in self.registFirstResponseArray) {
        textfield.delegate = self;
    }
}

- (NSMutableArray *)registFirstResponseArray
{
    if (_registFirstResponseArray == nil) {
        self.registFirstResponseArray = [NSMutableArray array];
    }
    
    return _registFirstResponseArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBarButtonTitle];
    
    [self createBackButton];
    
    self.navigationController.navigationBar.layer.borderWidth = 1;
    self.navigationController.navigationBar.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 当应用程序收到应用警告时会被触发, 而且是工程中所有的控制器对象都会收到.
// 当收到内存警告时, 要释放可再生的内存数据, 通过方法可将资源重新加载回来.
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // 在内存警告方法中, 释放已经加载且不在当前Window上显示的根视图
    // 因为控制器的根视图是一个 lazyloading
    if ([self isViewLoaded] && ![self.view window]) {
        self.view = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField *textfield in self.registFirstResponseArray) {
        [textfield resignFirstResponder];
    }
}

- (void)createBarButtonTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    label.text = _barButtonTitle;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = label;
}

- (void)createBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *navigationspacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navigationspacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[navigationspacer, leftItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    
    NSInteger offset = (frame.origin.y+62)-(self.view.frame.size.height-216.0);
    
    if (offset > 0) {
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

@end