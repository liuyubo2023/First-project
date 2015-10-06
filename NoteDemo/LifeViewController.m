//
//  LifeViewController.m
//  NoteDemo
//
//  Created by yubo liu on 15/8/31.
//  Copyright (c) 2015年 yubo liu. All rights reserved.
//

#import "LifeViewController.h"
#import "AddItemViewController.h"

static NSString *const KtableView = @"LifeViewController";

@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource,PassValueDelegate>

@property (weak, nonatomic) IBOutlet UITableView *LifeTableView;
@property (nonatomic, strong) NSMutableArray *lifeItems;
@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活";
    [self setUpBarButton];
    self.lifeItems = [self readArray];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.LifeTableView reloadData];
}

//文件路径
- (NSString *)path{
    //获得文件即将保存的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"lifeArray.txt"];
    return filePath;
}

//写入数据
- (void)writeArray{
    [self.lifeItems writeToFile:[self path] atomically:YES];
    NSMutableArray *data = [[NSMutableArray alloc]initWithContentsOfFile:[self path]];
    NSLog(@"%@",data);
}

//读取数据
- (NSMutableArray *)readArray{
    self.lifeItems = [NSMutableArray arrayWithContentsOfFile:[self path]];
    return self.lifeItems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lifeItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KtableView];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KtableView];
    cell.textLabel.text = [self readArray][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.lifeItems removeObjectAtIndex:indexPath.row];
        [self writeArray];
        [self.LifeTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)setUpBarButton{
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = back;
}

- (void)addItem:(id)sender{
    AddItemViewController *addItem = [[AddItemViewController alloc]init];
    addItem.delegate = self;
    [self.navigationController pushViewController:addItem animated:YES];
}

- (void)passValue:(NSString *)content{
    if (![content  isEqual: @""]) {
        [self.lifeItems insertObject:content atIndex:0];
        [self writeArray];
    }
}

@end
