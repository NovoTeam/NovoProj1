//
//  Story.m
//  fat_dragon
//
//  Created by Xiang Guo on 11-12-31.
//  Copyright 2011 University of Manitoba. All rights reserved.
//

#import "Story.h"
#import "MainMenu.h"
#import "Bag.h"

@implementation Story
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Story *layer = [Story node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void) back:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[MainMenu node]];
    
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
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(-180, -130);
        CCMenuItemImage *bagItem = [CCMenuItemImage itemFromNormalImage:@"bag_button.png" selectedImage:@"bag_button.png" target:self selector:@selector(bag:)];
        bagItem.position=ccp(180, -130);        
        CCSprite* storyBackground=[CCSprite spriteWithFile:@"story_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:storyBackground];
        CCMenu *storyMenu = [CCMenu menuWithItems: backItem, bagItem, nil];
        [self addChild:storyMenu];
	}
	return self;
    
}
@end
