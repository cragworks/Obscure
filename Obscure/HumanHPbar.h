//
//  HumanHPbar.h
//  Obscure
//
//  Created by Roni Tu on 12/4/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#define Total_HealthBar 8

@interface HumanHPbar : NSObject
{
    int hp;
    int damage;
    SKSpriteNode * sprite;
    SKTexture* image;
}
@property SKSpriteNode* sprite;
-(void)heal;
- (void)humanwound;
-(int) getHP;
@end
