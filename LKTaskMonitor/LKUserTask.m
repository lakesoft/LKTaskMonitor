//
//  LKUserTask.m
//  LKTaskMonitor
//
//  Created by Hiroshi Hashiguchi on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKUserTask.h"


@implementation LKUserTask

- (id)init {
    self = [super init];
    if (self) {
        type = LKTaskTypeUserTask;
    }
    return self;
}

@end
