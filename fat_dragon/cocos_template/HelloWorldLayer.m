//
//  HelloWorldLayer.m
//  cocos_template
//
//  Created by Xiang Guo on 11-11-17.
//  Copyright University of Manitoba 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
//allow for touch control
#import "CCTouchDispatcher.h"

static double game_time=0;

CCSprite *image_1;
CCSprite *image_2;
CCSprite *image_3;
// HelloWorldLayer implementation
@implementation HelloWorldLayer


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
	if( (self=[super init])) {
        image_1=[CCSprite spriteWithFile:@"Icon-Small.png"];
        image_1.position=ccp(300,349);
        [self addChild:image_1];
        
        image_2=[CCSprite spriteWithFile:@"Icon-Small.png"];
        image_2.position=ccp(300,349);
        [self addChild:image_2];
        
        image_3=[CCSprite spriteWithFile:@"Icon-Small-50.png"];
        image_3.position=ccp(25,25);
        [self addChild:image_3];
        
        [self schedule:@selector(callEveryFrame:)];
        //register this view to respond touches(just make the picture respond)   gay joke as the tutorial said lol
        [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void) callEveryFrame: (ccTime)dt
{
    [self schedule:@selector(foodAnimation1:)];
}
- (void) foodAnimation1: (ccTime)dt
{
    game_time+=(arc4random()%5)*dt;
    image_1.position=ccp(image_1.position.x+5*sin(game_time), image_1.position.y*0.9);
    image_2.position=ccp(image_2.position.x+5*sin(game_time), image_2.position.y*0.9);
    if (image_1.position.y<0&&image_2.position.y<0) {
        image_1.position=ccp(100+arc4random()%100, 349);
        image_2.position=ccp(100+arc4random()%100, 349);
        game_time=0;
    }
}
//needed for any touch to begin touch
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}
//when we lift our finger, end of touch
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //take the position you touch
    CGPoint location=[self convertTouchToNodeSpace:touch];
    if (location.x<(image_1.position.x+50)&&location.x>(image_1.position.x-50)&&location.y<(image_1.position.y+50)&&location.y>(image_1.position.y-50)) {
        image_1.position = location;
    }
    [self checkCollision];
}
-(void)checkCollision{
    if ( (image_1.position.x-14.5) < (image_3.position.x+25) && (image_1.position.y-14.5)<(image_3.position.y+25)) {
        image_1.position=ccp(100+arc4random()%100, 349);
    }
}
@end
