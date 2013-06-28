//
//  TripMapViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "TripMapViewController.h"
#import <AddressBook/AddressBook.h>

#define kCLIENTID "LV3TKJ3FKSE5S33PDO005H5CKJIXGVXNMTYKHBU2GKWD5RBV"
#define kCLIENTSECRET "O1MZ1KASL52BYH0TBNN3DPPGRVKPLFIAYW4FOPW2GA1P24NY"
#define TAG_DEV 1

@interface TripMapViewController (){
    UITextField *nameTextField;
    DataAccess *da;
    //NSURL *photoURL;
    BOOL shouldZoomToUserLocation;
    BOOL shouldShowBatteryWarningAlert;
    
    Reachability *internetReachableFoo;
    
}
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *categoryload;
@end

@implementation TripMapViewController

@synthesize data,categoryId,categoryName;
@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([UIDevice currentDevice].batteryLevel == 0.1){
        NSLog(@"battery life is %f", [UIDevice currentDevice].batteryLevel);
        shouldZoomToUserLocation = NO;
        shouldShowBatteryWarningAlert = YES;
    }
    else{
        
        shouldZoomToUserLocation = YES;
        shouldShowBatteryWarningAlert = NO;
    }
    
    
    da = [DataAccess sharedDataSource];
    
    //設定按鈕樣式
    //self.barBtn_settings.enabled = NO;
    
    UIImage *barButtonImage = [[UIImage imageNamed:@"backBtn_G.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [self.backBtnOutlet setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //back鈕文字offset
    [self.backBtnOutlet setTitlePositionAdjustment:UIOffsetMake(4, 2) forBarMetrics:UIBarMetricsDefault];

	// Do any additional setup after loading the view.
    m_imagePickerController = [[UIImagePickerController alloc]init];
    
    self.delegate = self;
    self.userTripMapView.delegate = self;
    m_imagePickerController.delegate = self;
    m_imagePickerController.allowsEditing = YES;
    self.infoView.alpha = 0.0f;
    
    //確認是否開啓更新位置的授權
    [self checkUserLocationAuthorizationStatus];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 56, 44, 68);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"placesTag.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.menuBtn];
    if(self.isOngoingTrip){
        //self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Trip"];
        //確認是否開啓更新位置的授權
        self.view.layer.shadowOpacity = 0.75f;
        self.view.layer.shadowRadius = 10.0f;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        
        if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
            self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
        }
        
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
        
        [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else{
        menuBtn.enabled= NO;
    }
    
    
    isCustomLocationSet = NO;
    
    self.mapLongPressGesture.delegate = self;
    self.mapLongPressGesture.minimumPressDuration = 1.0;
    
    [self.mapLongPressGesture addTarget:self action:@selector(createCustomLocationWithLongPressGesture:)];
    [self.userTripMapView addGestureRecognizer:self.mapLongPressGesture];
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
    UIImage *image = [UIImage imageNamed:@"navBarYBG.png"];
    [self.slidingViewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
-(void)viewDidAppear:(BOOL)animated{
    
    ///view 出現之後 開始加大頭針跟劃線
    [self addAnnotationsOnMap];
    [self drawPolylineOnMap];
    if(self.isOngoingTrip && !self.isNewTrip && !self.isHistoryTrip){
        [self addTargetAnnotationsOnMap];
    }
    if(isCustomLocationSet){
        CLLocationCoordinate2D customCoordinate = CLLocationCoordinate2DMake([da.customLat doubleValue], [da.customLon doubleValue]);
        [self zoomToLocationWithCoordinate:customCoordinate];
    }
    else{
        [self zoomToLocationWithCoordinate:self.userTripMapView.userLocation.location.coordinate];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    //如果是newTrip
    if(self.isNewTrip && self.isOngoingTrip && !self.isHistoryTrip){
        //call alertView to give this trip a name
        [self callGiveNewTripNameAlertView];
    }
    //如果是舊的ongoing trip
    else if(!self.isNewTrip && self.isOngoingTrip && !self.isHistoryTrip){
        //設定tripName 跟 navigation bar的title
        self.tripName = [DataAccess sharedDataSource].theTrip.t_name;
        self.mapViewNavigation.title = self.tripName;
    }
    else if(!self.isNewTrip && !self.isOngoingTrip && self.isHistoryTrip){
        //設定tripName 跟 navigation bar的title
        self.tripName = [DataAccess sharedDataSource].theTrip.t_name;
        self.mapViewNavigation.title = self.tripName;
        self.btn_endTrip.enabled = NO;
        [self.btn_endTrip setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        //self.barButton_camera.enabled = NO;
        self.btn_camera.enabled = NO;
        [self.btn_camera setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        self.barButton_nearby.enabled = NO;
    }
    
    
}

- (BOOL)isNetworkReachable{

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark - map method

//檢查使用者是否開啓位置取得的授權
-(void)checkUserLocationAuthorizationStatus{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未開啓位置授權" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(shouldShowBatteryWarningAlert){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Battery level is too low!" message:@"Your battery level is too low to keep updating your location, location service will be stopped." delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
        [alertView show];
        mapView.showsUserLocation = NO;
        shouldZoomToUserLocation = NO;
        shouldShowBatteryWarningAlert = NO;
        return ;
    }
    
    if(shouldZoomToUserLocation){
       [self zoomToLocationWithCoordinate:userLocation.location.coordinate];
        shouldZoomToUserLocation = NO;
    }
}

- (void)zoomToLocationWithCoordinate:(CLLocationCoordinate2D)coordinate{

    
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    
    region.center = coordinate;
 
    // region = [self.userTripMapView regionThatFits:region];
 
    MKCoordinateRegion fitRegion = [self.userTripMapView regionThatFits:region];
    if (isnan(fitRegion.center.latitude)) {
       // iOS 6 will result in nan. 2012-10-15
        fitRegion.center.latitude = region.center.latitude;
        fitRegion.center.longitude = region.center.longitude;
        fitRegion.span.latitudeDelta = 0;
        fitRegion.span.longitudeDelta = 0;
    }
 
    currentLocation = coordinate;

    
    [self.userTripMapView setRegion:region animated:NO];
    
    
    if([categoryName isEqualToString:@"Nearby"]){
        [self start];
        //[self.categoryload startAnimating];
        categoryName =@"searchdone";
    }
}

// 設定線的性質
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    MKPolylineView *polyLineView = [[MKPolylineView alloc]initWithOverlay: overlay];
    polyLineView.strokeColor = [UIColor greenColor];
    polyLineView.alpha = 0.5;
    return polyLineView;
}

//在每個location的位置加上anootation
-(void)addAnnotationsOnMap{
    //先移除所有舊的annotation
    NSMutableArray *annotationsToRemove = [self.userTripMapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.userTripMapView.userLocation];
    [self.userTripMapView removeAnnotations:annotationsToRemove];
    
    //NSLog(@"self.tripname is  %@", self.tripName);
    //拿到所有這個trip的Location並存入array
    NSArray *resultArray = [da getAllLocationsCoordinateInTripWithName:self.tripName];
    //NSLog(@"result array is %@", [resultArray description]);
    
    //把所有location一個個做成annotation
    for(LOCATION *location in resultArray){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([location.l_latitude doubleValue], [location.l_longitude doubleValue]);
        NSString * subtitleText;
        //NSLog(@"coordinate is %f, %f", coordinate.latitude, coordinate.longitude);
        if (location.photo.count>0) {
            subtitleText = [NSString stringWithFormat:@"You have %i photos here.", location.photo.count];
        }
        else{
            subtitleText = [NSString stringWithFormat:@"You have been here."];
        }
        MyAnnotation *annotation = [[MyAnnotation alloc]initWithCoordinate:coordinate Title:location.region.r_name andSubtitle:subtitleText];

        
        //把annotation逐一加到map上
        [self.userTripMapView addAnnotation:annotation];
        //NSLog(@"annotation is added");
    }
    
    [self addCustomLocationAnnotationOnMap];
    
}


- (void)createCustomLocationWithLongPressGesture:(UIGestureRecognizer *)sender{
    if([sender state] == UIGestureRecognizerStateEnded){
        CGPoint point = [sender locationInView:self.userTripMapView];
        CLLocationCoordinate2D coordinate = [self.userTripMapView convertPoint:point toCoordinateFromView:self.userTripMapView];
        da.customLat = [NSString stringWithFormat:@"%f", coordinate.latitude];
        da.customLon = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        
        
        [self addCustomLocationAnnotationOnMap];
        //NSLog(@"User Custom Position is %f, %f", coordinate.latitude, coordinate.longitude);
        
    }
}

-(void) createCustomLocation{
    
    
    
    da.customLat = [NSString stringWithFormat:@"%f", self.userTripMapView.centerCoordinate.latitude];
    da.customLon = [NSString stringWithFormat:@"%f", self.userTripMapView.centerCoordinate.longitude];
    
    [self addCustomLocationAnnotationOnMap];
}

- (void)addCustomLocationAnnotationOnMap{
    for(MyAnnotation *ann in self.userTripMapView.annotations){
        if([ann.title isEqualToString:@"My Location"]){
            [self.userTripMapView removeAnnotation:ann];
        }
    }
    
    if(da.customLat != nil && da.customLon != nil){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([da.customLat doubleValue], [da.customLon doubleValue]);
        MyAnnotation *annotation = [[MyAnnotation alloc]initWithCoordinate:coordinate Title:@"My Location" andSubtitle:nil];
        
        currentLocation = coordinate;
        isCustomLocationSet = YES;
        
        
        
        [self.userTripMapView addAnnotation:annotation];
        self.btn_Custom.enabled = NO;
        [self.btn_Custom setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
}

-(void)addTargetAnnotationsOnMap{
    
     NSMutableArray *items=[[NSUserDefaults standardUserDefaults]objectForKey:self.tripName];
    for(NSDictionary *dict in items){
    //NSMutableArray *cachetarget = [NSMutableArray array];
    NSString *targetname= [dict valueForKey:@"PlaceName"];
    float lat = [[dict valueForKey:@"lat"] floatValue];
    float lon = [[dict valueForKey:@"lon"] floatValue];
        
        MKPointAnnotation *targetpoint = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D ui=CLLocationCoordinate2DMake(lat,lon);
        [targetpoint setTitle:targetname];
        [targetpoint setSubtitle:@"target"];
        [targetpoint setCoordinate:ui];
        [self.userTripMapView addAnnotation:targetpoint];
    }
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]) return  nil;
    
    NSString * const reuseIdentifier = @"myAnnotation";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView){
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    }
    
    MyAnnotation *myAnn = (MyAnnotation *)annotation;
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)annotationView;
    NSRange range = [myAnn.subtitle rangeOfString:@"You have"];
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    pinAnnotationView.canShowCallout = YES;
    
    if(range.length>3){
        pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinAnnotationView.leftCalloutAccessoryView = nil;
        pinAnnotationView.animatesDrop = YES;
    }
    
    else if([myAnn.subtitle isEqualToString:@"target"]){
        UIImage *btn = [UIImage imageNamed:@"remove.png"];

        UIButton *remove = [UIButton buttonWithType:UIButtonTypeCustom];
        [remove setBackgroundImage:btn forState:UIControlStateNormal];
        [remove setFrame:CGRectMake(80.0, 120.0, 30.0, 30.0)];


        pinAnnotationView.rightCalloutAccessoryView = remove;
        pinAnnotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        
        pinAnnotationView.pinColor = MKPinAnnotationColorRed;
        
        pinAnnotationView.animatesDrop = YES;
    }
    
    else if([myAnn.title isEqualToString:@"My Location"]){
        UIImage *btn = [UIImage imageNamed:@"remove.png"];
        
        pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
        pinAnnotationView.animatesDrop = YES;
        UIButton *remove = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [remove setBackgroundImage:btn forState:UIControlStateNormal];
        [remove setFrame:CGRectMake(80.0, 120.0, 30.0, 30.0)];
        
        
        pinAnnotationView.rightCalloutAccessoryView = remove;
        pinAnnotationView.leftCalloutAccessoryView = nil;
        pinAnnotationView.draggable = YES;
    }
    
    else{
        pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        pinAnnotationView.pinColor = MKPinAnnotationColorRed;
        pinAnnotationView.leftCalloutAccessoryView = nil;
        
        pinAnnotationView.animatesDrop = YES;
    }
    
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    
    if (newState == MKAnnotationViewDragStateStarting){
        NSLog(@"Drag Start");
    }
    else if (newState == MKAnnotationViewDragStateEnding){
        MyAnnotation *annotation = (MyAnnotation *)view.annotation;
        //NSLog(@" new location : %f, %f", annotation.coordinate.latitude, annotation.coordinate.longitude);
        currentLocation = annotation.coordinate;
        da.customLat = [NSString stringWithFormat:@"%f", currentLocation.latitude];
        da.customLon = [NSString stringWithFormat:@"%f", currentLocation.longitude];
        
    }
    
}

/*- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for(UIView *view in views){
        CGRect endFrame = view.frame;
    
        CGRect startFrame = endFrame;
        startFrame.origin.x = view.frame.origin.x;
        startFrame.origin.y += endFrame.size.height;
    
        startFrame.size.width = 0;
        startFrame.size.height = 0;
    
        view.frame = startFrame;
        view.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0];
    
        view.frame = endFrame;
        view.alpha = 1;
        [UIView commitAnimations];
    }
}*/


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    id<MKAnnotation> annotation = view.annotation;
    //MyAnnotation *myAnn = (MyAnnotation *)annotation;
    NSRange range = [view.annotation.subtitle rangeOfString:@"You have"];
    
    if([view.annotation.subtitle isEqualToString:@"target"]){
        if(control == view.rightCalloutAccessoryView) {
            [self.userTripMapView removeAnnotation:view.annotation];
            NSMutableArray *items=[[NSUserDefaults standardUserDefaults]objectForKey:self.tripName];
            int a=-1;
            for (NSDictionary *dele in items){
                a=a+1;
                //NSString *targetname= [dele valueForKey:@"PlaceName"];
                float lat = [[dele valueForKey:@"lat"] floatValue];
                float lon = [[dele valueForKey:@"lon"] floatValue];
                //NSLog(@"what %i",a);
                //NSLog(@"%f",annotation.coordinate.latitude);
                //NSLog(@"%f",lat);
                if(lat==annotation.coordinate.latitude && lon == annotation.coordinate.longitude){
                    //NSLog(@"%i",a);
                    NSMutableArray *placesT= nil;
                    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:self.tripName];
                    placesT=[array mutableCopy];
                    //NSLog(@"place t : %@", [placesT description]);
                
                
                    //[placesT removeAllObjects];
                    [placesT removeObjectAtIndex:a];
                
                    [[NSUserDefaults standardUserDefaults] setValue:placesT forKey:self.tripName];
                
                }
            }
        }
        else if (control == view.leftCalloutAccessoryView){
            CLLocationCoordinate2D coordinate = currentLocation;
            //coordinate.latitude = 48.8580;
            //coordinate.longitude = 2.29460;
            //NSDictionary *addressDict = @{(NSString*)kABPersonAddressCityKey: @"Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"};
            MKPlacemark *placeMark = [[MKPlacemark alloc]initWithCoordinate:coordinate addressDictionary:nil];
            
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
            [mapItem setName:@"Current Location"];
            //[mapItem setPhoneNumber:@"999-999-9999"];
            //[mapItem setUrl:[NSURL URLWithString:@"http://jprithvi.wordpress.com"]];
            
            CLLocationCoordinate2D coordinate2 = ((MyAnnotation *)view.annotation).coordinate;
            //coordinate2.latitude = 48.8044;
            //coordinate2.longitude = 2.1232;
            //NSDictionary *addressDict2 = @{(NSString*)kABPersonAddressCityKey:@"Place d’Armes, 78000 Versailles, France"};
            MKPlacemark *placeMark2 = [[MKPlacemark alloc]initWithCoordinate:coordinate2 addressDictionary:nil];
            
            MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:placeMark2];
            [mapItem2 setName:view.annotation.title];
            //[mapItem2 setPhoneNumber:@"999-999-9999"];
            //[mapItem2 setUrl:[NSURL URLWithString:@"http://jprithvi.wordpress.com"]];
            
            
            NSArray *mapPoints = @[mapItem , mapItem2];
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,};
            [MKMapItem openMapsWithItems:mapPoints launchOptions:launchOptions];
        }

        
        
        //[[NSUserDefaults standardUserDefaults] setValue:placesT forKey:self.tripName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        }
    
    else if(range.length<3 && ![view.annotation.title isEqualToString:@"My Location"]){
         NSString *title = view.annotation.title;
         // NSString *subtitle = view.annotation.subtitle;
         CLLocationCoordinate2D targetlocate=view.annotation.coordinate;
         
         NSMutableArray *annotationsToRemove = [self.userTripMapView.annotations mutableCopy];
         [annotationsToRemove removeObject:self.userTripMapView.userLocation];
         [self.userTripMapView removeAnnotations:annotationsToRemove];
         
         MKPointAnnotation *targetann = [[MKPointAnnotation alloc] init];
         [targetann setTitle:title];
         [targetann setSubtitle:@"target"];
         [targetann setCoordinate:targetlocate];
         [self addAnnotationsOnMap];
         [self drawPolylineOnMap];
         [self addTargetAnnotationsOnMap];
         [self.userTripMapView addAnnotation:targetann];
          
          NSMutableArray *placesT= nil;
          
          NSMutableArray *items=[[NSUserDefaults standardUserDefaults]objectForKey:self.tripName];
          NSMutableDictionary *targetToSave =[NSMutableDictionary dictionary];
          [targetToSave setValue:title forKey:@"PlaceName"];
          NSString *lat =[NSString stringWithFormat:@"%f",targetlocate.latitude];
          NSString *lon =[NSString stringWithFormat:@"%f",targetlocate.longitude];
          [targetToSave setValue:lat forKey:@"lat"];
          [targetToSave setValue:lon forKey:@"lon"];
          //NSLog(@"items: %@", [items description]);
          //NSLog(@"targetToSave: %@", [targetToSave description]);
          
          if (items) {
              placesT = [items mutableCopy];
          }
        
          else {
              placesT=[[NSMutableArray alloc] init];
          }

          
          [placesT addObject:targetToSave];
        
          [[NSUserDefaults standardUserDefaults] setValue:placesT forKey:self.tripName];
          [[NSUserDefaults standardUserDefaults] synchronize];
          // NSLog(@"did i");
        


    }
    
    else if([view.annotation.title isEqualToString:@"My Location"]){

        
        currentLocation = self.userTripMapView.userLocation.coordinate;
        
        da.customLat = nil;
        da.customLon = nil;
        
        [self.userTripMapView removeAnnotation:view.annotation];
        currentLocation = self.userTripMapView.userLocation.coordinate;
        

        
        isCustomLocationSet = NO;
        self.btn_Custom.enabled = YES;

    }

    else{
        addressToPass = annotation.title;
        //現在處理的location作設定。
        da.theLocation = [da fetchLocationWithLatitude:[NSString stringWithFormat:@"%f", annotation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f", annotation.coordinate.longitude] inTrip: da.theTrip];
        
        [self performSegueWithIdentifier:@"accessoryDetailSegue" sender:nil];
    }

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

//在地圖上劃線
-(void)drawPolylineOnMap{
    //先移除所有的線
    [self.userTripMapView removeOverlays: self.userTripMapView.overlays];
    //取得所有這個trip的Location
    NSArray *locations = [[DataAccess sharedDataSource] getAllLocationsCoordinateInTripWithName:self.tripName];
    
    //如果有兩個或以上的locations 開始劃線。
    if([locations count] > 1){
        
        CLLocationCoordinate2D startLocation;
        CLLocationCoordinate2D endLocation;
        
        //把location按順序劃出兩點間的線
        for(int i = 0; i < locations.count - 1; i++){
            LOCATION *location1 = (LOCATION *)[locations objectAtIndex:i];
            LOCATION *location2 = (LOCATION *)[locations objectAtIndex:i+1];
            startLocation = CLLocationCoordinate2DMake([location1.l_latitude doubleValue], [location1.l_longitude doubleValue]);
            endLocation = CLLocationCoordinate2DMake([location2.l_latitude doubleValue], [location2.l_longitude doubleValue]);
            CLLocationCoordinate2D resultLocations[] = { startLocation, endLocation };
            
            MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:resultLocations count:2];
            [self.userTripMapView addOverlay:polyLine];
            
        }
    }
    //沒有的話，回傳訊息
    else{
        NSLog(@"No sufficient locations to draw on map, amount of locations is %i", [locations count]);
    }
}

- (void) start{
    if([self isNetworkReachable]){
        [self.categoryload startAnimating];
        NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com/v2"];
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
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
    
        RKObjectMapping *categoriesMapping = [RKObjectMapping mappingForClass:[Categories class]];
        [categoriesMapping addAttributeMappingsFromDictionary:@{@"name":@"name",@"pluralName":@"pluralName",@"icon.prefix":@"prefix",@"icon.suffix":@"suffix"}];
        RKRelationshipMapping *cate = [RKRelationshipMapping relationshipMappingFromKeyPath:@"categories"   toKeyPath:@"categories" withMapping:categoriesMapping];
        [venueMapping addPropertyMapping:cate];
    
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                                                       pathPattern:nil
                                                                                           keyPath:@"response.venues"
                                                                                       statusCodes:nil];
    
        [objectManager addResponseDescriptor:responseDescriptor];
    
        [self sendRequest];
    }
    else{
        [self.categoryload stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Network is not connected" message:@"Please check your Internet connection, thanks." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        //NSLog(@"Oops");
    }
    
}
- (void) sendRequest {
    //NSLog([NSString stringWithFormat:@"%f", currentLocation.latitude]);
    
    NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.longitude];
    NSString *str = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
    
    NSLog(@"request location is %@", str);
    
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    NSDictionary *queryParams;
    
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:str, @"ll", clientID, @"client_id", clientSecret, @"client_secret",@"800",@"radius",categoryId, @"categoryId", @"20130513", @"v", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //NSURL *url = [NSURL URLWithString:@"/venues/search"];
    [objectManager getObjectsAtPath:@"/v2/venues/search" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSLog(@"objects[%d]", [[mappingResult array] count]);
                                if([[mappingResult array] count]==0){
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                          //上面是標題的設定
                                                                                    message:@"Couldn't find any places around here,please retry with other category."  //警告訊息內文的設定
                                                                                   delegate:self // 叫出AlertView之後，要給該ViewController去處理
                                                          
                                                                          cancelButtonTitle:@"OK"  //cancel按鈕文字的設定
                                                                          otherButtonTitles: nil]; // 其他按鈕的設定
                                    [self.categoryload stopAnimating];
                                    [alert show];  // 把alert這個物件秀出來

                                }
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
                                    for (Categories *category in venue.categories) {
                                        [getCategory addObject:category.name];
                                        /*NSString *imageurl =[NSString stringWithFormat:@"%@%@%@",category.prefix,@"bg_32",category.suffix];
                                         NSURL *url = [NSURL URLWithString:imageurl];
                                         NSData *imagedata = [[NSData alloc] initWithContentsOfURL:url];
                                         tmpimage =[[UIImage alloc] initWithData:imagedata];
                                         */
                                        [ann setSubtitle:category.name];
                                    }
                                    [self.userTripMapView addAnnotation:ann];
                                    [self.categoryload stopAnimating];
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];    
}

