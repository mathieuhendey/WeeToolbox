//
//  WeeToolboxController.m
//  WeeToolbox
//
//  Created by Mathieu Hendey on 2/24/12.
//
//

#import "WeeToolboxController.h"
#import "WTButton.h"
//#import "defs.h"

//#import <Twitter/Twitter.h>
//#import <AVFoundation/AVFoundation.h>
//#import <MobileCoreServices/MobileCoreServices.h>

@implementation WeeToolboxController

@synthesize slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8;
@synthesize pp;

-(id)init
{
	if ((self = [super init])) {
//        NSDictionary *settingsDict = [[NSDictionary dictionaryWithContentsOfFile:prefs_plist_path] autorelease];
//        slot1 = [settingsDict objectForKey:@"slot1"];
//        slot2 = [settingsDict objectForKey:@"slot2"];
//        slot3 = [settingsDict objectForKey:@"slot3"];
//        slot4 = [settingsDict objectForKey:@"slot4"];
//        slot5 = [settingsDict objectForKey:@"slot5"];
//        slot6 = [settingsDict objectForKey:@"slot6"];
//        slot7 = [settingsDict objectForKey:@"slot7"];
//        slot8 = [settingsDict objectForKey:@"slot8"];
//        
//        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        
//        if (device.torchLevel == 1.0) torchIsOn = YES;
//        
//        else if (device.torchLevel == 0.0) torchIsOn = NO;
//        
//        wtb = [[WTButton alloc] init];
	}

	return self;
}

-(void)dealloc
{
	[_view release];

    [slot1 release];
    [slot2 release];
    [slot3 release];
    [slot4 release];
    [slot5 release];
    [slot6 release];
    [slot7 release];
    [slot8 release];
    
    [button1 release];
    [button2 release];
    [button3 release];
    [button4 release];
    [button5 release];
    [button6 release];
    [button7 release];
    [button8 release];
    
    
    
	[super dealloc];
}

/*-------------------------------------------------------------------------------------------------*/
/*-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
 \                                                    \
 \        --------   Custom Methods   --------        \
 \                                                    \
/\/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-*/

/* -- Twitter -- */
- (void)twitterButtonPressed {
	//Method called when twitterButton is tapped.
    
	vc = [[UIViewController alloc] init];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	window.rootViewController = vc;  
	window.windowLevel = UIWindowLevelAlert;	//set window's windowLevel to be above Notification Center so you can see it.
    
	[window makeKeyAndVisible];  
	TWTweetComposeViewController *tweetSheet = 			//make and display tweetsheet.
   	[[TWTweetComposeViewController alloc] init];
    [tweetSheet setInitialText:@""];
    [vc presentModalViewController:tweetSheet animated:YES];
	
	tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
        if (result == TWTweetComposeViewControllerResultCancelled)
            [vc dismissModalViewControllerAnimated:YES];		//I had to do this for ResultCancelled because otherwise the keyboard didn't dismiss.
        [window release];
	};
}

/* -- Phone -- */

- (void)makeCallWithNumber:(NSString *)phone_number // to initialize call
{ // make call
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phone_number];
    NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (void)tappedContacts
{
    self.pp = [[[ABPeoplePickerNavigationController alloc] init] autorelease];
    self.pp.peoplePickerDelegate = self;
    self.pp.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    
    vc = [[UIViewController alloc] init];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = vc;  
    [window makeKeyAndVisible];  
    [vc presentModalViewController:self.pp animated:YES];
    
    window.windowLevel = UIWindowLevelAlert;
}

- (void)releasePickerElements 
{
    [[vc parentViewController] dismissModalViewControllerAnimated:YES];
    self.pp = nil;
    [vc release];
    vc = nil;
    [window release];
    window = nil; 
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
    NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phone);
    [self makeCallWithNumber:phone];
    [self releasePickerElements];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [vc dismissModalViewControllerAnimated:YES];
    [self releasePickerElements];
}

