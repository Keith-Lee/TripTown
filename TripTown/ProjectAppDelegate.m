//
//  ProjectAppDelegate.m
//  TripTown
//
//  Created by 李 國揚 on 13/4/19.
//  Copyright (c) 2013年 李 國揚. All rights reserved.
//

#import "ProjectAppDelegate.h"
#import "HistoryTripCollectionViewController.h"
#import <RestKit/RestKit.h>


@implementation ProjectAppDelegate
@synthesize m_managedObjectContext, m_manageObjectModel, m_persistStoreCoordinator;
//FB synth
@synthesize navController = navController;
@synthesize mainViewController = mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[self StartFBConnectAfterLaunch];
    //設定字型
    [[UILabel appearance] setFont:[UIFont fontWithName:@"BebasNeue" size:19.0f]];
    //設定navbar樣式
    UIImage *image = [UIImage imageNamed:@"navBarBG.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                     UITextAttributeFont: [UIFont fontWithName:@"BebasNeue" size:28.0f]}];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-5 forBarMetrics:UIBarMetricsDefault];
    
        //設定bar鈕樣式
    UIImage *barButtonImage = [[UIImage imageNamed:@"barBtn_G.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 2) forBarMetrics:UIBarMetricsDefault];
    
    //設定back鈕樣式
    UIImage *backButtonImage = [[UIImage imageNamed:@"backBtn_G.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //back鈕文字offset
    //IT DOES NOT FUCKING WORKKKKKKKKKKKKKKKK QAQ
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(4, 2) forBarMetrics:UIBarMetricsDefault];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Application's Documents Directory
//取得應用程式Documents目錄的子路徑。
-(NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


/*
   傳回已經被初始化過的 NSPersistentStoreCoordinator 物件
   如果已經初始化過就直接傳回
   不然就開啟 Documents 下的 ios6.sqlite檔案
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    //如果已經初始化就傳回
    if(m_persistStoreCoordinator != nil){
        return  m_persistStoreCoordinator;
    }
    
    //從Documents目錄下指定物件的路徑
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"data.sqlite"];
    
    NSError *error = nil;
    //初始化並傳回
    m_persistStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    
    if(![m_persistStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error: &error]){
        NSLog(@"在存取資料庫時發生不可預期的錯誤 %@, %@", error, [error userInfo]);
        abort();
    }
    
    return m_persistStoreCoordinator;
}

/* 從Data Model檔中建立NSManagedObjectModel物件
   如果已經建立會直接回傳不用再次讀取。
 */
- (NSManagedObjectModel *)managedObjectModel{
    //如果物件已經初始化過就直接回傳
    if(m_manageObjectModel != nil){
        return m_manageObjectModel;
    }
    //沒有的話就直接載入該檔案之後回傳
    //在URLForResource中傳入Data Madel的檔名
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TripTownModel" withExtension:@"momd"];
    //從Model檔案中實例化 m_manageObjectModel
    m_manageObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL: modelURL];
    
    return m_manageObjectModel;
}

/* 傳回這個應用程式的 NSManagedObjectContext 物件
   如果已經存在就直接回傳，不然就從 sql-lite 中
   藉由 persistStoreCoordinator 中讀取
 */

-(NSManagedObjectContext *)managedObjectContext{
    //如果物件已經初始化就直接回傳
    if(m_managedObjectContext != nil){
        return m_managedObjectContext;
    }
    
    //不然就使用 persistentStoreCoordinator 從資料庫中讀取
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        m_managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [m_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return m_managedObjectContext;
}

//將資料儲存進managedObjectContext中
- (void)saveContext{
    NSError *error = nil;
    //取得 NSManagedObjectContext 物件
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    //如果存在就進行儲存的動作
    if(managedObjectContext != nil){
        //如果資料有變更就進行儲存
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            //資料儲存發生錯誤
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

///////////FB codes////////////
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    
    switch (state) {
        case FBSessionStateOpen:
            if ([FBSession activeSession].accessTokenData.accessToken!=NULL) {
                NSLog(@"This is token %@",[FBSession activeSession].accessTokenData.accessToken);
            }
            [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            if([[(UINavigationController *)self.window.rootViewController topViewController] isKindOfClass:[HistoryTripCollectionViewController class]]){
                
                
            }
            else{
                [[(UINavigationController *)self.window.rootViewController topViewController] performSegueWithIdentifier:@"goToMain" sender:self.window.rootViewController];
                [self gogogo];
                NSLog(@"Opened");
            }
            break;
            
        case FBSessionStateClosed:
            NSLog(@"Closed");
        case FBSessionStateClosedLoginFailed:
            NSLog(@"Failed");
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            NSLog(@"Restarted");
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    //NSLog(@"2");
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
}
- (void)StartFBConnectAfterLaunch
{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
}
- (void)showLoginView
{
    //NSLog(@"4");
    
    [self performSelector:@selector(loadAuthenticateViewController) withObject:nil afterDelay:1.0];
    
}

- (void)gogogo
{
    LogInViewController* login = [[LogInViewController alloc]init];
    [login postTokenwithRK];
}

-(void)loadAuthenticateViewController
{
    [self.window.rootViewController performSegueWithIdentifier:@"goToLogin" sender:self.window.rootViewController];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
    //NSLog(@"5");
}

- (void)logOut{
    [FBSession.activeSession closeAndClearTokenInformation];
}
@end
