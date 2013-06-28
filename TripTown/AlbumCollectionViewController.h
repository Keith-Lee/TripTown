//
//  AlbumCollectionViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/15.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumCollectionViewCell.h"
#import "AlbumPhotoHeaderView.h"
#import "AlbumScrollViewController.h"
#import "DataAccess.h"

@interface AlbumCollectionViewController : UIViewController < UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControlOutlet;
@property (strong, nonatomic) IBOutlet UICollectionView *albumCollectionView;
- (IBAction)barBtn_back_pressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtnOutlet;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControll_sortingMethod;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)segment_sortingMethodChanged:(id)sender;


@end
