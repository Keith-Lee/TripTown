//
//  MainViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
}

-(void)viewDidAppear:(BOOL)animated{
    //如果有正在進行的trip直接進map畫面
    if([[DataAccess sharedDataSource]isOngoingTripExist]){
        [self performSegueWithIdentifier:@"toMapSegue" sender:nil];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toMapSegue"]){
        TripMapViewController *vc = [segue destinationViewController];
        
        //判別是newTrip 還是舊的Ongoing trip
        if([[DataAccess sharedDataSource]isOngoingTripExist]){
            vc.isNewTrip = NO;
            vc.isOngoingTrip = YES;
            vc.isHistoryTrip = NO;
        }
        else{
            vc.isNewTrip = YES;
            vc.isOngoingTrip = YES;
            vc.isHistoryTrip = NO;
        }
    }
}
- (IBAction)btn_newTrip_pressed:(id)sender {
    [self performSegueWithIdentifier:@"toMapSegue" sender:nil];
}
@end
