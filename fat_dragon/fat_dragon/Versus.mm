//
//  Versus.m
//  fat_dragon
//
//  Created by Xiang Guo on 12-01-17.
//  Copyright 2012 University of Manitoba. All rights reserved.
//

#import "Versus.h"
#import "MainMenu.h"

@implementation Versus
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
        CCSprite* versusBackground=[CCSprite spriteWithFile:@"versus_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:versusBackground];
        CCMenu *versusMenu = [CCMenu menuWithItems: backItem, nil];
        [self addChild:versusMenu];
    }
    return self;
}
@end
