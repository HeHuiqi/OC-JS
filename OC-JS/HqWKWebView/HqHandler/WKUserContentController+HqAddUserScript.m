//
//  WKUserContentController+HqAddUserScript.m
//  OC-JS
//
//  Created by hehuiqi on 2020/11/2.
//  Copyright © 2020 macpro. All rights reserved.
//

#import "WKUserContentController+HqAddUserScript.h"

@implementation WKUserContentController (HqAddUserScript)


- (WKUserScript *)injectLogScript{
    NSString *source = @"\
    console.log = (function(logFunc){\
        return function(str) {\
            window.webkit.messageHandlers.log.postMessage(str);\
            logFunc.call(console,str);\
    }\
    })(console.log);";
    return  [self injectScript:source];
}
- (WKUserScript *)injectErrorScript{
    NSString *source = @"\
    (function () {\
        var abc = function(errormsg,url,line){\
            var msg = '错误了: ' + '{' + errormsg + '}' + 'url:' + url + '  Line:' + line;\
            console.log(msg);\
        };\
        window.onerror = abc;\
    })();";
    
    return  [self injectScript:source];
}

- (WKUserScript *)injectScript:(NSString *)source{
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:source injectionTime:(WKUserScriptInjectionTimeAtDocumentEnd) forMainFrameOnly:NO];
    return userScript;
}

- (void)hqAddErrorScript:(id)object{
    WKUserScript *script = [self injectErrorScript];
    
    [self addUserScript:script];
    [self addScriptMessageHandler:object name:@"error"];

}
- (void)hqAddLogScript:(id)object{
    WKUserScript *script = [self injectLogScript];
    [self addUserScript:script];
    [self addScriptMessageHandler:object name:@"log"];
}
- (void)hqAddUserScript:(NSString *)userSript{
    WKUserScript *script = [self injectScript:userSript];
    [self addUserScript:script];
}
- (void)showLog:(id)object{
    [self hqAddLogScript:object];
    [self hqAddErrorScript:object];
}
@end
