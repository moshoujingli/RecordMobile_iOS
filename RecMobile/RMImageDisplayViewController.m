//
//  RMImageDisplayViewController.m
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/11.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import "RMImageDisplayViewController.h"
#define IMAGE_CELL @"imagecell"

@interface RMImageDisplayViewController ()
@property (strong, nonatomic)UITableView *imageContainer;
@property (strong,nonatomic)UIButton *backBtn;
@property (strong,nonatomic)UIProgressView *processView;
@property (strong,nonatomic)NSArray *images;
@end

@implementation RMImageDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [[UIButton alloc]init];
    UITableView *container = [[UITableView alloc]init];
    UIProgressView *progressView = [[UIProgressView alloc]init];
    
    container.dataSource = self;
    container.delegate = self;
    
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

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.images?self.images.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [[UIScreen mainScreen]bounds].size.height-100;
    UIImage *image = self.images[indexPath.row];
    return image.size.height;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELL];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IMAGE_CELL];
    }
    [cell.contentView addSubview:[[UIImageView alloc]initWithImage:self.images[indexPath.row]] ];
    return cell;
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.images = nil;
    
    //start download
    self.processView.progress = 0.0;
    [[RecordManager sharedManager]loadImageInEvent:self.e progress:^(NSUInteger byteReaded, NSUInteger byteDecompressed, NSUInteger total) {
        self.processView.progress = (byteReaded+byteDecompressed)/((float)total);
    } success:^(NSArray *images) {
        self.images = images;
        [self.imageContainer reloadData];
    } failure:^(NSError *error) {
        [self.backBtn setTitle:@"Download Failed..." forState:UIControlStateNormal];
    }];
    [self.imageContainer reloadData];
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
