#import "Sound.h"

@implementation Sound

-(void) playSound:(NSString*)fileName
{
    NSString *formattedString = [NSString stringWithFormat:@"%@/%@.aiff", [[NSBundle mainBundle] resourcePath], fileName];
    NSURL *url = [NSURL fileURLWithPath:formattedString];
    bg = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [bg setEnableRate:YES];
    [bg setRate:1];
    [bg setVolume:0.85];
    [bg play];
}

-(void) playSound:(NSString*)fileName :(float)volume
{
    NSString *formattedString = [NSString stringWithFormat:@"%@/%@.aiff", [[NSBundle mainBundle] resourcePath], fileName];
    NSURL *url = [NSURL fileURLWithPath:formattedString];
    bg = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [bg setEnableRate:YES];
    [bg setRate:1];
    [bg setVolume:volume];
    [bg play];
}

-(void) playSoundForever:(NSString*)fileName
{
    NSString *formattedString = [NSString stringWithFormat:@"%@/%@.aiff", [[NSBundle mainBundle] resourcePath], fileName];
    NSURL *url = [NSURL fileURLWithPath:formattedString];
    bg = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [bg setEnableRate:YES];
    [bg setRate:1];
    [bg setVolume:1];
    [bg play];
    [bg setNumberOfLoops:99];
}

-(void) stopSound
{
    [bg stop];
}

-(float) getDuration
{
    return (float)bg.duration;
}

-(BOOL) isPlaying
{
    return bg.isPlaying;
}
@end
