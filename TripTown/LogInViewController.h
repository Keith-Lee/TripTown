//
//  LogInViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) NSString * gotname;
@property (strong, nonatomic) NSString * gotkey;
@property (strong, nonatomic) NSString * access_token;
- (IBAction)performLogin:(id)sender;
- (IBAction)performFBLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (void)loginFailed;
- (void)postTokenwithRK;
@end

