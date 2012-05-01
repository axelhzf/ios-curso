//
//  HelloWorldLayer.m
//  starwars
//
//  Created by Axel Hernández Ferrera on 01/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//



#import "GameLayer.h"
#import "CCTouchDispatcher.h"

#define kXWingMarginLeft 40
#define kXWingUpSpeed 300
#define kXWingDownSpeed 200
#define kPlasmaTag 1
#define kPlasmaInteral 2

#define kAnimationMinDuration 2.0
#define kAnimationMaxDuration 4.0

#define ARC4RANDOM_MAX      0x100000000

@implementation GameLayer

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
    
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	
	return scene;
}

#pragma mark - randoms
+ (int)randomIntBetweenMin:(int)min andMax:(int)max {
     return (arc4random() % (max-min + 1)) + min ;
}

+ (float)randomFloatBetweenMin:(float)min andMax:(float)max {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min)) + min;    
}

#pragma mark - Xwing

- (void)addXWing {
    xwing = [CCSprite spriteWithFile:@"xwing.png" rect:CGRectMake(0, 0, 50, 33)];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    xwing.position = ccp(0 + kXWingMarginLeft, winSize.height /2);
    
    [self addChild:xwing];
}

- (void)moveXWingY:(long)yDistance {
    xwing.position = ccp(xwing.position.x, xwing.position.y + yDistance);
}

- (void)limitXWingPositionInScreen {
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    
    CGFloat midHeight = xwing.contentSize.width / 2;
    CGFloat top = xwing.position.y + midHeight;
    CGFloat bottom = xwing.position.y - midHeight; 
    
    if(top >= winSize.height){
        xwing.position = ccp(xwing.position.x, winSize.height - midHeight);
    }else if(bottom < 0){
        xwing.position = ccp(xwing.position.x, 0 + midHeight);
    }
}

#pragma mark - plasma and tie

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;

    if(sprite.tag == kPlasmaTag){
        [plasmas removeObject:sprite];        
    }
    [self removeChild:sprite cleanup:YES];
}

- (void)randomMove:(CCSprite*)sprite {        
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int minY = sprite.contentSize.height/2;
    int maxY = winSize.height - sprite.contentSize.height/2;
    int actualY = [GameLayer randomIntBetweenMin:minY andMax:maxY];
        
    sprite.position = ccp(winSize.width + (sprite.contentSize.width/2), actualY);
    [self addChild: sprite];
     
    ccTime duration = [GameLayer randomFloatBetweenMin:kAnimationMinDuration andMax:kAnimationMaxDuration];
    
    id actionMove = [CCMoveTo actionWithDuration:duration 
                                        position:ccp(-sprite.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(spriteMoveFinished:)];
    [sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)addPlasma {
    CCSprite *plasma = [CCSprite spriteWithFile:@"plasma.png" rect:CGRectMake(0, 0, 30, 30)];
    plasma.tag = kPlasmaTag;
    
    [self randomMove:plasma];
    [plasmas addObject:plasma];    
}


#pragma mark - collisions

- (CGRect)rectFromSprite:(CCSprite *)sprite {
    return CGRectMake(
                      sprite.position.x - (sprite.contentSize.width/2), 
                      sprite.position.y - (sprite.contentSize.height/2), 
                      sprite.contentSize.width, 
                      sprite.contentSize.height);
}

- (NSArray *)detectXWingCollisions:(NSArray*)sprites {
    NSMutableArray *collisions= [[NSMutableArray alloc] init];
    CGRect shipRect = [self rectFromSprite:xwing];
    for(CCSprite *sprite in sprites){
        CGRect spriteRect = [self rectFromSprite:sprite];
        
        if(CGRectIntersectsRect(shipRect, spriteRect)){
            [collisions addObject:sprite];
        }
    }
    return collisions;
}

- (BOOL)detectCollions {
    BOOL collisions = NO;
    NSArray *plasmasCollisions = [self detectXWingCollisions:plasmas];
    
    if(plasmasCollisions.count > 0){
        collisions = YES;
    }
    
    for(CCSprite *plasma in plasmasCollisions){
        [self spriteMoveFinished:plasma];
    }
    
    [plasmasCollisions release];    
    return collisions;
}

#pragma mark - main loop

- (void)nextFrame:(ccTime)dt {
    if(isTouching){
        [self moveXWingY:kXWingUpSpeed * dt];
    }else{
        [self moveXWingY:-kXWingDownSpeed * dt];
    }
    [self limitXWingPositionInScreen];
    [self detectCollions];
}

- (id)init {
    self = [super init];    
	if(self) {
        isTouching = NO;
        self.isTouchEnabled = YES;
        
        plasmas = [[NSMutableArray alloc] init];
        
        [self addXWing];
        
        [self schedule:@selector(nextFrame:)];
        [self schedule:@selector(addPlasma) interval:kPlasmaInteral];
	}
	return self;
}

#pragma mark - touches

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    isTouching = YES;
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event { 
    isTouching = NO;
}

- (void)registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark - dealloc

- (void)dealloc {
    [plasmas release];
    
	[super dealloc];
}

@end
