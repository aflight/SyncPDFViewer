//
//  SynchronousInfo.h
//  Test_Sonoba_01
//
//  Created by admin on 4/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UNVALIDINIT (__INT_MAX__  *2U +1U)

@interface SynchronousInfo : NSObject <NSCoding>
{
    NSString        *pathName;
    NSInteger        pageNumber;
}

@property (nonatomic, strong) NSString *pathName;
@property (nonatomic, assign) NSInteger pageNumber;

@end
