//
//  MtgManager.h
//  Test_Sonoba_01
//
//  Created by admin on 4/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UDP_REQUEST_TIMES           20
#define IS_NOT_APPLYING_PRSENTER    (__INT_MAX__  *2U +1U)  //最大的UINT

@class CONNREQ;
@class CONNRES;
@class PRESREQ;
@class PRESRES;
@class SYNCREQ;

@class SynchronousInfo;

@interface NSObject (ViewDelegate)
// 当主持人申请事件结果出来之后被调用，isAgreed是YES时为申请被允许，反之为不允许
- (void) onReceiveResultOfApplyingPresenter:(BOOL)isAgreed;
// 当收到其他主持人发过来的同步数据时调用，信息封装在SynchronousInfo类的对象info中
- (void) onReceiveSynchronizationInfo:(SynchronousInfo*)info;
// 当收到有人主动申请获取同步消息的时候
- (void) onReceiveActiveInfoRequest;
@end

@interface MtgManager : NSObject
{
    BOOL        isPresenter;                // 是否在主持
    BOOL        isSynchronizing;            // 是否在同步中
    
    NSUInteger  connectionCounter;          // 连接数计数器
    NSUInteger  statisticalCounter;         // 统计计数器，当为IS_NOT_APPLYING_PRSENTER时为非统计状态
    
    id          MtgDelegate;                // 委托指针
}

@property (nonatomic, assign) BOOL isPresenter, isSynchronizing;
@property (nonatomic, assign) NSUInteger connectionCounter, statisticalCounter;
@property (nonatomic, retain) id MtgDelegate;

#pragma mark - Recommand To Use

+ (MtgManager*)instance;

- (id) initWithMtgDelegate:(id)delegate;

// 申请成为主持人
- (void) applyPresenter;
// 申请放弃主持
- (void) giveUpPresenter;
// 设置同步状态
- (void) setSynchronizationState:(BOOL)state;
// 发送同步信息（当且仅当成为主持人时）
- (void) sendSynchronizationInfo:(SynchronousInfo*)cmd;

#pragma mark - Don't Recommand To Use

- (void) handleCONNREQ:(CONNREQ*)cmd fromHost:ip;
- (void) handleCONNRES:(CONNRES*)cmd fromHost:ip;
- (void) handlePRESREQ:(PRESREQ*)cmd fromHost:ip;
- (void) handlePRESRES:(PRESRES*)cmd fromHost:ip;

@end
