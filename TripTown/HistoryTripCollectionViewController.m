//
//  HistoryTripCollectionViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/24.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "HistoryTripCollectionViewController.h"

@interface HistoryTripCollectionViewController (){
    NSMutableArray *ongoingTripArray;
    NSMutableArray *historyTripArray;
}

@end

@implementation HistoryTripCollectionViewController{
    NSInteger indexNumberOfItem;
    NSString *tripNameToDelete;
}

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
    //設定按鈕樣式
    UIImage *barButtonImage = [[UIImage imageNamed:@"barBtn_Y.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [self.addBtnOutlet setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	// Do any additional setup after loading the view.
    self.tripColllectionView.delegate = self;
    self.tripColllectionView.dataSource = self;

    ongoingTripArray = [NSMutableArray array];
    historyTripArray = [NSMutableArray array];
    
    UILongPressGestureRecognizer *recog = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteActionSheet:)];
    recog.minimumPressDuration = 1.0; //seconds
    recog.delegate = self;
    
    
    [self.tripColllectionView addGestureRecognizer:recog];


    
    
    //NSLog(@"allTripArray: %@", [allTripArray description]);
    
    
    /*NSURL *baseURL = [NSURL URLWithString:@"http://140.119.19.20:8000/api/trip/"];
     
     
     
     RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
     
     //RKObjectMapping *userMapping
     RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
     [requestMapping addAttributeMappingsFromDictionary:@{ @"Name": @"t_name", @"startDateTime": @"t_startDate", @"ongoingFlag": @"t_isOngoing", @"endDateTime": @"t_endDate"}];
     requestMapping = [requestMapping inverseMapping];
     RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[TRIP class] rootKeyPath:nil];
     
     [objectManager addRequestDescriptor:requestDescriptor];
     TRIP *tempTrip = [[DataAccess sharedDataSource] fetchTripWithTripName:@"test"];
     NSLog(@"%@", tempTrip.t_isOngoing);
     objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
     
     NSString *postURL = @"trip/";
     RKManagedObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:tempTrip method:RKRequestMethodPOST path:postURL parameters:nil];
     [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     
     }];
     
     [objectManager enqueueObjectRequestOperation:operation];*/
    
    /*NSURL *baseURL = [NSURL URLWithString:@"http://140.119.19.20:8000/api/trip/"];
    
    
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    //RKObjectMapping *userMapping
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    RKEntityMapping *regionRelationshipMapping = [RKEntityMapping mappingForEntityForName:@"REGION" inManagedObjectStore:[objectManager managedObjectStore]];
    
    RKEntityMapping *tripRelationshopMapping = [RKEntityMapping mappingForEntityForName:@"TRIP" inManagedObjectStore:[objectManager managedObjectStore]];
    [tripRelationshopMapping addAttributeMappingsFromDictionary:@{@"Name": @"t_name", @"startDateTime": @"t_startDate", @"ongoingFlag": @"t_isOngoing", @"endDateTime": @"t_endDate"}];
    
    [regionRelationshipMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"trip" withMapping:tripRelationshopMapping]];
    [regionRelationshipMapping addAttributeMappingsFromDictionary:@{@"Name": @"r_name"}];
    [requestMapping addAttributeMappingsFromDictionary:@{ @"Latitude": @"l_latitude", @"Longitude": @"l_longitude"}];
    [requestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil
                                                                                   toKeyPath:@"region"
                                                                                 withMapping:regionRelationshipMapping]];
    requestMapping = [requestMapping inverseMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[LOCATION class] rootKeyPath:nil];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    NSArray *tempLocations = [[DataAccess sharedDataSource] getAllLocationsCoordinateInTripWithName:@"test"];
    LOCATION *tempLocation = nil;
    if([tempLocations count] > 0){
        tempLocation = [tempLocations objectAtIndex:0];
    }
    else{
        NSLog(@"No locaitons");
        
    }
    
    //NSLog(@"%@", tempTrip.t_isOngoing);
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSString *postURL = @"location/";
    RKManagedObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:tempLocation method:RKRequestMethodPOST path:postURL parameters:nil];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
    [objectManager enqueueObjectRequestOperation:operation];*/
    
