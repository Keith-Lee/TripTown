//
//  PhotoEditingViewController.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "PhotoEditingViewController.h"

@interface PhotoEditingViewController (){
    NSMutableArray *filterNameArray;
    NSMutableArray *filterArray;
    BOOL keyboardIsShown;
    UITextField *currentTextField;
    
    
    UITextField *textField_location;
    UITextField *textField_description;
    
    UILabel *label_date;
    
    UIPanGestureRecognizer *panGesture_location;
    UIPanGestureRecognizer *panGesture_description;
    UIPanGestureRecognizer *panGesture_date;
    
    UIPinchGestureRecognizer *pinchGesture_location;
    UIPinchGestureRecognizer *pinchGesture_description;
    UIPinchGestureRecognizer *pinchGesture_date;
    
    UIRotationGestureRecognizer *rotateGesture_location;
    UIRotationGestureRecognizer *rotateGesture_description;
    UIRotationGestureRecognizer *rotateGesture_date;
}

@end

@implementation PhotoEditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [filterArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * const identifier = @"coreImageCell";
    CoreImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    /*NSString *nameString = [filterNameArray objectAtIndex:indexPath.row];
    NSString *imageNameString = [NSString stringWithFormat:@"filter_%@.JPG", nameString];
    UIImage *image = [UIImage imageNamed:imageNameString];
    
    if(image == nil){
        image = [UIImage imageNamed:@"filter_Normal.JPG"];
    }*/
    
    
    //cell.coreImageImageView.image = image;
    if(indexPath.row == 0){
        cell.coreImageImageView.image = self.image;
    }
    else{
        UIImage *cellImage = [self convertImage:self.image toSize:CGSizeMake(30, 30) withFilter:[filterArray objectAtIndex:indexPath.row -1]];
        cell.coreImageImageView.image = cellImage;
    }
    
    if(indexPath.row == 0){
        cell.coreImageNameLabel.text = @"Normal";
    }
    else{
        CIFilter *currentFilter = [filterArray objectAtIndex:indexPath.row -1];
        cell.coreImageNameLabel.text = [currentFilter.attributes objectForKey:@"CIAttributeFilterDisplayName"];

    }
    
    
    return cell;
}

