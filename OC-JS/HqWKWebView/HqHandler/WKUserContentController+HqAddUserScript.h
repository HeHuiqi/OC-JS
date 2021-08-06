//
//  WKUserContentController+HqAddUserScript.h
//  OC-JS
//
//  Created by hehuiqi on 2020/11/2.
//  Copyright © 2020 macpro. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKUserContentController (HqAddUserScript)

- (void)hqAddErrorScript:(id)object;
- (void)hqAddLogScript:(id)object;
- (void)hqAddUserScript:(NSString *)userSript;
- (void)showLog:(id)object;
@end

NS_ASSUME_NONNULL_END