#warning start from here!
    
    
    /*RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    
    //set up
    NSURL *baseURL = [NSURL URLWithString:@"http://140.119.19.20:8000/api/trip/"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    ProjectAppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    
    // Initialize managed object store
    //NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    //RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSManagedObjectModel *managedObjectModel = [appdelegate managedObjectModel];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc]initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // Setup our object mappings
    RKObjectMapping *tripMapping = [RKObjectMapping requestMapping];
    [tripMapping addAttributeMappingsFromDictionary:@{ @"Name": @"t_name", @"startDateTime": @"t_startDate", @"ongoingFlag": @"t_isOngoing", @"endDateTime": @"t_endDate"}];
    
    RKEntityMapping *locationMapping = [RKEntityMapping mappingForEntityForName:@"LOCATION" inManagedObjectStore:managedObjectStore];
    [locationMapping addAttributeMappingsFromDictionary:@{@"Latitude": @"l_latitude", @"Longitude": @"l_longitude"}];
    RKEntityMapping *photoMapping = [RKEntityMapping mappingForEntityForName:@"PHOTO" inManagedObjectStore:managedObjectStore];
    [photoMapping addAttributeMappingsFromDictionary:@{@"Date": @"p_date", @"Description": @"p_description",@"Photo": @"p_image"}];
    
    
    [locationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Photo" toKeyPath:@"photo" withMapping:photoMapping]];
    [tripMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Location" toKeyPath:@"location" withMapping:locationMapping]];
    
    //RKRelationshipMapping *locationRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping];
    
    //[tripMapping addRelationshipMappingWithSourceKeyPath:@"location" mapping:locationRelationshipMapping.mapping];
    
    
    tripMapping = [tripMapping inverseMapping];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:tripMapping objectClass:[TRIP class] rootKeyPath:nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;

    NSLog(@"==============================");
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //NSLog(@"%@",[objectManager.requestSerializationMIMEType description]);
    
    NSString *postURL = @"trip/";
    
    /*TRIP *tempTrip = [[DataAccess sharedDataSource] fetchTripWithTripName:@"test"];
     RKManagedObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:tempTrip method:RKRequestMethodPOST path:postURL parameters:nil];
     [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     NSLog(@"operation :%@, mappingResult: %@", [operation description], [mappingResult description]);
     
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     NSLog(@"Fail: operation : %@, Error: %@", [operation description], [error description]);
     
     }];
     
     [objectManager enqueueObjectRequestOperation:operation];*/
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.activityIndicator startAnimating];
    [self.tripColllectionView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    
    allTripArray = [[DataAccess sharedDataSource]getAllTrip];
    
    [self categorizeTrips];
    
    NSLog(@"data reload");
    
    [self.tripColllectionView reloadData];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    /*if([[DataAccess sharedDataSource]isOngoingTripExist]){
        [self performSegueWithIdentifier:@"toMapSegue" sender:nil];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if([allTripArray count] == 0){
        return 1;
    }
    else{
        return 2;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HistoryTripCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"historyTripHeaderView" forIndexPath:indexPath];
    if([allTripArray count] == 0){
        headerView.labelOfHeaderView.text = @"請按下＋新增或點選相片繼續旅程";
    }
    
    else{
        if (indexPath.section == 0) {
            headerView.labelOfHeaderView.text = @"Ongoing Trips";
            [headerView.labelOfHeaderView setFont:[UIFont fontWithName:@"Oswald" size:20.0f]];
        }
    
        else{
            headerView.labelOfHeaderView.text = @"Ended Trips";
            [headerView.labelOfHeaderView setFont:[UIFont fontWithName:@"Oswald" size:20.0f]];
        }
    }
    
    return headerView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return [ongoingTripArray count];
    }
    else{
        return [historyTripArray count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const identifier = @"tripCell";
    HistoryTripColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if([allTripArray count] == 0){
        return cell;
    }
    
    else{
        
        
        DataAccess *da = [DataAccess sharedDataSource];
        
        if(indexPath.section == 0){
            
            
            TRIP *trip = (TRIP *)[ongoingTripArray objectAtIndex:indexPath.row];
            NSLog(@"trip is %@",trip.t_name);
            NSArray *allPhotoArray = [da getAllPhotoForTrip:trip];
            NSArray *tripImageViewArray = [NSArray arrayWithObjects:cell.tripImageView, cell.tripImageView1, cell.tripImageView2, cell.tripImageView3, cell.tripImageView4, nil];
            int numberOfPhotosShouldPick = 5;
            
            if([allPhotoArray count] < 5){
                numberOfPhotosShouldPick = [allPhotoArray count];
            }
            
            for (int i = 0; i < numberOfPhotosShouldPick; i++) {
                UIImageView *imageView = [tripImageViewArray objectAtIndex:i];
                //imageView.image = nil;
                PHOTO *photo = [allPhotoArray objectAtIndex:i];
                UIImage *image = [da tranferURLtoImage:[NSURL URLWithString:photo.p_image]];
                imageView.image = image;

            }
            
            /*for (int i = 5; i > numberOfPhotosShouldPick; i--){
                
                UIImageView *imageViewShouldAddLabel = [tripImageViewArray objectAtIndex:i-1];
                UILabel *label = [[UILabel alloc]initWithFrame:imageViewShouldAddLabel.frame];
                label.text = @"No Pics";
                [imageViewShouldAddLabel addSubview:label];
            }*/
            
            
            //UIImage *image = [self getTheFirstImageForTrip: (TRIP *)[ongoingTripArray objectAtIndex:indexPath.row]];
            //cell.tripImageView.image = image;
                        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:trip.t_startDate];
            NSString *dateString = [NSString stringWithFormat:@"%i/%i", components.year, components.month];
            cell.tripDateLabel.text = dateString;
            cell.tripNameLabel.text = trip.t_name;
        
        }
    
        else{
        
            TRIP *trip = (TRIP *)[historyTripArray objectAtIndex:indexPath.row];
            
            NSArray *allPhotoArray = [da getAllPhotoForTrip:trip];
            NSArray *tripImageViewArray = [NSArray arrayWithObjects:cell.tripImageView, cell.tripImageView1, cell.tripImageView2, cell.tripImageView3, cell.tripImageView4, nil];
            int numberOfPhotosShouldPick = 5;
            
            if([allPhotoArray count] < 5){
                numberOfPhotosShouldPick = [allPhotoArray count];
            }
            
            for (int i = 0; i < numberOfPhotosShouldPick; i++) {
                UIImageView *imageView = [tripImageViewArray objectAtIndex:i];
                //imageView.image = nil;
                PHOTO *photo = [allPhotoArray objectAtIndex:i];
                UIImage *image = [da tranferURLtoImage:[NSURL URLWithString:photo.p_image]];
                imageView.image = image;
                
            }
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:trip.t_startDate];
            NSString *dateString = [NSString stringWithFormat:@"%i/%i", components.year, components.month];
            cell.tripDateLabel.text = dateString;
            cell.tripNameLabel.text = trip.t_name;
        }
        
        
        [cell.tripDateLabel setFont:[UIFont fontWithName:@"BebasNeue" size:25.0f]];
        [cell.tripNameLabel setFont:[UIFont fontWithName:@"BebasNeue" size:25.0f]];
    }
    return cell;
}

