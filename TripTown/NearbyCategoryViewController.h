//
//  NearbyCategoryViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyCategoryViewController : UITableViewController

{
    NSString *categroyID;
    NSString *categoryName;
    NSMutableArray *getid;
    BOOL artCheck;
    BOOL collegeCheck;
    BOOL foodCheck;
    BOOL nightCheck;
    BOOL outdoorCheck;
    BOOL professionCheck;
    BOOL ResidenceCheck;
    BOOL shopCheck;
    BOOL travelCheck;
    
}
@property (weak, nonatomic) IBOutlet UIButton *checkArtBoxButton;
-(IBAction)Artselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkCoellegeBoxButton;
-(IBAction)Collegeselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkFoodBoxButton;
-(IBAction)Foodselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkNightBoxButton;
-(IBAction)Nightselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkOutdoorBoxButton;
-(IBAction)Outdoorsselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkProfessionBoxButton;
-(IBAction)Professionelect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkResidenceBoxButton;
-(IBAction)Residenceselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkShopBoxButton;
-(IBAction)Shopselect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkTravelBoxButton;
-(IBAction)Travelselect:(id)sender;

- (IBAction)barBtn_back_pressed:(id)sender;

@end