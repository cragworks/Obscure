#import "DrawScene.h"
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

//declare variables here!
@implementation DrawScene
{
    //the 4 corner points of the rectangle detected
    CGPoint topLeft;
    CGPoint topRight;
    CGPoint bottomRight;
    CGPoint bottomLeft;
    
    //note by michelle: what is this for? variable not used...
    //int health; //3 2 1 0
    
    //the SKShapeNode which will overlay the rectangle
    SKShapeNode *fourSidedFigure;
    Sound* soundPlayer;
    
    int maxMonsterHP;
    int currentMonsterHP;
    float percentMonsterHP;
}

//--------------------------------- Monster HP functions --------------------------------- //
- (CGFloat) updateMonsterHP{
    percentMonsterHP = (float) currentMonsterHP/ (float) maxMonsterHP;
   // NSLog(@"%f", percentMonsterHP);
    return (CGFloat) percentMonsterHP;
}

- (float) decreaseMonsterHP {
    if (currentMonsterHP < 0) {
        return 0;
    }
    currentMonsterHP -= 10;
    [self updateMonsterHP];
    return currentMonsterHP;
}

//--------------------------------- Core functions --------------------------------- //
//this function is the update loop
//it is called nonstop 1000 times a second
//used for when you need something to be
//constantly updated
//like updating the detected rectangle's coordinates
//or drawing the background over the detected rectangle
int seconds = 0;
-(void)update:(NSTimeInterval)currentTime
{
    seconds++;
    
    if(seconds%30==0)
    {
        //update the detected rectangle's 4 points
        [self requestRectangleObjectCoordinates];
        //draw the background
        //[self drawBg];
        //print the rectangle coordinates
        /*
        NSLog(@"Detected Rectangle's 4 pts (x,y):");
        NSLog(@"TopLeft: (%i, %i)\n",(int)topLeft.x,(int)topLeft.y);
        NSLog(@"TopRight: (%i, %i)\n",(int)topRight.x,(int)topRight.y);
        NSLog(@"BottomRight: (%i, %i)\n",(int)bottomRight.x,(int)bottomLeft.y);
        NSLog(@"BottomLeft: (%i, %i)\n",(int)bottomLeft.x,(int)bottomLeft.y);
        NSLog(@"\n");
         */
        [self winlosestatus];
    }
    [self updateRadar];
}

-(void)updateRadar
{
    float maxX = 1500;
    //if monster is  3000px x then move to -3000 and vice versa
    if(monster.position.x > maxX)
    {
        [monster setPosition:CGPointMake(-maxX, monster.position.y)];
    }
    else if(monster.position.x < -maxX)
    {
        [monster setPosition:CGPointMake(maxX, monster.position.y)];
    }
    
    //show degrees from 0 to 360
    int degrees = 360 * (monster.position.x / 3000);
    if(degrees < 0)
    {
        degrees = 0;
    }
    
    //the radar line
    CGPoint centerOfRadar = CGPointMake(screenWidth/12.5,screenHeight/7.75);
    SKShapeNode *line = [SKShapeNode node];
    float lineRadius = screenWidth/18;
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    float lineEndX = centerOfRadar.x + lineRadius * cos( DEGREES_RADIANS(lineAngle) );
    float lineEndY = centerOfRadar.y + lineRadius * sin( DEGREES_RADIANS(lineAngle) );
    CGPathMoveToPoint(pathToDraw, NULL, centerOfRadar.x, centerOfRadar.y);
    CGPathAddLineToPoint(pathToDraw, NULL, lineEndX, lineEndY);
    line.path = pathToDraw;
    [line setStrokeColor:[UIColor colorWithRed:255/255.0 green:51/255.0 blue:153/255.0 alpha:1]];
    [line setGlowWidth:1.5];
    [line setLineWidth:2];
    lineAngle+=10;
    if(lineAngle > 360)
        lineAngle = 0;
    [self addChild:line];
    [arcLines addObject:line];
    //remove old lines
    if(arcLines.count > 1)
    {
        for(int i = 0; i < arcLines.count - 1; i++)
        {
            [arcLines[i] removeFromParent];
        }
    }
    
    //move the circle to that degrees spot
    //[radarCircle setPosition: CGPointMake(screenWidth/12.5,screenHeight/8.5)];
    degrees *= -1;
    float radius = 25;
    float startAngle = 125;
    float endX = centerOfRadar.x + radius * cos( DEGREES_RADIANS(startAngle + degrees) );
    float endY = centerOfRadar.y + radius * sin( DEGREES_RADIANS(startAngle + degrees) );
    //[radarCircle setPosition:CGPointMake(endX, endY)];
    //NSLog(@"DEGREES: %i \n",degrees);
    
    //play blip sound if radar line = monster's location's blip
    int monsterBlipDegrees = startAngle + degrees;
    int lineDegrees = lineAngle;
    NSLog(@"monster degrees: %i \n",monsterBlipDegrees);
    NSLog(@"line degrees: %i \n",lineDegrees);
    if(abs(monsterBlipDegrees - lineDegrees) < 20)
    {
        [sound playSound:@"radarBlip"];
        [radarCircle setPosition:CGPointMake(endX, endY)];
    }
    
}

