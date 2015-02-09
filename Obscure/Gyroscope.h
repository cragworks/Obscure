# import <CoreMotion/CoreMotion.h>
# import <SpriteKit/SpriteKit.h>
# import <CoreImage/CoreImage.h>
# import <QuartzCore/QuartzCore.h>

@interface Gyroscope : NSObject
{
    double currentMaxAccelX;
    double currentMaxAccelY;
    double currentMaxAccelZ;
    double currentMaxRotX;
    double currentMaxRotY;
    double currentMaxRotZ;
    float xDelta;
    float yDelta;
    SKSpriteNode * sprite;
    NSArray* array;
    
}

@property (strong, nonatomic) CMMotionManager *motionManager;
-(void)coreMotionSetVariables;
-(void)outputAccelertionData:(CMAcceleration)acceleration;
-(void)outputRotationData:(CMRotationRate)rotation;
-(void)moveSprite:(SKSpriteNode*)sprite;
-(void)moveArrayOfSprite:(NSArray*)array;
-(void)update:(NSArray*)array;

@end