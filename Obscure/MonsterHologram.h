<<<<<<< HEAD
//
//  MonsterHologram.h
//  Obscure
//
//  Created by Minjae Wee, Michelle Tjoa, and Michelle Wong on 1/27/15.
//  Copyright (c) 2015 Calvin Tham. All rights reserved.
//

#ifndef Obscure_MonsterHologram_h
#define Obscure_MonsterHologram_h


#endif
=======
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define DMG 10

@interface MonsterHologram : NSObject
{
    SKSpriteNode* sprite;
    float health;
}

@property SKSpriteNode *sprite;
-(id)init :(float)x :(float)y :(float)width :(float)height;
-(void)hurt;
-(void)update;
-(void)checkForTouchesBegan:(CGPoint)loc;

@end
>>>>>>> FETCH_HEAD
