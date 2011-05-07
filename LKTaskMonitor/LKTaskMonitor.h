//
//  LKTaskMonitor.h
//  LKTaskMonitor
//
//  Created by Hiroshi Hashiguchi on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKGenericTask.h"
#import "LKTaskType.h"

@interface LKTaskMonitor : NSObject {
    
}

@property (nonatomic, assign, readonly) BOOL finished;

+ (LKTaskMonitor*)taskMonitorCompletion:(void(^)(void))aCompletion completionTaskType:(void(^)(LKTaskType))aCompletionTaskType;

// API
- (void)addTaskType:(LKTaskType)type name:(NSString*)name;
- (void)finishTaskName:(NSString*)taskName;

@end
