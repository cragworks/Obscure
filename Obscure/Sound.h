#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface Sound : NSObject
{
    AVAudioPlayer *bg;
}
-(void)playSound:(NSString*)fileName;
-(void)playSound:(NSString*)fileName :(float)volume;
-(void)playSoundForever:(NSString*)fileName;
-(void)stopSound;
-(float)getDuration;
-(BOOL)isPlaying;
@end
