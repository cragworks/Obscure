//
//  Attacking.m
//  Obscure
//
//  Created by Michelle Tjoa on 12/7/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Attacking.h"
#import "HumanHPbar.h"
#import "HumanHPbar.m"

/* This does the calculations once one of hte onject is being damaged */
@implementation Attacking
- (id)init {
    if (self = [super init]) {
        damage = 0;
    }
    return self;
}

/* calculates the hp after being hit */
- (void) damaging
{
    double damageDealt;
    damageDealt = [self howMuchDamage];
    hpObject-=damage;
    if (hpObject <=0) {
        [self respawning];
    }
}

/* defines how much damage is taken */
-(double) howMuchDamage
{
    return 10;
    
}

-(void) respawning
{
    
}
@end
