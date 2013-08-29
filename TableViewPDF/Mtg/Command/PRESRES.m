//
//  PRESRES.m
//  Test_Sonoba_01
//
//  Created by admin on 4/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PRESRES.h"

@implementation PRESRES

@synthesize isAgreed;

- (id)init {
    self = [super init];
    if (self) {
        isAgreed = NO;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:isAgreed forKey:@"BOOL"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) 
    {
        isAgreed = [aDecoder decodeBoolForKey:@"BOOL"];
    }
    return self;
}

@end
