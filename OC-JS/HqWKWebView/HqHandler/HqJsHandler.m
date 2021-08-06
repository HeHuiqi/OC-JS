//
//  HqHandler.m
//  OC-JS
//
//  Created by hqmac on 2018/12/6.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqJsHandler.h"
#import "WKUserContentController+HqAddUserScript.h"
@interface HqJsHandler()<WKScriptMessageHandler>

@property (nonatomic,strong) WKUserContentController *userContentController;
@property(nonatomic,assign) BOOL isShowLog;

@end
@implementation HqJsHandler

- (void)dealloc{
    NSLog(@"HqHandler-dealloc");
}
- (instancetype)init{
    //异常的名称
    NSString *exceptionName = @"Init exception";
    //异常的原因
    NSString *exceptionReason = @"Can't init,please use jsHandlerWithWebView: method";
    //异常的信息
    NSDictionary *exceptionUserInfo = nil;

    NSException *exception = [NSException exceptionWithName:exceptionName reason:exceptionReason userInfo:exceptionUserInfo];
    //抛异常
    @throw exception;
    
    return nil;
}
- (instancetype)_init{
    if (self = [super init]) {
        
    }
    return self;
}
+ (HqJsHandler *)jsHandlerWithWebView:(WKWebView *)webView{
    HqJsHandler *js = [[HqJsHandler alloc] _init];
    [js configUserJsWithWebView:webView];
    return js;
}
- (void)configUserJsWithWebView:(WKWebView *)webView{
    
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
        NSString *msgId = message.body[HqMessageId];
        id params = message.body[HqParams];
        if (self.hqHandlerBlock) {
            self.hqHandlerBlock(msgId, params);
        }
        if ([self.delegate respondsToSelector:@selector(hqJsHandler:messageId:params:)] && self.delegate) {
            [self.delegate hqJsHandler:self messageId:msgId params:params];
        }
    }else{
        if ([message.name isEqualToString:@"log"]) {
            NSLog(@"JSlog:\n%@",message.body);
        }
    }
}

- (void)callbackJsWithDic:(NSDictionary *)dic{
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    NSString *callBack = [NSString stringWithFormat:@"HqJsHandler.onNativeCallback(%@);",jsonStr];
    [self.webView evaluateJavaScript:callBack completionHandler:^(id _Nullable resp , NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"resp==%@",resp);
            NSLog(@"error==%@",error);
        }
        
    }];
    
}
- (void)showLog{
    [self.userContentController hqAddLogScript:self];
    [self.userContentController hqAddErrorScript:self];
    self.isShowLog = YES;
    /*
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
    */
}
- (void)removeAllScriptMessageHandlers{
    if (self.isShowLog) {
        [self.userContentController removeScriptMessageHandlerForName:@"log"];
        [self.userContentController removeScriptMessageHandlerForName:@"error"];
    }
    [self.userContentController removeScriptMessageHandlerForName:HqJsHanderName];
}

@end
