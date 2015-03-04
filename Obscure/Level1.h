//
//  UIPopUp.h
//  Obscure
//
//  Created by Kay Lab on 2/10/15.
//  Copyright (c) 2015 Calvin Tham. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Level1: NSObject
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    //enemies/holograms
    int num_enemies;
    CGPoint enemyLoc1;
    CGPoint enemyLoc2;
    CGPoint enemyLoc3;
    CGPoint enemyLoc4;
    
    //player stats
    int player_num_lives;
    int player_num_health;
    int player_item;
    CGPoint playerStartPoint;
    
    //win or lose
    int winLoseStatus; //-1 = lost, 0 = stillPlaying, 1 = won
    
    //music
    NSString* nameOfBgMusic;
    NSString* nameOfWinMusic;
    NSString* nameOfLoseMusic;
    NSString* nameOfHitMonsterSfx;
}

@end