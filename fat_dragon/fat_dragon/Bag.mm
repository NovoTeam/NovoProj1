//
//  Bag.m
//  fat_dragon
//
//  Created by Xiang Guo on 12-01-01.
//  Copyright 2012 University of Manitoba. All rights reserved.
//

#import "Bag.h"
#import "Stage.h"

@implementation Bag
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Bag *layer = [Bag node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(void) back:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[Stage node]];
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(180, -130);
        CCSprite* bagBackground=[CCSprite spriteWithFile:@"bag_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:bagBackground];
        CCMenu *bagMenu = [CCMenu menuWithItems: backItem, nil];
        [self addChild:bagMenu];
	}
	return self;
    
}
@end
