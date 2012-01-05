//
//  HelloWorldLayer.mm
//  box2dtutorial
//
//  Created by Patrick Johnstone on 11-12-08.
//  Copyright NovoTeam 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

@implementation HelloWorld

+ (id)scene {
    
    CCScene *scene = [CCScene node];
    HelloWorld *layer = [HelloWorld node];
    [scene addChild:layer];
    return scene;
    
}

- (id)init {
    
    if ((self=[super init])) 
    {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Create sprite and add it to the layer
        _ball = [CCSprite spriteWithFile:@"Ball.jpg" rect:CGRectMake(0, 0, 52, 52)];
        _ball.position = ccp(100, 100);
        [self addChild:_ball];
        
        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, -30.0f); //set velocity - gravity vector
        bool doSleep = true; //A sleeping object will not take up processing time until certain actions occur such as colliding with another object
        _world = new b2World(gravity, doSleep); //Box2D world object that controls all the Box2D related stuff
        
        //create invisible edges around the entire screen, that line up with the edges of our iPhone
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        _groundBody = _world->CreateBody(&groundBodyDef);
        b2PolygonShape groundBox;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundBox;
        groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(0, winSize.height/PTM_RATIO), 
                            b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO, 
                                   winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
        _groundBody->CreateFixture(&boxShapeDef);
        
        
        // *** Create ball body and shape (one body object can contain multiple fixture objects)
        
        
        //create the ball body like the groundbody
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody; //default value for bodies is to be a static body, which means it does not move and will not be simulated. Obviously we want our ball to be simulated
        ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
        ballBodyDef.userData = _ball; //set the user data parameter to be our ball CCSprite
        _ballBody = _world->CreateBody(&ballBodyDef); //add one fixture objects
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle; //its a ball so use a circle shape
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        _ballFixture = _ballBody->CreateFixture(&ballShapeDef); //add another fixture object
        
        self.isTouchEnabled = YES; //enable accel so we can make it bounce around!
        
        
        // Create paddle and add it to the layer
        CCSprite *paddle = [CCSprite spriteWithFile:@"icon-72.png"];
        paddle.position = ccp(winSize.width/2, 50);
        [self addChild:paddle];
        
        // Create paddle body
        b2BodyDef paddleBodyDef;
        paddleBodyDef.type = b2_dynamicBody;
        paddleBodyDef.position.Set(winSize.width/2/PTM_RATIO, 50/PTM_RATIO);
        paddleBodyDef.userData = paddle;
        _paddleBody = _world->CreateBody(&paddleBodyDef);
        
        // Create paddle shape
        b2PolygonShape paddleShape;
        paddleShape.SetAsBox(paddle.contentSize.width/PTM_RATIO/2, 
                             paddle.contentSize.height/PTM_RATIO/2);
        
        // Create shape definition and add to body
        b2FixtureDef paddleShapeDef;
        paddleShapeDef.shape = &paddleShape;
        paddleShapeDef.density = 10.0f;
        paddleShapeDef.friction = 0.4f;
        paddleShapeDef.restitution = 0.1f;
        _paddleFixture = _paddleBody->CreateFixture(&paddleShapeDef);
        
        //[self schedule:@selector(tick:)];
        
    }
    return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location]; //convert the touch location to our Cocos2D coordinates (convertToGL) 
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO); //and then to our Box2D coordinates (locationWorld)
    
    if (_paddleFixture->TestPoint(locationWorld)) //see if the touch point is within the fixture. 
    {
        //If it is, we create something called a “mouse joint.” a mouse joint is used to make a body move toward a specified point – in this case where the user is tapping
        b2MouseJointDef md;
        md.bodyA = _groundBody;
        md.bodyB = _paddleBody; //the body you want to move
        md.target = locationWorld; //specify where you want the target to move – in our case where the user is tapping
        md.collideConnected = true; //treat it as a collision, rather than ignoring it. This is very important. When I was trying to get this working, I didn’t have this set, so when I was moving the paddle with my mouse it wouldn’t collide with the edges of the screen
        md.maxForce = 1000.0f * _paddleBody->GetMass(); //If you reduce this amount, the body will react more slowly to your mouse movements
        
        md.bodyB->SetAwake(true);
        _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
        
    }
    
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld); //update the target of the mouse joint (i.e. where we want the body to move) to be the current location of the touch
    
}

//destroy the mouse joint because when the touches end
-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

//destroy the mouse joint because when the touches end
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }  
}

//setting the gravity vector in the simulation to be a multiple of the acceleration vector.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Landscape left values
    b2Vec2 gravity(-acceleration.y * 15, acceleration.x *15);
    _world->SetGravity(gravity);
    
}

/*
- (void)tick:(ccTime) dt {
    
    //perform the physics simulation. The two parameters here are velocity iterations and position iterations
    _world->Step(dt, 10, 10);
    
    //iterate through all of the bodies in the world looking for those with user data set
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
        if (b->GetUserData() != NULL) {
            //update the position and angle of the sprite to match the physics simulation
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                    b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }        
    }
    
}*/

- (void)dealloc {    
    delete _world;
    _ballBody = NULL;
    _world = NULL;
    [super dealloc];
}

@end // on "dealloc" you need to release all your retained objects