-(id)initWithSize:(CGSize)size
{
    maxMonsterHP = 100;
    currentMonsterHP = maxMonsterHP;
    [self updateMonsterHP];
    
    if (self = [super initWithSize:size]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        //[self setBackgroundColor:[UIColor whiteColor]];
        [self initNSNotifications];
        [self coreMotionSetVariables];
        [self setVariables];
        
    }
    return self;
}

-(void)setVariables{
    arcLines = [[NSMutableArray alloc] init];
    lineAngle = 125;
    
    topLeft = CGPointMake(300,200);
    topRight = CGPointMake(400,200);
    bottomRight = CGPointMake(400,100);
    bottomLeft = CGPointMake(300,100);
    
    sound = [[Sound alloc] init];
    soundSfx = [[Sound alloc] init];
    
    
    //make duck quack
    /*
    if((int)(arc4random()%2)==1)
        [sound playSoundForever:@"duck_hunt"];
    else
        [sound playSoundForever:@"duck_hunt_2"];
    */
    
    //make screenshot buttons appear
    //[self setVariableButtons];
    
    //make combat UI appear
    [self drawCombatUI];
    
    //set up monster hp
    monsterHPBar = [[MonsterHPBar alloc] initWithCustomSize:CGSizeMake(75, 20)];
    
    //setup Player HP
    player = [[HumanHPbar alloc]init];
    [self addChild:player];
    
    monster = [SKSpriteNode spriteNodeWithImageNamed:@"catmain1"];
    [monster setName:@"catmain1"];
    [monster setSize:CGSizeMake(50, 50)];
    int random = arc4random() % 500;
    [monster setPosition:CGPointMake(random, 250)];
    [self addChild:monster];
    
    [self monsterMovement];
    //reticule symbol
    reticule = [SKSpriteNode spriteNodeWithImageNamed:@"reticule.png"];
    [reticule setName:@"reticule"];
    [reticule setPosition:CGPointMake(random, 250)];
    [reticule setSize:CGSizeMake(25,25)];
    [self addChild:reticule];
    
    //mine
    BOOL containMonsterHp = [self.children containsObject:monsterHPBar];
    if (!containMonsterHp) {
        //[self addChild:monsterHPBar];
    }
    //NSLog(@"%f %f ", monster.position.x, monster.position.y);
    [monsterHPBar setPosition:CGPointMake(monster.position.x, monster.position.y + 50)];
    
    //[monsterHPBar runAction:together];
    
    radarCircle = [SKShapeNode shapeNodeWithCircleOfRadius:3.0];
    [radarCircle setPosition: CGPointMake(screenWidth/12.5,screenHeight/8.5)];
    [radarCircle setStrokeColor:[UIColor blackColor]];
    [radarCircle setGlowWidth:2];
    [self addChild:radarCircle];
    
    [self monsterMovement];
}

-(void)didMoveToView:(SKView *)view {
    
}

//Determines whether game is won or lost
-(void)winlosestatus
{
    if([player getHP] <= 0)
        [self gameoverAnimation];
    else if(percentMonsterHP <= 0)
        [self stageCompleteAnimation];
}

