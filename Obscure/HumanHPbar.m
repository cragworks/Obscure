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
            image = [SKTexture textureWithImageNamed:@"health2"];
        }else if(max == 2)
        {
            image = [SKTexture textureWithImageNamed:@"health3"];
        }else if(max ==0)
        {
             image = [SKTexture textureWithImageNamed:@"health1"];
        }
        [sprite setTexture:image];
        max+=1;
    }
}
- (void) humanwound
{
    if (max >= 1)
    {
        if (max == 3)
        {
            image = [SKTexture textureWithImageNamed:@"health2"];
        }else if(max == 2)
        {
            image = [SKTexture textureWithImageNamed:@"health1"];
        }else if(max ==1)
        {
            image = [SKTexture textureWithImageNamed:@"health0"];
        }
        [sprite setTexture:image];
        max-=1;
    }
}
@end
