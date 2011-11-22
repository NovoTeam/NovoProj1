//
//  AppDelegate.h
//  cocos_template
//
//  Created by Xiang Guo on 11-11-17.
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
