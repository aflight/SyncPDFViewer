//
//  PRESRES.h
//  Test_Sonoba_01
//
//  Created by admin on 4/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 当对方发送PRESREQ消息之后，向对方反馈的PRESRES链接请求确认消息。使用TCP定向发送。
// 程序参数只有一个BOOL类型，YES为同意成为主持人，反之则不同意。注意：1.初始化为NO；2.只有当全员同意后才能当主持
@interface PRESRES : NSObject <NSCoding>
{
    BOOL isAgreed;
}
@property (nonatomic, assign) BOOL isAgreed;

@end