/*- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTripColletionCell *cell = (HistoryTripColletionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    DataAccess *da = [DataAccess sharedDataSource];
    da.theTrip = [da fetchTripWithTripName:cell.tripNameLabel.text];
    NSLog(@"the TRip is %@", da.theTrip.t_name);
}*/

//拿每個trip的第一個照片當代表
-(UIImage *)getTheFirstImageForTrip:(TRIP *)trip{
    NSArray *photoArray = [[DataAccess sharedDataSource] getAllPhotoForTrip:trip];
    
    if(photoArray != nil){
        //NSLog(@"result image array is %@ at view", [[[DataAccess sharedDataSource] tranferURLtoPhotoForTrip:trip] description]);
        PHOTO *firstPhoto = (PHOTO *)[photoArray objectAtIndex:0];
        UIImage *firstImage = [[DataAccess sharedDataSource] tranferURLtoImage:[NSURL URLWithString:firstPhoto.p_image]];
        return firstImage;
    }
    else{
        //NSLog(@"Cannot get the first image");
        return nil;
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"toMapSegue"]){
        HistoryTripColletionCell *cell = (HistoryTripColletionCell *)sender;
        //TripMapViewController *vc = [segue destinationViewController];
        SlideViewController *vc = [segue destinationViewController];
        DataAccess *da = [DataAccess sharedDataSource];
        da.theTrip = [da fetchTripWithTripName:cell.tripNameLabel.text];
        NSLog(@"theTripName: %@", da.theTrip.t_name);
    
        if(da.theTrip.t_isOngoing == [NSNumber numberWithInteger:1]){
            vc.isNewTrip = NO;
            vc.isOngoingTrip = YES;
            vc.isHistoryTrip = NO;
        }
        
        else{
            vc.isNewTrip = NO;
            vc.isOngoingTrip = NO;
            vc.isHistoryTrip = YES;
        }
    }
    
    else if([[segue identifier] isEqualToString:@"addNewTripSegue"]){
        NSLog(@"segue called");
        SlideViewController *vc = [segue destinationViewController];
        vc.isNewTrip = YES;
        vc.isOngoingTrip = YES;
        vc.isHistoryTrip = NO;
    }
    
}

