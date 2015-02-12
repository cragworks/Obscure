#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "MonsterHPBar.h"

@interface Monster : NSObject
{
    SKSpriteNode * sprite;
    SKTexture* image;
    CGFloat screenWidth;
    CGFloat screenHeight;
    MonsterHPBar* monsterHpClass;
}
@property SKSpriteNode * sprite;
-(void)monsterMovement;
-(void)attack;
-(void)beingAttackedAnimation;

@end