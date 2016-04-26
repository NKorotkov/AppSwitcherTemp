//
//  RFAppBlurManager.m
//  RFClient
//
//  Created by Nikolay Korotkov on 25/04/16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

#import "NKAppBlurManager.h"
#import "UIImageEffects.h"
#import <objc/runtime.h>

// Private category to add a blur view property to a window
@interface UIWindow (BlurPrivate)
@property UIView *nkBlurView;
@end

@implementation UIWindow (BlurPrivate)
- (void)setNkBlurView:(UIView *)nkBlurView { objc_setAssociatedObject(self, @selector(nkBlurView), nkBlurView, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)nkBlurView { return objc_getAssociatedObject(self, @selector(nkBlurView)); }
@end





static NSTimeInterval  const ANIMATION_DURATION = .15;
static CGFloat const BLUR_RADIUS = 15;



@interface NKAppBlurManager ()
@property (nonatomic, assign) BOOL autoBlur;
@end

@implementation NKAppBlurManager


+ (instancetype)sharedManager {
    
    static NKAppBlurManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [NKAppBlurManager new];
        
    });
    
    return _manager;
}

- (void)setAutoBlurEnabled:(BOOL)enabled {
    
    if (enabled && !self.autoBlur) {
        
        self.autoBlur = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        
    } else if (!enabled && self.autoBlur) {
        
        self.autoBlur = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }
    
}

+ (void)setAppActive:(BOOL)active {
    NKAppBlurManager *manager = [NKAppBlurManager sharedManager];
    _setAppActive(active, manager.blurRadius, manager.tintColor);
}


#pragma mark - Notification Handling

- (void)_handleApplicationDidBecomeActive {
    _setAppActive(YES, 0, nil);
}

- (void)_handleWillResignActive {
    _setAppActive(NO, self.blurRadius, self.tintColor);
}

#pragma mark - Dealloc

- (void)dealloc {
    
     // will never be called on a singleton. Just a reminder.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - Helper Functions

void _setAppActive(BOOL active, CGFloat blurRadius, UIColor *tintColor) {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (!active) {
        // set up a blur view
        
        if (window.nkBlurView) {
            // precaution. Blur view might still be present due to animation delay
            [window.nkBlurView removeFromSuperview];
        }
        
        // set up image view
        UIImageView *blurEffectView = [UIImageView new];
        blurEffectView.backgroundColor = [UIColor clearColor];
        blurEffectView.frame = [UIScreen mainScreen].bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // get image rendered from snapshot
        UIGraphicsBeginImageContextWithOptions(blurEffectView.bounds.size, YES, 0);
        [window drawViewHierarchyInRect:blurEffectView.bounds afterScreenUpdates:NO];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //apply blur
        image = _applyBlurToImage(image, blurRadius, tintColor);
        
        // set image
        [blurEffectView setImage:image];
        blurEffectView.alpha = 0;
        
        [window addSubview:blurEffectView];
        window.nkBlurView = blurEffectView;
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            blurEffectView.alpha = 1;
        }];
        
    } else {
        
        // if blur view is present - get rid of it
        UIView *view = window.nkBlurView;
        if (view) {
            [UIView animateWithDuration:ANIMATION_DURATION
                             animations:^{
                                 view.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 [view removeFromSuperview];
                             }];
        }
        
    }
}


UIImage * _applyBlurToImage(UIImage * inputImage, CGFloat blurRadius, UIColor *tintColor) {
    //    tintColor = tintColor ?: [UIColor colorWithWhite:0.5 alpha:.0];
    blurRadius = blurRadius ?: BLUR_RADIUS;
    return  [UIImageEffects imageByApplyingBlurToImage:inputImage withRadius:blurRadius tintColor:tintColor saturationDeltaFactor:1 maskImage:nil];
}







@end
