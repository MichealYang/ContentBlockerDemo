//
//  ViewController.m
//  ContentBlockerDemo
//
//  Created by lyang on 15/9/2.
//  Copyright © 2015年 lyang. All rights reserved.
//

#import "HomeViewController.h"
#import "YLSettingModel.h"

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (nonatomic,strong) NSArray *settingItems;

@end

@implementation HomeViewController


//懒加载数据
-(NSArray *)settingItems
{
    if (_settingItems == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"customize.plist" ofType:nil];
        NSArray *content =[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModel = [NSMutableArray array];
        for ( NSDictionary *dic in content) {
            YLSettingModel *model =[YLSettingModel settingWithDic:dic];
            [arrayModel addObject:model];
        }
        _settingItems = arrayModel;
    }
    return _settingItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_settingTableView];
    self.view.backgroundColor = [UIColor orangeColor];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"settingitem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    YLSettingModel *model = _settingItems[indexPath.row];
    cell.textLabel.text = model.text;
    cell.detailTextLabel.text = model.desc;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settingItems.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
