//
//  AlbumScrollViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/15.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccess.h"

@interface AlbumScrollViewController : UIViewController <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic) NSInteger thePageOfView;
@property (strong, nonatomic) IBOutlet UILabel *desciptionLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *ToolbarOutlet;

@property (strong, nonatomic) NSArray *categorizedPhotoArray;

- (IBAction)barBtn_delete_pressed:(id)sender;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

- (void) resetView;
@end