- (IBAction)barBtn_back_pressed:(id)sender {
    
    //[self.categoryload startAnimating];
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Main"] animated:NO completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


//按下結束旅程後的事件
- (IBAction)btn_endTrip_pressed:(id)sender {
    [self callEndEnsureAlertView];
    
}


- (IBAction)btn_locating_pressed:(id)sender {
    [self zoomToLocationWithCoordinate:currentLocation];
    
}

- (IBAction)btn_album_pressed:(id)sender {
    //[self.categoryload startAnimating];
}

- (IBAction)btn_custom_pressed:(id)sender {
    [self createCustomLocation];
}



#pragma mark - alert view method
//設定當click alertView的 button會trigger的事件，目前的判斷基準是button的title
#warning - this delegate method cound be done in a better way, maybe use tag rather than title.
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
   
    //表示是在give a new name的情況
    if([title isEqualToString:@"start"]){
        NSString *tripName = [[alertView textFieldAtIndex:0] text];
        if([[DataAccess sharedDataSource] isTripExistWithTripName:tripName]){
            [self callSameNameTripNameAlertView];
        }
        else{
            [[DataAccess sharedDataSource] createNewTripWithName:tripName StartDate:[NSDate date] EndDate:nil];
            NSLog(@"new trip is added, name is %@", tripName);
            self.mapViewNavigation.title = tripName;
            self.tripName = [DataAccess sharedDataSource].theTrip.t_name;
            self.isNewTrip = NO;
            
            [[DataAccess sharedDataSource]createNewAlbumWithName:self.tripName];
        }
    }
    
    else if ([title isEqualToString:@"cancel"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //表示是在same name的情況
    else if([title isEqualToString:@"Rename"]){
        [self callGiveNewTripNameAlertView];
    }
    
    //表示是按下camera且找不到相機的情況
    else if([title isEqualToString:@"Okay"]){
        m_imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:m_imagePickerController animated:YES completion:nil];
    }
    
    else if([title isEqualToString:@"Yes"]){
        TRIP *alteredTrip = [[DataAccess sharedDataSource] fetchTripWithTripName:self.tripName];
        alteredTrip.t_isOngoing = [NSNumber numberWithBool:NO];
        alteredTrip.t_endDate = [NSDate date];
        
        NSError *error = nil;
        ProjectAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        //如果儲存改變發生錯誤
        if(![[appDelegate managedObjectContext]save: &error]){
            NSLog(@"終結旅程 && 設定end date發生錯誤");
        }
        //成功儲存就disable buttons only for ongoing trips;
        else{
            self.btn_camera.enabled = NO;
            [self.btn_camera setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            //self.barButton_camera.enabled = NO;
            self.barButton_nearby.enabled = NO;
            self.menuBtn.enabled=NO;
            [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
            self.btn_endTrip.enabled = NO;
            [self.btn_endTrip setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        }
    }
   }

//alertView to give a new name
- (void)callGiveNewTripNameAlertView{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Name your trip" message:@"Now give your trip a name" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"start", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    nameTextField = [alertView textFieldAtIndex:0];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.placeholder = @"trip name...";
    
    [alertView show];
}

//alertView for same name
- (void)callSameNameTripNameAlertView{
    UIAlertView *wrongNameAlert = [[UIAlertView alloc]initWithTitle:@"Same Name!" message:@"The Name Has Been Use!!" delegate:self cancelButtonTitle:@"Rename" otherButtonTitles:nil, nil];
    
    [wrongNameAlert show];
}

- (void)callEndEnsureAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"End Trip" message:@"Are you sure you want to end this trip ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alertView show];
}


#pragma mark - image picker method

//按下camera的button
- (IBAction)btn_Camera_Pressed:(id)sender {
    [self createImageSourceActionSheet];
}

//delegete method 當Image完成選取的時候。
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //將檔案的資訊取出
    //NSLog(@"metadata is %@",[[info objectForKey:UIImagePickerControllerMediaMetadata] description]);
    //UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    ALAssetsGroup *album = [[DataAccess sharedDataSource]getAlbumWithName:self.tripName];
    if( album == nil){
        NSLog(@"try to recreate album");
        
        [da createNewAlbumWithName:self.tripName];
    }
    
    
    //如果來源是相機
    //if(m_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera){
    //將選擇的照片存進相簿
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    //[[DataAccess sharedDataSource] saveImage:image withInfoDictionary:info toAlbum:album];
    //}
    
    //NSLog(@"tripName is %@", self.tripName);
    //NSLog(@"album is  %@", [album description]);
    
    //else{
    //    [[DataAccess sharedDataSource] saveImageWithURL:(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] toAlbum:album];
    //}
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //執行editPhotoSegue
    //將info dictionary當作參數傳入
    [self performSegueWithIdentifier:@"editPhotoSegue" sender:info];
}

//如果cancel imagePickerController
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createImageSourceActionSheet{
    UICustomActionSheet *customActionSheet = [[UICustomActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"From Camera" otherButtonTitles:@"From Album", nil];
    
    [customActionSheet setColor:[UIColor colorWithRed:0 green:0 blue:256 alpha:0] forButtonAtIndex:0];
    [customActionSheet setColor:[UIColor grayColor] forButtonAtIndex:1];
    [customActionSheet setColor:[UIColor grayColor] forButtonAtIndex:2];
    
    customActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [customActionSheet showInView:self.view];
    
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"From Camera" otherButtonTitles:@"From Album", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];*/
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"From Camera"]){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
            m_imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:m_imagePickerController animated:YES completion:nil];
            
        }
        //如果不能使用相機
        else{
            //就從相片庫選擇照片
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Camera Was Detected." message:@"Choose Photo From Library ?" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"NO", nil];
                [alertView show];
            }
        }
    }
    
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"From Album"]){
        m_imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:m_imagePickerController animated:YES completion:nil];
    }
}



#pragma mark - album method


#pragma mark - segue method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"editPhotoSegue"]){
        //取得選取時的參數字典
        NSDictionary *info = (NSDictionary *) sender;
        //NSLog(@"info : %@", [info description]);
        //取出PhotoEditingViewController的實例
        NSDate *date = [NSDate date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
        NSString *dateString = [NSString stringWithFormat:@"%i/%i/%i", components.year, components.month, components.day];
        
        PhotoEditingViewController *photoEditingViewController = (PhotoEditingViewController *)[segue destinationViewController];
        
        //設定選取的影像資訊
        photoEditingViewController.image = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
        photoEditingViewController.latitude = [NSString stringWithFormat:@"%f", currentLocation.latitude];
        photoEditingViewController.longitude = [NSString stringWithFormat:@"%f", currentLocation.longitude];
        photoEditingViewController.photoReference = (NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"];
        photoEditingViewController.info = info;
        photoEditingViewController.dateString = dateString;
        
    }
    
    else if ([[segue identifier]isEqualToString:@"accessoryDetailSegue"]){
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        AccessoryDetailViewController *vc = (AccessoryDetailViewController *)[navController.viewControllers objectAtIndex:0];
        vc.addressTitle = addressToPass;
    }
}


@end
