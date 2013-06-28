//
//  PHOTO.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/8.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LOCATION;

@interface PHOTO : NSManagedObject

@property (nonatomic, retain) NSDate * p_date;
@property (nonatomic, retain) NSString * p_image;
@property (nonatomic, retain) NSString * p_description;
@property (nonatomic, retain) LOCATION *location;

@end
