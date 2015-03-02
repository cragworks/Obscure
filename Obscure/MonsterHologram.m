#import "MonsterHologram.h"

@implementation MonsterHologram
@synthesize sprite;

-(id)init :(float)x :(float)y :(float)width :(float)height
{
    self = [super init];
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"catmain1"];
    [sprite setPosition:CGPointMake(x, y)];
    [sprite setSize:CGSizeMake(width, height)];
    [self startRotateAnimation];
    return self;
}

-(void)hurt
{
    health -= DMG;
}

-(void)update
{
    //Might need to add sth later.
}

-(void)startRotateAnimation
{
    SKTextureAtlas * atlas = [SKTextureAtlas atlasNamed:@"CAT3D"];
    SKTexture * one = [atlas textureNamed:@"1"];
    SKTexture * two = [atlas textureNamed:@"2"];
    SKTexture * three = [atlas textureNamed:@"3"];
    SKTexture * four = [atlas textureNamed:@"4"];
    SKTexture * five = [atlas textureNamed:@"5"];
    SKTexture * six = [atlas textureNamed:@"6"];
    SKTexture * seven = [atlas textureNamed:@"7"];
    SKTexture * eight = [atlas textureNamed:@"8"];
    SKTexture * nine = [atlas textureNamed:@"9"];
    SKTexture * ten = [atlas textureNamed:@"10"];
    SKTexture * eleven = [atlas textureNamed:@"11"];
    SKTexture * twelve = [atlas textureNamed:@"12"];
    SKTexture * thirteen = [atlas textureNamed:@"13"];
    SKTexture * fourteen = [atlas textureNamed:@"14"];
    SKTexture * fifteen = [atlas textureNamed:@"15"];
    SKTexture * sixteen = [atlas textureNamed:@"16"];
    NSArray * animation = @[one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen];
    SKAction* runleap = [SKAction animateWithTextures:animation timePerFrame: 0.075 resize:NO restore:NO];
    [sprite runAction:[SKAction repeatActionForever:runleap] ];
}


-(void)checkForTouchesBegan:(CGPoint)loc
{
    /*
     if ([[self nodeAtPoint:loc].name isEqualToString:MonsterHologram.name])
     {
     hurt();
     }
     */
}

@end
