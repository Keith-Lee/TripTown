//
//  MyAnnotation.m
//  TripTown
//
//  Created by 李 國揚 on 13/5/2.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)pCoordinate Title:(NSString *)pTitle andSubtitle:(NSString *)pSubtitle{
    self = [super init];
    
    if(self){
        self.coordinate = pCoordinate;
        self.title = pTitle;
        self.subtitle = pSubtitle;
    }
    
    return self;
}

@end
