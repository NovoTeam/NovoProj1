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
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
// enums that will be used as tags


// MainMenu implementation
@implementation MainMenu
static bool toMute=true;
CCSprite *volume;
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
        //play background music
        [self defaultBackgroundMusic];
        
        //make backGround
        CCSprite* menuBackground=[CCSprite spriteWithFile:@"menu_background.png"];
        //create an layer
        CCLayer* layer=[CCLayer node];
        
        //add layer and background to main menu
        [self addChild:layer];
        [self addChild:menuBackground];
        
        //make volume image
        volume=[CCSprite spriteWithFile:@"volume_button.png"];
        //this sprite use screen base coordinate: left bottom (0,0)
        volume.position=ccp(460, 300);
        [self addChild:volume];
        
        //set back ground and sprite touchable, but not effect happen
        [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches: YES];
        
        
        //make menu button
        
        //button for going to profile
        CCMenuItemImage *profile=[CCMenuItemImage itemFromNormalImage: @"profile_button.png" selectedImage:@"profile_button.png" target:self selector:@selector(profile:)];        
        profile.position=ccp(-160, -50);
        
        //button for going to play game scene
        CCMenuItemImage *play_game=[CCMenuItemImage itemFromNormalImage:@"play_button.png" selectedImage:@"play_button.png" target:self selector:@selector(playGame:)];
        play_game.position=ccp(0, -50);

        
        //right now having problem to quit game
        CCMenuItemImage *quit=[CCMenuItemImage itemFromNormalImage: @"quit.png" selectedImage:@"quit_button.png"];
        quit.position=ccp(160, -50);
        
        //adding all these menu button to a menu object
        CCMenu *main_menu = [CCMenu menuWithItems: profile, play_game, quit, nil];
        
        //adding menu object to this class
        [self addChild:main_menu];
        
    }
	return self;
}

//START
//method for checking if client touch target sprite
-(bool) isTouchable: (CGPoint) touchLocation, CCSprite* target 
{
    //check if the touch location is inside target boundary
    if (CGRectContainsPoint(target.boundingBox, touchLocation)) {
        return true;
    }
    else
    {
        return false;
    }
}
//END

//START
//Author: Xiang Guo
-(void)defaultBackgroundMusic
{
    //play back ground music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_music.mp3"];
}
//END

//START
//Author: Xiang Guo
//Method for touch sprite
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[self convertTouchToNodeSpace:touch];
    [self changeSound: touchLocation];
    return YES;
}

//START***********************************************
//author: Xiang Guo
//method actually mute the sound or enable the sound
-(void) changeSound:(CGPoint)touchLocation
{
    if([self isTouchable: touchLocation, volume])
    {
        if (toMute) 
        {
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
            [volume setTexture:[[CCTextureCache sharedTextureCache] addImage:@"volume_mute_button.png"]];
            toMute=false;
        }
        else
        {
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
            [volume setTexture:[[CCTextureCache sharedTextureCache] addImage:@"volume_button.png"]];
            toMute=true;
        }
    }
}
//END***************************************************

//START*************************************************
//author: Xiang Guo
//method for going to playGame scene
-(void) playGame:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[PlayGame node]];
}
//END***************************************************

//START*************************************************
//Author: Xiang Guo
//method for going into profile
-(void) profile:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[Profile node]];
}
//END***************************************************


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
