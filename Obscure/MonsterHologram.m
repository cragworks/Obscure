#import "MonsterHologram.h"

@implementation MonsterHologram
@synthesize sprite;

-(id)init :(float)x :(float)y :(float)width :(float)height
{
    self = [super init];
    [sprite setPosition:CGPointMake(x, y)];
    [sprite setSize:CGSizeMake(width, height)];
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
