//
//  ConnectionManager.m
//  Test_Sonoba_01
//
//  Created by admin on 4/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ConnectionManager.h"

#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

#import "UIDeviceHardware.h"

#import <arpa/inet.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>

#pragma mark Utility Methods

// 数据化对象，最终生成一个NSData对象
NSData* archiveObject(NSObject *object)
{
    NSMutableData   *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeRootObject:object];
    [archiver finishEncoding];
    [archiver release];
    return data;
}

// 获取IP地址
NSString* getIpAddress()
{
    // iPhone的Wi-Fi总是"en0"
    NSString                *address = @"N/A";
    
    struct ifaddrs          *addrs;
    const struct ifaddrs    *cursor;
    
    if (0 == getifaddrs(&addrs)) 
    {
        cursor = addrs;
        while (NULL != cursor) 
        {
            if ((strcmp(cursor->ifa_name, "en0") == 0) && (cursor->ifa_addr->sa_family == AF_INET)) 
            {
                // 从一个C字符串中获取地址
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)cursor->ifa_addr)->sin_addr)];
                cursor = NULL;
            }
            else
            {
                cursor = cursor->ifa_next;
            }
        }
        freeifaddrs(addrs);
    }
    return address;
}

// 获取模拟器的IP地址
NSString* getSimulatorIpAddress()
{
    // iPhone模拟器的Wi-Fi总是"en1"
    NSString                *address = @"N/A";
    
    struct ifaddrs          *addrs;
    const struct ifaddrs    *cursor;
    
    if (0 == getifaddrs(&addrs)) 
    {
        cursor = addrs;
        while (NULL != cursor) 
        {
            if ((strcmp(cursor->ifa_name, "en1") == 0) && (cursor->ifa_addr->sa_family == AF_INET)) 
            {
                // 从一个C字符串中获取地址
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)cursor->ifa_addr)->sin_addr)];
                cursor = NULL;
            }
            else
            {
                cursor = cursor->ifa_next;
            }
        }
        freeifaddrs(addrs);
    }
    return address;
}

// 获取广播地址
NSString* getBroadcastAddress()
{
    NSString                *address = @"N/A";
    
    struct ifaddrs          *addrs;
    const struct ifaddrs    *cursor;
    
    if (0 == getifaddrs(&addrs)) 
    {
        cursor = addrs;
        while (NULL != cursor) 
        {
            if ((strcmp(cursor->ifa_name, "en0") == 0) && (cursor->ifa_addr->sa_family == AF_INET)) 
            {
                // 从一个C字符串中获取地址
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)cursor->ifa_dstaddr)->sin_addr)];
                cursor = NULL;
            }
            else
            {
                cursor = cursor->ifa_next;
            }
        }
        freeifaddrs(addrs);
    }
    return address;
}

// 获取模拟器广播地址
NSString* getSimulatorBroadcastAddress()
{
    NSString                *address = @"N/A";
    
    struct ifaddrs          *addrs;
    const struct ifaddrs    *cursor;
    
    if (0 == getifaddrs(&addrs)) 
    {
        cursor = addrs;
        while (NULL != cursor) 
        {
            if ((strcmp(cursor->ifa_name, "en1") == 0) && (cursor->ifa_addr->sa_family == AF_INET)) 
            {
                // 从一个C字符串中获取地址
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)cursor->ifa_dstaddr)->sin_addr)];
                cursor = NULL;
            }
            else
            {
                cursor = cursor->ifa_next;
            }
        }
        freeifaddrs(addrs);
    }
    return address;
}

#ifndef IFT_ETHER
#define IFT_ETHER 0x6
#endif

