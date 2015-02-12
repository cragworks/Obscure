//
//  UIPopUp.h
//  Obscure
//
//  Created by Kay Lab on 2/10/15.
//  Copyright (c) 2015 Calvin Tham. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

//#ifndef Obscure_UIPopUp_h
//#define Obscure_UIPopUp_h
@interface UIPopUp: NSObject
{
    SKSpriteNode* banner;
    
    
    //SKTexture* image;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property SKSpriteNode * banner;

-(void)displayPopUp:(NSString*)Name;

@end

//#endif