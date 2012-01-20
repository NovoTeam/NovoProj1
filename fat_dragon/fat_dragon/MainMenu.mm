//
//  HelloWorldLayer.mm
//  fat_dragon
//
//  Created by Xiang Guo on 11-12-08.
//  Copyright University of Manitoba 2011. All rights reserved.
//


// Import the interfaces
#import "MainMenu.h"
#import "PlayGame.h"
#import "Profile.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
// enums that will be used as tags


// MainMenu implementation
@implementation MainMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
    {
        CCMenuItemImage *profile=[CCMenuItemImage itemFromNormalImage: @"profile_button.png" selectedImage:@"profile_button.png" target:self selector:@selector(profile:)];        
        profile.position=ccp(-160, -50);
        
        CCMenuItemImage *play_game=[CCMenuItemImage itemFromNormalImage:@"play_button.png" selectedImage:@"play_button.png" target:self selector:@selector(playGame:)];
        play_game.position=ccp(0, -50);
        //right now having problem to quit game
        CCMenuItemImage *quit=[CCMenuItemImage itemFromNormalImage: @"quit.png" selectedImage:@"quit_button.png"];
        
        quit.position=ccp(160, -50);
        CCSprite* menuBackground=[CCSprite spriteWithFile:@"menu_background.png"];
        CCLayer* layer=[CCLayer node];
        [self addChild:layer];
        [self addChild:menuBackground];
        CCMenu *main_menu = [CCMenu menuWithItems: profile, play_game, quit, nil];
        [self addChild:main_menu];
	}
	return self;
}
-(void) playGame:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[PlayGame node]];
}
-(void) profile:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[Profile node]];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
