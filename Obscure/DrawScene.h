<<<<<<< HEAD
//
//  DrawScene.h
//  TicTacVideo
//
//  Created by Calvin Tham on 7/28/14.
//  Copyright (c) 2014 Calvin Tham. All rights reserved.
//
#define btnFadeAlpha 0.3
#define clearBtnFadeAlpha 0.3
#define takeScreenshotBtnFadeAlpha 0.3
#define switchCameraBtnFadeAlpha 0.3
#define pawBtnFadeAlpha 0.3
#define btnMaxFadeAlpha 0.05

#import "Sound.h"
#import "MonsterHPBar.h"
#import "HumanHPbar.h"
#import "Monster.h"

=======
>>>>>>> FETCH_HEAD
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

<<<<<<< HEAD
=======
#import "Sound.h"
#import "Monster.h"
#import "Gyroscope.h"

>>>>>>> FETCH_HEAD
@interface DrawScene : SKScene <UIAlertViewDelegate>
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSArray *monsters;
    Monster *monster;
    
    BOOL monsterReachedYou;
    BOOL GAMEOVER;
    SKShapeNode *fourSidedFigure;
    
    SKSpriteNode *static1;
    int lineAngle;
    
    Sound *sound;
    Sound *soundSfx;
    Sound* soundPlayer;
    int msec;
    
    Gyroscope *gyroscope;
}
@end
