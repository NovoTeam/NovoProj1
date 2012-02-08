//
//  Island.m
//  fat_dragon
//
//  Created by Xiang Guo on 12-01-24.
//  Copyright 2012 University of Manitoba. All rights reserved.
//

#import "Island.h"
#import "MainMenu.h"
#import "Stage.h"
@implementation Island
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Island *layer = [Island node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void) back:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[MainMenu node]];
    
}
-(void) stage:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Stage node]];
    
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
        CCSprite* islandBackground=[CCSprite spriteWithFile:@"island_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:islandBackground];
        
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(-180, -130);
        CCMenuItemImage *stageItem = [CCMenuItemImage itemFromNormalImage:@"stage_button.png" selectedImage:@"stage_button.png" target:self selector:@selector(stage:)];
        stageItem.position=ccp(50, -130);
        CCMenu *islandMenu = [CCMenu menuWithItems: backItem, stageItem, nil];
        [self addChild:islandMenu];
    }
	return self;
    
}
/*
#import "Bag.h"

-(void) bag:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Bag node]];
    
}
CCMenuItemImage *bagItem = [CCMenuItemImage itemFromNormalImage:@"bag_button.png" selectedImage:@"bag_button.png" target:self selector:@selector(bag:)];
 bagItem.position=ccp(180, -130); 
 */
@end
