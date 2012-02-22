#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol BBWeeAppController <NSObject, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ABPeoplePickerNavigationControllerDelegate, UIGestureRecognizerDelegate>
@required
- (id)view;
@optional
- (void)loadPlaceholderView;
- (void)loadFullView;
- (void)loadView;
- (void)unloadView;
- (void)clearShapshotImage;
- (id)launchURL;
- (id)launchURLForTapLocation:(CGPoint)tapLocation;
- (float)viewHeight;
- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;
- (void)willAnimateRotationToInterfaceOrientation:(int)interfaceOrientation;
- (void)willRotateToInterfaceOrientation:(int)interfaceOrientation;
- (void)didRotateFromInterfaceOrientation:(int)interfaceOrientation;

// new methods
- (void)twitterButtonPressed;
- (void)instaCallButtonPressed;
- (void)flashButtonPressed;
- (void)pastieButtonPressed;
- (void)cameraButtonPressed;
- (void)instaCallButtonPressed;
@end
