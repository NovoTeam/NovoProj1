//
//  Scene2.m
//  fat_dragon
//
//  Created by Xiang Guo on 11-12-08.
//  Copyright 2011 University of Manitoba. All rights reserved.
//

#import "PlayGame.h"
#import "MainMenu.h"
#import "Story.h"
#import "Arcade.h"
#import "Versus.h"

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
-(void) story:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Story node]];
    
}
-(void) arcade:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Arcade node]];
    
}
-(void) versus:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Versus node]];
    
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(-180, -130);
        CCMenuItemImage *arcadeItem = [CCMenuItemImage itemFromNormalImage:@"arcade_button.png" selectedImage:@"arcade_button.png" target:self selector:@selector(arcade:)];
        arcadeItem.position=ccp(-160, 0);
        CCMenuItemImage *storyItem = [CCMenuItemImage itemFromNormalImage:@"story_button.png" selectedImage:@"story_button.png" target:self selector:@selector(story:)];
        CCMenuItemImage *versusItem = [CCMenuItemImage itemFromNormalImage:@"versus_button.png" selectedImage:@"versus_button.png" target:self selector:@selector(versus:)];  
        versusItem.position=ccp(160, 0);
        CCSprite* menuBackground=[CCSprite spriteWithFile:@"playGame_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:menuBackground];
        CCMenu *play = [CCMenu menuWithItems: backItem, storyItem, arcadeItem, versusItem, nil];
        [self addChild:play];
	}
	return self;
}
@end
