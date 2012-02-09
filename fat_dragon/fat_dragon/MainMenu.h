//
//  HelloWorldLayer.h
//  fat_dragon
//
//  Created by Xiang Guo on 11-12-08.
//  Copyright University of Manitoba 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


// HelloWorldLayer
@interface MainMenu : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
//method for going to playGame menu
-(void) playGame:(id)sender;
//method for going to profile menu
-(void) profile:(id)sender;

//method for changing sound
-(void) changeSound:(CGPoint)touchLocation;
//method for play back ground music
-(void)defaultBackgroundMusic;
@end
