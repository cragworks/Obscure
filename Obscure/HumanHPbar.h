//
//  HumanHPbar.h
//  Obscure
//
//  Created by Roni Tu on 12/4/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HumanHPbar : SKScene
{
    int max;
    SKSpriteNode * sprite;
}
- (void) heal:(CGFloat) hp;
- (void) humanwound:(CGFloat) hp;
@end
