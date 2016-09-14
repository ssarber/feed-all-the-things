//
//  KCAPIClient.h
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVKit;

@interface KCAPIClient : NSObject

typedef void (^KCAPIClientImageFetchingBlock)(UIImage *image, BOOL success, NSError *error);
typedef void (^KCAPIClientBasicCompletionBlock)(BOOL success, NSError *error);

+ (id)sharedClient;

- (void)fetchMediaImageAssetWithPath:(NSString *)imagePath
                          completion:(KCAPIClientImageFetchingBlock)completionBlock
                               error:(KCAPIClientBasicCompletionBlock)errorBlock;

@end
