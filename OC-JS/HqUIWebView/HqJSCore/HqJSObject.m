//
//  HqJSObject.m
//  OC-JS
//
//  Created by macpro on 2017/11/25.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqJSObject.h"

@implementation HqJSObject

#pragma mark - 实现JSExport的方法

- (void)completeOpen{
    //NSLog(@"completeOpen");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"任务完成了" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)getUserInfo:(NSString *)name{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的名字" message:name delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle{
    //NSLog(@"showAlert:msg:buttonTitle");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:btnTitle, nil];
        [alert show];
    });
    
}
@end
