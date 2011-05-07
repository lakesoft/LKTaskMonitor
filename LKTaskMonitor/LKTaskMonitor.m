//
//  LKTaskMonitor.m
//  LKTaskMonitor
//
//  Created by Hiroshi Hashiguchi on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKTaskMonitor.h"

#import "LKGenericTask.h"
#import "LKUserTask.h"
#import "LKAsynchronousTask.h"


@interface LKTaskMonitor()
@property (nonatomic, retain) NSMutableDictionary* tasks;
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, copy) void (^completionTaskType)(LKTaskType);

@property (nonatomic, assign) BOOL finished;
@end

@implementation LKTaskMonitor

@synthesize tasks;
@synthesize finished;
@synthesize completion;
@synthesize completionTaskType;

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Initialization and deallocation
//------------------------------------------------------------------------------

- (id)initWithCompletion:(void(^)(void))aCompletion completionTaskType:(void(^)(LKTaskType))aCompletionTaskType
{
    self = [super init];
    if (self) {
        self.tasks = [NSMutableDictionary dictionary];
        self.finished = NO;
        self.completion = aCompletion;
        self.completionTaskType = aCompletionTaskType;
    }
    return self;
}

- (void)dealloc {
    self.tasks = nil;
    [super dealloc];
}

+ (LKTaskMonitor*)taskMonitorCompletion:(void(^)(void))aCompletion completionTaskType:(void(^)(LKTaskType))aCompletionTaskType
{
    return [[[self alloc] initWithCompletion:aCompletion
                          completionTaskType:aCompletionTaskType] autorelease];
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark API
//------------------------------------------------------------------------------
- (void)addTaskType:(LKTaskType)type name:(NSString*)name
{
    LKGenericTask* task = nil;
    switch (type) {
        case LKTaskTypeGenericTask:
            task = [[LKGenericTask alloc] init];
            break;
            
        case LKTaskTypeUserTask:
            task = [[LKUserTask alloc] init];
            break;
            
        case LKTaskTypeAsynchronousTask:
            task = [[LKAsynchronousTask alloc] init];
            break;
            
        default:
            break;
    }
    if (task) {
        [self.tasks setObject:task forKey:name];
        [task release];
        self.finished = NO;
    }
}

- (void)finishTaskName:(NSString*)taskName
{
    if (self.finished) {
        return;
    }

    LKGenericTask* finishedTask = [self.tasks objectForKey:taskName];
    if (finishedTask) {
        if ([finishedTask hasFinished]) {
            return;
            // no reaction
        } else {
            [finishedTask finish];
        }
    }
    
    BOOL allTaskDone = YES;
    BOOL currentTypeTaskDone = YES;

    for (NSString* name in [self.tasks keyEnumerator]) {
        LKGenericTask* task = [self.tasks objectForKey:name];
        if (![task hasFinished]) {
            allTaskDone = NO;
            if (task.type == finishedTask.type) {
                currentTypeTaskDone = NO;
            }
        }
    }
    if (currentTypeTaskDone) {
        self.completionTaskType(finishedTask.type);
    }

    if (allTaskDone) {
        self.finished = YES;
        self.completion();
    }
}


@end
