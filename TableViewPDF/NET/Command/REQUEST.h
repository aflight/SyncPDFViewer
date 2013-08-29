//
//  REQUEST.h
//  Test_Sonoba_01
//
//  Created by admin on 4/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQ_DATA_KEY (@"reqdatakey")

@interface REQUEST : NSObject <NSCoding>
{
    NSData *data;
}

@property (nonatomic, retain) NSData *data;

@end
