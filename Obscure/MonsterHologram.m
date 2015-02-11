<<<<<<< HEAD
//
//  MonsterHologram.m
//  Obscure
//
//  Created by Minjae Wee, Michelle Tjoa, and Michelle Wong on 1/27/15.
//  Copyright (c) 2015 Calvin Tham. All rights reserved.
//

#import <Foundation/Foundation.h>

// monsterHologram

// <Variables>
//  SKSpriteNode * sprite;
//  float health;

// <Functions>
/*
    init(int x, int y, int width, int height);
    hurt(); // called when hurt

    update(); // Update necessary things if needed like animations
    checkForTouchesBegan(); // Check if touchedBegan, then do necessary tasks
*/
=======
#import "MonsterHologram.h"

@implementation MonsterHologram
@synthesize sprite;

-(id)init :(float)x :(float)y :(float)width :(float)height
{
    self = [super init];
    [sprite setPosition:CGPointMake(x, y)];
    [sprite setSize:CGSizeMake(width, height)];
    return self;
}

-(void)hurt
{
    health -= DMG;
}

-(void)update
{
//Might need to add sth later.
}

-(void)checkForTouchesBegan:(CGPoint)loc
{
/*
    if ([[self nodeAtPoint:loc].name isEqualToString:MonsterHologram.name])
    {
        hurt();
    }
*/
}
    
@end
>>>>>>> FETCH_HEAD
