#import "DrawScene.h"
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation DrawScene
-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        [self setVariables];
    }
    return self;
}

-(void)setVariables
{
    [self removeAllChildren];
    msec = 0;
    points = [[NSMutableArray alloc] init];
    
    soundPlayer = [[Sound alloc] init];
    [soundPlayer playSoundForever:@"introtrackloop"];
    maxMonsterHP = 100;
    currentMonsterHP = maxMonsterHP;
    
    arcLines = [[NSMutableArray alloc] init];
    lineAngle = 125;
    
    topLeft = CGPointMake(300,200);
    topRight = CGPointMake(400,200);
    bottomRight = CGPointMake(400,100);
    bottomLeft = CGPointMake(300,100);
    
    sound = [[Sound alloc] init];
    soundSfx = [[Sound alloc] init];
    
    [self drawCombatUI];
    
    monsters = [[NSArray alloc] init];
    monster = [[Monster alloc] init];
    [self addChild:monster.sprite];
    [monster monsterMovement];
    
    //reticule symbol
    int random = arc4random() % 500;
    reticule = [SKSpriteNode spriteNodeWithImageNamed:@"reticule.png"];
    [reticule setName:@"reticule"];
    [reticule setPosition:CGPointMake(random, 250)];
    [reticule setSize:CGSizeMake(25,25)];
    [self addChild:reticule];
    
    radarCircle = [SKShapeNode shapeNodeWithCircleOfRadius:3.0];
    [radarCircle setPosition: CGPointMake(screenWidth/12.5,screenHeight/8.5)];
    [radarCircle setStrokeColor:[UIColor blackColor]];
    [radarCircle setGlowWidth:2];
    [self addChild:radarCircle];
    
    [monster monsterMovement];
    [monster attack];
}

-(void)update:(NSTimeInterval)currentTime
{
    msec++;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [[event allTouches] allObjects];
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint location = [touch locationInNode:self];
    
    if ([allTouches count] > 1)
        return;
    else
    {
        // If user taps the reticule, monster stops attacking
        if ([[self nodeAtPoint:location].name isEqualToString:reticule.name])
        {
            NSLog(@"Testing....");
            // INSERT MONSTER STOPPED ATTACKING HERE!!
            
        }
        if([[self nodeAtPoint:location].name isEqualToString:monster.sprite.name])
        {
            //decrease monster's hp
            [sound playSound:@"ouch"];
            //[self flash];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSArray *allTouches = [[event allTouches] allObjects];
    
    if([allTouches count] > 1)
        return;
    else
    {
        UITouch *touch = [allTouches objectAtIndex:0];
        CGPoint loc = [touch locationInNode:self];
        
        if([[self nodeAtPoint:loc].name isEqualToString:monster.sprite.name])
        {
            //decrease monster's hp
            [sound playSound:@"ouch"];
            //[self flash];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [[event allTouches] allObjects];
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint loc = [touch locationInNode:self];
    
    for(int i = 0; i < points.count; i++)
    {
        [points[i] removeFromParent];
        [points removeObjectAtIndex:i];
    }
}

-(void)updateRadar
{
    float maxX = 1500;
    //if monster is  3000px x then move to -3000 and vice versa
    if(monster.sprite.position.x > maxX)
    {
        [monster.sprite setPosition:CGPointMake(-maxX, monster.sprite.position.y)];
    }
    else if(monster.sprite.position.x < -maxX)
    {
        [monster.sprite setPosition:CGPointMake(maxX, monster.sprite.position.y)];
    }
    
    //show degrees from 0 to 360
    int degrees = 360 * (monster.sprite.position.x / 3000);
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
    [radarCircle setPosition:CGPointMake(endX, endY)];
    //NSLog(@"DEGREES: %i \n",degrees);
    
    //play blip sound if radar line = monster's location's blip
    int monsterBlipDegrees = startAngle + degrees;
    int lineDegrees = lineAngle;
    NSLog(@"monster degrees: %i \n",monsterBlipDegrees);
    NSLog(@"line degrees: %i \n",lineDegrees);
}

//Determines whether game is won or lost
-(void)gameoverAnimation
{
    //[self losegameAnimation];
    //[self wingameAnimation];
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
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
        [self setVariables];
    }
}

-(void)wingameAnimation
{
    if(![self.children containsObject: fourSidedFigure])
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
        
        [soundPlayer playSoundForever:@"win"];
        
        //alert to if want to restart
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"YOU WIN"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"RESTART"
                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)losegameAnimation
{
    if(![self.children containsObject: static1])
    {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"staticdamage"];
        SKTexture * static2 = [atlas textureNamed:@"15perc2.png"];
        SKTexture * static3 = [atlas textureNamed:@"15perc3.png"];
        SKTexture * static4 = [atlas textureNamed:@"15perc4.png"];
        
        NSArray * runTexture = @[static2,static3,static4, static3,static2];
        SKAction* runAnimation = [SKAction animateWithTextures:runTexture timePerFrame:0.07 resize:NO restore:NO];
        [static1 runAction:[SKAction repeatActionForever:runAnimation]];
        [self addChild:static1];
        [soundPlayer playSoundForever:@"owMusic"];
        
        if((int)(arc4random()%2)==1)
            [sound playSound:@"okaykid"];
        else
            [sound playSound:@"OW"];
        //alert to if want to restart
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"GAME OVER"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"CONTINUE"
                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)flash
{
    SKSpriteNode *redflash = [SKSpriteNode spriteNodeWithImageNamed:@"Flash@2x.jpg"];
    SKAction* flash = [SKAction fadeOutWithDuration:0.5];
    [redflash setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [redflash setSize:CGSizeMake(screenWidth*2, screenHeight*2)];
    [self addChild:redflash];
    [redflash runAction:flash completion:^{
        [redflash removeFromParent];
    }];
}

-(Boolean)checkAccessCameraPermission
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status !=  AVAuthorizationStatusNotDetermined)
        if (status == ALAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot show camera's video feed until Obscure gets access permission to Camera in your Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    
    return YES;
}

-(void)beginNewLine:(CGPoint)startPt
{
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

-(void)addPointToLine:(CGPoint)pt
{
    CGPathAddLineToPoint(currentPathToDraw, NULL, pt.x, pt.y);
    CGPathMoveToPoint(currentPathToDraw, NULL, pt.x, pt.y);
    currentLine.path = currentPathToDraw;
}
@end