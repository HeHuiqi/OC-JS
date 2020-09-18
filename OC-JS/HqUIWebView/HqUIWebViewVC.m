//
//  HqUIWebViewVC.m
//  OC-JS
//
//  Created by hqmac on 2018/12/5.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqUIWebViewVC.h"
#import "HqJSCore/HqJSObject.h"
@interface HqUIWebViewVC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) HqJSObject *jsObject;

@end

@implementation HqUIWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"UIWebView";
    NSString *htmlPath = @"www/html/index1";
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPath ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"调用JS" style:UIBarButtonItemStylePlain target:self action:@selector(invokeJS)];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)invokeJS{
    if (self.context) {
       
        [self.context evaluateScript:@"requestUserInfo(12345)"];
//        [self.webView stringByEvaluatingJavaScriptFromString:@"requestUserInfo(12345)"];
//        JSValue *jsFun = self.context[@"requestUserInfo"];
//        [jsFun callWithArguments:@[@(12345)]];

    }
}

- (HqJSObject *)jsObject{
    if (!_jsObject) {
        _jsObject = [[HqJSObject alloc] init];
    }
    return _jsObject;
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}
#pragma mark -  UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
  
    self.context[@"NativeObject"] = self.jsObject;
    /*将OC对象传递给JS，然后js就可以直接用NativeObject来调用实现JSExport
     协议的方法，在js中的方法如下：
     function btnClick() {
         console.log("调用Native方法");
         NativeObject.completeOpen();
     }
     */
    
    //定义好JS要调用的方法, share就是调用的share方法名
    // 打印异常,由于JS的异常信息是不会在OC中被直接打印的,所以我们在这里添加打印异常信息,
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常信息==%@", exceptionValue);
    };
    
    //这里的appToken是js的方法，这样可以监听到appToken
    self.context[@"appToken"] = ^() {
        NSLog(@"appToken");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"jsVal==%@", jsVal.toString);
        }
        
    };
    
    self.context[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@"H5  log : %@", msg);
    };
    self.context[@"console"][@"warn"] = ^(JSValue * msg) {
        NSLog(@"H5  warn : %@", msg);
    };
    self.context[@"console"][@"error"] = ^(JSValue * msg) {
        NSLog(@"H5  error : %@", msg);
    };
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
