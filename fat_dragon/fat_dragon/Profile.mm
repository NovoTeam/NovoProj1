//
//  Profile.m
//  fat_dragon
//
//  Created by Xiang Guo on 11-12-31.
//  Copyright 2011 University of Manitoba. All rights reserved.
//
#import "Profile.h"
#import "MainMenu.h"

@implementation Profile
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Profile *layer = [Profile node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void) back:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[MainMenu node]];
    
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(-180, -130);
        CCSprite* profileBackground=[CCSprite spriteWithFile:@"profile_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:profileBackground];
        CCMenu *profile = [CCMenu menuWithItems: backItem, nil];
        [self addChild:profile];
	}
	return self;
     
}
@end