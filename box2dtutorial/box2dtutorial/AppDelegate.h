//
//  AppDelegate.h
//  box2dtutorial
//
//  Created by Patrick Johnstone on 11-12-08.
//  Copyright University of Manitoba 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
