//
//  KCShotDataProvider.h
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCShotDataProvider : NSObject

typedef void (^KCAPIClientArrayBlock)(NSArray *array);
typedef void (^KCAPIClientBasicErrorBlock)(NSError *error);


+ (void)fetchShotsWithCompletion:(KCAPIClientArrayBlock)completionBlock
                           error:(KCAPIClientBasicErrorBlock)errorBlock;

@end
