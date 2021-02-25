//
//  JSAndOCCallViewController.m
//  WKWebViewSample
//
//  Created by nathan on 2021/2/25.
//  Copyright © 2021 nathan. All rights reserved.
//

#import "JSAndOCCallViewController.h"
#import <WebKit/WebKit.h>
@interface JSAndOCCallViewController ()<WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *wkWebView;

@end

@implementation JSAndOCCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"与原生交互";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"原生调用js" style:UIBarButtonItemStylePlain target:self action:@selector(ocCallJs:)];
    
    [self.view addSubview:self.wkWebView];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

- (void)ocCallJs:(UIBarButtonItem *)sender{
    [self.wkWebView evaluateJavaScript:@"ocCallJsNoParams()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"调用失败：%@",error);
        }else{
            NSLog(@"调用成功");
        }
    }];
    
    NSString *jsString = [NSString stringWithFormat:@"changeColor('%@')", @"Js颜色参数"];
    [self.wkWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"改变HTML的背景色");
    }];
}

- (WKWebView *)wkWebView{
    if (_wkWebView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        WKUserContentController *ucVc = [[WKUserContentController alloc]init];
        config.userContentController = ucVc;
        [ucVc addScriptMessageHandler:self name:@"jsCallOCNoParams"];
        [ucVc addScriptMessageHandler:self name:@"jsCallOCParams"];
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 64) configuration:config];
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.UIDelegate = self;
 
    }
    return _wkWebView;
}

#pragma mark -UIDelegate
// JS弹窗（alert）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//js调用原生
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"方法名：%@", message.name);
    NSLog(@"参数：%@", message.body);
    NSDictionary * parameter = message.body;
    //JS调用OC
    if([message.name isEqualToString:@"jsCallOCNoParams"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:@"不带参数" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if([message.name isEqualToString:@"jsCallOCParams"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:parameter[@"params"] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
