//
//  HistoryTripCollectionViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/24.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryTripColletionCell.h"
#import "TripMapViewController.h"
#import "SlideViewController.h"
#import "DataAccess.h"
#import "HistoryTripCollectionHeaderView.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface HistoryTripCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>{
    
    
    NSArray *allTripArray;
    NSString *selectedTripName;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBtnOutlet;
@property (strong, nonatomic) IBOutlet UICollectionView  *tripColllectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(UIImage *)getTheFirstImageForTrip: (TRIP *)trip;
- (void) showDeleteActionSheet: (UILongPressGestureRecognizer *)recognizer;
- (void) fetchDeleteActionSheet;
- (IBAction)barBtn_add_pressed:(id)sender;

- (void)categorizeTrips;

@end
