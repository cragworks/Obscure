#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Monster : NSObject
{
    SKSpriteNode * sprite;
    SKTexture* image;
    CGFloat screenWidth;
    CGFloat screenHeight;
    float monsterHPBar;
}

@property SKSpriteNode* sprite;
-(void)monsterMovement;
-(void)attack;
-(void)beingAttackedAnimation;

@end