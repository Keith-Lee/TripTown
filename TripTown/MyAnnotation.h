//
//  MyAnnotation.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/2.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : MKPointAnnotation

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;


-(id) initWithCoordinate: (CLLocationCoordinate2D)pCoordinate Title: (NSString *)pTitle andSubtitle: (NSString *)pSubtitle;

@end
