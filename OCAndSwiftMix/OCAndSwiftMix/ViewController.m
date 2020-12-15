//
//  ViewController.m
//  OCAndSwiftMix
//
//  Created by nathan on 2020/12/14.
//

#import "ViewController.h"
#import "OCAndSwiftMix-Swift.h"
#import "OCAndSwiftMix-Bridging-Header.h"

@interface ViewController ()

@property(nonatomic,strong) BarChartView *barView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SwiftViewController *swiftVc = [[SwiftViewController alloc]init];
    [swiftVc ocUserSwift];
    
    [self userCharts];
    
}

- (void)swiftUseOC{
    NSLog(@"swiftUseOC");
}


- (void)userCharts{
    self.barView = [[BarChartView alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    [self.view addSubview:self.barView];
}
@end
