//
//  TripMapViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataAccess.h"
#import "MyAnnotation.h"
#import "PhotoEditingViewController.h"
#import "AccessoryDetailViewController.h"
#import "AlbumCollectionViewController.h"
#import "ECSlidingViewController.h"
#import <RestKit/RestKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Venue.h"
#import "MenuViewController.h"
#import "UICustomActionSheet.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <AddressBook/AddressBook.h>


@interface TripMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>{
    UIImagePickerController *m_imagePickerController;
    CLLocationCoordinate2D currentLocation;
    NSString *addressToPass;
    NSMutableArray *getCategory;
    NSMutableDictionary *target;
    NSMutableArray *targetarray;
    
    BOOL isCustomLocationSet;
  //  UIImage tmpimage;
}


#pragma mark - Outlet property
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtnOutlet;
@property (weak, nonatomic) IBOutlet UINavigationItem *mapViewNavigation;
@property (weak, nonatomic) IBOutlet MKMapView *userTripMapView;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton_camera;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton_nearby;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton_Album;
@property (weak, nonatomic) IBOutlet UIButton *btn_endTrip;
@property (strong, nonatomic) IBOutlet UIButton *btn_camera;
@property (strong, nonatomic) IBOutlet UIButton *btn_Custom;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtn_settings;

#pragma mark - other property
@property (strong, nonatomic) NSString *tripName;
//@property (strong, nonatomic) NSMutableDictionary *target;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *mapLongPressGesture;

//分辨 TRIP 的狀態
@property (nonatomic) BOOL isNewTrip;
@property (nonatomic) BOOL isOngoingTrip;
@property (nonatomic) BOOL isHistoryTrip;

//Need to figure out why this property should be created;
@property (nonatomic, assign) id <UIImagePickerControllerDelegate, UINavigationControllerDelegate> delegate;

- (void)zoomToLocationWithCoordinate:(CLLocationCoordinate2D)coordinate;

#pragma mark - setup method
- (void) callGiveNewTripNameAlertView;
- (void) callSameNameTripNameAlertView;
- (void) checkUserLocationAuthorizationStatus;
- (BOOL) isNetworkReachable;


#pragma mark - button-related method
- (IBAction)btn_Camera_Pressed:(id)sender;
- (IBAction)btn_endTrip_pressed:(id)sender;
- (IBAction)barBtn_back_pressed:(id)sender;
- (IBAction)btn_locating_pressed:(id)sender;
- (IBAction)btn_album_pressed:(id)sender;
- (IBAction)btn_custom_pressed:(id)sender;


@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *categoryId;
@property (strong,nonatomic) NSString *categoryName;

#pragma mark - map-related method
- (void) addAnnotationsOnMap;
- (void) addCustomLocationAnnotationOnMap;
- (void) drawPolylineOnMap;
- (void) callEndEnsureAlertView;
- (void) createCustomLocationWithLongPressGesture:(UIGestureRecognizer*)sender;
- (void) createCustomLocation;
- (void) createImageSourceActionSheet;

@end
