//
//  CreateNewTripViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "CreateNewTripViewController.h"

@interface CreateNewTripViewController ()

@end

@implementation CreateNewTripViewController
@synthesize textField_newTripName;

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
    
    [self.tapGestureToHideKeyboard addTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer: self.tapGestureToHideKeyboard];
    newTripName = [[NSString alloc]init];
    
    wrongNameAlert = [[UIAlertView alloc]initWithTitle:@"Wrong Name!" message:@"Wrong Name!!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_Cancel_Pressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_StartTrip_Pressed:(id)sender {
    if(textField_newTripName.text.length > 0){
        newTripName = textField_newTripName.text;
        DataAccess *da = [DataAccess sharedDataSource];
        if([da isTripExistWithTripName:newTripName]){
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Same name" message:@"The name has been used" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [view show];
        }
        else{
            [da createNewTripWithName:newTripName StartDate:[NSDate date] EndDate:nil];
            [self performSegueWithIdentifier:@"toTripMap" sender:sender];
        }
    }
    else
        [wrongNameAlert show];
        
}

- (void)hideKeyboard{
    [self.textField_newTripName resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toTripMap"]){
        TripMapViewController *tmvc = segue.destinationViewController;
        tmvc.tripName = newTripName;
        tmvc.isNewTrip = YES;
        tmvc.isOngoingTrip = YES;
        tmvc.isHistoryTrip = NO;
    }
}

@end
