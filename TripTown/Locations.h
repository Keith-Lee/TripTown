//
//  Locations.h
//  TripTown
//
//  Created by MIS99 on 13/5/21.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Locations : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;


@end
