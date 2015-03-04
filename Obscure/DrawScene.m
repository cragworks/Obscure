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
        
//        SK3DNode *alien3D = [[SK3DNode alloc] initWithViewportSize:CGSizeMake(200, 200)];
//        SCNScene *alienSCN = [SCNScene sceneNamed:@"cat.dae"];
//        alien3D.scnScene = alienSCN;
//        [self addChild:alien3D];
    }
    gyroscope = [[Gyroscope alloc] init];
    return self;
}

-(void)setVariables
{
    [self removeAllChildren];
    gyroscope = [[Gyroscope alloc] init];
    msec = 0;
    
    soundPlayer = [[Sound alloc] init];
    [soundPlayer playSoundForever:@"splat_city"];
    
    sound = [[Sound alloc] init];
    soundSfx = [[Sound alloc] init];
    
    [self drawCombatUI];
    
    monsters = [[NSArray alloc] initWithObjects:monster.sprite, nil];
    monster = [[Monster alloc] init];
    [self addChild:monster.sprite];
    [monster monsterMovement];
    [monster attack];
    
    MonsterHologram* mH1 = [[MonsterHologram alloc] init:screenWidth/2 :screenHeight/2 :300 :300];
    [self addChild:mH1.sprite];
    
    MonsterHologram* mH2 = [[MonsterHologram alloc] init:0 :screenHeight*2 :100 :300];
    [self addChild:mH2.sprite];
    
    MonsterHologram* mH3 = [[MonsterHologram alloc] init:screenWidth*2 :0 :300 :50];
    [self addChild:mH3.sprite];
    
    MonsterHologram* mH4 = [[MonsterHologram alloc] init:0 :0 :300 :1000];
    [self addChild:mH4.sprite];
    
    banner = [[UIPopUp alloc]init];
    [banner displayPopUp:@"win"];
    [self addChild:banner.sprite];
}

-(NSMutableArray*)getAllNonUISprites
{
    NSMutableArray* allSprites = [NSMutableArray arrayWithObjects:nil];
    for(int i = 0; i < [self children].count; i++)
    {
        SKSpriteNode* tempSprite = self.children[i];
        if([tempSprite.name isEqualToString: @"UI"] == NO)
            [allSprites addObject:self.children[i]];
    }
    
    return allSprites;
}

-(void)update:(NSTimeInterval)currentTime
{
    msec++;
    
    NSMutableArray* allSprites = [self getAllNonUISprites];
    [gyroscope update:allSprites];
}

-(int)genRandNum :(int)min :(int)max
{
    int randNum = min + arc4random_uniform(max - min + 1);
    return randNum;
}

