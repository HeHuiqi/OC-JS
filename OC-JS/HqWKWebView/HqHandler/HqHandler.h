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
NS_ASSUME_NONNULL_BEGIN
typedef void(^HqHandlerBlock)(NSString*messageId,id params);
@interface HqHandler : NSObject

@property (nonatomic,copy) HqHandlerBlock hqHandlerBlock;
@property (nonatomic,strong) WKUserContentController *userContentController;
@property (nonatomic,strong) WKWebView *webView;
@property(nonatomic,assign) BOOL isDealJsReqquest;

- (void)hqJsHandlerWithWebView:(WKWebView *)webView;
- (void)callbackJsWithResponse:(id)response;
- (void)showLog:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
