# import "Gyroscope.h"
# import "Monster.h"

@implementation Gyroscope

-(id)init{
    if (self = [super init]) {
        xDelta = 0;
        yDelta = 0;
        
        [self coreMotionSetVariables];
    }
    return self;
}

-(void)coreMotionSetVariables
{
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = .1;
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
}

-(void)outputRotationData:(CMRotationRate)rotation
{
    float rotationScale = 10;
    xDelta = rotation.y*rotationScale;
    yDelta = rotation.x*rotationScale;
    
    
    
}

-(void)moveSprite:(SKSpriteNode*)monstersprite
{
    [monstersprite setPosition:CGPointMake(monstersprite.position.x + yDelta, monstersprite.position.y + xDelta)];
    
}

-(void)moveArrayOfSprite:(NSArray*)monsterarray
{
    for (int i = 0; i < monsterarray.count; i++)
    {
        [self moveSprite: (SKSpriteNode*)monsterarray[i]];
        
    }
    
}

-(void)update:(NSArray*)monsterarray
{
    [self moveArrayOfSprite: monsterarray];
    
    
}

@end