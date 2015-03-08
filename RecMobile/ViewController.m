//
//  ViewController.m
//  RecMobile
//
//  Created by BiXiaopeng on 15/3/1.
//  Copyright (c) 2015年 BiXiaopeng. All rights reserved.
//

#import "ViewController.h"
#define CELL_IDENTIFIER @"ci"
@interface ViewController ()
@property (strong,nonatomic)NSUserDefaults *usrSetting;
@property (strong,nonatomic)UISwitch* notificationSwitch;
@property (strong,nonatomic)UITableView* recordTable;
@property (strong,nonatomic)UILabel *optionNameLabel;
@property (strong,nonatomic)RecordManager *recordManager;
@end

@implementation ViewController
@synthesize usrSetting = _usrSetting;

-(NSUserDefaults*)usrSetting{
    if (!_usrSetting) {
        _usrSetting = [NSUserDefaults standardUserDefaults];
    }
    return _usrSetting;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordManager = [RecordManager sharedManager];
    self.optionNameLabel = [[UILabel alloc]init];
    self.optionNameLabel.text = @"Notification Mode";
    self.notificationSwitch = [[UISwitch alloc]init];
    self.notificationSwitch.on = [self.usrSetting boolForKey:@"ntfOn"];
    
    self.recordTable = [[UITableView alloc]init];
    self.recordTable.dataSource = self;
    self.recordTable.delegate = self;
    
    [self.view addSubview:self.optionNameLabel];
    [self.view addSubview:self.notificationSwitch];
    [self.view addSubview: self.recordTable];
    
    [self.optionNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view);
        make.leading.equalTo(self.view);
    }];
    
    [self.notificationSwitch mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
    
    [self.recordTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.notificationSwitch.mas_top);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];


    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.recordManager getRecords]count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *date = [((MotionEvent*)[self.recordManager getRecords][indexPath.row]).created description];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    cell.textLabel.text = date;
    
    return cell;
}
-(void)viewDidAppear:(BOOL)animated{
    [self.recordTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)notificationSwitchChanged:(UISwitch *)sender {
    [self.usrSetting setBool:sender.on forKey:@"ntfOn"];
    if (sender.on) {
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication]unregisterForRemoteNotifications];
    }
}

@end
