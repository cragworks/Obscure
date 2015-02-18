#import "UIPopUp.h"
@implementation UIPopUp
@synthesize banner;

- (id)init
{
    if (self = [super init])
    {
        banner = [SKSpriteNode spriteNodeWithImageNamed:@"win.jpeg"];
    }
    return self;
}

-(void)displayPopUp:(NSString*)Name
{
    if([Name isEqual:@"win"])
        banner = [SKSpriteNode spriteNodeWithImageNamed:@"win.jpeg"];
    else if([Name isEqual:@"lose"])
        banner = [SKSpriteNode spriteNodeWithImageNamed:@"loser.png"];
    else if([Name isEqual:@"gyro" ])
        banner = [SKSpriteNode spriteNodeWithImageNamed:@"move.png"];

    [banner setSize:CGSizeMake(50, 50)];
    [banner setPosition:CGPointMake(screenWidth/2, screenHeight/2)];
    [banner setSize:CGSizeMake(banner.size.width, banner.size.height)];
    [banner setZPosition:-1];
}


@end