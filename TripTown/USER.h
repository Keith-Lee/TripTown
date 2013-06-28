//
//  USER.h
//  TripTown
//
//  Created by 李 國揚 on 13/5/2.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TRIP;

@interface USER : NSManagedObject

@property (nonatomic, retain) NSString * u_email;
@property (nonatomic, retain) NSString * u_name;
@property (nonatomic, retain) NSString * u_password;
@property (nonatomic, retain) NSSet *trip;
@end

@interface USER (CoreDataGeneratedAccessors)

- (void)addTripObject:(TRIP *)value;
- (void)removeTripObject:(TRIP *)value;
- (void)addTrip:(NSSet *)values;
- (void)removeTrip:(NSSet *)values;

@end
