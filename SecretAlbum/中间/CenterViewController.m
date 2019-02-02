//
//  ViewController1.m
//  SecretAlbum
//
//  Created by 王雪剑 on 2018/3/15.
//  Copyright © 2018年 zkml－wxj. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupNavigationbarBack];
}

- (void)setupNavigationbarBack {
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 0, kSize(72), kSize(72));
    leftButton.adjustsImageWhenHighlighted = NO;
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"car_easy_nav_back_normal_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -7;
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftButtonItem];
}

#pragma mark ********【操作】********左上角返回按钮
- (void)backAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