-(UIImage *)convertImage:(UIImage *)image toSize:(CGSize)size withFilter:(CIFilter *)filter{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CIImage *ciResizedImage = [CIImage imageWithCGImage:resizedImage.CGImage options:nil];
    [filter setValue:ciResizedImage forKey:kCIInputImageKey];
    
    ciResizedImage = [filter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef imageRef = [context createCGImage:ciResizedImage fromRect:ciResizedImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
        
    return newImage;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"seleted");
    if(indexPath.row == 0){
        self.photoImageView.image = self.image;
    }
    else{
        CIFilter *currentFilter = [filterArray objectAtIndex:indexPath.row - 1];
        
        CIImage *image = [CIImage imageWithCGImage:self.image.CGImage options:nil];
        
        [currentFilter setValue:image forKey:kCIInputImageKey];
        
        image = [currentFilter valueForKey:kCIOutputImageKey];
        
        
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CGImageRef imageRef = [context createCGImage:image fromRect:image.extent];
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        self.photoImageView.image = newImage;
        
        //UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    
    
    //svos = self.scrollView.contentOffset;
    
    //設定toolbar樣式
    UIImage *image = [UIImage imageNamed:@"navBarBG.png"];
    [self.ToolbarOutlet setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    //設定按鈕樣式
    UIImage *barButtonImage = [[UIImage imageNamed:@"barBtn_Y.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [self.postBtnOutlet setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    
    // Do any additional setup after loading the view.
    //keyboardIsShowing = NO;    
    
    
    filterNameArray = [[NSMutableArray alloc] initWithObjects:
                       @"Normal", @"CIColorInvert", @"CIColorMonochrome",@"CIColorPosterize", @"CIPixellate", @"CIColorMatrix", @"CIFalseColor", @"CIToneCurve", nil];
    
    filterArray = [NSMutableArray array];
    for(NSString *name in filterNameArray){
        if(![name isEqualToString:@"Normal"]){
            CIFilter *currentFilter = [CIFilter filterWithName:name];
            if([name isEqualToString:@"CIColorMatrix"]){
                [currentFilter setValue:[CIVector vectorWithX:0.2125 Y:0.7154 Z:0.0721 W:0] forKey:@"inputRVector"];
                [currentFilter setValue:[CIVector vectorWithX:0.2125 Y:0.7154 Z:0.0721 W:0] forKey:@"inputGVector"];
                [currentFilter setValue:[CIVector vectorWithX:0.2125 Y:0.7154 Z:0.0721 W:0] forKey:@"inputBVector"];
            }
            else if ([name isEqualToString:@"CIFalseColor"]){
                CIColor *myBlue = [CIColor colorWithRed:0.0 green:0.0 blue:0.6 alpha:0.5];
                CIColor *myRed = [CIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.5];
                
                [currentFilter setValue:myBlue forKey:@"inputColor0"];
                [currentFilter setValue:myRed forKey:@"inputColor1"];
            }
            
            else if ([name isEqualToString:@"CIToneCurve"]){
                [currentFilter setValue:[CIVector vectorWithX:0.0  Y:0.0] forKey:@"inputPoint0"]; // default
                [currentFilter setValue:[CIVector vectorWithX:0.27 Y:0.26] forKey:@"inputPoint1"];
                [currentFilter setValue:[CIVector vectorWithX:0.5  Y:0.80] forKey:@"inputPoint2"];
                [currentFilter setValue:[CIVector vectorWithX:0.7  Y:1.0] forKey:@"inputPoint3"];
                [currentFilter setValue:[CIVector vectorWithX:1.0  Y:1.0] forKey:@"inputPoint4"];
            }
            
            [filterArray addObject:currentFilter];
        }
    }
    

    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImageView.image = self.image;
    //self.userLocationLabel.text = @"讀取地點中.....";
    
    
    
    
    textField_location = [[UITextField alloc]initWithFrame:CGRectMake(20, 252, 250, 28)];
    textField_location.delegate = self;
    
    textField_description = [[UITextField alloc]initWithFrame:CGRectMake(20, 277, 250, 28)];
    textField_description.delegate = self;
    
    [self.scrollView addSubview:textField_location];
    [self.scrollView addSubview:textField_description];
    
    textField_location.textColor = [UIColor whiteColor];
    textField_location.font = [UIFont fontWithName:@"Oswald" size:21.0f];
    textField_location.minimumFontSize = 17;
    textField_location.adjustsFontSizeToFitWidth = YES;
    textField_location.text = @"detecting location...";
    textField_description.placeholder = @"Your Location..";
    
    textField_description.textColor = [UIColor whiteColor];
    textField_description.font =[UIFont fontWithName:@"Oswald" size:21.0f];;
    textField_description.minimumFontSize = 17;
    textField_description.adjustsFontSizeToFitWidth = YES;
    textField_description.placeholder = @"Write something here";
    
    panGesture_location = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragTextField:)];
    panGesture_description = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragTextField:)];
    pinchGesture_location = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture_description = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    rotateGesture_location = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotate:)];
    rotateGesture_description = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotate:)];
    
    [textField_location addGestureRecognizer:panGesture_location];
    [textField_description addGestureRecognizer:panGesture_description];
    [textField_location addGestureRecognizer:pinchGesture_location];
    [textField_description addGestureRecognizer:pinchGesture_description];
    [textField_location addGestureRecognizer:rotateGesture_location];
    [textField_description addGestureRecognizer:rotateGesture_description];
    
    label_date = [[UILabel alloc]initWithFrame:CGRectMake(20, 13, 152, 36)];
    [self.scrollView addSubview:label_date];
    
    label_date.textColor = [UIColor whiteColor];
    label_date.font = [UIFont fontWithName:@"Oswald" size:21.0f];
    label_date.text = self.dateString;
    label_date.backgroundColor = [UIColor clearColor];
    
    panGesture_date = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragLabel:)];
    pinchGesture_date = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    rotateGesture_date = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotate:)];
    [label_date addGestureRecognizer:panGesture_date];
    [label_date addGestureRecognizer:pinchGesture_date];
    [label_date addGestureRecognizer:rotateGesture_date];
    label_date.userInteractionEnabled = YES;
    
    
    
    //將coordinate轉成placemark
    CLLocation *theLocation = [[CLLocation alloc]initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:theLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks && placemarks.count > 0){
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            NSDictionary *addressDictionary = topResult.addressDictionary;
            NSString *streetName = [NSString stringWithFormat:@"%@", [addressDictionary objectForKey:@"Thoroughfare"]];
            if ( [streetName isEqualToString:@"(null)"]){
                //NSLog(@"1");
                //self.userLocationLabel.text = topResult.name;
                textField_location.text = topResult.name;
            }
            else{
                //self.userLocationLabel.text = streetName;
                textField_location.text = streetName;
                //NSLog(@"%@", streetName);
            }
        }
        else{
            NSLog(@"placemark is not founded");
            //self.userLocationLabel.text = @"找不到地點";
            textField_location.text = @"Location is not found (tap to edit).";
            textField_location.clearsOnBeginEditing = YES;
        }
    }];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    

    
}

