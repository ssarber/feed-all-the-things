//
//  KCShot.h
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


@interface KCShot : NSObject

@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSNumber *heartCount;
@property (strong, nonatomic) NSString *videoURL;
@property (strong, nonatomic) UIImage *image;

- (id)initWithThumbnail:(NSString*)thumbnail
             heartCount:(NSString*)heartCount
               videoURL:(NSString*)videoURL;

@end
