//
//  WorkViewController.m
//  
//
//  Created by yubo liu on 15/8/31.
//
//

#import "WorkViewController.h"
#import "AddItemViewController.h"

static NSString *const KtableView = @"WorkViewController";

@interface WorkViewController ()<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>

@property (weak, nonatomic) IBOutlet UITableView *workTableView;
@property (nonatomic, strong) NSMutableArray *workItems;
@end

@implementation WorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作";
    [self setUpBarButton];
    self.workItems = [self readArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.workTableView reloadData];
}

//文件路径
- (NSString *)path{
    //获得文件即将保存的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"workArray.txt"];
    return filePath;
}

//写入数据
- (void)writeArray{
    [self.workItems writeToFile:[self path] atomically:YES];
    NSMutableArray *data = [[NSMutableArray alloc]initWithContentsOfFile:[self path]];
    NSLog(@"%@",data);
}

//读取数据
- (NSMutableArray *)readArray{
    self.workItems = [NSMutableArray arrayWithContentsOfFile:[self path]];
    return self.workItems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.workItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KtableView];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KtableView];
    cell.textLabel.text = [self readArray][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.workItems removeObjectAtIndex:indexPath.row];
        [self writeArray];
        // Delete the row from the data source.
        [self.workTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)passValue:(NSString *)content{
    if (![content isEqualToString:@""]) {
        [self.workItems insertObject:content atIndex:0];
        [self writeArray];
    }
}

@end