//--------------------------------- Touch Functions --------------------------------- //
//touched the screen
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *allTouches = [[event allTouches] allObjects];
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint location = [touch locationInNode:self];
    
    [self touchesBeganSettingButtons :allTouches];
    
    /*duck functions
    for (UITouch *touch in touches) {
        
        //make the SKSpritenode duck spawn when touch the screen
        //[self makeDuckFlyUpRight];
    }
    */
    
    // Counterattack Reticule
    if ([allTouches count] > 1)
        return;
    else{
        NSLog(@"X: %f Y: %f", location.x, location.y);
        
        // If user taps the reticule, monster stops attacking
        if ([[self nodeAtPoint:location].name isEqualToString:reticule.name])
        {
            NSLog(@"Testing....");
            // INSERT MONSTER STOPPED ATTACKING HERE!!
            
        }
        
        if([[self nodeAtPoint:location].name isEqualToString:monster.name])
        {
            //decrease monster's hp
            [self decreaseMonsterHP];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSArray *allTouches = [[event allTouches] allObjects];
    
    if([allTouches count] > 1)
        return;
    else{
        UITouch *touch = [allTouches objectAtIndex:0];
        CGPoint loc = [touch locationInNode:self];
        
        [self touchesMovedButtons:loc];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSArray *allTouches = [[event allTouches] allObjects];
    
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint loc = [touch locationInNode:self];
    
    [self touchesEndedButtons:loc :(NSSet *)touches :(UIEvent *)event];
}

//DRAW THE BACKGROUND OVER THE DETECTED RECTANGLE
//THE RECTANGLE HAS 4 CGPoints
//to get the x or y:
//topLeft.x or topLeft.y
//4 pts
    //   topLeft ....... topRight
    //           .......
    //           .......
    //bottomLeft         bottomRight

//--------------------------------- Draw Functions --------------------------------- //
-(void)drawBg
{
    //needed to make the SKShapeNode
    CGPoint rect[] = {topLeft,topRight,bottomRight,bottomLeft,topLeft};
    size_t numPoints = 5;
    
    //if SKShapeNode exists already, delete it
    if(fourSidedFigure!=nil)
        [fourSidedFigure removeFromParent];
    
    //make SKShapeNode at the rectangle’s points and number of points (5)
    fourSidedFigure = [SKShapeNode shapeNodeWithPoints:rect count:numPoints];
    //make the rect green
    [fourSidedFigure setFillColor:[UIColor greenColor]];
    //give it an image for the background
    SKTexture *tex = [SKTexture textureWithImageNamed:@"duck_hunt_bg.png"];
    //apply the image background to it
    [fourSidedFigure setFillTexture:tex];
    //put it behind the ducks
    [fourSidedFigure setZPosition:-1];
    //add it to the screen
    [self addChild:fourSidedFigure];
}

//displays UI
-(void)drawCombatUI
{
    //grid overlay
    SKSpriteNode *overlay = [SKSpriteNode spriteNodeWithImageNamed:@"combatUI-overlayfilter.png"];
    [overlay setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [overlay setSize:CGSizeMake(screenWidth, screenHeight)];
    [overlay setZPosition:-2];
    
    //ui decal
    SKSpriteNode *decal = [SKSpriteNode spriteNodeWithImageNamed:@"ui-Decal.png"];
    [decal setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [decal setSize:CGSizeMake(screenWidth, screenHeight)];
    [decal setZPosition:-1];
    
    //pause button
    SKSpriteNode *pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause-button.png"];
    float pause_height = pause.size.height*0.6;
    float pause_width = pause.size.width*0.6;
    [pause setPosition:CGPointMake(screenWidth-pause_width, screenHeight-pause_height)];
    [pause setSize:CGSizeMake(pause_width, pause_height)];
    [pause setZPosition:-1];
    
    //target cross hair
    SKSpriteNode *crosshair = [SKSpriteNode spriteNodeWithImageNamed:@"targetcrosshair.png"];
        // to be changed to position of monster. this is just to test
    [crosshair setPosition:CGPointMake(screenWidth/3, screenHeight/3)];
    [crosshair setSize:CGSizeMake(crosshair.size.width*0.5, crosshair.size.height*0.5)];
    [crosshair setZPosition:-1];
    
    //katana
    SKSpriteNode *katana = [SKSpriteNode spriteNodeWithImageNamed:@"weapon-katana.png"];
    [katana setPosition:CGPointMake(screenWidth*0.875 - katana.size.width, screenHeight*0.3 - katana.size.height)];
    [katana setSize:CGSizeMake(katana.size.width*0.6, katana.size.height*0.6)];
    [katana setZPosition:-1];

    //[overlay setSize: CGPointMake(100, 100)];
    [self addChild:overlay];
    [self addChild:decal];
    [self addChild:pause];
    [self addChild:katana];
}

//--------------------------------- Animation Functions --------------------------------- //
//if player is being attacked by monster
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
    
    [self addChild:warning];
//    [self addChild:redflash];
}

//if player loses level
-(void)gameoverAnimation //*** WIP BY MICHELLE W. ***
{
    SKSpriteNode *static1 = [SKSpriteNode spriteNodeWithImageNamed:@"15perc1.png"];
    [static1 setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [static1 setSize:CGSizeMake(screenWidth, screenHeight)];
    [self addChild:static1];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"staticdamage"];
    SKTexture * static2 = [atlas textureNamed:@"15perc2.png"];
    SKTexture * static3 = [atlas textureNamed:@"15perc3.png"];
    SKTexture * static4 = [atlas textureNamed:@"15perc4.png"];
    
    NSArray * runTexture = @[static2,static3,static4, static3,static2];
    SKAction* runAnimation = [SKAction animateWithTextures:runTexture timePerFrame:0.07 resize:NO restore:NO];
    [static1 runAction:[SKAction repeatActionForever:runAnimation]];
}

//if player wins the level, play this animation
-(void)stageCompleteAnimation
{
    //needed to make the SKShapeNode
    CGPoint rect[] = {CGPointMake(0, 0), CGPointMake(screenWidth,0), CGPointMake(screenWidth, screenHeight), CGPointMake(0, screenHeight), CGPointMake(0, 0)};
    size_t numPoints = 5;
    
    //make SKShapeNode at the rectangle’s points and number of points (5)
    fourSidedFigure = [SKShapeNode shapeNodeWithPoints:rect count:numPoints];
    //make the rect white
    [fourSidedFigure setFillColor:[UIColor whiteColor]];
    //make rectangle transparent
    [fourSidedFigure setAlpha:0.0];
    
    SKAction* fadetowhite = [SKAction fadeInWithDuration:1];
    [fourSidedFigure runAction:fadetowhite];
    [self addChild:fourSidedFigure];
}

-(void)attack
{
    [self beingAttackedAnimation];
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"CAT"];
    SKTexture * catstop = [atlas textureNamed:@"catmain1"];
    SKTexture * catleap = [atlas textureNamed:@"catmain2"];
    NSArray * textureleap = @[catstop, catleap];
    SKAction* runleap = [SKAction animateWithTextures:textureleap timePerFrame: 0.25 resize:NO restore:NO];
    //[monster runAction:runleap];
    //SKAction* backleap = [
    NSArray* wait2 = @[ catstop, catstop];
    SKAction* wait = [SKAction animateWithTextures:wait2 timePerFrame:2 resize:NO restore:NO];
    
    [monster setScale:1];
    SKAction* leap2 = [SKAction moveToY:150 duration:1];
    SKAction* Bigger = [SKAction scaleTo:2 duration:1];
    NSArray* jump = @[leap2, Bigger];
    
    
    SKAction* leapback = [SKAction moveToY:200 duration:1];
    SKAction* Smaller = [SKAction scaleTo:1 duration:1];
    NSArray* jumpback = @[leapback, Smaller];
    
    SKTexture * claws = [atlas textureNamed:@"catattack1"];
    SKTexture * attack = [atlas textureNamed:@"catattack15"];
    
    NSArray* Sample = @[claws, attack];
    SKAction* Sample1 = [SKAction animateWithTextures:Sample timePerFrame:.5 resize:NO restore:NO];
    
    NSArray* array = [[NSArray alloc] initWithObjects:runleap, jump, runleap, Sample1, runleap, jumpback,wait ,  nil];
    
    SKAction* together = [SKAction sequence:array];
    [monster runAction:together completion:^{ [player humanwound];
                                                [self flash];
                                            }];
    
}

-(void)flash
{
    SKAction* flash = [SKAction fadeOutWithDuration:1];
    
    SKSpriteNode *redflash = [SKSpriteNode spriteNodeWithImageNamed:@"Flash@2x.jpg"];
    [redflash setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [redflash setSize:CGSizeMake(screenWidth*2, screenHeight*2)];
    
    
    [redflash runAction:[SKAction repeatActionForever:flash]];
    [self addChild:redflash];
}

-(void)monsterMovement
{
    NSLog(@"%f %f ", monster.position.x, monster.position.y);

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
    [monster runAction:together];
    [monster runAction:resizeOut];
    
    /* ------- reticule target ------- /
    // Counterattack reticule target spawns with the monster and moves along with it
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
    [monster runAction:runAnimation completion:^{monsterReachedYou = YES;
                                                }];
}


//--------------------------------- Reference/Other Functions --------------------------------- //

/*Make a duck, give it a spritesheet, give it animation, give it sound
 -(void)makeDuckFlyUpRight
 {
 //make SKSpriteNode!
 CGPoint center = CGPointMake((topLeft.x+topRight.x)/2, (topLeft.y + bottomLeft.y)/2);
 SKSpriteNode *duck = [SKSpriteNode spriteNodeWithImageNamed:@"duck"];
 [duck setPosition:center];
 [self addChild:duck];
 
 [player humanwound];
 
 //mine
 [monsterHPBar setHP:[self updateMonsterHP]];
 [monsterHPBar setScale:[self updateMonsterHP]];
 //   NSLog(@"%f", [self updateMonsterHP]);
 [self decreaseMonsterHP];
 
 //spritesheet!
 //an atlas is a folder in the project
 //here it is called duck.atlas
 //it contains images for the animation spritesheets
 //you use the images to make SKTexture
 //then you make an SKAction called animateWithTextures
 //and run it to apply the spritesheet
 SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"duck"];
 SKTexture * duckTex1 = [atlas textureNamed:@"flyUpRight1"];
 SKTexture * duckTex2 = [atlas textureNamed:@"flyUpRight2"];
 NSArray * runTexture = @[duckTex1,duckTex2];
 SKAction* runAnimation = [SKAction animateWithTextures:runTexture timePerFrame:0.075 resize:NO restore:NO];
 [duck runAction:[SKAction repeatActionForever:runAnimation]];
 
 //animations! SKAction!
 //make duck gradually get larger by 500 and 500 in 2 sec
 SKAction* resizeOut = [SKAction resizeByWidth:500 height:500 duration:2];
 //move the duck right by 700px and right by 700px in 2 sec
 SKAction* flyOut = [SKAction moveByX:700 y:700 duration:2];
 //run the actions
 [duck runAction:resizeOut];
 [duck runAction:flyOut];
 
 //sound!
 soundPlayer = [[Sound alloc] init];
 [soundPlayer playSound:@"quack"];
 } */

/* 3D Maya Test
-(void)make3DGhost:(int)x :(int)y
{
    SK3DNode *alien3D = [[SK3DNode alloc] initWithViewportSize:CGSizeMake(self.frame.size.width,
                                                                          self.frame.size.height)];
    SCNScene *alienSCN = [SCNScene sceneNamed:@"ghosty.dae"];
    alien3D.scnScene = alienSCN;
    [alien3D setPosition:CGPointMake(x - 350, y)];
    [alien3D setScale:0.25];
    [self addChild:alien3D];
} */

























-(void)coreMotionSetVariables
{
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    //self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .1;
    
    /*[self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
     withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
     [self outputAccelertionData:accelerometerData.acceleration];
     if(error){
     
     NSLog(@"%@", error);
     }
     }];
     */
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    //self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    //self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    //self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
    {
        currentMaxAccelZ = acceleration.z;
    }
    
    //self.maxAccX.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelX];
    //self.maxAccY.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelY];
    //self.maxAccZ.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelZ];
    
    
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    
    //    //self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    //    if(fabs(rotation.x)> fabs(currentMaxRotX))
    //    {
    //        currentMaxRotX = rotation.x;
    //    }
    //    //self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    //    if(fabs(rotation.y) > fabs(currentMaxRotY))
    //    {
    //        currentMaxRotY = rotation.y;
    //    }
    //    //self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    //    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    //    {
    //        currentMaxRotZ = rotation.z;
    //    }
    
    //self.maxRotX.text = [NSString stringWithFormat:@" %.2f",currentMaxRotX];
    //self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentMaxRotY];
    //self.maxRotZ.text = [NSString stringWithFormat:@" %.2f",currentMaxRotZ];
    
    float rotationScale = 50;
    const float xDelta = rotation.y*rotationScale;
    const float yDelta = (rotation.x*rotationScale);
    [monster setPosition:CGPointMake(monster.position.x + yDelta, monster.position.y)];
    
    //[currentLine setPosition:CGPointMake(currentLine.position.x + rotation.y*rotationScale, currentLine.position.y - rotation.x*rotationScale)];
}

//Request rectangle object coordinates
-(void)requestRectangleObjectCoordinates
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"requestRectangleObjectCoordinates"
     object:self];
}
//Receive rectangle object coordinates
-(void)receiveRectangleObjectCoordinates:(NSNotification*)notification{
    NSArray* points = (NSArray*) notification.object;
    
    //update rectangle object coordinates
    NSValue *val;
    val = [points objectAtIndex:0];
    topLeft = [val CGPointValue];
    val = [points objectAtIndex:1];
    topRight = [val CGPointValue];
    val = [points objectAtIndex:2];
    bottomRight = [val CGPointValue];
    val = [points objectAtIndex:3];
    bottomLeft = [val CGPointValue];
}

//draw lines to show the rectangle
//[self drawLinesOnTheRectangleObject];
-(void)drawLinesOnTheRectangleObject
{
    [self beginNewLine:topLeft];
    [self addPointToLine:topRight];
    [self addPointToLine:bottomRight];
    [self addPointToLine:bottomLeft];
    [self addPointToLine:topLeft];
}
//end of detecting rectangle code

-(void)sendGetIfCameraSideIsBack{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"getIfCameraSideIsBack"
     object:nil];
}

-(void)receiveIfCameraSideIsBackAndUpdateIcon :(NSNotification *)notification {
    
    //remove buttonSwitchCamera and buttonSwitchCameraPressed nodes if they exist
    if(buttonSwitchCamera != nil)
        [buttonSwitchCamera removeFromParent];
    if(buttonSwitchCameraPressed != nil)
        [buttonSwitchCameraPressed removeFromParent];
    
    NSString* cameraType = (NSString*)notification.object;
    //NSLog(@"%@",cameraType);
    //NSLog(@"RECEIVED");
    if([cameraType isEqualToString:@"BACK"]){
        buttonSwitchCamera = [SKSpriteNode spriteNodeWithImageNamed:@"button_switch_camera_pressed_2"];
        [buttonSwitchCamera setSize:buttonTakeScreenshot.size];
        
        buttonSwitchCameraPressed = [SKSpriteNode spriteNodeWithImageNamed:@"button_switch_camera_pressed_2"];
    }
    else{
        buttonSwitchCamera = [SKSpriteNode spriteNodeWithImageNamed:@"button_switch_camera_2"];
        
        buttonSwitchCameraPressed = [SKSpriteNode spriteNodeWithImageNamed:@"button_switch_camera_2"];
    }
    
    [buttonSwitchCamera setSize:buttonTakeScreenshot.size];
    [buttonSwitchCamera setPosition:CGPointMake(screenWidth-buttonSwitchCamera.size.width/2,screenHeight-buttonSwitchCamera.size.height/2)];
    [buttonSwitchCamera setZPosition:100];
    [buttonSwitchCamera setName:@"button_switch_camera"];
    [buttonSwitchCamera setAlpha:switchCameraBtnFadeAlpha];
    
    [buttonSwitchCameraPressed setZPosition:99];
    [buttonSwitchCameraPressed setName:@"button_switch_camera_pressed"];
    [buttonSwitchCameraPressed setHidden:YES];
    [buttonSwitchCameraPressed setAlpha:switchCameraBtnFadeAlpha];
    [buttonSwitchCameraPressed setSize:buttonSwitchCamera.size];
    [buttonSwitchCameraPressed setScale:1.25];
    [buttonSwitchCameraPressed setPosition:CGPointMake(screenWidth-buttonSwitchCameraPressed.size.width/2,screenHeight-buttonSwitchCameraPressed.size.height/2)];
    [self addChild:buttonSwitchCamera];
    [self addChild:buttonSwitchCameraPressed];
    
}
-(Boolean)checkAccessCameraPermission{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status !=  AVAuthorizationStatusNotDetermined)
        if (status == ALAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot show camera's video feed until Pawrikura gets access permission to Camera in your Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    
    return YES;
}

-(Boolean)checkAccessDoodleCameraPermission{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status !=  AVAuthorizationStatusNotDetermined)
        if (status == ALAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Only saved screenshot of doodle. Please give permission to access Camera in your Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    
    return YES;
}

-(Boolean)checkAccessPhotoLibraryPermission{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if(status !=  ALAuthorizationStatusNotDetermined)
        if (status == ALAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot take screenshot until you give Pawrikura access permission to Photo Library in your Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    
    return YES;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *allTouches = [[event allTouches] allObjects];
    
    if([allTouches count] > 1)
        return;
    
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint loc = [touch locationInNode:self];
    
}

-(void)beginNewLine:(CGPoint)startPt{
    SKShapeNode *line = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, startPt.x, startPt.y);
    line.path = pathToDraw;
    
    UIColor *orangish = [UIColor colorWithRed:255/255.0 green:222/255.0 blue:0/255.0 alpha:1];
    
    //random color generator
    //UIColor *orangish = [UIColor colorWithRed:(arc4random() %256)/255.0 green:(arc4random() %256)/255.0 blue:(arc4random() %256)/255.0 alpha:1];
    [line setStrokeColor:orangish];
    [line setFillColor:orangish];
    [line setGlowWidth:10.0];
    [line setLineWidth:6.0];
    [line setLineCap:kCGLineCapButt];
    [line setLineJoin:kCGLineJoinRound];
    currentLine = line;
    currentPathToDraw = pathToDraw;
    [self addChild:line];
}

-(void)addPointToLine:(CGPoint)pt{
    CGPathAddLineToPoint(currentPathToDraw, NULL, pt.x, pt.y);
    CGPathMoveToPoint(currentPathToDraw, NULL, pt.x, pt.y);
    //Cool background pattern effect!
    //[currentLine setLineWidth:6+(arc4random() %0)];
    currentLine.path = currentPathToDraw;
}

-(UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width, secondImage.size.width), MAX(firstImage.size.height, secondImage.size.height));
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
    }
    [firstImage drawAtPoint:CGPointMake(roundf((newImageSize.width-firstImage.size.width)/2),
                                        roundf((newImageSize.height-firstImage.size.height)/2))];
    [secondImage drawAtPoint:CGPointMake(roundf((newImageSize.width-secondImage.size.width)/2),
                                         roundf((newImageSize.height-secondImage.size.height)/2))];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)finishedTakingAllScreenshots{
    [self showButtons];
    stillTakingScreenshot = NO;
}

