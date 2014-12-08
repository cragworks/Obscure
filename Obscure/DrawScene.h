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

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

@interface DrawScene : SKScene
{
    SKSpriteNode *monster;
    SKSpriteNode *static1;
    BOOL monsterReachedYou;
    BOOL GAMEOVER;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    SKShapeNode *currentLine;
    CGMutablePathRef currentPathToDraw;
    
    SKSpriteNode *buttonClear;
    SKSpriteNode *buttonClearPressed;
    
    SKSpriteNode *buttonSwitchCamera;
    SKSpriteNode *buttonSwitchCameraPressed;
    
    SKSpriteNode *buttonTakeScreenshot;
    SKSpriteNode *buttonTakeScreenshotPressed;
    
    SKSpriteNode *reticule;
    
    Boolean stillTakingScreenshot;
    
    Sound *sound;
    Sound *soundSfx;
    NSMutableArray *lines;
    //test
    
    //coremotion stuff
    double currentMaxAccelX;
    double currentMaxAccelY;
    double currentMaxAccelZ;
    double currentMaxRotX;
    double currentMaxRotY;
    double currentMaxRotZ;
    
    HumanHPbar * player;
    MonsterHPBar * monsterHPBar;
    
    SKShapeNode* radarCircle;
    NSMutableArray *arcLines;
    int lineAngle;
}

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
