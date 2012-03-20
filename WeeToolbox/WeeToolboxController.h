//
//  WeeToolboxController.h
//  WeeToolbox
//
//  Created by Will Coughlin on 2/24/12.
//  Copyright (c) 2012 Wundersoft. All rights reserved.
//

#import "defs.h"

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "SpringBoard/BBWeeAppController.h"

//#import <AddressBook/AddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>

#import "WTButton.h"

@interface WeeToolboxController : NSObject <BBWeeAppController, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ABPeoplePickerNavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    UIView *_view;
    
    UIImageView *button1;
	UIImageView *button2;
	UIImageView *button3;
	UIImageView *button4;
	UIImageView *button5;
    UIImageView *button6;
    UIImageView *button7;
    UIImageView *button8;
    
    UIScrollView *scrollView;
    
    WTButton *wtb;
    
    UIViewController *vc;	//UIViewController to be used for displaying modal views.
	UIWindow *window; //UIWindow for which the viewController will be set to vc.
    
	ABPeoplePickerNavigationController *pp;
    
    UIActivityIndicatorView *activityIndicator;
    
    bool torchIsOn;
}

- (UIView *)view;

@property (nonatomic, retain) NSNumber *slot1;
@property (nonatomic, retain) NSNumber *slot2;
@property (nonatomic, retain) NSNumber *slot3;
@property (nonatomic, retain) NSNumber *slot4;
@property (nonatomic, retain) NSNumber *slot5;
@property (nonatomic, retain) NSNumber *slot6;
@property (nonatomic, retain) NSNumber *slot7;
@property (nonatomic, retain) NSNumber *slot8;

@property (nonatomic, retain) ABPeoplePickerNavigationController *pp;

@end