//
//  CustomizeViewController.m
//  ContentBlocker
//
//  Created by lyang on 10/29/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#import "CustomizeViewController.h"
#import "AppConfigurationmanager.h"

@interface CustomizeViewController ()

@property (weak, nonatomic)  UITableView *settingTableView;
@property (nonatomic,strong) NSDictionary *settings;


@end

@implementation CustomizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *path = [[NSBundle mainBundle] pathForResource:@"customize.plist" ofType:nil];
    NSLog(@"path is %@",path);
    _settings = [NSDictionary dictionaryWithContentsOfFile:path];


    _switchStatesDic = [[AppConfigurationmanager shareInstance] getSwitchState];
    if (_switchStatesDic == nil) {
        _switchStatesDic = [NSMutableDictionary dictionary];
    }

    CGFloat titleLableWidth = 200;
    CGFloat titleLabelHeight = 80;
    CGFloat titleHeight = 64;
    self.view.backgroundColor = [UIColor colorWithRed:0xec/255.f green:0xef/255.f blue:0xf1/255.f alpha:1.0f];

    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect statueBarRect;
    statueBarRect = [[UIApplication sharedApplication] statusBarFrame];


    CGFloat titleWidth = width;
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
    titleView.backgroundColor = [UIColor colorWithRed:0x00/255.f green:0xb1/255.f blue:0x88/255.f alpha:1.0f];

    CGFloat titleLabelX = (titleWidth - titleLableWidth)/2;
    CGFloat titleLabelY = (titleHeight - titleLabelHeight)/2 + statueBarRect.size.height - 10;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLableWidth, titleLabelHeight)];
    titleLabel.text = NSLocalizedString(@"customize", nil);
    titleLabel.font = [UIFont fontWithName:@"Medium" size:24];
    [titleLabel setTextColor:[UIColor colorWithRed:0xff/255.f green:0xff/255.f blue:0xff/255.f alpha:1.0f]];
    [titleView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleView];

    //BACK BUTTON
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, statueBarRect.size.height, width, 50)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:0xff/255.f green:0xff/255.f blue:0xff/255.f alpha:1.0f] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:0xff/255.f green:0xff/255.f blue:0xff/255.f alpha:0.6f] forState:UIControlStateHighlighted];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 10);
    [titleView addSubview:backButton];
    UIImageView* backArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 10, 15)];
    [backArrow setImage:[UIImage imageNamed:@"back-normal.png"]];
    [backButton addSubview:backArrow];


    UITableView *customizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height, width, height) style:UITableViewStyleGrouped];
    customizeTableView.dataSource = self;
    customizeTableView.rowHeight = 56;
    [self.view addSubview:customizeTableView];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *customizeItems = [_settings valueForKey:@"customizeItems"];
    return customizeItems.count;
}


-(void)back
{
    DebugLog(@"[CustomizeViewController] %s", __func__);
    [Flurry logEvent:@"Customize|Back"];
    [self.navigationController popViewControllerAnimated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建单元格cell
    NSString *ID = @"customize";

    //单元格的复用
    UITableViewCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    NSDictionary *itemDic = [_settings valueForKey:@"customizeItems"][indexPath.row];

    //设置单元格cell
    cell.textLabel.text =  [itemDic valueForKey:@"text"];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0xaa/255.f green:0xad/255.f blue:0xb4/255.f alpha:1.f];
    cell.detailTextLabel.text = [itemDic valueForKey:@"desc"];
    UISwitch *switchView = [[UISwitch alloc]init];
    [switchView setTag:indexPath.row];
    NSNumber *swithState = [_switchStatesDic valueForKey:[self getNameBySwitch:switchView]];
    DebugLog(@"swithState is %@",swithState);
    if (swithState == nil) {
        [_switchStatesDic setObject: [NSNumber numberWithBool:NO] forKey: [self getNameBySwitch:switchView]];
        [switchView setOn:NO];
    }else{
        [switchView setOn:[swithState boolValue]];
    }
    [switchView addTarget:self action:@selector(switchRules:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //返回cell
    return cell;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchRules: (id)sender
{
    UISwitch * settingSwitch = (UISwitch *)sender;
    NSString *fileName = [self getNameBySwitch:settingSwitch];
    if ([settingSwitch isOn]) {
        [[BlockerRulesDataManager shareInstance]enableBlockRuleWithName:fileName];
        [_switchStatesDic setObject:[NSNumber numberWithBool:YES]forKey:fileName];
        NSLog(@"switch is on");
    }else{
        [[BlockerRulesDataManager shareInstance]disableBlockRuleWithName:fileName];
        [_switchStatesDic setObject:[NSNumber numberWithBool:NO]forKey:fileName];
        NSLog(@"switch is off");
    }
    [[AppConfigurationmanager shareInstance] setSwitchState:_switchStatesDic];
}

-(NSString *)getNameBySwitch: (UISwitch *)settingSwitch
{
    NSString *fileName;
    switch (settingSwitch.tag) {
        case 0:
            fileName = JSON_BLOCKLIST_AD_DATA;
            break;
        case 1:
            fileName = JSON_BLOCKLIST_IMAGE;
            break;
        case 2:
            fileName = JSON_BLOCKLIST_COMMENT;
            break;
        case 3:
            fileName = JSON_BLOCKLIST_SOCIALBUTTON;
            break;
        case 4:
            fileName = JSON_BLOCKLIST_SCRIPT;
            break;
        case 5:
            fileName = JSON_BLOCKLIST_FONT;
            break;
        default:
            break;
    }
    return fileName;

}

@end
