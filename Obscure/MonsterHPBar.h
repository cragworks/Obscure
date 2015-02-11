//
//  MonsterHPBar.h
//  Obscure
//
//  Created by Derrick Chuong on 12/2/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MonsterHPBar : SKCropNode{
    float hp;
    int power;
    
    
}

- (id) initWithCustomSize:(CGSize)cgsize;
- (void) setHP:(CGFloat) hp;
- (void) hurt:(CGFloat) damage, hp;
-(void) update:(CGFloat) hp;
-(float) getHP;
@end
