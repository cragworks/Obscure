//
//  HumanHPbar.m
//  Obscure
//
//  Created by Roni Tu on 12/4/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import "HumanHPbar.h"

@implementation HumanHPbar
- (id)init {
    if (self = [super init]) {
        
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health3"];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float screenWidth = screenRect.size.width;
        float screenHeight = screenRect.size.height;
        [sprite setPosition:CGPointMake(sprite.size.width, screenHeight-sprite.size.height)];
        NSLog(@"%f,%f", screenWidth, screenHeight);
        hp = 3;
        [self addChild:sprite];
    }
    return self;
}
- (void) heal
{
    if (hp < 3)
    {
        if (hp == 1)
        {
            image = [SKTexture textureWithImageNamed:@"health2"];
        }else if(hp == 2)
        {
            image = [SKTexture textureWithImageNamed:@"health3"];
        }else if(hp ==0)
        {
             image = [SKTexture textureWithImageNamed:@"health1"];
        }
        [sprite setTexture:image];
        hp+=1;
    }
}
- (void) humanwound
{
    if (hp >= 1)
    {
        if (hp == 3)
        {
            image = [SKTexture textureWithImageNamed:@"health2"];
        }else if(hp == 2)
        {
            image = [SKTexture textureWithImageNamed:@"health1"];
        }else if(hp ==1)
        {
            image = [SKTexture textureWithImageNamed:@"health0"];
        }
        [sprite setTexture:image];
        hp-=1;
    }
}

- (int) getHP
{
    return hp;
}
@end
