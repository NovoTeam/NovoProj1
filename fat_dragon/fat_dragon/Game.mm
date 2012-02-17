//
//  GameLevel.mm
//  Game
//
//  Created by Patrick Johnstone on 12-01-17.
//  Copyright University of Manitoba 2012. All rights reserved.
//


// Import the interfaces
#import "Game.h"
#import "MainMenu.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define FALL_HEIGHT 20

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

// GameLevel implementation
@implementation Game

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game *layer = [Game node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//START
//Author: Xiang Guo
//help to go back to main menu
-(void) back:(id) sender
{
    [[CCDirector sharedDirector]replaceScene:[MainMenu node]];
    
}
//END

//PAT start -- create the fruits 
-(void)addTarget {
    
    CCSprite *target = [fruitSprites objectAtIndex: (arc4random()%4)];
    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    
    // Determine speed of the target
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}

// on "init" you need to initialize your instance
-(id) init
{
	if((self = [super init])) {		
        CGSize winSize = [CCDirector sharedDirector].winSize;
        //PAT
        b2Vec2 fruitGravity = b2Vec2(0.0f, -5.0f);
        bool doSleep = false;
        world = new b2World(fruitGravity, doSleep);
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565]; //uses less memory by loading a lower quality background
        //
        background = [CCSprite spriteWithFile:@"Icon 512x512.png"]; //load background
        background.anchorPoint = ccp(0,0); //anchor the background to bottom left
        [self addChild:background];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default]; //go back to normal memory usage and high-res images
        
        fruitSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:@"watermelon.png", @"apple.png", @"grape.png", @"pineapple.png", nil];       
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image rect:CGRectMake(0, 0, 51, 51)];
            float offsetFraction = ((float)(i+1))/(images.count+1); //for our game we wil want to use a random value (restricted to a range)
            sprite.position = ccp(winSize.width*offsetFraction, winSize.height - FALL_HEIGHT);
            
            [self addChild:sprite];
            [fruitSprites addObject:sprite];
            
            ///////PAT -- adding gravity to the sprite
            [self addGravityToSprite:sprite];
            ///////PAT -- end
            
        }
        
        [self schedule:@selector(tick:)];
        
        /**XiangGuo*********set up the menu item for go back to main menu***/
        CCMenuItemImage *backItem = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
        backItem.position=ccp(-180, -130);
        CCMenu *GameMenu = [CCMenu menuWithItems: backItem, nil];
        [self addChild:GameMenu];
        /*******End**/
    }
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    return self;
}
//START
//Author: Xiang Guo
//checking how many item is eated and set up a game finished condition
/*-(void) setGame:(NSMutableArray*) movableSprites
{
    CGPoint dragonLocation=[self convertToNodeSpace:<#(CGPoint)#>]
    for (CCSprite *sprite in movableSprites) 
    {
        if (CGRectContainsPoint(dragon, )) {
        }
    }
}*/
//END

- (void) panForTranslation:(CGPoint)translation {    
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
    } 
}
//helper method that loops through all of the sprites in the movableSprites array, looking for the first sprite that the touch intersects
- (CCSprite *) selectSpriteForTouch:(CGPoint)touchLocation {
    for (CCSprite *sprite in fruitSprites) 
    {
        //"sprite.boundingbox" returns the bounding box around the sprite. This is generally better to use than computing the rectangle yourself
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {         
            return sprite;
        }
    }
    return nil;
}
- (void) shakingAnimation: (CCSprite *)newSprite
{
    if (newSprite != selSprite&& newSprite!=nil) 
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
-(void) removeGravityFromSprite:(CCSprite *)selectSprite
{   
    b2Body *body;
    
    //find body for selected sprite
    for (body=world->GetBodyList(); body&&body->GetUserData()!=selectSprite; body=body->GetNext());
    //remove body
    if (body) {
        world->DestroyBody(body);
    }
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event { 
    //has to convert the touch location from UIView coordinates to layer (node space) coordinates
    CCSprite *fruitSelected;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    fruitSelected=[self selectSpriteForTouch:touchLocation];
    if(fruitSelected!=nil)
    {
        [self shakingAnimation:fruitSelected];
        [self removeGravityFromSprite: fruitSelected];
    }
    return TRUE;    
}
//the callback you get when the user drags their finger
- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch]; //convert the touch to layer coordinates
    
    //Xiang Guo: This could have potential problem. but it is very efficient!!!!! That's why I leave it there!!!!
    selSprite.position=touchLocation;
    /*
    //get the information about the previous touch as well. no helper method to convert these, so have to do the steps to convert the touch coordinates manually
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    //figures out the amount the touch moved by subtracting the current location from the last location
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];    
     */
}
- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint dropLocation = [self convertTouchToNodeSpace:touch]; //convert the touch to layer coordinates
    CCSprite *dropSprite;
    dropSprite=[self selectSpriteForTouch: dropLocation];
    if(dropSprite!=nil)
    {
        [self addGravityToSprite:dropSprite];
    }
}
///////PAT -- adding gravity to the sprite
-(void) addGravityToSprite: (CCSprite *)sprite 
{
    //b2Vec2 fruitGravity;
    //fruitGravity.Set(0.0f, -20.0f); //we may want to change this based on which type of fruit the sprite represents (if it's a watermelon, it will fall a bit faster?)
    // Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set((sprite.position.x)/PTM_RATIO, (sprite.position.y)/PTM_RATIO);
    bodyDef.userData = sprite;
    b2Body *body = world->CreateBody(&bodyDef);
    // Define another circle shape for our dynamic body.
    b2CircleShape circle;
    circle.m_radius = (sprite.contentSize.width/2)/PTM_RATIO;
    
    // Define the dynamic body fixture.
    b2FixtureDef fruitDef;
    fruitDef.shape = &circle;
    fruitDef.density = 1.0f;
    fruitDef.friction = 0.2f;
    fruitDef.restitution = 0.8f;
    body->CreateFixture(&fruitDef);
    //body->ApplyForce(body->GetMass()*fruitGravity, body->GetWorldCenter());
    
}

- (void)tick:(ccTime) dt {
    
    world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {    
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                    b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }        
    }
    
}
/////PAT -- end

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[fruitSprites release];
    fruitSprites = nil;
    
    
    world = NULL;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
