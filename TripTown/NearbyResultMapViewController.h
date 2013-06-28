//
//  NearbyResultMapViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ProjectAppDelegate.h"

@interface NearbyResultMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    
    NSString *result;
    CLLocationCoordinate2D currentLocation;
    //MKMapView *mapView;
    NSTimer *timeToReupdate;
    NSInteger timeLeftToReupdate;
    
}

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *categoryId;
@property (strong,nonatomic) NSString *categoryName;
//@property (strong,nonatomic) NSString *result;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
- (void)countTime;
- (void)timeReset;

@end
