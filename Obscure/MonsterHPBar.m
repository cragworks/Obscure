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

- (void) setHP:(CGFloat) hp {
    self.maskNode.xScale = hp;
}
@end