- (void)showDeleteActionSheet:(UILongPressGestureRecognizer *)recognizer{
    if(UIGestureRecognizerStateBegan == recognizer.state){
        CGPoint p = [recognizer locationInView:self.tripColllectionView];
        
        NSIndexPath *indexPath = [self.tripColllectionView indexPathForItemAtPoint:p];
        HistoryTripColletionCell *cell = (HistoryTripColletionCell *)[self.tripColllectionView cellForItemAtIndexPath:indexPath];
        if(cell != nil){
            //indexNumberOfItem = indexPath.row;
            tripNameToDelete = cell.tripNameLabel.text;
            //NSLog(@"It's the %i row item", indexPath.row);
            
            [self fetchDeleteActionSheet];
        }
        else{
            NSLog(@"No item is pressed");
        }
    }
    
    else{
        
    }
}

- (void)fetchDeleteActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction)barBtn_add_pressed:(id)sender {
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //delete button
        TRIP *tripToDelete = [[DataAccess sharedDataSource] fetchTripWithTripName:tripNameToDelete];
        [[DataAccess sharedDataSource] deleteDataModelObject:tripToDelete];
        
        allTripArray = [[DataAccess sharedDataSource] getAllTrip];
        [self categorizeTrips];
        //NSLog(@"%@", [allTripArray description]);
        [self.tripColllectionView reloadData];
    }
}

-(void)categorizeTrips{
    [ongoingTripArray removeAllObjects];
    [historyTripArray removeAllObjects];
    for(TRIP *trip in allTripArray){
        if(trip.t_isOngoing == [NSNumber numberWithInteger:1]){
            [ongoingTripArray addObject:trip];
        }
        else{
            [historyTripArray addObject:trip];
        }
    }
    
}
@end
