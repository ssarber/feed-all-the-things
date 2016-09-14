//
//  KCAPIClient.m
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import "KCAPIClient.h"


@implementation KCAPIClient

+ (instancetype)sharedClient
{
    static KCAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}


- (void)fetchMediaImageAssetWithPath:(NSString *)imagePath
                    completion:(KCAPIClientImageFetchingBlock)completionBlock
                         error:(KCAPIClientBasicCompletionBlock)errorBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            completionBlock(image, YES, nil);
        }
    });
}

@end
