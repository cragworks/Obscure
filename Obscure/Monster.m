#import "Monster.h"
@implementation Monster
@synthesize sprite;
- (id)init {
    if (self = [super init]) {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"catmain1"];
        [sprite setName:@"catmain1"];
        [sprite setSize:CGSizeMake(50, 50)];
        int random = arc4random() % 500;
        monsterHPBar = 100.0f;
        [sprite setPosition:CGPointMake(random, 250)];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        monsterHpClass = [[MonsterHPBar alloc] init];
        [monsterHpClass setHP:100];
    }
    return self;
}


-(void)monsterMovement
{
    NSLog(@"%f %f ", sprite.position.x, sprite.position.y);
    
    //    SKAction* start = [SKAction moveBy:CGVectorMake(-150, 70) duration:1];
    SKAction* jumpUp1 = [SKAction moveBy:CGVectorMake(100, 45) duration:0.5];
    SKAction* jumpDown1 = [SKAction moveBy:CGVectorMake(35, -20) duration:0.5];
    SKAction* jumpUp2 = [SKAction moveBy:CGVectorMake(35, 10) duration:0.5];
    SKAction* jumpDown2 = [SKAction moveBy:CGVectorMake(55, -55) duration:0.5];
    SKAction* jumpUp3 = [SKAction moveBy:CGVectorMake(-65, 20) duration:0.5];
    SKAction* jumpDown3 = [SKAction moveBy:CGVectorMake(-30, -35) duration:0.5];
    SKAction* jumpUp4 = [SKAction moveBy:CGVectorMake(-45, 15) duration:0.5];
    SKAction* jumpDown4 = [SKAction moveBy:CGVectorMake(-20, -50) duration:0.5];
    SKAction* jumpUp5 = [SKAction moveBy:CGVectorMake(75, 15) duration:0.5];
    SKAction* jumpDown5 = [SKAction moveBy:CGVectorMake(10, -35) duration:0.5];
    SKAction* resizeOut = [SKAction resizeByWidth:175 height:175 duration:6];
    SKAction* resizeOut2 = [SKAction resizeByWidth:45 height:45 duration:6];
    NSArray* array = [[NSArray alloc] initWithObjects:jumpUp1, jumpDown1, jumpUp2, jumpDown2, jumpUp3, jumpDown3, jumpUp4, jumpDown4, jumpUp5, jumpDown5, nil];
    SKAction* together = [SKAction sequence:array];
    [sprite runAction:together];
    [sprite runAction:resizeOut];
    
    /* ------- reticule target ------- /
     // Counterattack reticule target spawns with the sprite and moves along with it
     [reticule runAction:together];
     [reticule runAction:resizeOut2];
     */
    
    SKTexture * front1 = [SKTexture textureWithImageNamed:@"catmain1"];
    SKTexture * front2 = [SKTexture textureWithImageNamed:@"catmain2"];
    SKTexture * right1 = [SKTexture textureWithImageNamed:@"catright1"];
    SKTexture * right2 = [SKTexture textureWithImageNamed:@"catright2"];
    SKTexture * left1 = [SKTexture textureWithImageNamed:@"catleft1"];
    SKTexture * left2 = [SKTexture textureWithImageNamed:@"catleft2"];
    NSArray * runTexture = @[right2, right1, right1, right1, right2, right1, right1, right1, left2, left1, left1, left1,  left2, left1, left1, left1, right2, right1, right1, right1, front2, front1];
    SKAction* runAnimation = [SKAction animateWithTextures:runTexture timePerFrame:0.25 resize:NO restore:NO];
//    [sprite runAction:runAnimation completion:^{spriteReachedYou = YES;
//    }];
}

-(void)attack
{
    [self beingAttackedAnimation];
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"CAT"];
    SKTexture * catstop = [atlas textureNamed:@"catmain1"];
    SKTexture * catleap = [atlas textureNamed:@"catmain2"];
    NSArray * textureleap = @[catstop, catleap];
    SKAction* runleap = [SKAction animateWithTextures:textureleap timePerFrame: 0.25 resize:NO restore:NO];
    //[sprite runAction:runleap];
    //SKAction* backleap = [
    NSArray* wait2 = @[ catstop, catstop];
    SKAction* wait = [SKAction animateWithTextures:wait2 timePerFrame:2 resize:NO restore:NO];
    
    [sprite setScale:1];
    SKAction* leap2 = [SKAction moveToY:150 duration:1];
    SKAction* Bigger = [SKAction scaleTo:2 duration:1];
    NSArray* jump = @[leap2, Bigger];
    
    
    SKAction* leapback = [SKAction moveToY:200 duration:1];
    SKAction* Smaller = [SKAction scaleTo:1 duration:1];
    NSArray* jumpback = @[leapback, Smaller];
    
    SKTexture * claws = [atlas textureNamed:@"catattack1"];
    SKTexture * attack = [atlas textureNamed:@"catattack15"];
    
    NSArray* Sample = @[claws, attack];
    SKAction* Sample1 = [SKAction animateWithTextures:Sample timePerFrame:.25 resize:NO restore:NO];
    
    NSArray* array = [[NSArray alloc] initWithObjects:runleap, jump, runleap, Sample1, nil];
    SKAction* together = [SKAction sequence:array];
    NSArray* returnAfterAttacking = [[NSArray alloc] initWithObjects:runleap, jumpback, wait,  nil];
    SKAction* together2 = [SKAction sequence:returnAfterAttacking];
    //[sprite runAction:together completion:^{
      //  [player humanwound];
       // [self flash];
        //[sound playSound:@"OW"];
        //[sprite runAction:together2];
    //}];
}


-(void)beingAttackedAnimation
{
    //warning symbol
    SKSpriteNode *warning = [SKSpriteNode spriteNodeWithImageNamed:@"Warning-Symbol.png"];
    [warning setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [warning setSize:CGSizeMake(warning.size.width*0.5, warning.size.height*0.5)];
    [warning setZPosition:-1];
    
    
    /*
     //needed to make the SKShapeNode
     CGPoint rect[] = {CGPointMake(0, 0), CGPointMake(screenWidth,0), CGPointMake(screenWidth, screenHeight), CGPointMake(0, screenHeight), CGPointMake(0, 0)};
     size_t numPoints = 5;
     
     
     //make SKShapeNode at the rectangle’s points and number of points (5)
     fourSidedFigure = [SKShapeNode shapeNodeWithPoints:rect count:numPoints];
     //make the rect red
     [fourSidedFigure setFillColor:[UIColor redColor]];
     //make rectangle transparent
     [fourSidedFigure setAlpha:0.1];
     */
    SKAction* flash = [SKAction fadeOutWithDuration:1];
    
    SKSpriteNode *redflash = [SKSpriteNode spriteNodeWithImageNamed:@"Flash@2x.jpg"];
    [redflash setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [redflash setSize:CGSizeMake(screenWidth*2, screenHeight*2)];
    
    [warning runAction:[SKAction repeatActionForever:flash]];
    [redflash runAction:[SKAction repeatActionForever:flash]];
    //[fourSidedFigure runAction:[SKAction repeatActionForever:flash]];
    
    //make rectangle flash
    //[fourSidedFigure setAlpha:0.0];
    
    //[self addChild:warning];
    //    [self addChild:redflash];
}



@end