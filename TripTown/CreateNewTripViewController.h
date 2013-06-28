//
//  CreateNewTripViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "DataAccess.h"
#import "TripMapViewController.h"


@interface CreateNewTripViewController : UIViewController{
    NSString *newTripName;
    UIAlertView *wrongNameAlert;
}
- (IBAction)btn_Cancel_Pressed:(id)sender;
- (IBAction)btn_StartTrip_Pressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField_newTripName;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureToHideKeyboard;
- (void)hideKeyboard;


@end
