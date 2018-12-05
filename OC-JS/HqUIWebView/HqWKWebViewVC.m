//
//  HqWKWebViewVC.m
//  OC-JS
//
//  Created by hqmac on 2018/12/5.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqWKWebViewVC.h"
#import <WebKit/WebKit.h>
#import "HqWKController.h"

#define HqGetUserInfo @"HqGetUserInfo"

@interface HqWKWebViewVC ()<WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation HqWKWebViewVC

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"WKWebView";
    NSString *htmlPath = @"www/html/index2";
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPath ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
   
    [self deleteCache];

}
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *HqWKC = [[WKUserContentController alloc] init];
        [HqWKC addScriptMessageHandler:self name:HqGetUserInfo];
        
        /*
        js端调用，注意postMessage不传参数的话要传一个空字符串如postMessage('')
        MessageName要和这里的name参数设置一致
        //window.webkit.messageHandlers.MessageName.postMessage('{"name:"王小二"}')
        这里是：window.webkit.messageHandlers.HqGetUserInfo.postMessage('{"name:"王小二"}');
        */
        config.userContentController = HqWKC;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        //log
        [HqWKC addScriptMessageHandler:self name:@"log"];
        //rewrite the method of console.log
        NSString *jsCode = @"console.log = (function(logFunc){\
        return function(str) {\
        window.webkit.messageHandlers.log.postMessage(str);\
        logFunc.call(console,str);\
        }\
        })(console.log);";
        //injected the method when H5 starts to create the DOM tree
        [config.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    }
    return _webView;
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"message.body=%@",message.body);
    NSLog(@"message.name=%@",message.name);
    if ([message.name isEqualToString:HqGetUserInfo]) {
        [self hqGetUserInfo];
    }
}
- (void)hqGetUserInfo{
    NSLog(@"获取用户信息");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取用户信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
