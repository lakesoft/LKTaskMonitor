//
//  LKGenericTask.m
//  LKTaskMonitor
//
//  Created by Hiroshi Hashiguchi on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKGenericTask.h"

typedef enum {
    LKTaskStateDoing = 0,
    LKTaskStateFinished
} LKTaskState;

@interface LKGenericTask()
@property (nonatomic, assign) LKTaskType type;
@property (nonatomic, assign) LKTaskState state;
@end


@implementation LKGenericTask

@synthesize type;
@synthesize state;

- (id)init {
    self = [super init];
    if (self) {
        self.type = LKTaskTypeGenericTask;
        self.state = LKTaskStateDoing;
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}


- (void)finish
{
    self.state = LKTaskStateFinished;
}

- (BOOL)hasFinished
{
    return (self.state == LKTaskStateFinished);
}

@end
