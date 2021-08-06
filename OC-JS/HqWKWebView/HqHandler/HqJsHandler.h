//
//  HqHandler.h
//  OC-JS
//
//  Created by hqmac on 2018/12/6.
//  Copyright © 2018 macpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define HqJsHanderName @"HqJsHandler"
#define HqMessageId @"messageId"
#define HqParams @"params"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HqHandlerBlock)(NSString*messageId,id params);

@protocol HqJsHandlerDelegate;
@interface HqJsHandler : NSObject

@property (nonatomic,copy) HqHandlerBlock hqHandlerBlock;
@property(nonatomic,weak) id<HqJsHandlerDelegate> delegate;
@property (nonatomic,strong) WKWebView *webView;
@property(nonatomic,assign) BOOL isDealJsRequest;

+ (HqJsHandler *)jsHandlerWithWebView:(WKWebView *)webView;

- (void)callbackJsWithDic:(NSDictionary *)dic;

- (void)showLog;
//一定要在使用的类的delloc方法中调用，否则不会释放该类对象
- (void)removeAllScriptMessageHandlers;

@end

@protocol HqJsHandlerDelegate <NSObject>

@required
- (void)hqJsHandler:(HqJsHandler *)jsHandler messageId:(NSString *)messageId params:(id)params;

@end



NS_ASSUME_NONNULL_END
