//
//  REQUEST.m
//  Test_Sonoba_01
//
//  Created by admin on 4/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "REQUEST.h"

@implementation REQUEST

@synthesize data;

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:data forKey:REQ_DATA_KEY];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) 
    {
        self.data = [aDecoder decodeObjectForKey:REQ_DATA_KEY];
    }
    return self;
}

@end
