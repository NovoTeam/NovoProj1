//
//  Stage.m
//  fat_dragon
//
//  Created by Xiang Guo on 12-01-24.
//  Copyright 2012 University of Manitoba. All rights reserved.
//

#import "Stage.h"
#import "MainMenu.h"
#import "Game.h"
#import "Bag.h"
@implementation Stage
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Stage *layer = [Stage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void) back:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[MainMenu node]];
    
}
-(void) next:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Game node]];
    
}
-(void) bag:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Bag node]];
    
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
        CCSprite* stageBackground=[CCSprite spriteWithFile:@"stage_backgr.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild: stageBackground];
        
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(-180, -130);
        CCMenuItemImage *nextItem = [CCMenuItemImage itemFromNormalImage:@"next_button.png" selectedImage:@"next_button.png" target:self selector:@selector(next:)];
        nextItem.position=ccp(0, -130);
        
        CCMenuItemImage *bagItem = [CCMenuItemImage itemFromNormalImage:@"bag_button.png" selectedImage:@"bag_button.png" target:self selector:@selector(bag:)];
        bagItem.position=ccp(180, -130);
        CCMenu *stageMenu = [CCMenu menuWithItems: backItem, nextItem, bagItem, nil];
        [self addChild:stageMenu];

    }
    return self;
}
@end
