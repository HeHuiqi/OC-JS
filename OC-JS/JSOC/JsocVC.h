//
//  JsocVC.h
//  OC-JS
//
//  Created by macpro on 2017/11/22.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSDelegate <JSExport>
//@optional 这里不能是optional，否则不会回调
- (void)completeOpen;
//注意js中的方法名
- (void)showAlert:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle;
@end

@interface JsocVC : UIViewController


@end


