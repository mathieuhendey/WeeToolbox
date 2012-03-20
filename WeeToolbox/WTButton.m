//
//  WTButton.m
//  WeeToolbox
//
//  Created by Mathieu Hendey on 2/24/12.
//  
//

#import "WTButton.h"
//#import <AVFoundation/AVFoundation.h>
#import "defs.h"

@implementation WTButton

- (id)init
{
    if((self = [super init]) != nil) {
        // nothing to see here
	} 
    return self;
}

/*--------------------------------------------------------

    These methods return imageviews with the proper icon.
 */

- (UIImageView *)twitterButtonType
{
    twitterButton = [[UIImageView alloc] init];
    [twitterButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/twitter.png", resources_dir_path]]];
    
    return twitterButton;
}

- (UIImageView *)facebookButtonType
{
    faceBookButton = [[UIImageView alloc] init];
    [faceBookButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/facebook.png", resources_dir_path]]];
    
    return faceBookButton;
}

- (UIImageView *)SMSButtonType
{
    smsButton = [[UIImageView alloc] init];
    [smsButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/sms.png", resources_dir_path]]];
    
    return smsButton;
}

- (UIImageView *)phoneButtonType
{
    instaCallButton = [[UIImageView alloc] init];
    [instaCallButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/phone.png", resources_dir_path]]];
    
    return instaCallButton;
}

- (UIImageView *)cameraButtonType
{
    cameraButton = [[UIImageView alloc] init];
    [cameraButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/camera.png", resources_dir_path]]];
    
    return cameraButton;
}

- (UIImageView *)torchButtonType
{
    flashButton = [[UIImageView alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchLevel == 1.0) {
        [flashButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/flashon.png", resources_dir_path]]];
    }
    
    else if (device.torchLevel == 0.0) {
        [flashButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/flashoff.png", resources_dir_path]]];
    }
    
    return flashButton;
}

- (UIImageView *)pastieButtonType
{
    pastieButton = [[UIImageView alloc] init];
    [pastieButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pastie.png", resources_dir_path]]];
    
    return pastieButton;
}

- (UIImageView *)powerButtonType
{
    powerButton = [[UIImageView alloc] init];
    [powerButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/power.png", resources_dir_path]]];
    
    return powerButton;
}

- (void)dealloc
{
    [super dealloc];
    
    [twitterButton release];
    twitterButton = nil;
    [instaCallButton release];
    instaCallButton = nil;
    [flashButton release];
    flashButton = nil;
    [pastieButton release];
    pastieButton = nil;
    [cameraButton release];
    cameraButton = nil;
    [smsButton release];
    smsButton = nil;
    [powerButton release];
    powerButton       = nil;
    [faceBookButton release];
    faceBookButton    = nil;
}

@end


/*--------------------------------------------------------
 
 Declare buttons' frames
 */

@implementation WTButtonFrame

+ (CGRect)frame1
{
    return CGRectMake(3,0,42,42);
}

+ (CGRect)frame2
{
    return CGRectMake(70,0,42,42);
}

+ (CGRect)frame3
{
    return CGRectMake(137,0,42,42);
}

+ (CGRect)frame4
{
    return CGRectMake(204,0,42,42);
}

+ (CGRect)frame5
{
    return CGRectMake(271,0,42,42);
}

+ (CGRect)frame6
{
    return CGRectMake(318,0,42,42);
}

+ (CGRect)frame7
{
   return CGRectMake(385,0,42,42); 
}

+ (CGRect)frame8
{
   return CGRectMake(452,0,42,42); 
}

@end


