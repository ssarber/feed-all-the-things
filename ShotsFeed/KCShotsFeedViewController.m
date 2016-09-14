//
//  KCShotsFeedViewController.m
//  ShotsFeed
//
//  Created by Zook Gek on 9/5/16.
//  Copyright © 2016 Stan Sarber. All rights reserved.
//

#import "KCShotsFeedViewController.h"
#import "KCShotsFeedCollectionViewCell.h"
#import "KCShotDataProvider.h"
#import "KCAPIClient.h"
#import "KCShot.h"
@import AVKit;
@import AVFoundation;

@interface KCShotsFeedViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *shots;
@property (strong, nonatomic) NSMutableArray *thumbnailURLs;

@end

@implementation KCShotsFeedViewController

static NSString * const cellReuseIdentifier = @"KCShotsFeedCollectionCellReuseID";


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        [self fetchShots];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


- (void)fetchShots
{
    [KCShotDataProvider fetchShotsWithCompletion:^(NSArray *array)  {
        
        __weak typeof(self) weakSelf = self;
         weakSelf.shots = array;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    } error:^(NSError *error) {
        NSLog(@"Failed to fetch shots.");
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shots.count;
}
                                 

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCShotsFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    KCShot *shot = [self.shots objectAtIndex:indexPath.row];
    
    if (shot.image) {
        cell.shotImage.image = shot.image;
    } else {
    
        NSString *thumbUrlString = (NSString *)shot.thumbnail;
        
        if (thumbUrlString != nil) {
            
            cell.shotImage.image = nil;

            [[KCAPIClient sharedClient] fetchMediaImageAssetWithPath:thumbUrlString completion:^(UIImage *image, BOOL success, NSError *error) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.shotImage.contentMode = UIViewContentModeScaleAspectFit;
                    cell.shotImage.clipsToBounds = YES;
                    cell.shotImage.image = image;
                    [cell.heartCountLabel setText:[shot.heartCount stringValue]];
                    
                    // Cache the image for better performance when scrolling up
                    shot.image = image;
                });
            } error:nil];
        }
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeScale(0.0, 0.0);

    [UIView beginAnimations:@"scale" context:nil];
    
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    
    cell.transform = CGAffineTransformIdentity;
    cell.alpha = 1;
    
    [UIView commitAnimations];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCShot *shot = [self.shots objectAtIndex:indexPath.row];
    NSString *videoURLString = (NSString *)shot.videoURL;
    
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:NO completion:nil];
    [playerViewController.player play];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    BOOL isIPad = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
    
    // Display 5 rows if running on iPad or 3 on an iPhone
    float cellWidth = isIPad? screenWidth / 5.0 - 10.0 : screenWidth / 3.0 - 10.0;

    CGSize size = CGSizeMake(cellWidth, 175);
    
    return size;
}

@end
