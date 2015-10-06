//
//  AddItemViewController.m
//  NoteDemo
//
//  Created by yubo liu on 15/8/31.
//  Copyright (c) 2015年 yubo liu. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *editText;

@property (nonatomic,copy) NSString *text;
@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBarButton];
    [self setTime];
    [self.editText becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpBarButton{
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEdit:)];
    self.navigationItem.rightBarButtonItem = back;
}

- (void)doneEdit:(id)sender{
    NSString *info = self.editText.text;
    [self.delegate passValue:info];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    [self.timeLabel setText:[dateFormatter stringFromDate:date]];
}


@end
