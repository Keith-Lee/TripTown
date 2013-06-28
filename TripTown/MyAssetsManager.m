//
//  MyAssetsManager.m
//  TripTown
//
//  Created by 李 國揚 on 13/5/16.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "MyAssetsManager.h"

@implementation MyAssetsManager

+ (ALAssetsLibrary *)defaultAssetLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


@end
