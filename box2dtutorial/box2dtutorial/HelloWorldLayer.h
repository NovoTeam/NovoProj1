//
//  HelloWorldLayer.h
//  box2dtutorial
//
//  Created by Patrick Johnstone on 11-12-08.
//  Copyright NovoTeam 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32.0

@interface HelloWorld : CCLayer { 
    b2World *_world;
    b2Body *_body;
    CCSprite *_ball;
}

+ (id) scene;

@end