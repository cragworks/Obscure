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
