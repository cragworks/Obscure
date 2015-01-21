#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Monster : NSObject
{
    SKSpriteNode * sprite;
    SKTexture* image;
    CGFloat screenWidth;
    CGFloat screenHeight;
}
@property SKSpriteNode * sprite;
-(void)monsterMovement;
-(void)attack;
-(void)beingAttackedAnimation;

@end