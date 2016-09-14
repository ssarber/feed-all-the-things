//
//  KCShotsFeedCollectionViewCell.h
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCShotsFeedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shotImage;
@property (weak, nonatomic) IBOutlet UILabel *heartCountLabel;

@end
