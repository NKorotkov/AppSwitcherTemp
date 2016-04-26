//
//  RFAppBlurManager.h
//  RFClient
//
//  Created by Nikolay Korotkov on 25/04/16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
@class UIColor;

@interface NKAppBlurManager : NSObject

/*! @brief Use this property to control the blur radius applied to your app's window when app goes to inactive state. Usually you'll want values somewhere between 5 and 50. If not set, default value of 15 will be used. */

@property (nonatomic, assign) CGFloat blurRadius;

/*! @brief Use this property to control the tint color applied to your app's window when app goes to inactive state. Usually you'll want colors with alpha component somewhere between 0 and 0.5 . If not set, clear color will be used by default. */

@property (nonatomic, strong) UIColor *tintColor;

/*!
 @brief Returns a singleton instance of NKAppBlurManager.
 @discussion Use NKAppBlurManager singleton instance to control <i>blurRadius</i> and <i>tintColor</i> of the blur view applied to your app's window and to enable\disable automatic blurring.
 */

+ (instancetype)sharedManager __attribute__((const));

/*!
 @brief Manually apply or remove blur.
 @param active When set to NO app's window is blured. When set to YES initial state is restored.
 */

+ (void)setAppActive:(BOOL)active;

/*!
 @brief Switches auto blurring on and off.
 @param enabled When <i>enabled</i> is set to YES NKAppBlurManager automatically blurs your app's window when app goes to inactive state and restores initial state when app becomes active. Set <i>enabled</i> to NO to stop auto blurring.
 */

- (void)setAutoBlurEnabled:(BOOL)enabled;

@end
