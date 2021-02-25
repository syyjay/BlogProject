//
//  ViewController.m
//  WKWebViewSample
//
//  Created by nathan on 2021/2/24.
//  Copyright © 2021 nathan. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "JSAndOCCallViewController.h"

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *wkWebView;

@property(nonatomic,strong)UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.wkWebView];
    [self.wkWebView addSubview:self.progressView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.mogu.com/"]]];
    
//    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"原生交互" style:UIBarButtonItemStylePlain target:self action:@selector(jsOCAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"与原生交互" style:UIBarButtonItemStylePlain target:self action:@selector(jsOCAction:)];
}

- (void)dealloc{
    //移除观察者
    [_wkWebView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_wkWebView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}

- (void)jsOCAction:(UIBarButtonItem *)sender{
    [self.navigationController pushViewController:[JSAndOCCallViewController new] animated:YES];
}

- (WKWebView *)wkWebView{
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 64)];
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        //添加监测网页加载进度的观察者
        [_wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        //添加监测网页标题title的观察者
        [_wkWebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 1)];
        
    }
    return _progressView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == _wkWebView) {
        self.progressView.progress = _wkWebView.estimatedProgress;
        if (_wkWebView.estimatedProgress >= 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == _wkWebView){
        self.title = _wkWebView.title;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate

/*
 WKNavigationDelegate ：主要处理一些跳转、加载处理操作
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载失败");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"开始返回内容");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"提交发生错误");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"重定向了");
}

//  根据webview对于即将跳转的http请求信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//  根据客户端收到的服务器的相应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString *urlString = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转的地址：%@",urlString);
//    decisionHandler(WKNavigationResponsePolicyAllow);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//  需要相应身份验证时调用
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//
//}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"进程被终止");
}
@end
