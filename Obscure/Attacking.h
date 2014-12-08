//
//  Attacking.h
//  Obscure
//
//  Created by Michelle Tjoa on 12/7/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>

@interface Attacking : UIViewController
{
    double damage;
    double hpObject;
    
    
}
@property SKSpriteNode* sprite;
- (void) damaging;
-(double) howMuchDamage;
-(void) respawning;
@end
