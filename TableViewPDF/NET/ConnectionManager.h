//
//  ConnectionManager.h
//  Test_Sonoba_01
//
//  Created by admin on 4/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define COMMAND_TYPE_LEN        0
#define COMMAND_TYPE_NORMAL     1

#define SERVER_PORT_TCP         6001
#define SERVER_PORT_UDP         6000

@class AsyncSocket;
@class AsyncUdpSocket;

@interface NSObject (CommandDelegate)
- (void) onRecieveCommand:(NSObject *)cmd fromHost:(NSString *)ip;
- (void) onSendDataCommandComplete:(NSString *)ip;
- (void) onConnect:(NSString *)ip;
- (void) onDisconnect:(NSString *)ip;
@end

@interface ConnectionManager : NSObject
{
    AsyncSocket         *tcpHostSocket;
    AsyncUdpSocket      *udpHostSocket;
    
    NSString            *broadcastIpAddr;
    NSString            *localIpAddr;
    NSString            *localMacAddr;
    
    NSMutableDictionary *connectedSockets;
    NSMutableSet        *connectingSockets;
    
    id                   commandDelegate;
}

@property (nonatomic, retain) NSString              *broadcastIpAddr;
@property (nonatomic, retain) NSString              *localIpAddr;
@property (nonatomic, retain) NSString              *localMacAddr;
@property (nonatomic, retain) NSMutableDictionary   *connectedSockets;
@property (nonatomic, retain) NSMutableSet          *connectingSockets;

+ (ConnectionManager*) instance;

- (id) initWithCommandDelegate:(id)delegate;

- (void) broadcastCommand:(NSObject*)cmd;
- (void) broadcastCommand:(NSObject *)cmd toHost:(NSString*)hostIp;

- (void) connectToHost:(NSString*)hostIp;
- (void) sendCommand:(NSObject*)cmd toHost:(NSString*)hostIp;
- (void) sendCommand:(NSObject *)cmd toHost:(NSString *)hostIp tag:(long)tag;

- (void) disconnectAllSockets;
- (void) disconnectSocketByIp:(NSString*)hostIp;

@end
