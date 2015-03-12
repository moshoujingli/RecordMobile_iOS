//
//  RMImageDisplayViewController.m
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/11.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import "RMImageDisplayViewController.h"

@interface RMImageDisplayViewController ()
@property (strong, nonatomic)UIScrollView *imageContainer;
@property (strong,nonatomic)UIButton *backBtn;
@property (strong,nonatomic)UIProgressView *processView;
@end

@implementation RMImageDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [[UIButton alloc]init];
    UIScrollView *container = [[UIScrollView alloc]init];
    UIProgressView *progressView = [[UIProgressView alloc]init];
    
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.backBtn = backBtn];
    [self.view addSubview:self.processView = progressView];
    [self.view addSubview:self.imageContainer = container];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.view);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.view);
    }];
    
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(self.view);
    }];

    [self.imageContainer mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.view);
        make.top.equalTo(self.processView.mas_bottom);
        make.bottom.equalTo(self.backBtn.mas_top);
    }];

    //start download
    //

}
-(void)backPushed:(UIButton*)backBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
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