-(void)hideButtons{
    [buttonClear setHidden:YES];
    [buttonClearPressed setHidden:YES];
    [buttonTakeScreenshot setHidden:YES];
    [buttonTakeScreenshotPressed setHidden:YES];
    [buttonSwitchCamera setHidden:YES];
    [buttonSwitchCameraPressed setHidden:YES];
}

-(void)showButtons{
    [buttonClear setHidden:NO];
    [buttonSwitchCamera setHidden:NO];
    [buttonTakeScreenshot setHidden:NO];
}

-(void)touchesBeganSettingButtons :(NSArray*)allTouches
{
    if([allTouches count] > 1)
    {
        return;
    }
    else{
        UITouch *touch = [allTouches objectAtIndex:0];
        CGPoint loc = [touch locationInNode:self];
        
        if([[self nodeAtPoint:loc].name isEqualToString:buttonClear.name]){
            [buttonClear setHidden:YES];
            [buttonClearPressed setHidden:NO];
        }
        else if([[self nodeAtPoint:loc].name isEqualToString:buttonSwitchCamera.name]){
            [buttonSwitchCamera setHidden:YES];
            [buttonSwitchCameraPressed setHidden:NO];
        }
        else if([[self nodeAtPoint:loc].name isEqualToString:buttonTakeScreenshot.name]){
            [buttonTakeScreenshot setHidden:YES];
            [buttonTakeScreenshotPressed setHidden:NO];
        }
    }
}



