//
//  WTButton.h
//  WeeToolbox
//
//  Created by Will Coughlin on 2/24/12.
//  Copyright (c) 2012 Wundersoft. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

#import "defs.h"

#import "WTButton.h"

@interface WTButton : NSObject {
    UIImageView *twitterButton;
	UIImageView *instaCallButton;
	UIImageView *flashButton;
	UIImageView *pastieButton;
	UIImageView *cameraButton;
    UIImageView *smsButton;
    UIImageView *powerButton;
    UIImageView *faceBookButton;
}

- (UIImageView *)twitterButtonType;
- (UIImageView *)facebookButtonType;
- (UIImageView *)SMSButtonType;
- (UIImageView *)phoneButtonType;
- (UIImageView *)cameraButtonType;
- (UIImageView *)torchButtonType;
- (UIImageView *)pastieButtonType;
- (UIImageView *)powerButtonType;

@end


@interface WTButtonFrame : NSObject

+ (CGRect)frame1;
+ (CGRect)frame2;
+ (CGRect)frame3;
+ (CGRect)frame4;
+ (CGRect)frame5;
+ (CGRect)frame6;
+ (CGRect)frame7;
+ (CGRect)frame8;

@end
