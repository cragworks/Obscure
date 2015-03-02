#import "Level1.h"
@implementation Level1

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

@end