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

#define HqJsHanderName @"HqJsBridge"
#define HqMessageId @"callbackId"
#define HqParams @"params"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HqBridgerBlock)(NSString*messageId,id params);

@protocol HqJsBridgerDelegate;
@interface HqJsBridger : NSObject

@property (nonatomic,copy) HqBridgerBlock hqBridgeBlock;
@property(nonatomic,weak) id<HqJsBridgerDelegate> delegate;
@property (nonatomic,strong) WKWebView *webView;
@property(nonatomic,assign) BOOL isDealJsRequest;

+ (HqJsBridger *)jsHandlerWithWebView:(WKWebView *)webView;

- (void)callbackJsWithDic:(NSDictionary *)dic;
- (void)callbackJsWithDic:(NSDictionary *)dic callbackId:(NSString *)callbackId;

- (void)showLog;
//一定要在使用的类的delloc方法中调用，否则不会释放该类对象
- (void)removeAllScriptMessageHandlers;

@end

@protocol HqJsBridgerDelegate <NSObject>

@required
- (void)hqJsBridger:(HqJsBridger *)jsHandler messageId:(NSString *)messageId params:(id)params;

@end



NS_ASSUME_NONNULL_END
