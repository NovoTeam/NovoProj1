//
//  GameLevel.h
//  Game
//
//  Created by Patrick Johnstone on 12-01-17.
//  Copyright University of Manitoba 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// GameLevel
@interface Game: CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    CCSprite * background;
    CCSprite * selSprite;
    NSMutableArray * movableSprites;
}

// returns a CCScene that contains the GameLevel as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
@end
