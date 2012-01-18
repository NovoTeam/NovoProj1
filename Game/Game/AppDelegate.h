//
//  AppDelegate.h
//  Game
//
//  Created by Patrick Johnstone on 12-01-17.
//  Copyright University of Manitoba 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
