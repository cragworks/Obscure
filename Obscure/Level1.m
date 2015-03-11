#import "Level1.h"
@implementation Level1

- (id)init
{
    if(self = [super init])
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        
        //enemies/holograms
        num_enemies = 2;
        CGPoint enemyLoc1 = CGPointMake(90, 90);
        CGPoint enemyLoc2 = CGPointMake(450, 300);
        CGPoint enemyLoc3 = CGPointMake(200, 530);
        CGPoint enemyLoc4 = CGPointMake(500, 90);
        
        //player stats
        player_num_lives = 50;
        player_num_health = 200;
        player_item = 2;
        CGPoint playerStartPoint = CGPointMake(9, 9);
        
        //win or lose
        winLoseStatus = 0; //-1 = lost, 0 = stillPlaying, 1 = won
        
        //music
        nameOfBgMusic = @"introtrackloop.aiff";
        nameOfWinMusic = @"win.aiff";
        nameOfLoseMusic = @"gameover.aiff";
        nameOfHitMonsterSfx = @"owMusic.aiff";
    }
    return self;
}

@end