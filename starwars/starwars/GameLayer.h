//
//  HelloWorldLayer.h
//  starwars
//
//  Created by Axel Hernández Ferrera on 01/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"


@interface GameLayer : CCLayer {
    CCSprite *xwing;
    
    BOOL isTouching;
    
    NSMutableArray *plasmas;
    NSMutableArray *ties;
    
    long lives;
    long score;
    
    CCLabelTTF *scoreBoardLabel;
}

+(CCScene *) scene;

@end
