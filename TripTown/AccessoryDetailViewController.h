//
//  AccessoryDetailViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/11.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessoryDetailCollectionViewCell.h"
#import "ImageScrollViewController.h"
#import "DataAccess.h"

@interface AccessoryDetailViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>{
    DataAccess *da;
    NSArray *photoImageArray;
    NSArray *photoArray;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtnOutlet;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) NSString *addressTitle;
//@property (strong, nonatomic) IBOutlet UINavigationItem *theNavigationItem;


- (IBAction)barBtn_back_pressed:(id)sender;


@end
