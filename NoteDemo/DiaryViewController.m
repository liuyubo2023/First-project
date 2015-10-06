//
//  DiaryViewController.m
//  NoteDemo
//
//  Created by yubo liu on 15/9/2.
//  Copyright (c) 2015年 yubo liu. All rights reserved.
//

#import "DiaryViewController.h"
#import "AddItemViewController.h"
#import "EditItemViewController.h"

static NSString *const KtableView = @"DiaryViewController";

@interface DiaryViewController ()<UITableViewDataSource,UITableViewDataSource,PassValueDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *diaryTableView;
@property (nonatomic, strong) NSMutableArray *diaryItems;
@property (nonatomic, assign) BOOL searching;
@end

@implementation DiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学习";
    [self setUpBarButton];
//    self.diaryItems = [self readArray];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.diaryTableView addGestureRecognizer:longpress];
}

#pragma mark 刷新页面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.diaryItems = [self readArray];
    [self.diaryTableView reloadData];
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
    [self.diaryItems writeToFile:[self path] atomically:YES];
    NSMutableArray *data = [[NSMutableArray alloc]initWithContentsOfFile:[self path]];
    NSLog(@"%@",data);
}

//读取数据
- (NSMutableArray *)readArray{
    self.diaryItems = [NSMutableArray arrayWithContentsOfFile:[self path]];
    return self.diaryItems;
}

#pragma mark 代理模式
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.diaryItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KtableView];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KtableView];
//    self.diaryItems = [self readArray];
    cell.textLabel.text = self.diaryItems[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark 编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.diaryItems removeObjectAtIndex:indexPath.row];
        [self writeArray];
        [self.diaryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

#pragma mark 点击选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditItemViewController *vc = [[EditItemViewController alloc]init];
    vc.tableViewRow = [indexPath row];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    NSUInteger fromRow = [sourceIndexPath row];
//    NSUInteger toRow = [destinationIndexPath row];
//    
//    id object = [self.diaryItems objectAtIndex:fromRow];
//    [self.diaryItems removeObjectAtIndex:fromRow];
//    [self.diaryItems insertObject:object atIndex:toRow];
//}

#pragma mark 搜索栏
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searching = NO;
    self.mSearchBar.text = @"";
    [self.diaryTableView reloadData];
    [self.mSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([self.mSearchBar.text isEqual:@""]) {
        self.searching = NO;
        self.diaryItems = [self readArray];
        [self.diaryTableView reloadData];
        return;
    }
    [self searchDataWithKeyWord:self.mSearchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchDataWithKeyWord:self.mSearchBar.text];
    [self.mSearchBar resignFirstResponder];
}

- (void)searchDataWithKeyWord:(NSString *)keyWord{
    self.searching = YES;
    NSArray *tempArray = [[NSMutableArray alloc]initWithArray:self.diaryItems];
//    [self.diaryItems removeAllObjects];
    self.diaryItems = [NSMutableArray array];
    for (NSString *tempString in tempArray) {
        if ([tempString hasPrefix:self.mSearchBar.text]) {
            [self.diaryItems addObject:tempString];
        }
    }
    [self.diaryTableView resignFirstResponder];
    [self.diaryTableView reloadData];
}

#pragma mark 添加按钮
- (void)setUpBarButton{
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = add;
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"All" style:UIBarButtonItemStyleDone target:self action:@selector(backAll:)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backAll:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addItem:(id)sender{
    AddItemViewController *addItem = [[AddItemViewController alloc]init];
    addItem.delegate = self;
    [self.navigationController pushViewController:addItem animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 传值
- (void)passValue:(NSString *)content{
    if (![content isEqualToString:@""]) {        
        [self.diaryItems insertObject:content atIndex:0];
        [self writeArray];
    }
}

#pragma mark 移动cell
- (IBAction)longPressGesture:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.diaryTableView];
    NSIndexPath *indexPath = [self.diaryTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.diaryTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.diaryTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.diaryItems exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.diaryTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.diaryTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
    [self writeArray];
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
