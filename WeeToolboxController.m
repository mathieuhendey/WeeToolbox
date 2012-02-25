#import "BBWeeAppController-Protocol.h"
#import <Twitter/Twitter.h>
#import <AVFoundation/AVfoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define kHeaderBoundary @"_wundersoft_weetoolbox_paste_"

static NSBundle *_WeeToolboxWeeAppBundle = nil;

@interface WeeToolboxController: NSObject <BBWeeAppController> {
	UIView *_view;
	UIImageView *_backgroundView;
    
    UIViewController *vc;	//UIViewController to be used for displaying modal views.
	UIWindow *window; //UIWindow for which the viewController will be set to vc.
    
	ABPeoplePickerNavigationController *pp;
    
	UIImageView *twitterButton;
	UIImageView *instaCallButton;
	UIImageView *flashButton;
	UIImageView *pastieButton;
	UIImageView *cameraButton;

  UIActivityIndicatorView *activityIndicator;
    
	bool torchIsOn;
}
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) ABPeoplePickerNavigationController *pp;
@end

@implementation WeeToolboxController
@synthesize view = _view;
@synthesize pp;

/*--------------------- Leave this stuff alone ----------------------*/
+ (void)initialize {
	_WeeToolboxWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init {
	if((self = [super init]) != nil) {
		
	} return self;
}

- (void)dealloc {
	[_view release];
	[_backgroundView release];
	[super dealloc];
}
/*----------------------------------------------------------------------------*/

#pragma mark - custom methods

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
        UIAlertView *noPhone = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This device does not have telephone capabilities." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    else {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Call"])
        {
            NSString *phoneNumber = [alertView textFieldAtIndex:0].text;
            if ([[phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] != 0)
                [self makeCallWithNumber:phoneNumber]; // make the call 
            
        }
    }
}

/* -- LED Flash -- */
- (void)flashButtonPressed {
	//Working
    
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
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *string = pasteboard.string;
    
    if (string == nil) { // we dont want to send a nil value!
        UIAlertView *derp = [[UIAlertView alloc] initWithTitle:@"No clipboard contents." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
	UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Result:" message:@"Paste failed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [activityIndicator stopAnimating];
    [activityIndicator release];
    [resultAlert show];
    [resultAlert release];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
    NSURLResponse *pasteURL = [response URL];
    if ([[pasteURL absoluteString] isEqualToString:@"http://pastie.org/pastes"]) {
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Result:" message:@"Unable to connect to Pastie services! They may be experiencing some downtime, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [resultAlert show];
        [resultAlert release];
        [activityIndicator stopAnimating];
        [activityIndicator release];
    }
    else {
        // success
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Result:" message:@"Paste successful! The URL has been added to your clipboard." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [resultAlert show];
        [resultAlert release];
        [activityIndicator stopAnimating];
        [activityIndicator release];
        
        [[UIPasteboard generalPasteboard] setString:[pasteURL absoluteString]];
        [[UIPasteboard generalPasteboard] setURL:pasteURL];
    }
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
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        [vc presentModalViewController:imagePicker
                              animated:YES];
        [imagePicker release];
    }
    else {
        UIAlertView *noCam = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This device does not have an LED flash." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCam show];
        [noCam release];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [vc dismissModalViewControllerAnimated:YES];
    UIImage *image = [info
                      objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,  
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[vc dismissModalViewControllerAnimated:YES];
	[window release];
}

/*----------------------------------------------------------------------------*/

#pragma mark - view configuration
- (void)loadFullView {
	// Add subviews to _backgroundView (or _view) here.
    
    torchIsOn = NO;
    
    twitterButton   = [[UIImageView alloc] init];
    instaCallButton = [[UIImageView alloc] init];
    flashButton     = [[UIImageView alloc] init];
    pastieButton    = [[UIImageView alloc] init];
    cameraButton    = [[UIImageView alloc] init];
    
    twitterButton.frame   = CGRectMake(((_view.bounds.size.width / 2) - 155),4,42,42);
    instaCallButton.frame = CGRectMake(((_view.bounds.size.width / 2) - 88),4,42,42);
    flashButton.frame     = CGRectMake(((_view.bounds.size.width / 2) - 21),4,42,42);
    pastieButton.frame    = CGRectMake(((_view.bounds.size.width / 2) + 50),4,42,42);
    cameraButton.frame    = CGRectMake(((_view.bounds.size.width / 2) + 113),4,42,42);
    
    [twitterButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/twitter.png"]];  //sets image for button.
    [instaCallButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/phone.png"]];  // "" ""
    [flashButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/flashoff.png"]];    // "" ""
    [pastieButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/pastie.png"]];    // "" ""
    [cameraButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeToolbox.bundle/camera.png"]];    // "" ""
    
    [twitterButton setUserInteractionEnabled:YES];
    [instaCallButton setUserInteractionEnabled:YES];
    [flashButton setUserInteractionEnabled:YES];
    [pastieButton setUserInteractionEnabled:YES];
    [cameraButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* twitterButtonTap   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterButtonPressed)];
    UITapGestureRecognizer* instaCallButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(instaCallButtonPressed)];
    UITapGestureRecognizer* flashButtonTap     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flashButtonPressed)];
    UITapGestureRecognizer* pastieButtonTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pastieButtonPressed)];
    UITapGestureRecognizer* cameraButtonTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraButtonPressed)];
    
    [twitterButton addGestureRecognizer:twitterButtonTap];    //adds gesture recognizers.
    [instaCallButton addGestureRecognizer:instaCallButtonTap]; // "" ""
    [flashButton addGestureRecognizer:flashButtonTap];        // "" ""
    [pastieButton addGestureRecognizer:pastieButtonTap];      // "" ""
    [cameraButton addGestureRecognizer:cameraButtonTap];      // "" ""
    
    [_view addSubview: twitterButton];  //add button to _view.
    [_view addSubview: instaCallButton];  // "" ""
    [_view addSubview: flashButton];  // "" ""
    [_view addSubview: pastieButton]; // "" ""
    [_view addSubview: cameraButton]; // "" ""
}

- (void)loadPlaceholderView {
	// This should only be a placeholder - it should not connect to any servers or perform any intense
	// data loading operations.
	//
	// All widgets are 316 points wide. Image size calculations match those of the Stocks widget.
	_view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {316.f, [self viewHeight]}}];
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UIImage *bgImg                   = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
    UIImage *stretchableBgImg        = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
    _backgroundView                  = [[UIImageView alloc] initWithImage:stretchableBgImg];
    _backgroundView.frame            = CGRectInset(_view.bounds, 2.f, 0.f);
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_view addSubview:_backgroundView];
}

- (void)unloadView {
	[_view release];
	_view = nil;
	[_backgroundView release];
	_backgroundView = nil;
	// Destroy any additional subviews you added here. Don't waste memory :(.
    
    [twitterButton release];
    twitterButton   = nil;
    [instaCallButton release];
    instaCallButton = nil;
    [flashButton release];
    flashButton     = nil;
    [pastieButton release];
    pastieButton    = nil;
    [cameraButton release];
    cameraButton    = nil;
}

- (float)viewHeight {
	// return 71.f;
    return 50.f;
}

@end