- (void)dial // this is called when the phone icon is tapped in NCInstaCall
{
    UIAlertView *inputView = [[UIAlertView alloc] initWithTitle:@"Enter Phone Number"
                                                        message:nil 
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"Call", nil];
    [inputView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [inputView textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
    [inputView show];
    [inputView release];
}

- (void)instaCallButtonPressed
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]]) {
        UIAlertView *optionsView = [[UIAlertView alloc] initWithTitle:@"Make Call" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Dial", @"Select Contact", nil];
        [optionsView show];
        [optionsView release];
    }
    else {
        UIAlertView *noPhone = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This device does not have telephone capabilities" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noPhone show];
        [noPhone release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([[alertView title] isEqualToString:@"Make Call"]) {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Dial"]) {
            [self dial];
        }
        else if ([title isEqualToString:@"Select Contact"]) {
            [self tappedContacts];
        }
    }
    
    if ([[alertView title] isEqualToString:@"Enter Phone Number"]) {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Call"]) {
            NSString *phoneNumber = [alertView textFieldAtIndex:0].text;
            if ([[phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] != 0)
                [self makeCallWithNumber:phoneNumber];
        }
    }
    
    if ([[alertView title] isEqualToString:@"System"]) {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Respring"])
        {
            system("killall -9 SpringBoard"); 
            
        }
        else if([title isEqualToString:@"Reboot"])
        {
            [[UIApplication sharedApplication] _rebootNow]; 
            
        }
        else if([title isEqualToString:@"Shutdown"])
        {
            [[UIApplication sharedApplication] _powerDownNow]; 
            
        }
        else if ([title isEqualToString:@"Safemode"]) {
            system("killall -SEGV SpringBoard");
        }
        
    }
    
    if ([[alertView title] isEqualToString:@"WeeToolbox First Run"]) {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Respring"])
        {
            system("killall -9 SpringBoard"); 
            
        } 
    }
}

/* -- LED Flash -- */
- (void)flashButtonPressed {
	//Working
    
    UIImageView *flashButton;
    
    if ([slot1 intValue] == 6) flashButton = button1;
    else if ([slot2 intValue] == 6) flashButton = button2;
    else if ([slot3 intValue] == 6) flashButton = button3;
    else if ([slot4 intValue] == 6) flashButton = button4;
    else if ([slot5 intValue] == 6) flashButton = button5;
    else if ([slot6 intValue] == 6) flashButton = button6;
    else if ([slot7 intValue] == 6) flashButton = button7;
    else if ([slot8 intValue] == 6) flashButton = button8;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
    	if (torchIsOn == NO) {
            torchIsOn = YES;
    		[device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];
            [flashButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/flashon.png"]];
    	}
  		else if (torchIsOn) {
  			[device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
            torchIsOn = NO;
            [flashButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/flashoff.png"]];
  		}
    } else {
        UIAlertView *noTorch = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This device does not have an LED flash" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noTorch show];
        [noTorch release];
    }
}

/* -- Pastie -- */
- (void)pastieButtonPressed {
	//Method called when pastieButton is tapped.
    
    UIView *pastieButton;
    
    if ([slot1 intValue] == 7) pastieButton = button1;
    else if ([slot2 intValue] == 7) pastieButton = button2;
    else if ([slot3 intValue] == 7) pastieButton = button3;
    else if ([slot4 intValue] == 7) pastieButton = button4;
    else if ([slot5 intValue] == 7) pastieButton = button5;
    else if ([slot6 intValue] == 7) pastieButton = button6;
    else if ([slot7 intValue] == 7) pastieButton = button7;
    else if ([slot8 intValue] == 7) pastieButton = button8;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *string = pasteboard.string;
    
    if (string == nil) { // we dont want to send a nil value!
        UIAlertView *derp = [[UIAlertView alloc] initWithTitle:@"No clipboard contents" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [derp show];
        [derp release];
    } else {
        //-------Show an activity indicator over the Pastie button
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = pastieButton.center;
        [_view addSubview: activityIndicator];
        [activityIndicator startAnimating];
        //--------
        BOOL private = YES;  // to be on the safe side
        
        NSMutableDictionary *post_dict = [NSMutableDictionary dictionary];
        [post_dict setObject:string forKey:@"paste[body]"];
        [post_dict setObject:@"burger" forKey:@"paste[authorization]"];
        [post_dict setObject:private ? @"1" : @"0" forKey:@"paste[restricted]"];
        [post_dict setObject:@"6" forKey:@"paste[parser_id]"]; // pass 6 as a string... 
        
        NSMutableData *post_data = [NSMutableData data];
        for (NSString *key in [post_dict allKeys]) {
            [post_data appendData:[[NSString stringWithFormat:@"--%@\r\n", kHeaderBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [post_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [post_data appendData:[[post_dict valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
            [post_data appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [post_data appendData:[[NSString stringWithFormat:@"--%@--\r\n", kHeaderBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://pastie.org/pastes"]];
        NSString *content_type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kHeaderBoundary];
        [request addValue:content_type forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:post_data];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // failure
	UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Paste failed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [activityIndicator stopAnimating];
    [activityIndicator release];
    [resultAlert show];
    [resultAlert release];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// success
    UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Paste successful! The URL has been added to your clipboard" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [resultAlert show];
    [resultAlert release];
    [activityIndicator stopAnimating];
    [activityIndicator release];
    
    [[UIPasteboard generalPasteboard] setString:[[response URL] absoluteString]];
	[[UIPasteboard generalPasteboard] setURL:[response URL]];
}

/* -- Camera -- */
- (void)cameraButtonPressed {
	vc = [[UIViewController alloc] init];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	window.rootViewController = vc;  
	window.windowLevel = UIWindowLevelAlert;
	[window makeKeyAndVisible]; 
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.mediaTypes               = [UIImagePickerController availableMediaTypesForSourceType:
                                                UIImagePickerControllerSourceTypeCamera];
        imagePicker.delegate                 = self;
        imagePicker.sourceType               =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing            = NO;
        [vc presentModalViewController:imagePicker
                              animated:YES];
        [imagePicker release];
    }
    else {
        UIAlertView *noCam = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This device does not have an LED flash" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCam show];
        [noCam release];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) 
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,  
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        NSString *tempFilePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath,
                                            self,
                                            @selector(video:finishedSavingWithError:contextInfo:),
                                            nil);
    }
    
    [vc dismissModalViewControllerAnimated:YES];
    [window release];
}


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void) video: (NSString *) videoPath
finishedSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save video"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[vc dismissModalViewControllerAnimated:YES];
	[window release];
}

- (void) smsButtonPressed {
    
    NSURL *smsURL = [NSURL URLWithString:@"sms:"];
    [[UIApplication sharedApplication] openURL:smsURL];
    
}

- (void) powerButtonPressed {
    
    UIAlertView *optionsView = [[UIAlertView alloc] initWithTitle:@"System"
                                                          message:nil delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Respring", @"Reboot", @"Shutdown", @"Safemode", nil];
    [optionsView show];
    [optionsView release];
    
    
    
}

- (void) faceBookButtonPressed {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    }
    else {
        UIAlertView *noFB = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This device does not have Facebook installed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noFB show];
        [noFB release];
    }
}


/*-------------------------------------------------------------------------------------------------*/


- (UIView *)view
{
	if (_view == nil)
	{
        _view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {page_width_f, [self viewHeight]}}];
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIImage *bg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/WeeAppBackground.png"];
        UIImage *stretchableBgImg = [bg stretchableImageWithLeftCapWidth:floorf(bg.size.width / 2.f) topCapHeight:floorf(bg.size.height / 2.f)];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:stretchableBgImg];
        bgView.frame = CGRectInset(_view.bounds, 2.f, 0.f);
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_view addSubview:bgView];
        
        NSString *path = [prefs_path stringByAppendingPathComponent:@"com.wundersoft.weetoolbox.plist"];
        
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:path];
        slot1 = [settingsDict objectForKey:@"slot1"];
        slot2 = [settingsDict objectForKey:@"slot2"];
        slot3 = [settingsDict objectForKey:@"slot3"];
        slot4 = [settingsDict objectForKey:@"slot4"];
        slot5 = [settingsDict objectForKey:@"slot5"];
        slot6 = [settingsDict objectForKey:@"slot6"];
        slot7 = [settingsDict objectForKey:@"slot7"];
        slot8 = [settingsDict objectForKey:@"slot8"];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (!fileExists || [settingsDict count] != 8) {
            
            system("cp /Library/WeeToolbox/Layouts/Default.plist /var/mobile/Library/Preferences/com.wundersoft.weetoolbox.plist");
            
            UIAlertView *config = [[UIAlertView alloc] initWithTitle:@"WeeToolbox First Run" 
                                                             message:@"Configuration complete.  A respring is required for this to take effect." delegate:self cancelButtonTitle:nil 
                                                   otherButtonTitles:@"Respring", nil];
            [config show];
            [config release];
        }
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (device.torchLevel == 1.0) torchIsOn = YES;
        
        else if (device.torchLevel == 0.0) torchIsOn = NO;
        
        wtb = [[WTButton alloc] init];
        
        UITapGestureRecognizer *twitterButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterButtonPressed)];
        UITapGestureRecognizer *instaCallButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(instaCallButtonPressed)];
        UITapGestureRecognizer *flashButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashButtonPressed)];
        UITapGestureRecognizer *pastieButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pastieButtonPressed)];
        UITapGestureRecognizer *cameraButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraButtonPressed)];
        UITapGestureRecognizer *smsButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smsButtonPressed)];
        UITapGestureRecognizer *powerButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(powerButtonPressed)];
        UITapGestureRecognizer *faceBookButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceBookButtonPressed)];
        
        bool allocSlot1 = YES;
        bool allocSlot2 = YES;
        bool allocSlot3 = YES;
        bool allocSlot4 = YES;
        bool allocSlot5 = YES;
        bool allocSlot6 = YES;
        bool allocSlot7 = YES;
        bool allocSlot8 = YES;
        
        NSLog(@"%i", [slot1 intValue]);
        
        NSLog(@"%@", settingsDict);
        
        switch ([slot1 intValue]) {
            case 1:
                NSLog(@"button 1 is 1");
                button1 = [wtb twitterButtonType];
                [button1 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button1 = [wtb facebookButtonType];
                [button1 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button1 = [wtb SMSButtonType];
                [button1 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button1 = [wtb phoneButtonType];
                [button1 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button1 = [wtb cameraButtonType];
                [button1 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button1 = [wtb torchButtonType];
                [button1 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button1 = [wtb pastieButtonType];
                [button1 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button1 = [wtb powerButtonType];
                [button1 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button1 = nil;
                NSLog(@"hhjggg");
                allocSlot1 = NO;
                break;
        }
        
        switch ([slot2 intValue]) {
            case 1:
                button2 = [wtb twitterButtonType];
                [button2 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button2 = [wtb facebookButtonType];
                [button2 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button2 = [wtb SMSButtonType];
                [button2 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button2 = [wtb phoneButtonType];
                [button2 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button2 = [wtb cameraButtonType];
                [button2 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button2 = [wtb torchButtonType];
                [button2 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button2 = [wtb pastieButtonType];
                [button2 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button2 = [wtb powerButtonType];
                [button2 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button2 = nil;
                allocSlot2 = NO;
                break;
        }
        
        switch ([slot3 intValue]) {
            case 1:
                button3 = [wtb twitterButtonType];
                [button3 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button3 = [wtb facebookButtonType];
                [button3 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button3 = [wtb SMSButtonType];
                [button3 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button3 = [wtb phoneButtonType];
                [button3 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button3 = [wtb cameraButtonType];
                [button3 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button3 = [wtb torchButtonType];
                [button3 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button3 = [wtb pastieButtonType];
                [button3 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button3 = [wtb powerButtonType];
                [button3 addGestureRecognizer:pastieButtonTap];
                break;
            default:
                button3 = nil;
                allocSlot3 = NO;
                break;
        }
        
        switch ([slot4 intValue]) {
            case 1:
                button4 = [wtb twitterButtonType];
                [button4 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button4 = [wtb facebookButtonType];
                [button4 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button4 = [wtb SMSButtonType];
                [button4 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button4 = [wtb phoneButtonType];
                [button4 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button4 = [wtb cameraButtonType];
                [button4 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button4 = [wtb torchButtonType];
                [button4 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button4 = [wtb pastieButtonType];
                [button4 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button4 = [wtb powerButtonType];
                [button4 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button4 = nil;
                allocSlot4 = NO;
                break;
        }
        
        switch ([slot5 intValue]) {
            case 1:
                button5 = [wtb twitterButtonType];
                [button5 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button5 = [wtb facebookButtonType];
                [button5 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button5 = [wtb SMSButtonType];
                [button5 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button5 = [wtb phoneButtonType];
                [button5 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button5 = [wtb cameraButtonType];
                [button5 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button5 = [wtb torchButtonType];
                [button5 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button5 = [wtb pastieButtonType];
                [button5 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button5 = [wtb powerButtonType];
                [button5 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button5 = nil;
                allocSlot5 = NO;
                break;
        }
        
        switch ([slot6 intValue]) {
            case 1:
                button6 = [wtb twitterButtonType];
                [button6 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button6 = [wtb facebookButtonType];
                [button6 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button6 = [wtb SMSButtonType];
                [button6 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button6 = [wtb phoneButtonType];
                [button6 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button6 = [wtb cameraButtonType];
                [button6 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button6 = [wtb torchButtonType];
                [button6 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button6 = [wtb pastieButtonType];
                [button6 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button6 = [wtb powerButtonType];
                [button6 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button6 = nil;
                allocSlot6 = NO;
                break;
        }
        
        switch ([slot7 intValue]) {
            case 1:
                button7 = [wtb twitterButtonType];
                [button7 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button7 = [wtb facebookButtonType];
                [button7 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button7 = [wtb SMSButtonType];
                [button7 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button7 = [wtb phoneButtonType];
                [button7 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button7 = [wtb cameraButtonType];
                [button7 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button7 = [wtb torchButtonType];
                [button7 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button7 = [wtb pastieButtonType];
                [button7 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button7 = [wtb powerButtonType];
                [button7 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button7 = nil;
                allocSlot7 = NO;
                break;
        }
        
        switch ([slot8 intValue]) {
            case 1:
                button8 = [wtb twitterButtonType];
                [button8 addGestureRecognizer:twitterButtonTap];
                break;
            case 2:
                button8 = [wtb facebookButtonType];
                [button8 addGestureRecognizer:faceBookButtonTap];
                break;
            case 3:
                button8 = [wtb SMSButtonType];
                [button8 addGestureRecognizer:smsButtonTap];
                break;
            case 4:
                button8 = [wtb phoneButtonType];
                [button8 addGestureRecognizer:instaCallButtonTap];
                break;
            case 5:
                button8 = [wtb cameraButtonType];
                [button8 addGestureRecognizer:cameraButtonTap];
                break;
            case 6:
                button8 = [wtb torchButtonType];
                [button8 addGestureRecognizer:flashButtonTap];
                break;
            case 7:
                button8 = [wtb pastieButtonType];
                [button8 addGestureRecognizer:pastieButtonTap];
                break;
            case 8:
                button8 = [wtb powerButtonType];
                [button8 addGestureRecognizer:powerButtonTap];
                break;
            default:
                button8 = nil;
                allocSlot8 = NO;
                break;
        }
        
        scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0,0,_view.bounds.size.width,_view.bounds.size.height);
        
        if (!allocSlot6 && !allocSlot7 && !allocSlot8)
            scrollView.contentSize = CGSizeMake(_view.bounds.size.width, _view.bounds.size.height);
        else
            scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width*2, _view.bounds.size.height);
        
        scrollView.pagingEnabled = YES;
        scrollView.scrollsToTop = NO;
        [scrollView setClipsToBounds:NO];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_view addSubview:scrollView];
        
        [button1 setUserInteractionEnabled:YES];
        [button2 setUserInteractionEnabled:YES];
        [button3 setUserInteractionEnabled:YES];
        [button4 setUserInteractionEnabled:YES];
        [button5 setUserInteractionEnabled:YES];
        [button6 setUserInteractionEnabled:YES];
        [button7 setUserInteractionEnabled:YES];
        [button8 setUserInteractionEnabled:YES];
        
        button1.frame = [WTButtonFrame frame1];
        button2.frame = [WTButtonFrame frame2];
        button3.frame = [WTButtonFrame frame3];
        button4.frame = [WTButtonFrame frame4];
        button5.frame = [WTButtonFrame frame5];
        button6.frame = [WTButtonFrame frame6];
        button7.frame = [WTButtonFrame frame7];
        button8.frame = [WTButtonFrame frame8];
        
        if (allocSlot1){ [scrollView addSubview:button1]; NSLog(@"b1 alloc'd"); }
        if (allocSlot2) [scrollView addSubview:button2];
        if (allocSlot3) [scrollView addSubview:button3];
        if (allocSlot4) [scrollView addSubview:button4];
        if (allocSlot5) [scrollView addSubview:button5];
        if (allocSlot6) [scrollView addSubview:button6];
        if (allocSlot7) [scrollView addSubview:button7];
        if (allocSlot8) [scrollView addSubview:button8];
        
	}
	return _view;
}

- (float)viewHeight
{
	return 42.0f;
}

@end