- (void)viewDidAppear:(BOOL)animated{
    self.scrollView.contentSize=CGSizeMake(1024.0,1300.0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)btn_post_pressed:(id)sender {
    [self hideKeyboard];
    if([textField_location.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Location Is Empty" message:@"Could not post without location information, please write something and repost again, thanks." delegate:self cancelButtonTitle:@"I'll edit it" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //按下post後，新增location(會先判別有無重複)還有這個PHOTO
    DataAccess *da = [DataAccess sharedDataSource];
    UIImage *newPhoto = [self getImageScreenshot];
    //self.photoImageView.image = newPhoto;
    //UIImageWriteToSavedPhotosAlbum(newPhoto, nil, nil, nil);
    //[da replacePhotoWithNewPhoto:newPhoto withInfo:self.info];
    ALAssetsGroup *album = [da getAlbumWithName:da.theTrip.t_name];
    NSLog(@"album is %@",[album description]);
    NSURL *photoURL = [da returnURLAfterSaveImage:newPhoto withInfoDictionary:self.info toAlbum:album];
    
    if(![da isRegionWithName:textField_location.text ExistInTrip:da.theTrip]){
        [da createRegionWithName:textField_location.text];
    }
    else{
        da.theRegion = [da getRegionWithName:textField_location.text inTrip:da.theTrip];
    }
    
    if(![da isLocationWithLatitude:self.latitude andLongitude:self.longitude ExistInTripWithTripName:da.theTrip.t_name])
        [da createLocationWithCoordinate:CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue])];
    
    else{
        da.theLocation = [da fetchLocationWithLatitude:self.latitude andLongitude:self.longitude inTrip:da.theTrip];
    }
    
    [da createPhotoWithDate:[NSDate date] WithImageReference:[NSString stringWithFormat:@"%@", photoURL] andDescription:textField_description.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)btn_text_pressed:(id)sender {
    if(textField_description.hidden){
        textField_description.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"Pencil_disable_30.png"];
        [self.barButtonItemOutlet2 setImage:image];
    }
    else{
        textField_description.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"Pencil_30.png"];
        [self.barButtonItemOutlet2 setImage:image];
    }
    
}

- (IBAction)btn_location_pressed:(id)sender {
    if(textField_location.hidden){
        textField_location.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"Location_disable_30.png"];
        [self.barButtonItemOutlet setImage:image];
        
    }
    else{
        textField_location.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"Location_301.png"];
        [self.barButtonItemOutlet setImage:image];
    }
    
}

- (IBAction)barBtn_cancel_pressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Cancel" message:@"Your photo will not be saved, are you sure you want to cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alertView.tag = 0;
    
    [alertView show];
}

- (IBAction)btn_date_pressed:(id)sender {
    if(label_date.hidden){
        label_date.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"Date_disable_30.png"];
        [self.barButtonItemOutlet3 setImage:image];
    }
    else{
        label_date.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"Date_30.png"];
        [self.barButtonItemOutlet3 setImage:image];
    }
}


#pragma mark - AlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0){
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark - Gesture Method

- (void)dragTextField:(UIPanGestureRecognizer *)gesture{
    
    
    UITextField *textField = (UITextField *) gesture.view;

    CGPoint translation = [gesture translationInView:self.scrollView];
    
    textField.center = CGPointMake(textField.center.x + translation.x, textField.center.y + translation.y);
    
    [gesture setTranslation:CGPointZero inView:self.scrollView];
}

- (void)dragLabel:(UIPanGestureRecognizer *)gesture{
    UILabel *label = (UILabel *) gesture.view;
    
    CGPoint translation = [gesture translationInView:self.scrollView];
    
    label.center = CGPointMake(label.center.x + translation.x, label.center.y + translation.y);
    
    [gesture setTranslation:CGPointZero inView:self.scrollView];
}

-(void)handlePinch:(UIPinchGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;

}

- (void)handleRotate:(UIRotationGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    gesture.rotation = 0;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return  NO;
}


#pragma mark - keyboard behavior methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    textField.clearsOnBeginEditing = NO;
    /*if(textField.frame.origin.y > 180){
        
        self.scrollView.transform = CGAffineTransformMakeTranslation(0, 180-textField.frame.origin.y);
    }*/
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //self.scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    currentTextField = nil;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard{
    [textField_description resignFirstResponder];
    [textField_location resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"current field: %ld",(long)currentTextField.tag);
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect,  currentTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, currentTextField.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (UIImage *)getImageScreenshot{
    
    UIGraphicsBeginImageContextWithOptions(self.photoImageView.bounds.size, YES, 0.0f);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -55);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* imdata =  UIImagePNGRepresentation ( screenshotImage ); // get PNG representation
    UIImage* im2 = [UIImage imageWithData:imdata];
    
    return im2;
    
}


@end
