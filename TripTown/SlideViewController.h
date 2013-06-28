//
//  SlideViewController.h
//  TripTown
//
//  Created by MIS on 13/6/2.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "ECSlidingViewController.h"
#import <UIKit/UIKit.h>

@interface SlideViewController : ECSlidingViewController

@property (nonatomic) BOOL isNewTrip;
@property (nonatomic) BOOL isOngoingTrip;
@property (nonatomic) BOOL isHistoryTrip;

@end
