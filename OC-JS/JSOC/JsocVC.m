//
//  JsocVC.m
//  OC-JS
//
//  Created by macpro on 2017/11/22.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "JsocVC.h"
#import "HqJSObject.h"

@interface JsocVC ()<UIWebViewDelegate,JavaScriptObjectiveCDelegate>

@property (nonatomic,strong) HqJSObject *ocObj;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) UIBarButtonItem *leftItem;

@end

@implementation JsocVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initView];

}
- (void)initView{
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    NSString *htmlPath = @"www/html/index";
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPath ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [_webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OC调用js" style:UIBarButtonItemStylePlain target:self action:@selector(getToken)];
    _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    _ocObj = [[HqJSObject alloc] init];
}
- (void)back{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}
- (void)getToken{
    //获取js的方法名
    JSValue *function = self.context[@"getToken"];
    //调用方法并传递参数
    [function callWithArguments:@[@"1234567890"]];
    
}
#pragma mark -
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //self.context[@"OCObject"] = _ocObj;
    /*将OC对象传递给JS，然后js就可以直接用OCObject来调用实现JSExport
    协议的方法，在js中的方法如下：
     callNativeMethod自己起名
     function callNativeMethod() {
         console.log("ovNative---");
         OCObject.completeOpen();
     }
    */
    self.context[@"OCObject"] = self;


    //定义好JS要调用的方法, share就是调用的share方法名
    // 打印异常,由于JS的异常信息是不会在OC中被直接打印的,所以我们在这里添加打印异常信息,
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常信息==%@", exceptionValue);
    };

    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = _leftItem;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    __weak typeof(self) weakSelf = self;
    //这里的appToken是js的方法，这可以监听到appToken
    self.context[@"appToken"] = ^() {
        NSLog(@"appToken");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"jsVal==%@", jsVal.toString);
        }
        //回传参数
        [weakSelf getToken];
        
    };
    
    self.context[@"complete"] = ^() {
        NSLog(@"OC开户完成");
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
#pragma mark - 实现JSExport的方法
- (void)completeOpen{
    NSLog(@"completeOpen");
}
- (void)showAlert:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle{
    NSLog(@"showAlert:msg:buttonTitle");

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:btnTitle, nil];
        [alert show];
    });
  
}


@end