// 获取MAC地址
NSString* getMacAddress()
{
    NSMutableString             *mac = [[NSMutableString alloc]initWithString:@"N/A"];
    struct ifaddrs              *addrs;
    const struct ifaddrs        *cursor;
    const struct sockaddr_dl    *dlAddr;
    const uint8_t               *base;          
    
    if (0 == getifaddrs(&addrs)) 
    {
        cursor = addrs;
        while (NULL != cursor) 
        {
            if ((cursor->ifa_addr->sa_family == AF_LINK) && (((const struct sockaddr_dl*)cursor->ifa_addr)->sdl_type == IFT_ETHER))
            {
                dlAddr = (const struct sockaddr_dl*)cursor->ifa_addr;
                base = (const uint8_t*)&dlAddr->sdl_data[dlAddr->sdl_nlen];
                [mac setString:@""];
                for (int i = 0; i < dlAddr->sdl_alen; ++i) 
                {
                    if (0 != i) 
                    {
                        [mac appendString:@":"];
                        fprintf(stderr, ":");
                    }
                    [mac appendFormat:@"%02x", base[i]];
                }
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return mac;
}

// 获取模拟器MAC地址
NSString* getSimulatorMacAddress()
{
    NSMutableString             *mac = [[NSMutableString alloc]initWithString:@"N/A"];
    struct ifaddrs              *addrs;
    const struct ifaddrs        *cursor;
    const struct sockaddr_dl    *dlAddr;
    const uint8_t               *base;          
    
    if (0 == getifaddrs(&addrs)) 
    {
        cursor = addrs;
        while (NULL != cursor) 
        {
            if ((cursor->ifa_addr->sa_family == AF_LINK) 
                && (((const struct sockaddr_dl*)cursor->ifa_addr)->sdl_type == IFT_ETHER)
                && [[NSString stringWithUTF8String:cursor->ifa_name]isEqualToString:@"en1"])
            {
                dlAddr = (const struct sockaddr_dl*)cursor->ifa_addr;
                base = (const uint8_t*)&dlAddr->sdl_data[dlAddr->sdl_nlen];
                [mac setString:@""];
                for (int i = 0; i < dlAddr->sdl_alen; ++i) 
                {
                    if (0 != i) 
                    {
                        [mac appendString:@":"];
                        fprintf(stderr, ":");
                    }
                    [mac appendFormat:@"%02x", base[i]];
                }
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return mac;
}

@implementation ConnectionManager

@synthesize broadcastIpAddr, localIpAddr, localMacAddr;
@synthesize connectedSockets;
@synthesize connectingSockets;

#pragma mark - Singleton Object Init Methods

static ConnectionManager * connectionManagerInstance = nil;

+ (ConnectionManager*)instance
{
    @synchronized(self)
    {
        if (nil == connectionManagerInstance) 
        {
            [[self alloc]init];
        }
    }
    return connectionManagerInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == connectionManagerInstance) 
        {
            connectionManagerInstance = [super allocWithZone:zone];
            return connectionManagerInstance;
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
    
- (id) init
{
//    if (connectionManagerInstance) 
//    {
//        return connectionManagerInstance;
//    }
    
    NSError *error = nil;
    
    if (self = [super init]) 
    {
        // 初始化Asyncsocket中的对象
        tcpHostSocket = [[AsyncSocket alloc]initWithDelegate:self];
        udpHostSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
        
        // 将系统设置为支持广播
        if (![udpHostSocket enableBroadcast:TRUE error:&error]) 
        {
            NSLog(@"CM - Error UDP enableBroadcast: %@", error);
            return nil;
        }
        
        // 初始化保存连接的词典
        connectedSockets = [[NSMutableDictionary alloc]init];
        connectingSockets = [[NSMutableSet alloc]init];
        
        //获取一些设备信息
        UIDeviceHardware *h = [[UIDeviceHardware alloc]init];
        NSString *platform = [h platform];
        // 获取IP地址
        if ([platform isEqualToString:@"i386"]) 
        {
            localIpAddr = getSimulatorIpAddress();
        }
        else
        {
            localIpAddr = getIpAddress();
        }
        [localIpAddr retain];
        NSLog(@"CM - localIpAddr:%@", localIpAddr);
        if ([localIpAddr isEqualToString:@"N/A"]) {
            return nil;
        }
        // 获取MAC地址
        if ([platform isEqualToString:@"i386"]) 
        {
            localMacAddr = getSimulatorMacAddress();
        }
        else
        {
            localMacAddr = getMacAddress();
        }
        [localMacAddr retain];
        NSLog(@"CM - localMacAddr:%@", localMacAddr);
        // 获取广播地址
        if ([platform isEqualToString:@"i386"]) 
        {
            broadcastIpAddr = getSimulatorBroadcastAddress();
        }
        else
        {
            broadcastIpAddr = getBroadcastAddress();
        }
        [h release];
        
        // 绑定UDP监听端口
        NSLog(@"CM - Broadcast to:%@ init UDP", broadcastIpAddr);
        if (![udpHostSocket bindToPort:SERVER_PORT_UDP error:&error]) 
        {
            NSLog(@"CM - Error UDP bindToPort:%@", error);
            return nil;
        }
        // UDP开始接收消息
        [udpHostSocket receiveWithTimeout:-1 tag:COMMAND_TYPE_NORMAL];
        NSLog(@"CM - Start Listen on:%@ init UDP", getIpAddress());
        
        // TCP开始监听端口
        if (![tcpHostSocket acceptOnPort:SERVER_PORT_TCP error:&error]) 
        {
            NSLog(@"CM - Error TCP acceptOnPort: %@", error);
            return nil;
        }
    }
    return self;
}

- (BOOL) reInitSocket
{
    // 关闭连接 START
    if (tcpHostSocket) 
    {
        [tcpHostSocket disconnect];
        [tcpHostSocket release];
        tcpHostSocket = nil;
    }
    if (udpHostSocket) 
    {
        [udpHostSocket close];
        [udpHostSocket release];
        udpHostSocket = nil;
    }
    // 关闭连接 END
    
    // 获取新的地址信息 START
    UIDeviceHardware *h = [[UIDeviceHardware alloc]init];
    NSString *platform = [h platform];
    // 获取新的IP地址
    [localIpAddr release];
    if ([platform isEqualToString:@"i386"]) 
    {
        localIpAddr = getSimulatorIpAddress();
    }
    else
    {
        localIpAddr = getIpAddress();
    }
    [localIpAddr retain];
    NSLog(@"CM - localIpAddr:%@", localIpAddr);
    if ([localIpAddr isEqualToString:@"N/A"]) {
        return  NO;
    }
    // 获取新的MAC地址
    [localMacAddr release];
    if ([platform isEqualToString:@"i386"]) 
    {
        localMacAddr = getSimulatorMacAddress();
    }
    else
    {
        localMacAddr = getMacAddress();
    }
    [localMacAddr retain];
    NSLog(@"CM - localMacAddr:%@", localMacAddr);
    // 获取新的广播地址
    [broadcastIpAddr release];
    if ([platform isEqualToString:@"i386"]) 
    {
        broadcastIpAddr = getSimulatorBroadcastAddress();
    }
    else
    {
        broadcastIpAddr = getBroadcastAddress();
    }
    [h release];
    // 获取新的地址信息 END
    
    
    NSError *error = nil;
    
    // 重新初始化2个Asyncsocket类
    tcpHostSocket = [[AsyncSocket alloc]initWithDelegate:self];
    udpHostSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    
    // 将系统设置为支持广播
    if (![udpHostSocket enableBroadcast:TRUE error:&error]) 
    {
        NSLog(@"CM - Error UDP enableBroadcast: %@", error);
        return NO;
    }
    
    // 绑定UDP监听端口
    NSLog(@"CM - Broadcast to:%@ init UDP", broadcastIpAddr);
    if (![udpHostSocket bindToPort:SERVER_PORT_UDP error:&error]) 
    {
        NSLog(@"CM - Error UDP bindToPort:%@", error);
        return NO;
    }
    // UDP开始接收消息
    [udpHostSocket receiveWithTimeout:-1 tag:COMMAND_TYPE_NORMAL];
    NSLog(@"CM - Start Listen on:%@ init UDP", getIpAddress());
    
    // TCP开始监听端口
    if (![tcpHostSocket acceptOnPort:SERVER_PORT_TCP error:&error]) 
    {
        NSLog(@"CM - Error TCP acceptOnPort: %@", error);
        return NO;
    }    
    return YES;
}

- (id) initWithCommandDelegate:(id)delegate
{
    commandDelegate = delegate;
    
    return self;
}

#pragma mark - Commands and Connection Methods

// 断开所有连接
- (void) disconnectAllSockets
{
    id obj;
    NSEnumerator *enumerator = [connectedSockets objectEnumerator];
    while (obj = [enumerator nextObject]) 
    {
        [(AsyncSocket*)obj disconnect];
    }
    [connectedSockets removeAllObjects];
}

// 断开指定IP的连接
- (void) disconnectSocketByIp:(NSString *)hostIp
{
    NSLog(@"#### will disconnectScoketByIp: %@", hostIp);
    if (nil == hostIp) 
    {
        return;
    }
    
    AsyncSocket *socket = (AsyncSocket*)[connectedSockets objectForKey:hostIp];
    if (nil != socket) 
    {
        NSLog(@"#### did disconnectScoketByIp that nil != socket");
        [socket disconnect];
    }
    else
    {
        return;
    }
    
    // 将对象从词典中删除
    [connectedSockets removeObjectForKey:hostIp];
    
    // 调用委托
    if ([commandDelegate respondsToSelector:@selector(onDisconnect:)]) 
    {
        [commandDelegate onDisconnect:hostIp];
    }
}

// 将自己的消息广播给所有人
- (void) broadcastCommand:(NSObject *)cmd
{
    NSData *cmdData = archiveObject(cmd);   // 打包数据
    [udpHostSocket sendData:cmdData toHost:broadcastIpAddr port:SERVER_PORT_UDP withTimeout:-1 tag:COMMAND_TYPE_NORMAL];
    NSLog(@"CM - Broadcast CMD: %@(%u) By UDP to host: %@", cmd, [cmdData length], broadcastIpAddr);
    [cmdData release];
}

// 将自己的消息发送给特定主机（UDP）
- (void) broadcastCommand:(NSObject *)cmd toHost:(NSString *)hostIp
{
    NSData *cmdData = archiveObject(cmd);
    [udpHostSocket sendData:cmdData toHost:hostIp port:SERVER_PORT_UDP withTimeout:-1 tag:COMMAND_TYPE_NORMAL];
    NSLog(@"CM - Broadcast CMD: %@(%u) By UDP to host: %@", cmd, [cmdData length], hostIp);
    [cmdData release];
}

// TCP连接到特定主机
- (void) connectToHost:(NSString *)hostIp
{
    AsyncSocket *tcpSocket = [[AsyncSocket alloc]initWithDelegate:self];
    NSError *error = nil;
    if (![tcpSocket connectToHost:hostIp onPort:SERVER_PORT_TCP error:&error]) 
    {
        NSLog(@"CM - Error conncecToHost: %@", error);
        [tcpSocket release];
    }
    else
    {
        NSLog(@"CM - Succeed Setup a TCP Connection to Host: %@", hostIp);
    }
}

- (void) sendCommand:(NSObject *)cmd toHost:(NSString *)hostIp
{
    [self sendCommand:cmd toHost:hostIp tag:COMMAND_TYPE_NORMAL];
}

- (void) sendCommand:(NSObject *)cmd toHost:(NSString *)hostIp tag:(long)tag
{
    // 获取IP地址对应的socket
    AsyncSocket *socket = (AsyncSocket*)[connectedSockets objectForKey:hostIp];
    if (nil != socket) 
    {
        NSData *cmdData = archiveObject(cmd);
        NSLog(@"CM - Send Cmd: %@(%u) to host: %@", cmd, [cmdData length], hostIp);
        
        // 获取长度信息并封装到一个NSData中
        NSUInteger len = [cmdData length];
        NSData *lenData = [NSData dataWithBytes: &len length:sizeof(NSUInteger)];
        
        // 把2个NSData先后发送出去
        [socket writeData:lenData withTimeout:-1 tag:COMMAND_TYPE_LEN];
        [socket writeData:cmdData withTimeout:-1 tag:tag];
        
        // 释放内存
        [cmdData release];
    }
}

#pragma mark - TCP Delgate Methods

// 当有新的连接要过来时
- (void) onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    // 得到新的socket可以只需要先retain下即可，之后的事情在onSocket:didConnectToHost中进行
    [newSocket retain];
}

// 当已经创建一个新的连接后
- (void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    // 注意，这里的sock是刚刚连接到的对方的socket...似乎是这样
    NSLog(@"CM - Connected: %@", host);
    // 首先准备获取一个NSUInterge大小的数据
    [sock readDataToLength:sizeof(NSUInteger) withTimeout:-1 tag:COMMAND_TYPE_LEN];
    // 把新连接到的socket加入到词典中
    [connectedSockets setObject:sock forKey:host];
    
    // 调用委托
    if ([commandDelegate respondsToSelector:@selector(onConnect:)])
    {
        [commandDelegate onConnect:host];
    }
}

- (void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //
}

// 当读到一条消息时
- (void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 如果收到的包是一个“数据包长度”的包，那么就开始准备接收该长度的数据包
    if (COMMAND_TYPE_LEN == tag) 
    {
        NSUInteger *len = (NSUInteger*)[data bytes];
        [sock readDataToLength:*len withTimeout:-1 tag:COMMAND_TYPE_NORMAL];
        return;
    }
    
    // 获取客户端IP
    NSString *clientIp = [sock connectedHost];
    // 创建一个解绑定data的解码器，并将解出的对象放到object中
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id object = [[[unarchiver decodeObject] retain] autorelease];

    if ([commandDelegate respondsToSelector:@selector(onRecieveCommand:fromHost:)]) 
    {
        [commandDelegate onRecieveCommand:object fromHost:clientIp];
    }
    
    [unarchiver release];
    
    // 获取下一个数据包的数据长度包
    [sock readDataToLength:sizeof(NSUInteger) withTimeout:-1 tag:COMMAND_TYPE_LEN];
}

- (void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"CM - willDisconnectWithError: %@: %u: %@", [sock connectedHost], [sock connectedPort], [err localizedDescription]);
    
    // 获取所断开连接的IP地址
    NSString *clientIp = [sock connectedHost];
    // 如果是有效的IP地址
    if (clientIp != nil) 
    {
        [connectedSockets removeObjectForKey:clientIp];
        
        // 将connectingSockets中得变量删除，运行接受其之后得UDP消息
        [connectingSockets removeObject:clientIp];
    }
    
    if ([commandDelegate respondsToSelector:@selector(onDisconnect:)]) 
    {
        [commandDelegate onDisconnect:clientIp];
    }
}

- (void) onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"CM - Disconnected:%@: %u", [sock connectedHost], [sock connectedPort]);
    [sock release];
}

#pragma mark - UDP Delgate Methods

- (BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    // 忽略自己
    if ([host rangeOfString:localIpAddr].location != NSNotFound) 
    {
        return FALSE;
    }
    
    // 忽略重复
    if ([connectingSockets containsObject:host]) {
        return FALSE;
    }
    
    [connectingSockets addObject:host];
    
    // 数据解码
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id object = [[[unarchiver decodeObject] retain] autorelease];
    
    NSLog(@"CM - Read UDP Cmd: %@(%u)", object, [data length]);
    
    if ([commandDelegate respondsToSelector:@selector(onRecieveCommand:fromHost:)]) 
    {
        [commandDelegate onRecieveCommand:object fromHost:host];
    }
    
    [unarchiver release];
    
    // UDP继续接收消息
    [udpHostSocket receiveWithTimeout:-1 tag:COMMAND_TYPE_NORMAL];
    
    return TRUE;
}

@end