-(void)addSplat
{
    int randNum = [self genRandNum :0 :1];
    SKSpriteNode* splat;
    if(randNum == 0)
        splat = [SKSpriteNode spriteNodeWithImageNamed:@"splat_green"];
    else if(randNum == 1)
        splat = [SKSpriteNode spriteNodeWithImageNamed:@"splat_yellow"];
    [self addChild:splat];
    [splat setPosition:CGPointMake(screenWidth/2, screenHeight/4)];
    [splat setScale:4];
    
    int randOffset = [self genRandNum:-50 :50];
    CGPoint centerPt = CGPointMake(screenWidth/2 + randOffset, screenHeight/2 + randOffset);
    SKAction* moveToCenter = [SKAction moveTo:centerPt duration:0.1];
    SKAction* getSmaller = [SKAction resizeToWidth:50 height:50 duration:0.05];
    [splat runAction:moveToCenter];
    int randSqueezeOffset = [self genRandNum:0 :100];
    SKAction* squeezeInOrOut = [SKAction resizeByWidth:randSqueezeOffset height:randSqueezeOffset duration:0.3];
    [splat runAction: squeezeInOrOut];
    SKAction* fadeOut = [SKAction fadeAlphaTo:0 duration:1 ];
    NSArray* array = [NSArray arrayWithObjects:getSmaller, fadeOut, nil];
    [splat runAction: [SKAction sequence:array] completion:^(void){
        [splat removeFromParent];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [[event allTouches] allObjects];
    UITouch *touch = [allTouches objectAtIndex:0];
    CGPoint location = [touch locationInNode:self];
    
    [soundSfx playSound:@"splat"];
    [self addSplat];
    
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
        else if([[self nodeAtPoint:location].name isEqualToString:banner.sprite.name])
        {
            [banner.sprite removeFromParent];
        }
        else if([[self nodeAtPoint:location].name isEqualToString:@"RESET"])
        {
            [banner.sprite removeFromParent];
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
    [overlay setName:@"UI"];
    [overlay setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [overlay setSize:CGSizeMake(screenWidth, screenHeight)];
    [overlay setZPosition:-2];
    
    //ui decal
    SKSpriteNode *decal = [SKSpriteNode spriteNodeWithImageNamed:@"ui-Decal.png"];
    [decal setName:@"UI"];
    [decal setAlpha:0.5];
    [decal setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [decal setSize:CGSizeMake(screenWidth, screenHeight)];
    [decal setZPosition:-1];
    
    //pause button
    SKSpriteNode *pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause-button.png"];
    [pause setName:@"UI"];
    [pause setAlpha:0.5];
    float pause_height = pause.size.height*0.6;
    float pause_width = pause.size.width*0.6;
    [pause setPosition:CGPointMake(screenWidth-pause_width, screenHeight-pause_height)];
    [pause setSize:CGSizeMake(pause_width, pause_height)];
    [pause setZPosition:-1];
    
    //target cross hair
    SKSpriteNode *crosshair = [SKSpriteNode spriteNodeWithImageNamed:@"targetcrosshair.png"];
    [crosshair setName:@"UI"];
    // to be changed to position of monster. this is just to test
    [crosshair setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [crosshair setSize:CGSizeMake(100,100)];
    [crosshair setZPosition:5];
    [crosshair setAlpha:0.5];
    SKAction* rotateRight = [SKAction rotateToAngle:0.5 duration:0.5];
    SKAction* rotateLeft = [SKAction rotateToAngle:-0.5 duration:0.5];
    SKAction* rotateRightLeft = [SKAction sequence: [NSArray arrayWithObjects:rotateRight, rotateLeft, nil]];
    [crosshair runAction: [SKAction repeatActionForever: rotateRightLeft]];
    
    //katana
    SKSpriteNode *katana = [SKSpriteNode spriteNodeWithImageNamed:@"weapon-katana.png"];
    [katana setName:@"UI"];
    [katana setPosition:CGPointMake(screenWidth*0.875 - katana.size.width, screenHeight*0.3 - katana.size.height)];
    [katana setSize:CGSizeMake(katana.size.width*0.6, katana.size.height*0.6)];
    [katana setZPosition:-1];
    
    //splat
    SKSpriteNode *splatUI = [SKSpriteNode spriteNodeWithImageNamed:@"splat_ui.png"];
    [splatUI setName:@"UI"];
    [splatUI setPosition: CGPointMake(screenWidth*0.725, screenHeight*0.1)];
    [splatUI setSize:CGSizeMake(splatUI.size.width*0.4, splatUI.size.height*0.4)];
    [splatUI setZPosition:-5];
    [splatUI setAlpha:0.5];
    SKAction* squeezeDown = [SKAction resizeToWidth:splatUI.size.width/1.25 height:splatUI.size.height/1.25 duration:1];
    SKAction* squeezeUp = [SKAction resizeToWidth:splatUI.size.width*1.25 height:splatUI.size.height*1.25 duration:1];
    SKAction* squeezeDownUp = [SKAction sequence: [NSArray arrayWithObjects:squeezeDown, squeezeUp, nil]];
    [splatUI runAction: [SKAction repeatActionForever: squeezeDownUp]];
    
    //[overlay setSize: CGPointMake(100, 100)];
    [self addChild:overlay];
    [self addChild:decal];
    [self addChild:pause];
    [self addChild:crosshair];
    
    //weapons
    //[self addChild:katana];
    [self addChild:splatUI];
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