-(void)switchCamera{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"switch_camera"
     object:self];
}
-(void)setVariableButtons
{
    

    buttonClear = [SKSpriteNode spriteNodeWithImageNamed:@"button_clear_2"];
    [buttonClear setSize:CGSizeMake(100, 100)];
    [buttonClear setPosition:CGPointMake(buttonClear.size.width/2, buttonClear.size.height/2)];
    [buttonClear setZPosition:100];
    [buttonClear setName:@"button_clear"];
    [buttonClear setAlpha:clearBtnFadeAlpha];
    [self addChild:buttonClear];
    
    buttonClearPressed = [SKSpriteNode spriteNodeWithImageNamed:@"button_clear_pressed_2"];
    [buttonClearPressed setSize: buttonClear.size];
    [buttonClearPressed setScale:1.25];
    [buttonClearPressed setPosition:CGPointMake(buttonClearPressed.size.width/2, buttonClearPressed.size.height/2)];
    [buttonClearPressed setZPosition:99];
    [buttonClearPressed setName:@"button_clear_pressed"];
    [buttonClearPressed setHidden:YES];
    [buttonClearPressed setAlpha:clearBtnFadeAlpha];
    [self addChild:buttonClearPressed];
    
    buttonTakeScreenshot = [SKSpriteNode spriteNodeWithImageNamed:@"button_take_screenshot_blue"];
    [buttonTakeScreenshot setSize:CGSizeMake(50, 50)];
    [buttonTakeScreenshot setPosition:CGPointMake(screenWidth-buttonTakeScreenshot.size.width/2, buttonTakeScreenshot.size.height/2)];
    [buttonTakeScreenshot setZPosition:100];
    [buttonTakeScreenshot setName:@"button_take_screenshot"];
    [buttonTakeScreenshot setAlpha:takeScreenshotBtnFadeAlpha];
    [self addChild:buttonTakeScreenshot];
    
    buttonTakeScreenshotPressed = [SKSpriteNode spriteNodeWithImageNamed:@"button_take_screenshot_pressed_blue"];
    [buttonTakeScreenshotPressed setSize:buttonTakeScreenshot.size];
    [buttonTakeScreenshotPressed setScale:1.25];
    [buttonTakeScreenshotPressed setPosition:CGPointMake(screenWidth-buttonTakeScreenshotPressed.size.width/2, buttonTakeScreenshotPressed.size.height/2)];
    [buttonTakeScreenshotPressed setZPosition:99];
    [buttonTakeScreenshotPressed setName:@"button_take_screenshot_pressed"];
    [buttonTakeScreenshotPressed setHidden:YES];
    [buttonTakeScreenshotPressed setAlpha:takeScreenshotBtnFadeAlpha];
    [self addChild:buttonTakeScreenshotPressed];
    
    stillTakingScreenshot = NO;
    
    [self sendGetIfCameraSideIsBack];
}

