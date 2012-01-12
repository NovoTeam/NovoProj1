//
//  Arcade.m
//  fat_dragon
//
//  Created by Xiang Guo on 12-01-01.
//  Copyright 2012 University of Manitoba. All rights reserved.
//

#import "Arcade.h"
#import "MainMenu.h"
@implementation Arcade
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Arcade *layer = [Arcade node];
	
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
        CCSprite* menuBackground=[CCSprite spriteWithFile:@"arcade_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:menuBackground];
        CCMenu *arcade = [CCMenu menuWithItems: backItem, nil];
        [self addChild:arcade];
    }
	return self;
}
@end
