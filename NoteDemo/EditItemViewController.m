//
//  EditItemViewController.m
//  NoteDemo
//
//  Created by yubo liu on 15/9/6.
//  Copyright (c) 2015年 yubo liu. All rights reserved.
//

#import "EditItemViewController.h"
#import "DiaryViewController.h"

@interface EditItemViewController ()

@property (weak, nonatomic) IBOutlet UITextView *editItem;
@property (nonatomic, strong) NSMutableArray *editItemArray;
@end

@implementation EditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self editTableViewCellItem];
    [self setUpBarButton];
}

#pragma mark 获取地址并读写
//文件路径
- (NSString *)path{
    //获得文件即将保存的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //获得文件的具体地址
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"diaryArray.txt"];
    return filePath;
}

//写入数据
- (void)writeArray{
    [self.editItemArray writeToFile:[self path] atomically:YES];
}

//读取数据
- (NSMutableArray *)readArray{
    self.editItemArray = [NSMutableArray arrayWithContentsOfFile:[self path]];
    return self.editItemArray;
}

- (void)editTableViewCellItem{
    self.editItemArray = [self readArray];
    self.editItem.text = self.editItemArray[self.tableViewRow];
}

#pragma mark 完成按钮
- (void)setUpBarButton{
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editItem:)];
    self.navigationItem.rightBarButtonItem = edit;
}

- (void)editItem:(id)sender{
    self.editItemArray[self.tableViewRow] = self.editItem.text;
    [self writeArray];
    DiaryViewController *editItem = [[DiaryViewController alloc]init];
    [self.navigationController pushViewController:editItem animated:YES];
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
