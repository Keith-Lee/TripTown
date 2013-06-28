//
//  ProjectAppDelegate.h
//  TripTown
//
//  Created by 李 國揚 on 13/4/19.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import <UIKit/UIKit.h>
//FB import
#import <FacebookSDK/FacebookSDK.h>
#import "CheckLoginViewController.h"
#import "LogInViewController.h"

@interface ProjectAppDelegate : UIResponder <UIApplicationDelegate>{
    
    //增加core data的成員變數
    NSManagedObjectContext *m_managedObjectContext;
    NSManagedObjectModel *m_manageObjectModel;
    NSPersistentStoreCoordinator *m_persistStoreCoordinator;
}

//增加core data的成員變數property定義
@property (nonatomic, retain) NSManagedObjectContext *m_managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *m_manageObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *m_persistStoreCoordinator;


//@property (nonatomic, retain) NSArray *objectManagerArray;

@property (strong, nonatomic) UIWindow *window;

//FB property
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) CheckLoginViewController * mainViewController;

//將物件同步進core data
- (void)saveContext;
//傳回這個應用程式目錄底下的Documents子目錄
- (NSURL *)applicationDocumentsDirectory;
//傳回這個應用程式中管理資料庫的Persistent Store Coordinator
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
//傳回這個應用程式中的物件模型管理員，負責讀取Data Model
- (NSManagedObjectModel *)managedObjectModel;
//傳回這個應用程式的物件本文管理員，用來作物件的同步。
- (NSManagedObjectContext *)managedObjectContext;


//FB codes
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;
- (void)openSession;
- (void)showLoginView;
- (void)StartFBConnectAfterLaunch;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)logOut;

@end
