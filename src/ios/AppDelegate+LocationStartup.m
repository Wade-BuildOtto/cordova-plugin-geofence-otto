//
//  AppDelegate+LocationStartup.m
//  GeoFencev2
//
//  Created by Colin Humber on 2017-05-05.
//
//

#import "AppDelegate+LocationStartup.h"
#import "GeoFencev2-Swift.h"
#import <objc/runtime.h>

@interface AppDelegate()
@property (strong) GeoNotificationManager *geoManager;

@end

@implementation AppDelegate (LocationStartup)

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        SEL applicationDidFinishLaunchingSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL geoApplicationDidFinishLaunchingSelector = @selector(geo_application:didFinishLaunchingWithOptions:);
        Method originalMethod = class_getInstanceMethod(self, applicationDidFinishLaunchingSelector);
        Method extendedMethod = class_getInstanceMethod(self, geoApplicationDidFinishLaunchingSelector);
        method_exchangeImplementations(originalMethod, extendedMethod);
    });
}

- (BOOL)geo_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL didLaunch = [self geo_application:application didFinishLaunchingWithOptions:launchOptions];
    
    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        self.geoManager = [[GeoNotificationManager alloc] init];
        
        [self.geoManager.locationManager startUpdatingLocation];
        [self.geoManager.locationManager startMonitoringSignificantLocationChanges];
    }
    
    return didLaunch;
}

- (void)setGeoManager:(GeoNotificationManager *)geoManager {
    objc_setAssociatedObject(self, @selector(geoManager), geoManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GeoNotificationManager *)geoManager {
    return objc_getAssociatedObject(self, @selector(geoManager));
}

@end
