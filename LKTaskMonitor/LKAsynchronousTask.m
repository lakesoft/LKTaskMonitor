//
//  LKAsynchronousTask.m
//  LKTaskMonitor
//
//  Created by Hiroshi Hashiguchi on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKAsynchronousTask.h"


@implementation LKAsynchronousTask

- (id)init {
    self = [super init];
    if (self) {
        type = LKTaskTypeAsynchronousTask;
    }
    return self;
}


@end
