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
        [sprite setPosition:CGPointMake(70,280)];
        max = 3;
        [self addChild:sprite];
    }
    return self;
}
- (void) heal
{
    if (max < 3)
    {
        if (max == 1)
        {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health2"];
        }else if(max == 2)
        {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health3"];
        }else if(max ==0)
        {
             sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health1"];
        }
        max+=1;
    }
}
- (void) humanwound
{
    if (max >= 1)
    {
        if (max == 3)
        {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health2"];
        }else if(max == 2)
        {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health1"];
        }else if(max ==1)
        {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"health0"];
        }
        max-=1;
    }
}
@end
