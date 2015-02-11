#import "UIPopUp.h"
@implementation UIPopUp
//@synthesize winbanner;

- (id)init
{
    if (self = [super init])
    {
        winbanner = [SKSpriteNode spriteNodeWithImageNamed:@"win.jpeg"];
        losebanner = [SKSpriteNode spriteNodeWithImageNamed:@"loser.png"];
        gyrobanner = [SKSpriteNode spriteNodeWithImageNamed:@"move.png"];
        
        [winbanner setSize:CGSizeMake(50, 50)];
        [losebanner setSize:CGSizeMake(50, 50)];
        [gyrobanner setSize:CGSizeMake(50, 50)];

    }
    return self;
}


-(void)displayPopUp:(NSString*)Name
{
    if(Name==@"win")
    {
        
    }
    else if(Name==@"lose")
    {
        
    }
    else if(Name==@"gyro")
    {
        
    }
}


@end