-(void)touchesMovedButtons:(CGPoint)loc
{
    //set alpha 1 buttons if not drawing onto them
    if(!stillTakingScreenshot){
        if(buttonClear.alpha < btnFadeAlpha){
            [buttonClear setAlpha:btnFadeAlpha];
        }
        if(buttonSwitchCamera.alpha < btnFadeAlpha){
            [buttonSwitchCamera setAlpha:btnFadeAlpha];
        }
        if(buttonTakeScreenshot.alpha < btnFadeAlpha){
            [buttonTakeScreenshot setAlpha:btnFadeAlpha];
        }
    }
    
    //hide all buttons when drawing
    if(!buttonClear.isHidden && !buttonTakeScreenshot.isHidden && !buttonSwitchCamera.isHidden)
        [self hideButtons];
    
    //hide buttons if drawing over them
    if(buttonClearPressed.isHidden && buttonClear.isHidden){
        if([self nodeAtPoint:loc].name != nil){
            if([[self nodeAtPoint:loc].name isEqualToString:buttonClear.name])
                [buttonClear setAlpha:btnMaxFadeAlpha];
            if([[self nodeAtPoint:loc].name isEqualToString:buttonSwitchCamera.name]){
                [buttonSwitchCamera setAlpha:btnMaxFadeAlpha];
            }
            if([[self nodeAtPoint:loc].name isEqualToString:buttonTakeScreenshot.name])
                [buttonTakeScreenshot setAlpha:btnMaxFadeAlpha];
        }
    }
}

