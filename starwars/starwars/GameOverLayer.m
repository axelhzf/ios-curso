//
//  GameOverLayer.m
//  bubbletap
//
//  Created by Axel Hernández Ferrera on 01/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameLayer.h"

@implementation GameOverLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
    GameOverLayer *layer = [GameOverLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    self = [super init];
    if(self){        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"the force is not with you"
                           fontName:@"Starjhol.ttf" 
                           fontSize:28];
        [label setColor:ccYELLOW];
        CGSize winsize = [[CCDirector sharedDirector] winSize];
        label.position = ccp(winsize.width / 2, winsize.height / 2);
        [self addChild:label];
        
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:3],
                         [CCCallFunc actionWithTarget:self selector:@selector(tryAgain)],
                         nil]];
    }
    return self;
}

- (void)tryAgain {
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}

@end
