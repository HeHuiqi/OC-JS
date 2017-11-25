//
//  HqJSObject.h
//  OC-JS
//
//  Created by macpro on 2017/11/25.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JavaScriptObjectiveCDelegate <JSExport>

//@optional 这里不能是optional，否则不会回调

- (void)completeOpen;
// 在JS中调用时，函数名应该为showAlertMsgButtonTitle(arg1, arg2,arg3)
//注意js中的方法名
- (void)showAlert:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle;

// JS调用此方法来调用OC的系统相册方法
//- (void)callSystemCamera;
//
//// 通过JSON传过来
//- (void)callWithDict:(NSDictionary *)params;
//
//// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
//- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

@end

@interface HqJSObject : NSObject<JavaScriptObjectiveCDelegate>


@end
