//
//  HqWebVC.m
//  OC-JS
//
//  Created by hqmac on 2018/12/5.
//  Copyright © 2018 macpro. All rights reserved.
//

#import "HqWebVC.h"
#import "HqUIWebView/HqWKWebViewVC.h"
#import "HqWKWebView/HqUIWebViewVC.h"
@interface HqWebVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HqWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC-JS";
    self.titles = @[@"UIWebView",@"WKWebView"];
    [self.view addSubview:self.tableView];

}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            {
                HqUIWebViewVC *webVC = [HqUIWebViewVC new];
                [self.navigationController pushViewController:webVC animated:YES];
            }
            break;
        case 1:
        {
            HqWKWebViewVC *webVC = [HqWKWebViewVC new];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            
        default:
            break;
    }
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