-(void)touchesEndedButtons:(CGPoint)loc :(NSSet *)touches :(UIEvent *)event
{
    NSArray *allTouches = [[event allTouches] allObjects];
    if([[self nodeAtPoint:loc].name isEqualToString:buttonClear.name] && !buttonClearPressed.isHidden){
        [self removeAllChildren];
        [self setVariables];
    }
    else if([[self nodeAtPoint:loc].name isEqualToString:buttonSwitchCamera.name] && !buttonSwitchCameraPressed.isHidden){
        if([self checkAccessCameraPermission] == YES)
            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(switchCamera) userInfo:nil repeats:NO];
        
    }
    else if([[self nodeAtPoint:loc].name isEqualToString:buttonTakeScreenshot.name] && !buttonTakeScreenshotPressed.isHidden){
        
        if([self checkAccessPhotoLibraryPermission] == YES){
            [buttonTakeScreenshot setHidden:NO];
            [buttonTakeScreenshotPressed setHidden:YES];
            
            if(!stillTakingScreenshot){
                stillTakingScreenshot = YES;
                [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideThenSaveScreenshotToPhotos) userInfo:nil repeats:NO];
            }
        }
    }
    
    //set alpha 1 buttons if not drawing onto them
    if(!stillTakingScreenshot){
        if(buttonClear.alpha < btnFadeAlpha){
            [buttonClear setAlpha:btnFadeAlpha];
        }
        if(buttonSwitchCamera.alpha < btnFadeAlpha){
            [buttonSwitchCamera setAlpha:btnFadeAlpha];
        }
        if(buttonTakeScreenshot.alpha < btnFadeAlpha){
            [buttonTakeScreenshot setAlpha:btnFadeAlpha];
        }
    }
    
    //unhide btns if hidden
    if(!stillTakingScreenshot){
        if(buttonClear.isHidden){
            [buttonClear setHidden:NO];
            [buttonClearPressed setHidden:YES];
        }
        if(buttonSwitchCamera.isHidden && buttonSwitchCameraPressed.isHidden && ![[self nodeAtPoint:loc].name isEqualToString: buttonSwitchCameraPressed.name]){
            [buttonSwitchCamera setHidden:NO];
            [buttonSwitchCameraPressed setHidden:YES];
        }
        else if(buttonSwitchCamera.isHidden && ![[self nodeAtPoint:loc].name isEqualToString: buttonSwitchCamera.name]){
            [buttonSwitchCamera setHidden:NO];
            [buttonSwitchCameraPressed setHidden:YES];
        }
        if(buttonTakeScreenshot.isHidden){
            [buttonTakeScreenshot setHidden:NO];
            [buttonTakeScreenshotPressed setHidden:YES];
        }
    }
    
    if([allTouches count] > 1)
        return;
    else if([self nodeAtPoint:loc].name == nil && buttonClearPressed.isHidden && buttonSwitchCameraPressed.isHidden && buttonClear.isHidden){
        
    }
    
}

-(void)initNSNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedTakingAllScreenshots)
                                                 name:@"finishedTakingAllScreenshots"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveIfCameraSideIsBackAndUpdateIcon:)
                                                 name:@"receiveIfCameraSideIsBackAndUpdateIcon"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRectangleObjectCoordinates:)
                                                 name:@"sendRectangleObjectCGPoints"
                                               object:nil];
}
@end
