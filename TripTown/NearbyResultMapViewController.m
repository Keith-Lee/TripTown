//
//  NearbyResultMapViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "NearbyResultMapViewController.h"
#import <RestKit/RestKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Venue.h"
#import <CoreLocation/CoreLocation.h>

#define kCLIENTID "LV3TKJ3FKSE5S33PDO005H5CKJIXGVXNMTYKHBU2GKWD5RBV"
#define kCLIENTSECRET "O1MZ1KASL52BYH0TBNN3DPPGRVKPLFIAYW4FOPW2GA1P24NY"

@interface NearbyResultMapViewController (){}
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation NearbyResultMapViewController

@synthesize data,categoryId,categoryName;

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
    self.mapView.showsUserLocation=YES;
    self.mapView.delegate = self;
    self.infoView.alpha = 0.0f;
    //[self timeReset];
    timeToReupdate = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
}
-(void) viewDidDisappear:(BOOL)animated{
    [timeToReupdate invalidate];
    //timeLeftToReupdate = 5;
}

// Deprecated in iOS 6
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    currentLocation = newLocation.coordinate;

    
}
- (void) start{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com/v2"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    [RKObjectManager setSharedManager:objectManager];
    //ProjectAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Locations class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
    RKRelationshipMapping *relation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping];
    [venueMapping addPropertyMapping:relation];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping addAttributeMappingsFromArray:@[@"checkinsCount", @"tipCount", @"usersCount"]];
    RKRelationshipMapping *statsRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping];
    [venueMapping addPropertyMapping:statsRelation];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                                                       pathPattern:nil
                                                                                           keyPath:@"response.venues"
                                                                                       statusCodes:nil];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [self sendRequest];
    
}
- (void) sendRequest {
    
    NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.longitude];
    NSString *str = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
    
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    NSDictionary *queryParams;
    
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:str, @"ll", clientID, @"client_id", clientSecret, @"client_secret",@"800",@"radius",categoryId, @"categoryId", @"20130513", @"v", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //NSURL *url = [NSURL URLWithString:@"/venues/search"];
    [objectManager getObjectsAtPath:@"/v2/venues/search" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSLog(@"objects[%d]", [[mappingResult array] count]);
                                data = [mappingResult array];
                                //[s reloadData];
                                for (int i = 0; i<[data count]; i++) {
                                    Venue *venue = [data objectAtIndex:i];
                                    CLLocationCoordinate2D loc;
                                    loc.latitude=venue.location.lat.floatValue;
                                    loc.longitude=venue.location.lng.floatValue;
                                    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
                                    ann.coordinate = loc;
                                    [ann setTitle:venue.name];
                                    NSString *dis = [NSString stringWithFormat:@"about %@m",venue.location.distance];
                                    [ann setSubtitle:dis];
                                    [self.mapView addAnnotation:ann];
                                }
                                
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    
}
-(void)countTime{
    if(timeLeftToReupdate > 0){
        timeLeftToReupdate -= 1;
        NSLog(@"%i seconds to reupdate the map.", timeLeftToReupdate);
    }
    else{
        //將畫面挪至使用者位置
        MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(0.005, 0.005);
         [self.mapView setRegion:MKCoordinateRegionMake(currentLocation, defaultSpan) animated:YES];
        [self start];
        [self timeReset];
        NSLog(@"time reset");
    }
}

-(void)timeReset{
    timeLeftToReupdate = 300;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    NSString * const ReuseIdentifier = @"PinAnnotation";
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:ReuseIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ReuseIdentifier];
    }
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)annotationView;
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Find address
    [UIView animateWithDuration:.3f animations:^{
        self.infoView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.addressLabel.text = nil;
        [self.loadingIndicator startAnimating];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocationCoordinate2D coord = view.annotation.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                CLPlacemark *placemark = placemarks[0];
                NSString *address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES);
                // Address may contains "line-break". Replace it with ","
                address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
                [self.loadingIndicator stopAnimating];
                self.addressLabel.text = address;
            } else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }];
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [UIView animateWithDuration:.3f animations:^{
        self.infoView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.addressLabel.text = nil;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

