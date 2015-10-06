//
//  AddItemViewController.h
//  NoteDemo
//
//  Created by yubo liu on 15/8/31.
//  Copyright (c) 2015年 yubo liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddItemViewController;
@protocol PassValueDelegate <NSObject>

- (void) passValue:(NSString *)content;

@end
@interface AddItemViewController : UIViewController
@property(nonatomic, assign) id<PassValueDelegate>delegate;
@end
