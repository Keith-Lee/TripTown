//
//  PhotoEditingViewController.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreImageCollectionViewCell.h"
#import "DataAccess.h"

@interface PhotoEditingViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonItemOutlet3;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonItemOutlet2;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonItemOutlet;
@property (strong, nonatomic) IBOutlet UIToolbar *ToolbarOutlet;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postBtnOutlet;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBtnOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
//@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *coreImageCollectionView;
@property (strong, nonatomic) NSDictionary *info;

//接傳過來的image圖
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) NSString *locationText;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *dateString;
@property(nonatomic, retain) NSURL *photoReference;



//post new photo
- (IBAction)btn_post_pressed:(id)sender;
- (IBAction)btn_text_pressed:(id)sender;
- (IBAction)btn_location_pressed:(id)sender;
- (IBAction)barBtn_cancel_pressed:(id)sender;
- (IBAction)btn_date_pressed:(id)sender;



- (void)keyboardWillShow:(NSNotification*)n;
- (void)keyboardWillHide:(NSNotification *)n;
//tap background -> hide keyboard
- (void)hideKeyboard;

- (void)dragTextField: (UIPanGestureRecognizer *)gesture;
- (void)dragLabel: (UIPanGestureRecognizer *)gesture;
- (void)handlePinch:(UIPinchGestureRecognizer *) gesture;
- (void)handleRotate: (UIRotationGestureRecognizer *) gesture;

- (UIImage *)getImageScreenshot;
- (UIImage *)convertImage:(UIImage *)image toSize:(CGSize) size withFilter: (CIFilter *)filter;


@end
