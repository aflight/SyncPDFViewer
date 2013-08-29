//
//  MTGRES.h
//  Test_Sonoba_01
//
//  Created by admin on 4/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 当对方发送CONNREQ消息之后，向对方反馈的CONNRES链接请求确认消息。使用UDP定向发送。
// 对方收到这个消息后，会试图建立TCP链接。
// 程序参数只有一个BOOL类型，YES为同意建立连接，反之则不同意。注意：初始化为NO。

@interface CONNRES : NSObject <NSCoding>
{
    BOOL isAgreed;
}
@property (nonatomic, assign) BOOL isAgreed;

@end
