//
//  ViewController.m
//  StudyDemo
//
//  Created by DOUBLEQ on 2018/8/20.
//  Copyright © 2018年 DOUBLE Q. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *wkweb;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *getNameBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testWKJS];
}
- (void)testWKJS{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"webViewApp22"];
    self.wkweb = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-100) configuration:config];
    self.wkweb.UIDelegate = self;
    [self.view addSubview:self.wkweb];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]]];
    [self.wkweb loadRequest:request];
   
}
//app注册方法后，js调用ios的委托
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *body = (NSDictionary *)message.body;
    if (body && [body isKindOfClass:[NSDictionary class]]) {
        NSString *method = [NSString stringWithFormat:@"%@",body[@"method"]];
        NSString *param1 = [NSString stringWithFormat:@"%@",body[@"param1"]];
        if ([method isEqualToString:@"hello"]) {
            [self hello:param1];
        }
    }
}
//js端的alert需要客户端协助才能弹框，其实就是js告诉客户端我要弹框了，然后客户端负责实现弹框。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    completionHandler();
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"客户端弹框" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:ok];
    [alertCon addAction:cancle];
    [self presentViewController:alertCon animated:YES completion:nil];
}
//js调用本地方法
-(void)hello:(NSString *)name{
    NSLog(@"js-调用本地方法-name=%@",name);
}
//app调用js方法
- (IBAction)button1:(id)sender {
    [self.wkweb evaluateJavaScript:@"hi()" completionHandler:nil];
}
//app调用js并传递值@“123”
- (IBAction)button2:(id)sender {
    [self.wkweb evaluateJavaScript:@"hello('wqq')" completionHandler:nil];
}
//app调用js方法并从js获取值
- (IBAction)getName:(id)sender {
    [self.wkweb evaluateJavaScript:@"getName()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result===%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
