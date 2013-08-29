//
//  MtgManager.m
//  Test_Sonoba_01
//
//  Created by admin on 4/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MtgManager.h"

#import "ConnectionManager.h"

#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

// 指令类 START
#import "SynchronousInfo.h"
#import "CONNREQ.h"
#import "CONNRES.h"
#import "PRESREQ.h"
#import "PRESRES.h"
#import "SYNCREQ.h"
// 指令类 END

@implementation MtgManager

@synthesize isPresenter, isSynchronizing;
@synthesize connectionCounter, statisticalCounter;
@synthesize MtgDelegate;

// 重载一些类和方法来制造一个单例对象
#pragma mark - Singleton Object Init Methods

static MtgManager* mtgManagerInstance = nil;

+ (MtgManager*) instance
{
    @synchronized(self)
    {
        if (nil == mtgManagerInstance) 
        {
            // 在调用[[self alloc] init]时，会自动默认调用+(id)allocWithZone:(NSZone*)zone
            if (![[self alloc] init]) 
            {
                [mtgManagerInstance release];
                mtgManagerInstance = nil;
            }
        }
    }
    return mtgManagerInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == mtgManagerInstance) 
        {
            mtgManagerInstance = [super allocWithZone:zone];
            return mtgManagerInstance;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (oneway void) release
{}

- (id) retain
{
    return self;
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return UINT_MAX;
}

// 主要的初始化函数
- (id) init
{
    //NSError *error = nil;
    
    if (self = [super init]) 
    {
        // 设置委托对象
        if (![[ConnectionManager instance] initWithCommandDelegate:self]) 
        {
            return nil;
        }
        
        // 初始化成员变量
        isPresenter = NO;
        isSynchronizing = NO;
        connectionCounter = 0;
        statisticalCounter = IS_NOT_APPLYING_PRSENTER;
        
        // 向周围发送UDP广播通知自己的信息
        CONNREQ *req = [[CONNREQ alloc]init];
        
        for (int i = 0; i < UDP_REQUEST_TIMES; ++i)     // 发送20次
        {
            [[ConnectionManager instance]broadcastCommand:req];
        }
        [req release];
    }
    return self;
}

// 接受委托设置
- (id) initWithMtgDelegate:(id)delegate
{
    MtgDelegate = delegate;
    return self;
}

#pragma mark - Commands Methods

// 申请成为主持人
- (void) applyPresenter
{
    if (isPresenter || connectionCounter == 0)   // 如果已经是主持或连接数是0
    {
        isPresenter = YES;
        
        // 直接反馈正消息
        if ([MtgDelegate respondsToSelector:@selector(onReceiveResultOfApplyingPresenter:)]) 
        {
            [MtgDelegate onReceiveResultOfApplyingPresenter:YES];
        }
        
        return;
    }
    
    // 将统计计数器设置为0，开始计数。
    statisticalCounter = 0;
    
    // 创建申请主持消息类
    PRESREQ *req = [[PRESREQ alloc]init];
    
    [[ConnectionManager instance].connectedSockets enumerateKeysAndObjectsUsingBlock:^(NSString* ip, AsyncSocket* AS, BOOL *stop) {
        [[ConnectionManager instance] sendCommand:req toHost:[AS connectedHost]];
    }];
//    id obj = nil;
//    NSEnumerator *enumerator = [[ConnectionManager instance].connectedSockets keyEnumerator];
//    while (obj = [enumerator nextObject])   // 遍历整个词典
//    {   // 向词典中的每一个对象发送主持申请信息
//        //[[ConnectionManager instance] sendCommand:req toHost:[(AsyncSocket*)obj connectedHost]];
//        //[[ConnectionManager instance] sendCommand:req toHost:@"192.1.112.37"];
//        
//        //NSString *add = [(AsyncSocket*)obj connectedHost];
//        NSString *add = [[[ConnectionManager instance].connectedSockets objectForKey:obj] connectedHost] ;
//        [[ConnectionManager instance] sendCommand:req toHost:add];
//    }
    
    [req release];
}

// 申请放弃主持
- (void) giveUpPresenter
{
    isPresenter = NO;
}

// 设置同步状态
- (void) setSynchronizationState:(BOOL)state
{
    isSynchronizing = state;
    
    // 如果时设置成同步状态，那么向主持人发送申请获取主持人当前状态的信息（由于主持人未知，所以群发）
    if (state)
    {
        SYNCREQ *req = [[SYNCREQ alloc]init];
        
        [[ConnectionManager instance].connectedSockets enumerateKeysAndObjectsUsingBlock:^(NSString* ip, AsyncSocket* AS, BOOL *stop) {
            [[ConnectionManager instance] sendCommand:req toHost:[AS connectedHost]];
        }];
        
        [req release];
    }
}

// 发送同步信息（当且仅当成为主持人时）
- (void) sendSynchronizationInfo:(SynchronousInfo*)cmd
{
    if (YES == isPresenter)     // 当自己是主持人时
    {
        [[ConnectionManager instance].connectedSockets enumerateKeysAndObjectsUsingBlock:^(NSString* ip, AsyncSocket* AS, BOOL *stop) {
            [[ConnectionManager instance] sendCommand:cmd toHost:[AS connectedHost]];
        }];
    }
}

#pragma mark - Delegate Methods

// 当收到消息后执行
- (void) onRecieveCommand:(NSObject *)cmd fromHost:(NSString *)ip
{
    NSLog(@"MM - onRecieveCommand: %@ fromHost: %@", cmd, ip);
    
    // 根据收到的类的类别选择特定的处理函数来处理
    if ([cmd isKindOfClass:[SynchronousInfo class]])
    {
        [self handleSynchronousInfo:(SynchronousInfo*)cmd fromHost:ip];
    }
    else if ([cmd isKindOfClass:[CONNREQ class]])
    {
        [self handleCONNREQ:(CONNREQ*)cmd fromHost:ip];
    } 
    else if ([cmd isKindOfClass:[CONNRES class]])
    {
        [self handleCONNRES:(CONNRES*)cmd fromHost:ip];
    }
    else if ([cmd isKindOfClass:[PRESREQ class]])
    {
        [self handlePRESREQ:(PRESREQ*)cmd fromHost:ip];
    }
    else if ([cmd isKindOfClass:[PRESRES class]])
    {
        [self handlePRESRES:(PRESRES*)cmd fromHost:ip];
    }
    else if ([cmd isKindOfClass:[SYNCREQ class]])
    {
        [self handleSYNCREQ:(SYNCREQ*)cmd fromHost:ip];
    }
}

// 当建立连接后执行
- (void) onConnect:(NSString *)ip
{
    ++connectionCounter;        // 连接数计数器＋1
    NSLog(@"MM - Number of connection after onConnect: %d", connectionCounter);
}

// 当断开连接后执行
- (void) onDisconnect:(NSString *)ip
{
    --connectionCounter;        // 连接数计数器－1
    
    NSLog(@"MM - Number of connection after onDisconnect: %d", connectionCounter);
}

#pragma mark - Massage Handler Function

- (void) handleSynchronousInfo:(SynchronousInfo*)cmd fromHost:ip
{
    if (isSynchronizing)
    {
        // 如果时同步状态
        if ([MtgDelegate respondsToSelector:@selector(onReceiveSynchronizationInfo:)])
        {
            [MtgDelegate onReceiveSynchronizationInfo:cmd];
        }
    }
}

- (void) handleCONNREQ:(CONNREQ*)cmd fromHost:ip
{
    // 创建一个连接请求反馈，并设置为同意
    CONNRES *res = [[CONNRES alloc]init];
    res.isAgreed = YES;
    
    for (int i = 0; i < UDP_REQUEST_TIMES; ++i) // 发送20次
    {
        [[ConnectionManager instance]broadcastCommand:res toHost:ip];
    }
    
    [res release];
}

- (void) handleCONNRES:(CONNRES*)cmd fromHost:ip
{
    // 试图与对方建立TCP连接
    [[ConnectionManager instance]connectToHost:ip];
}

- (void) handlePRESREQ:(PRESREQ*)cmd fromHost:ip
{
    // 检查自己的主持状态，发送反馈
    PRESRES *res = [[PRESRES alloc]init];
    if (isPresenter)        // 如果正在主持，则不允许
    {
        res.isAgreed = NO;
        NSLog(@"MM - Presenter Request FROM %@ Received, RESPOND: NO", ip);
    }
    else
    {
        res.isAgreed = YES;
        NSLog(@"MM - Presenter Request FROM %@ Received, RESPOND: YES", ip);
    }
    [[ConnectionManager instance]sendCommand:res toHost:ip];
    
    [res release];
}

- (void) handlePRESRES:(PRESRES*)cmd fromHost:ip
{
    // 如果没有在申请主持，直接退出
    if (IS_NOT_APPLYING_PRSENTER == statisticalCounter) 
    {
        return;
    }
    
    if (cmd.isAgreed)   // 如果同意
    {
        ++statisticalCounter;
        NSLog(@"MM - Presenter Request Answer: %d/%d", statisticalCounter, connectionCounter);
        if (statisticalCounter >= connectionCounter) // 和connectionCounter做比较
        {   // 相同的话将统计器设置为非统计状态并发送成功信息
            statisticalCounter = IS_NOT_APPLYING_PRSENTER;
            isPresenter = YES;
            if ([MtgDelegate respondsToSelector:@selector(onReceiveResultOfApplyingPresenter:)]) 
            {
                [MtgDelegate onReceiveResultOfApplyingPresenter:YES];
            }
        }
        else
        {
            return;
        }
    }
    else               // 如果不同意
    {
        //将统计器设置为非统计状态并返回失败消息
        NSLog(@"MM - Presenter Request is Disagreed");
        statisticalCounter = IS_NOT_APPLYING_PRSENTER;
        if ([MtgDelegate respondsToSelector:@selector(onReceiveResultOfApplyingPresenter:)]) 
        {
            [MtgDelegate onReceiveResultOfApplyingPresenter:NO];
        }
    }
}

- (void) handleSYNCREQ:(SYNCREQ*)cmd fromHost:ip
{
    // 如果自己时主持人则处理此消息
    if (isPresenter)
    {
        if ([MtgDelegate respondsToSelector:@selector(onReceiveActiveInfoRequest)])
        {
            [MtgDelegate onReceiveActiveInfoRequest];
        }
    }
}

@end
