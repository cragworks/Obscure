#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

#import "Sound.h"
#import "Monster.h"

@interface DrawScene : SKScene <UIAlertViewDelegate>
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSArray *monsters;
    Monster *monster;
    
    BOOL monsterReachedYou;
    BOOL GAMEOVER;
    SKShapeNode *fourSidedFigure;
    
    SKSpriteNode *static1;
    int lineAngle;
    
    Sound *sound;
    Sound *soundSfx;
    Sound* soundPlayer;
    int msec;
}
@end
