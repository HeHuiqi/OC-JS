//
//  HqWKWebViewVC.m
//  OC-JS
//
//  Created by hqmac on 2018/12/5.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqWKWebViewVC.h"
#import <WebKit/WebKit.h>
#import "HqJsHandler.h"
#import "WKUserContentController+HqAddUserScript.h"

#define HqGetUserInfoMsgId @"userInfo"
#define HqGetHomeListMsgId @"homeList"

@interface HqWKWebViewVC ()<WKUIDelegate,
WKNavigationDelegate,HqJsHandlerDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) WKWebViewConfiguration *config;
@property (nonatomic,strong) HqJsHandler *jsHandler;
@property(nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HqWKWebViewVC

- (void)dealloc{
    //记得移除
    [self.jsHandler removeAllScriptMessageHandlers];
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    self.webView = nil;
    NSLog(@"HqWKWebViewVC-dealloc");

}

- (void)deleteCache{
    
    if (@available(iOS 9.0, *)) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{ }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        _indicatorView.center = self.view.center;
    }
    return _indicatorView;
}
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config setValue:@"1" forKey:@"allowUniversalAccessFromFileURLs"];
        [config.preferences setValue:@"1" forKey:@"allowFileAccessFromFileURLs"];
        
        WKUserContentController *HqWKC = [[WKUserContentController alloc] init];
        config.userContentController = HqWKC;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
- (HqJsHandler *)jsHandler{
    if (!_jsHandler) {
        _jsHandler = [HqJsHandler jsHandlerWithWebView:self.webView];
    }

    return _jsHandler;
}
- (void)hqGetUserInfo:(NSDictionary *)params{
    NSLog(@"获取Native用户信息");
    NSLog(@"params==%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Native获取到了Js参数" message:params[@"name"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    completionHandler();
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"WKWebView";
    NSString *htmlPath = @"www/html/index2";
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPath ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.indicatorView];
    
//    [self deleteCache];
    //处理事件,block处理
    /*
    __weak typeof(self) weakSelf = self;
    self.jsHandler.hqHandlerBlock = ^(NSString * _Nonnull messageId, id  _Nonnull params) {
        NSLog(@"Native正在处理......");
        [weakSelf dealJsInvokeWithMessageId:messageId params:params];
        
    };
    */
    //代理处理回调
    self.jsHandler.delegate = self;
    //显示js端的console.log()信息
    [self.jsHandler showLog];
    
}

#pragma mark - HqJsHandlerDelegate
- (void)hqJsHandler:(HqJsHandler *)jsHandler messageId:(NSString *)messageId params:(id)params{
    //对于接收到js的数据类型，自行协商处理
    [self dealJsInvokeWithMessageId:messageId params:params];
}

- (void)dealJsInvokeWithMessageId:(NSString *)msgId params:(id)params{
    //执行你Native端的处理逻辑然后根据需要回调js端
    if ([msgId isEqualToString:HqGetUserInfoMsgId]) {
        [self hqGetUserInfo:params];
        return;
    }
    if ([msgId isEqualToString:HqGetHomeListMsgId]) {
        //处理有callback的情况
        if (self.jsHandler.isDealJsRequest) {
            //正在处理，防止js端重复提交
            return;
        }
        self.jsHandler.isDealJsRequest = YES;
        //模拟在Native请求/处理数据
        [self.indicatorView startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //处理完了，向js传递结果
            NSDictionary *rspData = @{@"data":@"life good!"};
            [self.jsHandler callbackJsWithDic:rspData];
            [self.indicatorView stopAnimating];
            //重置
            self.jsHandler.isDealJsRequest = NO;

        });
        return;
    }
}


@end
