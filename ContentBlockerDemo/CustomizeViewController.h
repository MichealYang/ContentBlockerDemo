//
//  CustomizeViewController.h
//  ContentBlocker
//
//  Created by lyang on 10/29/15.
//  Copyright © 2015 Baina/JieLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CustomizeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *switchStatesDic; //记录按钮的状态

@end
