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
    
    soundPlayer = [[Sound alloc] init];
    [soundPlayer playSoundForever:@"introtrackloop"];
    
    sound = [[Sound alloc] init];
    soundSfx = [[Sound alloc] init];
    
    [self drawCombatUI];
    
    monsters = [[NSArray alloc] init];
    monster = [[Monster alloc] init];
    [self addChild:monster.sprite];
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
            [sound playSound:@"ouch"];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [[event allTouches] allObjects];
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint loc = [touch locationInNode:self];
    
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

//if player is being attacked by monster
-(void)beingAttackedAnimation
{
    //warning symbol
    SKSpriteNode *warning = [SKSpriteNode spriteNodeWithImageNamed:@"Warning-Symbol.png"];
    [warning setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [warning setSize:CGSizeMake(warning.size.width*0.5, warning.size.height*0.5)];
    [warning setZPosition:-1];

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
@end