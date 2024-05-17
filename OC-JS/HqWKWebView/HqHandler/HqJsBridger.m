//
//  HqHandler.m
//  OC-JS
//
//  Created by hqmac on 2018/12/6.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqJsBridger.h"
#import "WKUserContentController+HqAddUserScript.h"
@interface HqJsBridger()<WKScriptMessageHandler>

@property (nonatomic,strong) WKUserContentController *userContentController;
@property(nonatomic,assign) BOOL isShowLog;

@end
@implementation HqJsBridger

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
+ (HqJsBridger *)jsHandlerWithWebView:(WKWebView *)webView{
    HqJsBridger *js = [[HqJsBridger alloc] _init];
    [js configUserJsWithWebView:webView];
    return js;
}
- (void)configUserJsWithWebView:(WKWebView *)webView{
    
    WKWebViewConfiguration *config = webView.configuration;
    self.webView = webView;
    self.userContentController = config.userContentController;
    
    //添加处理js消息的代理名称
    [config.userContentController addScriptMessageHandler:self name:HqJsHanderName];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"message.name:%@",message.name);
    NSLog(@"message.body:%@",message.body);

    if ([message.name isEqualToString:HqJsHanderName]) {
        id params = message.body[HqParams];
        NSString *msgId = message.body[HqMessageId];
        if (self.hqBridgeBlock) {
            self.hqBridgeBlock(msgId, params);
        }
        if ([self.delegate respondsToSelector:@selector(hqJsBridger:messageId:params:)] && self.delegate) {
            [self.delegate hqJsBridger:self messageId:msgId params:params];
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
    //向js传递数据统一用json字符串
    NSString *callBack = [NSString stringWithFormat:@"javascript:HqJsBridge.jsCallback(%@);",jsonStr];


    [self.webView evaluateJavaScript:callBack completionHandler:^(id _Nullable resp , NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"resp==%@",resp);
            NSLog(@"error==%@",error);
        }
        
    }];
    
}
- (void)callbackJsWithDic:(NSDictionary *)dic callbackId:(NSString *)callbackId {
    NSData *json = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    //向js传递数据统一用json字符串
    NSString *callBack = [NSString stringWithFormat:@"javascript:HqJsBridge.jsCallbacks['homeList'](%@);",jsonStr];
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
    
    //移除Handler时会出现一些系统打印的错误log，暂时不用管
    [self.userContentController removeScriptMessageHandlerForName:HqJsHanderName];
    if (self.isShowLog) {
        [self.userContentController removeScriptMessageHandlerForName:@"log"];
        [self.userContentController removeScriptMessageHandlerForName:@"error"];
    }
}

@end
