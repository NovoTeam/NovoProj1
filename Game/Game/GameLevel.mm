//
//  GameLevel.mm
//  Game
//
//  Created by Patrick Johnstone on 12-01-17.
//  Copyright University of Manitoba 2012. All rights reserved.
//


// Import the interfaces
#import "GameLevel.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

// GameLevel implementation
@implementation GameLevel

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevel *layer = [GameLevel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if((self = [super init])) {		
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565]; //uses less memory by loading a lower quality background
        background = [CCSprite spriteWithFile:@"Icon 512x512.png"]; //load background
        background.anchorPoint = ccp(0,0); //anchor the background to bottom left
        [self addChild:background];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default]; //go back to normal memory usage and high-res images
        
        movableSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:@"watermelon.png", @"apple.png", @"grape.png", @"pineapple.png", nil];       
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            float offsetFraction = ((float)(i+1))/(images.count+1); //for our game we wil want to use a random value (restricted to a range)
            sprite.position = ccp(winSize.width*offsetFraction, winSize.height/2);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }     		
    }
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    return self;
}



- (void)panForTranslation:(CGPoint)translation {    
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
    } 
}

//the callback you get when the user drags their finger
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch]; //convert the touch to layer coordinates
    
    //get the information about the previous touch as well. no helper method to convert these, so have to do the steps to convert the touch coordinates manually
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    //figures out the amount the touch moved by subtracting the current location from the last location
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];    
}

//helper method that loops through all of the sprites in the movableSprites array, looking for the first sprite that the touch intersects
- (void) selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites) 
    {
        //"sprite.boundingbox" returns the bounding box around the sprite. This is generally better to use than computing the rectangle yourself
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {         
            newSprite = sprite;
            break;
        }
    }    
    if (newSprite != selSprite) 
    {
        [selSprite stopAllActions]; //cancels any animation running on the previously selected sprite
        [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]]; //make the sprite appear to “wiggle” back and forth
        selSprite = newSprite;
    }
}
 
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event { 
    //has to convert the touch location from UIView coordinates to layer (node space) coordinates
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}

-(void) addNewSpriteWithCoords:(CGPoint)p 
{
    CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
    CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
    
    //We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
    //just randomly picking one of the images
    int idx = (CCRANDOM_0_1() > .5 ? 0:1);
    int idy = (CCRANDOM_0_1() > .5 ? 0:1);
    CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
    [batch addChild:sprite];
    
    sprite.position = ccp( p.x, p.y);
    
    // Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = sprite;
    b2Body *body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    body->CreateFixture(&fixtureDef);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[movableSprites release];
    movableSprites = nil;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
