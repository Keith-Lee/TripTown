//
//  SlideViewController.m
//  TripTown
//
//  Created by MIS on 13/6/2.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "SlideViewController.h"
#import "TripMapViewController.h"

@interface SlideViewController ()

@end

@implementation SlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    TripMapViewController *trip=[self.storyboard instantiateViewControllerWithIdentifier:@"Trip"];
    [trip setIsNewTrip:self.isNewTrip];
    [trip setIsOngoingTrip:self.isOngoingTrip];
    [trip setIsHistoryTrip:self.isHistoryTrip];
    self.topViewController = trip;
    /*
     TripMapViewController *category=segue.destinationViewController;
     //NSString *sentence = [getid componentsJoinedByString:@","];
     category.categoryId=[getid componentsJoinedByString:@","];
     category.categoryName=@"Nearby";
     category.isNewTrip = NO;
     category.isOngoingTrip = YES;
     category.isHistoryTrip = NO;
     */
        
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
