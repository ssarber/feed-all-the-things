//
//  KCShot.m
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import "KCShot.h"

@implementation KCShot

- (id)initWithThumbnail:(NSString*)thumbnail heartCount:(NSNumber*)heartCount videoURL:(NSString*)videoURL
{
    self = [super init];
    if (self)
    {
        _thumbnail = thumbnail;
        _heartCount = heartCount;
        _videoURL = videoURL;
    }
    return self;
}
@end
