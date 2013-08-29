//
//  SynchronousInfo.m
//  Test_Sonoba_01
//
//  Created by admin on 4/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SynchronousInfo.h"

@implementation SynchronousInfo

@synthesize pathName;
@synthesize pageNumber;

- (id)init
{
    self = [super init];
    if (self) {
        pathName = @"";
        pageNumber = UNVALIDINIT;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:pathName forKey:@"pathName"];
    [aCoder encodeInteger:pageNumber forKey:@"pageNumber"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) 
    {
        pathName = [aDecoder decodeObjectForKey:@"pathName"];
        pageNumber = [aDecoder decodeIntegerForKey:@"pageNumber"];
    }
    return self;
}

@end
