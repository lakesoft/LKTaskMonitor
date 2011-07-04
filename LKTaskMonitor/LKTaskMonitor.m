//
// Copyright (c) 2011 Hiroshi Hashiguchi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
    if (name == nil) {
        return;
    }

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

- (void)removeTaskName:(NSString*)taskName
{
    if (taskName == nil) {
        return;
    }
    [self.tasks removeObjectForKey:taskName];
}

- (void)setTaskName:(NSString*)taskName enbale:(BOOL)enabled
{
    if (taskName == nil) {
        return;
    }
   
}

- (void)finishTaskName:(NSString*)taskName
{
    if (taskName == nil) {
        return;
    }
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
        if (![task hasFinished] && task.enabled) {
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
