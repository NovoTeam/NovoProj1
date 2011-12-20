//
//  Scene2.m
//  fat_dragon
//
//  Created by Xiang Guo on 11-12-08.
//  Copyright 2011 University of Manitoba. All rights reserved.
//

#import "PlayGame.h"
#import "MainMenu.h"

@implementation PlayGame
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayGame *layer = [PlayGame node];
	
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
        CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"Icon-72.png" selectedImage:@"Icon-72.png" target:self selector:@selector(back:)];
        CCMenu *menu_2 = [CCMenu menuWithItems:item2, nil];
        [self addChild:menu_2];
	}
	return self;
}
@end
