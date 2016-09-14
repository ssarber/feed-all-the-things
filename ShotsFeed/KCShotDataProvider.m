//
//  KCShotDataProvider.m
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import "KCShotDataProvider.h"
#import "KCShot.h"


@implementation KCShotDataProvider

static NSString *const kShotsEndpoint = @"https://api.staging.kamcord.com/v1/feed/set/featuredShots?count=15";

+ (void)fetchShotsWithCompletion:(KCAPIClientArrayBlock)completionBlock
                           error:(KCAPIClientBasicErrorBlock)errorBlock
{
    NSURL *url = [NSURL URLWithString:kShotsEndpoint];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"en" forHTTPHeaderField:@"accept-language"];
    [request setValue:@"abc123" forHTTPHeaderField:@"device-token"];
    [request setValue:@"ios" forHTTPHeaderField:@"client-name"];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                         completionHandler:^(NSData *data,
                                                                                             NSURLResponse *response,
                                                                                             NSError *error) {
                                                                                             
        NSDictionary *shotsDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                                             
        NSMutableArray *shotObjects = [NSMutableArray new];
                                                                             
         if ([shotsDict isKindOfClass:[NSDictionary class]]) {
             
             for (NSDictionary *item in [shotsDict objectForKey:@"groups"]) {
                 NSArray *shots = [item objectForKey:@"cards"];
                 for (NSArray *s in shots) {
                     KCShot *shot = [[KCShot alloc] initWithThumbnail:[s valueForKeyPath:@"shotCardData.shotThumbnail.small"]
                                                           heartCount:[s valueForKeyPath:@"shotCardData.heartCount"]
                                                             videoURL:[s valueForKeyPath:@"shotCardData.play.mp4"]];
                     
                     [shotObjects addObject:shot];
                 }
             }
         }
                                                                             
        if (completionBlock) {
            completionBlock(shotObjects);
        }
   }];

    [downloadTask resume];
}

@end
