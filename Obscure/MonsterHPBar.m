//
//  MonsterHPBar.m
//  Obscure
//
//  Created by Derrick Chuong on 12/2/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import "MonsterHPBar.h"

@implementation MonsterHPBar

- (id)init {
    if (self = [super init]) {
        self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(75,20)];
        SKSpriteNode * sprite = [SKSpriteNode spriteNodeWithImageNamed:@"monsterHP.png"];
        [self addChild:sprite];
    }
    return self;
}

- (id) initWithCustomSize:(CGSize)cgsize {
    self = [super init];
    if(self) {
        self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:cgsize];
        SKSpriteNode * sprite = [SKSpriteNode spriteNodeWithImageNamed:@"monsterHP.png"];
        [self addChild:sprite];
    }
    return self;
}

//Sets the HP based on the type of monster
- (void) setHP:(CGFloat) hp {
    self.maskNode.xScale = hp;
}

//Whent he monster gets hurt the damage is taken and used to change the monster's hp
-(void) hurt:(CGFloat) damage, hp{
    hp -=damage;
    [self update: hp];
}

//updates the HP and the image of the HP
-(void) update:(CGFloat) hp{
    [self setHP:hp];
}

//returns the HP
-(float) getHP{
    return hp;
}

@end
