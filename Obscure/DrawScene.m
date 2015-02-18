#import "DrawScene.h"
#import "Gyroscope.h"
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
    gyroscope = [[Gyroscope alloc] init];
    msec = 0;
    
    soundPlayer = [[Sound alloc] init];
    [soundPlayer playSoundForever:@"introtrackloop"];
    
    sound = [[Sound alloc] init];
    soundSfx = [[Sound alloc] init];
    
    [self drawCombatUI];
    
    monsters = [[NSArray alloc] initWithObjects:monster.sprite, nil];
    monster = [[Monster alloc] init];
    [self addChild:monster.sprite];
    [monster monsterMovement];
    [monster attack];
}

-(void)update:(NSTimeInterval)currentTime
{
    msec++;
    [gyroscope moveSprite:monster.sprite];
    [gyroscope update:monsters];
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