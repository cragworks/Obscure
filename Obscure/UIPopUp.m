#import "UIPopUp.h"
@implementation UIPopUp
@synthesize sprite;

- (id)init
{
    if(self = [super init])
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
    }
    return self;
}

-(void)displayPopUp:(NSString*)Name
{
    if([Name isEqual:@"win"])
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"catleft1"];
    else if([Name isEqual:@"lose"])
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"catleft1"];
    else if([Name isEqual:@"gyro" ])
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"catleft1"];
    [sprite setName:@"popup"];
    [sprite setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [sprite setSize:CGSizeMake(sprite.size.width, sprite.size.height)];
    [sprite setZPosition:-1];
}


@end