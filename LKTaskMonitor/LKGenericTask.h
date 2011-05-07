//
//  LKGenericTask.h
//  LKTaskMonitor
//
//  Created by Hiroshi Hashiguchi on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKTaskType.h"

@interface LKGenericTask : NSObject {
    LKTaskType type;
}
@property (nonatomic, assign, readonly) LKTaskType type;

// API
- (void)finish;
- (BOOL)hasFinished;

@end
