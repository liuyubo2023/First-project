//
//  ViewController.m
//  NoteDemo
//
//  Created by yubo liu on 15/8/31.
//  Copyright (c) 2015年 yubo liu. All rights reserved.
//

#import "ViewController.h"
#import "DiaryViewController.h"
#import "WorkViewController.h"
#import "LifeViewController.h"

static NSString *const KtableView = @"ViewController";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSArray *)MainItems{
    return @[@"学习",@"工作",@"生活"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KtableView];
//    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KtableView];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [self MainItems][indexPath.row];
    //添加向右的箭头
    
//    设定分割线
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 30)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            DiaryViewController *diary = [[DiaryViewController alloc]init];
            [self.navigationController pushViewController:diary animated:YES ];
            break;
        }

        case 1:{
            WorkViewController *work =[[WorkViewController alloc]init];
            [self.navigationController pushViewController:work animated:YES];
            break;
        }
        case 2:{
            LifeViewController *life = [[LifeViewController alloc]init];
            [self.navigationController pushViewController:life animated:YES];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
