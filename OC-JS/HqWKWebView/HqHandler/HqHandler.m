//
//  HqHandler.m
//  OC-JS
//
//  Created by hqmac on 2018/12/6.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqHandler.h"
#define HqJsHanderName @"HqJsHandler"
@interface HqHandler()<WKScriptMessageHandler>

@end
@implementation HqHandler

- (void)hqJsHandlerWithWebView:(WKWebView *)webView{
    
    WKWebViewConfiguration *config = webView.configuration;
    self.webView = webView;
    self.userContentController = config.userContentController;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HqJsHandler" ofType:@"js"];
    NSString *jsHandlerCode = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:jsHandlerCode injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:usrScript];
    
    [config.userContentController addScriptMessageHandler:self name:HqJsHanderName];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:HqJsHanderName]) {
        if (self.hqHandlerBlock) {
            NSString *msgId = message.body[@"messageId"];
            id params = message.body[@"params"];
            self.hqHandlerBlock(msgId, params);
        }
    }else{
        NSLog(@"message.name=%@",message.name);
        NSLog(@"message.body=%@",message.body);

    }
}

- (void)callbackJsWithResponse:(id)response{
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    NSString *callBack = [NSString stringWithFormat:@"HqJsHandler.jsCallback(%@);",jsonStr];
    [self.webView evaluateJavaScript:callBack completionHandler:^(id _Nullable resp , NSError * _Nullable error) {
//        NSLog(@"resp==%@",resp);
//        NSLog(@"error==%@",error);
    }];
    
}
- (void)showLog:(WKWebView *)webView{
    WKWebViewConfiguration *config = webView.configuration;
    //log
    [config.userContentController addScriptMessageHandler:self name:@"log"];
    
    //rewrite the method of console.log
    NSString *jsCode = @"\
    console.log = (function(logFunc){\
        return function(str) {\
            window.webkit.messageHandlers.log.postMessage(str);\
            logFunc.call(console,str);\
    }\
    })(console.log);";
    //injected the method when H5 starts to create the DOM tree
    [config.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
}

@end
