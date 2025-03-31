// METEORA: iOS 9 LS FOR iOS 10
// ----------------------------
// Created by iKilledAppl3 and Skittyblock
// Updated with Notifications Support by Sleep
//
// Special thank you to: Minh Ton and his tweak NineLS on iOS 13.
// His very clean code was used as a reference when needed
// ----------------------------

#import "Headers.h"

static BOOL kEnabled;
static BOOL kDoubleTap;
static BOOL kRemoveChevron;
static BOOL kRemoveMediaPlayerBlur;
static BOOL kCustomSliderText;
static NSString *kCustomText;

#define kTouchIDFingerUp    0
#define kTouchIDFingerDown  1
#define kTouchIDFingerHeld  2
#define kTouchIDMatched     3
#define kTouchIDSuccess     4
#define kTouchIDDisabled    6
#define kTouchIDNotMatched 10

static NSString *noAlbumImagePath = @"/Library/Application Support/Meteora/noalbumart.png";

UITapGestureRecognizer *lockTapGesture;
UIView *mediaControls;
UIView *artworkView;
UIBlurEffect *mediaEffect;
UIVisualEffectView *mediaVisualEffect;
UIView *blurView;
UIVisualEffectView *blurEffect;
UIImageView* _artworkImageView;
UIImageView *grabberIconImageView;
UIView *notifsView = nil;
UIView *_foregroundLockView = nil;
CGRect artworkFrame;
SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
SBUILegibilityLabel *timeLabel;

UIScreenEdgePanGestureRecognizer *ncSwipeGesture;
UIScreenEdgePanGestureRecognizer *ccPanGesture;

// ----- Notifications -----
// -------------------------

// static BBServer *_bbServer = nil;
static SBLockScreenNotificationListController *_meteoraNotificationListController = nil;

@implementation MTONotificationsView
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self) {
    self.userInteractionEnabled = YES;
    _meteoraNotificationListController = [[%c(SBLockScreenNotificationListController) alloc] init];
    _meteoraNotificationListController.view.frame = frame;
    [self addSubview:_meteoraNotificationListController.view];
  }
  return self;
}
- (void)dealloc {
  if (_meteoraNotificationListController) {
    [_meteoraNotificationListController release];
    _meteoraNotificationListController = nil;
  }
  [super dealloc];
}
// - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//     UIView *hitView = [super hitTest:point withEvent:event];

//     // If the touch is on a notification cell, handle it normally
//     // if ([hitView isDescendantOfView:self]) {
//     //     return hitView;
//     // }
//     if ([self isNotificationCell:hitView]) {
//         return hitView;
//     }

//     if ([event.allTouches.anyObject gestureRecognizers]) {
//         return nil;
//     }

//     // Otherwise, pass the touch through to the views behind it
//     return nil;
// }

// TODO passthrough the tap
- (UIView *)isNotificationCell:(UIView *)view {
    while (view) {
        if (([view isKindOfClass:%c(SBLockScreenNotificationTableView)] ||
            [view isKindOfClass:%c(SBLockScreenNotificationCell)])) {
            return view;
        }
        view = view.superview;
    }
    return nil;
}
@end

%hook BBServer
// - (id)initWithQueue:(id)arg1 {
//   _bbServer = [%orig retain];
//   return _bbServer;
// }

- (void)dealloc {
  // if (_bbServer == self) _bbServer = nil;
  %orig;
}

- (void)publishBulletinRequest:(id)arg1 destinations:(unsigned long long)arg2 alwaysToLockScreen:(BOOL)arg3 {
  BOOL isScreenLocked = ([[%c(SBLockStateAggregator) sharedInstance] lockState] != 0);

  // Send notification to Meteora LockScreen Controller
  if (isScreenLocked && kEnabled) {
    BBBulletin *bulletin = [[%c(BBBulletin) alloc] init];
    bulletin.title = [arg1 title];
    bulletin.message = [arg1 message];
    bulletin.subtitle = [arg1 message];

    bulletin.sectionID = [arg1 sectionID];
    bulletin.recordID = [arg1 recordID];
    bulletin.publisherBulletinID = [arg1 publisherBulletinID];

    bulletin.date = [arg1 date];
    bulletin.publicationDate = [arg1 date];
    bulletin.lastInterruptDate = [arg1 date];

    bulletin.showsMessagePreview = YES;
    [bulletin setClearable:YES];
    // bulletin.clearable = YES;
    // [bulletin setDefaultAction:[BBAction action]];
    [bulletin setDefaultAction:[%c(BBAction) actionWithLaunchBundleID:bulletin.sectionID callblock:nil]];
    [bulletin setBulletinID:[arg1 bulletinID]];

    // NSMutableArray *buttons = [NSMutableArray array];

    // BBAction *reqaction = [arg1 valueForKey:@"defaultAction"];
    // if (reqaction) { // Thank you, Coolstar
    //   [buttons addObject:@{@"title":@"Open", @"action":reqaction, @"response":@NO}];
    // }
    // for (BBAction *action in [bulletin supplementaryActions]){
		// 	if ([action hasPluginAction])
		// 		continue;
		// 	if ([action hasRemoteViewAction])
		// 		continue;

		// 	NSNumber *response = @NO;
		// 	// if (action.behavior == UIUserNotificationActionBehaviorTextInput)
		// 	// 	response = @YES;
		// 	// else {
		// 	// 	if (action.activationMode == UIUserNotificationActivationModeBackground)
		// 	// 		continue;
		// 	// }
		// 	if (action.appearance.title != nil && action != nil && response != nil){
		// 		[buttons addObject:@{@"title":action.appearance.title, @"action":action, @"response":response}];
		// 	}
		// }
    // NSMutableDictionary *actions = [[NSMutableDictionary alloc] init];
    
    // BBAction *openAction = [BBAction actionWithLaunchBundleID:[arg1 sectionID] callblock:nil];
    // [openAction setIdentifier:@"openAction"];

    // NSMutableDictionary *actions = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                             @"Action 1", @"action1Key",
    //                             @"Action 2", @"action2Key",
    //                             nil];
    // [actions setObject:openAction forKey:@"openActionKey"];

    // [bulletin setActions:actions];

    if (_meteoraNotificationListController) {
      BBObserver *observer = [_meteoraNotificationListController valueForKey:@"observer"];
      [_meteoraNotificationListController observer:observer addBulletin:bulletin forFeed:4 playLightsAndSirens:YES withReply:nil];
    }

    // SBLockScreenActionContext *bbcontext = [[%c(SBLockScreenActionContext) alloc] init];
    // [bbcontext setBulletin:bulletin];
    // [_meteoraNotificationListController setLockScreenActionContext:bbcontext];

    // Now do original action but send to just LS+NC. This prevents a duplicate banner from appearing on unlocking.
    // ...Of course sending to the original LS goes nowhere, but it's still needed to make sure notification sounds plays when locked.
    %orig(arg1, 7, arg3); 
    [bulletin release];
  } else { 
    %orig;
  }
}
%end

%hook SBLockScreenNotificationListController
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(/*^block*/id)arg5 {
  %orig;
}
- (void)dealloc {
  %orig;
}
%end

// Blur LS
%hook SBLockScreenNotificationListView
- (void)updateForAdditionOfItemAtIndex:(unsigned long long)arg1 allowHighlightOnInsert:(BOOL)arg2 {
  %orig;

  // Check if exists
  for(UIView *view in self.superview.superview.superview.superview.subviews) {
    if(view.tag == 167) {
      return;
    }
  }

  // Create blur view
  blurView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  blurView.backgroundColor = [UIColor clearColor];
  blurView.alpha = 0;
  blurView.tag = 167;

  blurEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
  blurEffect.frame = blurView.bounds;
  [blurView addSubview:blurEffect];

  [self.superview.superview.superview.superview addSubview:blurView];
  [self.superview.superview.superview.superview sendSubviewToBack:blurView];

  [UIView animateWithDuration:0.4 animations:^(void) {
    blurView.alpha = 1;
  } completion:nil];
}
-(long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2 {
  // Deallocate blurView/Effect if not in use to save memory
  long long count = %orig;
  if (count == 0) {
    if (blurView) {
      [blurView removeFromSuperview];
      [blurView release];
      blurView = nil;
    }
    if (blurEffect) {
      [blurEffect release];
      blurEffect = nil;
    }
  }
  return count;
}
%end

// ----- Disable iOS 10 LS -----
// -----------------------------

%hook SBLockScreenDefaults
- (void)setUseDashBoard:(BOOL)arg1 {
  if (kEnabled) {
    %orig(NO);	  
  } else {
    %orig;
  }
}

- (BOOL)useDashBoard {
  if (kEnabled) {
    return FALSE;
  } else {
    return %orig;   
  }  
}

- (void)_bindAndRegisterDefaults {
  %orig;
  if (kEnabled) {
    [self performSelector:@selector(setUseDashBoard:)];
  }
}     
%end

// ----- Main LS Hook -----
// ------------------------
%hook SBLockScreenView 
-(void)setSlideToUnlockHidden:(BOOL)arg1 forRequester:(id)arg2 {
  if (kEnabled) {
    %orig(NO, arg2);
  } else {
    %orig;
  }
}

- (void)setSlideToUnlockBlurHidden:(BOOL)arg1 forRequester:(id)arg2 {
  if (kEnabled) {
    %orig(NO, arg2);
  } else {
    %orig;
  }
}

// Detect when the gesture recognizer for sliding to the right is added, and don't add it.
// This is necessary so it doesn't conflict with notification actions.
// - (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
//     if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
//         UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)gestureRecognizer;
//         if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft && kEnabled) {
//             return; // Prevent the gesture from being added
//         }
//     }
//     %orig;
// }

// - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//     UIView *hitView = [super hitTest:point withEvent:event];

//     // If the touch is on a notification cell, handle it normally
//     // if ([hitView isDescendantOfView:self]) {
//     //     return hitView;
//     // }
//     if ([self isNotificationCell:hitView]) {
//         return hitView;
//     }

//     if ([event.allTouches.anyObject gestureRecognizers]) {
//         return nil;
//     }

//     // Otherwise, pass the touch through to the views behind it
//     return nil;
// }

// -(BOOL)presentingController:(id)arg1 gestureRecognizer:(id)arg2 shouldReceiveTouch:(id)arg3 {
//   if (([_meteoraNotificationListController _firstBulletin] != nil) && notifsView) {
//     UITouch *touch = (UITouch *)arg3;
//     UIView *hitView = touch.view;

//     UIView *_bulletinListView = MSHookIvar<UIView*>(_meteoraNotificationListController, "_notificationView");
//     CGPoint touchPoint = [touch locationInView:_bulletinListView];

//     // Traverse up the hierarchy to check if the touch is within MTONotificationsView
//     UIView *currentView = hitView;
//     BOOL isInsideNotificationsView = NO;

//     while (currentView) {
//         if ([currentView isKindOfClass:%c(SBLockScreenBulletinCell)]) {
//             isInsideNotificationsView = YES;
//             break;
//         }
//         currentView = currentView.superview;
//     }

//     if (isInsideNotificationsView) {
//         NSLog(@"SLEEPDEBUG: Allowing gesture for notifications");
//         return NO;
//     }

//     if (CGRectContainsPoint(_bulletinListView.bounds, touchPoint)) {
//         NSLog(@"SLEEPDEBUG: Denying gesture outside notification interactions");
//         return NO;
//     }

//     // if (
//     //   ![hitView isKindOfClass:%c(MTONotificationsView)] &&
//     //   CGRectContainsPoint(_bulletinListView.bounds, touchPoint)
//     // ) {
//     //   NSLog(@"SLEEPDEBUG Denying gesture");
//     //   return NO;
//     // }

//     // if ([hitView isKindOfClass:%c(MTONotificationsView)]) { // found
//     //     UIGestureRecognizer *gesture = (UIGestureRecognizer *)arg2;
//     //     UIView *gestureView = gesture.view;
//     //     while (gestureView) {
//     //         if ([gestureView isKindOfClass:%c(MTONotificationsView)]) {
//     //             NSLog(@"SLEEPDEBUG: Forwarding gesture to %@", arg2);
//     //             return YES; // Allow gesture on notifications
//     //         }
//     //         gestureView = gestureView.superview;
//     //     }
//     //     return NO; // Prevent this gesture recognizer from blocking notification gesture
//     // }
//     NSLog(@"SLEEPDEBUG Returning YES");
//     return YES;
//   }
//   NSLog(@"SLEEPDEBUG Doing nothing");
//   return %orig;
// }

// - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//   // UIView *hitView = [self hitTest:point withEvent:event];
//   if (CGRectContainsPoint(_foregroundLockView.bounds, point)) {
//       // We are inside the bounds of _foregroundLockView, now check if it's the MTONotificationsView
//       // UIView *notifsView = nil;
//       // UITableView *tableView = [_meteoraNotificationListController.view valueForKey:@"_tableView"];

//       // if (([_meteoraNotificationListController _firstBulletin] != nil) 
//       // && notifsView 
//       // && CGRectContainsPoint(tableView.frame, point)) {
//       //   return tableView;
//       // }

//       // for (UIView *subview in _foregroundLockView.subviews) {
//       //     if ([subview isKindOfClass:[MTONotificationsView class]]) {
//       //         for (UIView *mtosubview in subview.subviews) {
//       //           if (([_meteoraNotificationListController _firstBulletin] != nil) && notifsView && CGRectContainsPoint(notifsView.frame, point)) {
//       //               return subview;  // Forward the touch event to MTONotificationsView
//       //           }
//       //         }
//       //     }
//       // }

//       if (([_meteoraNotificationListController _firstBulletin] != nil) && notifsView) { // 
//           // UITableViewWrapperView *wrapperView = [tableView valueForKey:@"_wrapperView"];
          
//           // Check if the touch is within the bounds of the cell and return it
//           // if (CGRectContainsPoint(cell.frame, point)) {
//           //     return cell;  // Forward touch to the correct cell
//           // }
//           // if (CGRectContainsPoint(tableView.frame, point)) {
//           //     NSLog(@"SLEEPDEBUG sending touch to %@", tableView);
//           //     return tableView;  // Forward touch to SBLockScreenBulletinCell
//           // }
//           // for (UIView *subview in wrapperView.subviews) {
//           //     NSLog(@"SLEEPDEBUG checking subview %@", subview);
//           //     if (CGRectContainsPoint(subview.frame, point)) {
//           //         NSLog(@"SLEEPDEBUG sending touch to %@", subview);
//           //         return subview;  // Forward touch to SBLockScreenBulletinCell
//           //     }
//           //     // if ([subview isKindOfClass:NSClassFromString(@"UITableViewCell")]) {
//           //     //     // Check if the touch is inside the bounds of the SBLockScreenBulletinCell
//           //     //     if (CGRectContainsPoint(subview.frame, point)) {
//           //     //         NSLog(@"SLEEPDEBUG sending touch to %@", subview);
//           //     //         return subview;  // Forward touch to SBLockScreenBulletinCell
//           //     //     }
//           //     // }
//           // }
//           // UITableView *tableView = [_meteoraNotificationListController.view valueForKey:@"_tableView"];
          
//           // for (UIView *subview in tableView.subviews) {

//           // }
//           UIView *hitView = [notifsView hitTest:point withEvent:event];
//           // if ([hitView isDescendantOfView:notifsView]) {
//           //     return hitView;
//           // }
//           if (hitView) {
//             // BOOL isNotificationCell = (
//             //   // [hitView isKindOfClass:%c(SBLockScreenNotificationTableView)] ||
//             //   [hitView isKindOfClass:%c(UIView)] && [hitView.superview isKindOfClass:%c(SBLockScreenNotificationScrollView)]
//             // );
//             UIView *superview = hitView.superview;
                
//             // Traverse hierarchy to find a valid notification cell or scroll view
//             while (superview && ![superview isKindOfClass:%c(MTONotificationsView)]) {
//                 superview = superview.superview;
//             }

//             if (superview) {
//               NSLog(@"SLEEPDEBUG Touched view: %@", NSStringFromClass([hitView class]));
//               NSLog(@"SLEEPDEBUG Found superview: %@", NSStringFromClass([superview class]));
//               return superview;
//             }
            
//             // if (isNotificationCell) {
//             //     NSLog(@"SLEEPDEBUG SENDING to NotificationScrollView");
//             //     return hitView.superview;
//             // }
//           } 
//       }
//   }
//   return %orig;
// }

// %new
// - (BOOL)isNotificationCell:(UIView *)view {
//     while (view) {
//         if (([view isKindOfClass:%c(SBLockScreenNotificationTableView)] ||
//             [view isKindOfClass:%c(SBLockScreenNotificationCell)])
//             &&
//             ([_meteoraNotificationListController _firstBulletin] != nil)
//             ) {
//             return YES;
//         }
//         view = view.superview;
//     }
//     return NO;
// }

- (void)layoutSubviews {
  %orig;

  if (kEnabled) {
    // Grabbers
    SBUIChevronView *topGrabberView = [self valueForKey:@"_topGrabberView"];
    topGrabberView.alpha = 1;
    topGrabberView.hidden = NO;
    topGrabberView.userInteractionEnabled = YES;
    [self addSubview:topGrabberView];
    [self sendSubviewToBack:topGrabberView];

    if (kRemoveChevron || mediaController.isPlaying) {
      topGrabberView.hidden = YES;
    }
    
    SBUIChevronView *bottomGrabberView = [self valueForKey:@"_bottomGrabberView"];
    bottomGrabberView.alpha = 1;
    bottomGrabberView.hidden = NO;
    [self addSubview:bottomGrabberView];
    [self sendSubviewToBack:bottomGrabberView];
    
    if (kRemoveChevron) {
      bottomGrabberView.hidden = YES;
    }
	
    // Vibrancy bug fix
    SBWallpaperEffectView *slideToUnlockBackgroundView = [self valueForKey:@"_slideToUnlockBackgroundView"];
    slideToUnlockBackgroundView.alpha = 0;

    // TODO: Make these gestures track motion, and not just a simple presentAnimated when recognized
	
    // NC Gesture
    if (!ncSwipeGesture) {
      ncSwipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ncSwipeGestureAction)];
      ncSwipeGesture.edges = UIRectEdgeTop;
      [[%c(FBSystemGestureManager) sharedInstance] addGestureRecognizer:ncSwipeGesture toDisplay:[%c(FBDisplayManager) mainDisplay]];
    }
    
    // CC Gesture
    if (!ccPanGesture) {
      ccPanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ccPanGestureAction)];
      ccPanGesture.edges = UIRectEdgeBottom;
      [self addGestureRecognizer:ccPanGesture];
    }
    
    // 2 Finger Tap Gesture
    if (kDoubleTap == YES) {
      if (!lockTapGesture) {
        lockTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapLockAction)];
        lockTapGesture.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:lockTapGesture];
      }
    }

    _foregroundLockView = MSHookIvar<UIView*>(self, "_foregroundLockView");
    _foregroundLockView.exclusiveTouch = NO;
    _foregroundLockView.userInteractionEnabled = YES;

    for(UIView *notifView in _foregroundLockView.subviews) {
      if([notifView class] == NSClassFromString(@"MTONotificationsView")) {
	      return;
      }
    }

    if (mediaController.isPlaying) { // ???
      [mediaControls removeFromSuperview];
    }

    // Add MTONotificationsView
    if (!_meteoraNotificationListController) {
      notifsView = [[%c(MTONotificationsView) alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      notifsView.exclusiveTouch = NO;
      notifsView.userInteractionEnabled = YES;
    }
    
    // UIView *_foregroundView = MSHookIvar<UIView*>(self, "_foregroundView");
    // _foregroundView.exclusiveTouch = NO;
    // _foregroundView.userInteractionEnabled = YES;
    [_foregroundLockView addSubview:notifsView];
  }
}

// -(BOOL)presentingController:(id)arg1 gestureRecognizer:(id)arg2 shouldReceiveTouch:(id)arg3 {
//   // NSLog(@"SDBG [SBLockScreenView] Gesture detected: %@", arg2);
//   return %orig;
// }

// // Disable slide to left gesture
// - (void)presentingController:(id)arg1 willHandleGesture:(id)arg2 {
//   // ----- debug -----
//   // NSLog(@"SDBG [SBLockScreenView] Gesture detected: %@", arg2);
//   // NSLog(@"SDBG Gesture class: %@", NSStringFromClass([arg2 class]));
//   // NSLog(@"SDBG Gesture state: %ld", (long)arg2.state);
//   // NSLog(@"SDBG Gesture location: %@", NSStringFromCGPoint([arg2 locationInView:self]));
  
//   // if ([arg2 isKindOfClass:[UISwipeGestureRecognizer class]]) {
//   //     UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)arg2;
//   //     NSLog(@"SDBG Swipe direction: %lu", (unsigned long)swipeGesture.direction);
      
//   //     if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
//   //         NSLog(@"SDBG Detected a left swipe!");
//   //     }
//   // }
//   // -----------------
//   %orig;
// }

// 2 FINGER TAP GESTURE
%new
-(void)doubleTapLockAction {
  [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress];
}

// SHOW NOTIFICATION CENTER
%new
-(void)ncSwipeGestureAction {
  [[%c(SBNotificationCenterController) sharedInstance] presentAnimated:YES];
}

// SHOW CONTROL CENTER
%new
-(void)ccPanGestureAction {
  [[%c(SBControlCenterController) sharedInstance] presentAnimated:YES];
}

// LOCKSCREEN MEDIA CONTROLS
-(void)_layoutMediaControlsView { 
  if (kEnabled && mediaController.isPlaying) {
    UIView *_foregroundLockView = MSHookIvar<UIView*>(self, "_foregroundLockView");
    for (UIView* sub in _foregroundLockView.subviews) {
      if ([sub class] == NSClassFromString(@"MTOMediaView")) {
	      return;
      }
    }
    
    int deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (deviceHeight) {
      case 736: // iPhone 5.5in
        mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-20,  200)];
        [_foregroundLockView addSubview:mediaControls];
        mediaControls.userInteractionEnabled = YES;
        break;
            
      case 667:  // iPhone 4.7in
        mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-20,  200)];
        [_foregroundLockView addSubview:mediaControls];
        mediaControls.userInteractionEnabled = YES;
        break;
            
      case 568: // iPhone 4in
        mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5.5, 10, 300, 200)];
        [_foregroundLockView addSubview:mediaControls];
        mediaControls.userInteractionEnabled = YES;
        break;
            
      default: // iPad
        mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5.5, 10, 300, 200)];
        [_foregroundLockView addSubview:mediaControls];
        mediaControls.userInteractionEnabled = YES;
        break;
    }
    if (kRemoveMediaPlayerBlur) {
      mediaVisualEffect = nil;
    } else {
      mediaEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
      mediaVisualEffect = [[UIVisualEffectView alloc] initWithEffect:mediaEffect];
      mediaVisualEffect.frame = [[UIScreen mainScreen] bounds];
      [self addSubview:mediaVisualEffect];
      [self sendSubviewToBack:mediaVisualEffect];
    }
  }
  if (!mediaController.isPlaying) {
    // Deallocate effects to save memory
    if (mediaEffect) {
      [mediaEffect release];
      mediaEffect = nil;
    }
    if (mediaVisualEffect) {
      [mediaVisualEffect release];
      mediaVisualEffect = nil;
    }
  }
}

// LAYOUT MEDIA CONTROLS
-(void)setMediaControlsView:(id)arg1 {
  if (kEnabled && mediaController.isPlaying) {
    [self _layoutMediaControlsView];
  } else if (kEnabled && mediaController.isPaused && !kRemoveMediaPlayerBlur) {
    [mediaControls removeFromSuperview];
    [mediaVisualEffect removeFromSuperview];
  } else if (kEnabled && mediaController.isPaused && kRemoveMediaPlayerBlur) {
    [mediaControls removeFromSuperview];
  } else {
    %orig;
  }
}

- (void)dealloc {
 %orig;
 if (_meteoraNotificationListController) {
  // NSLog(@"SLEEPDEBUG Removing _mNLC");
  // [_meteoraNotificationListController removeFromSuperview];
  [_meteoraNotificationListController release];
  _meteoraNotificationListController = nil;
 }

 if (ccPanGesture) {
  // NSLog(@"SLEEPDEBUG Removing ccPan");
  [self removeGestureRecognizer:ccPanGesture];
  [ccPanGesture release];
  ccPanGesture = nil;
 }

 if (ncSwipeGesture) {
  // NSLog(@"SLEEPDEBUG Removing ncSwipe");
  [self removeGestureRecognizer:ncSwipeGesture];
  [ncSwipeGesture release];
  ncSwipeGesture = nil;
 }

  if (lockTapGesture) {
    // NSLog(@"SLEEPDEBUG Removing lockTap");
    [self removeGestureRecognizer:lockTapGesture];
    [lockTapGesture release];
    lockTapGesture = nil;
  }

 if (mediaControls) {
    // NSLog(@"SLEEPDEBUG Removing mediaC");
    [mediaControls removeFromSuperview];
    [mediaControls release];
    mediaControls = nil;
  }
  if (mediaVisualEffect) {
    // NSLog(@"SLEEPDEBUG Removing mediaVis");
    [mediaVisualEffect removeFromSuperview];
    [mediaVisualEffect release];
    mediaVisualEffect = nil;
  }
  if (_foregroundLockView) { 
    // [_foregroundLockView release];
    // NSLog(@"SLEEPDEBUG fLV = nil");
    _foregroundLockView = nil;
  }
}
%end

// %hook SBLockScreenViewController
// -(BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2 {
//   UIGestureRecognizer *otherGestureRecognizer = (UIGestureRecognizer *) arg2;
//   if ([otherGestureRecognizer.view isKindOfClass:%c(SBLockScreenNotificationScrollView)]) {
//     NSLog(@"SLEEPDEBUG: Allowing simultaneous gestures for %@", arg2);
//     return YES;
//   } else {
//     NSLog(@"SLEEPDEBUG: Did not detect notification gesture");
//     return %orig;
//   }
// }
// %end

// ----- ????? -----
// -----------------

%hook SBControlCenterController
-(void)setUILocked:(BOOL)arg1 {
	if(kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
    %orig(YES);
	}
	
	else {
    %orig(arg1);	
	}
}
%end
	
// VOLUME CONTROL
%hook VolumeControl
-(void)increaseVolume {
  %orig;

  if (kEnabled && mediaController.isPlaying && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
  [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.0];
  }
}

-(void)decreaseVolume {
  %orig;

  if (kEnabled && mediaController.isPlaying && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
    [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.0];
  }
}
%end

// SLIDE TO UNLOCK TEXT
%hook _UIGlintyStringView 
-(void)layoutSubviews {
  if (kEnabled == YES && ![self.text isEqualToString:@"slide to power off"]) {
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0];     
    self.clipsToBounds = YES;
  } else if (kEnabled == YES && ![self.text isEqualToString:@"slide to power off"] && kCustomSliderText == YES) {
    self.text = kCustomText;
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0];     
    self.clipsToBounds = YES;
  } else {
    %orig;
  }
}
%end 

// CAMERA ICON
// TODO: When activating camera, after going back and unlocking the camera app opens. This behavior should not happen
%hook SBSlideUpAppGrabberView
-(void)layoutSubviews {
  %orig;

  if (kEnabled) {
    UIImageView *saturatedIconView = [self valueForKey:@"_saturatedIconView"];
      
    UIImage *cameraImage = [saturatedIconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    saturatedIconView.tintColor = [UIColor whiteColor];

    grabberIconImageView = [[UIImageView alloc] init];
    grabberIconImageView.frame = saturatedIconView.frame;
    grabberIconImageView.bounds = saturatedIconView.bounds;
    grabberIconImageView.image = cameraImage;
    [saturatedIconView addSubview:grabberIconImageView];
    
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    backgroundView.hidden = YES;
    UIView *tintView = [self valueForKey:@"tintView"];
    tintView.hidden = YES;
  }
}
-(void) dealloc {
  if (grabberIconImageView) {
    [grabberIconImageView release];
    grabberIconImageView = nil;
  }
  %orig;
}     
%end

// DISABLE SHOW PASSCODE BUTTON
%hook SBHomeButtonShowPasscodeRecognizer
-(void)setDelegate:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}     
%end

%hook SBHomeButtonShowPasscodeRecognizerDelegate
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}

-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}
%end

// touch id fix (maybe or just a fluke, may have side effects) from DGh0st
%hook SBFUserAuthenticationController
-(void)_revokeAuthenticationImmediately:(BOOL)arg1 forPublicReason:(id)arg2 {
  if (kEnabled && arg1 && ([arg2 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg2 isEqualToString:@"StartupTransitionToLockOut"])) {
  } else {
    %orig(arg1, arg2);
  }
}

-(void)revokeAuthenticationImmediatelyForPublicReason:(id)arg1 {
  if (kEnabled && ([arg1 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg1 isEqualToString:@"StartupTransitionToLockOut"])) {
  } else {
    %orig(arg1);
  }
}

-(void)revokeAuthenticationImmediatelyIfNecessaryForPublicReason:(id)arg1 {
  if (kEnabled && ([arg1 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg1 isEqualToString:@"StartupTransitionToLockOut"])) {
  } else {
    %orig(arg1);
  }
}

-(void)revokeAuthenticationIfNecessaryForPublicReason:(id)arg1 {
  if (kEnabled && ([arg1 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg1 isEqualToString:@"StartupTransitionToLockOut"])) {
  } else {
    %orig(arg1);
  }
}
%end

// SHOW TIME AND DATE
%hook SBFLockScreenDateView
-(void)layoutSubviews {
  if (kEnabled && mediaController.isPlaying) {
    timeLabel = [self valueForKey:@"_timeLabel"];
    timeLabel.hidden = YES;
  } else if (kEnabled && mediaController.isPaused) {
    %orig;
    timeLabel = [self valueForKey:@"_timeLabel"];
    timeLabel.hidden = NO;
    [mediaControls removeFromSuperview];
    [mediaVisualEffect removeFromSuperview];
  } else {
    %orig;
  }
}
%end

// HIDE VOLUME HUD (MEDIA PLAYING)
%hook SBVolumeHUDView
- (void)layoutSubviews {
  %orig;

  if (kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked])  {
    [self setHidden:YES];     
  }
}
%end
    
%hook SBLockScreenViewController
// -(void)viewDidLoad {
//   %orig;
//   NSLog(@"SLEEPDEBUG Gesture detection begin");

//   for (UIView *view in self.view.subviews) {
//     NSLog(@"SLEEPDEBUG View %@", view);
//     for (UIGestureRecognizer *gesture in [view gestureRecognizers]) {
//       NSLog(@"SLEEPDEBUG Checking %@", gesture);
//       if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
//         NSLog(@"SLEEPDEBUG Gesture detected %@", gesture);
//         UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)gesture;
//         if ([swipeGesture isKindOfClass:[UIPanGestureRecognizer class]]) {
//             NSLog(@"SLEEPDEBUG Gesture DISABLING %@", swipeGesture);
//             swipeGesture.enabled = NO; // Disable swipe gesture
//         }
//       }
//     }
//   }
// }

// -(BOOL)gestureRecognizerShouldBegin:(id)arg1 {
//   NSLog(@"SLEEPDEBUG checking %@", arg1);
//   BOOL res = %orig;
//   UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer *)arg1;
//   if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//     NSLog(@"SLEEPDEBUG Found UIPanGestureRecognizer, disabling...");
//     // gestureRecognizer.enabled = NO; // Disable the gesture
//     return NO; // Prevent the gesture from beginning
//   } else {
//     return res;
//   }

// }

-(void)handleBiometricEvent:(unsigned long long)arg1 {
  if (kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked] && arg1 == kTouchIDSuccess) {
    //SystemSoundID soundID;
    //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:unlockSound],&soundID);
    //AudioServicesPlaySystemSound(soundID);
     %orig;
  } else {
    %orig;
  }
}

// SHOW MEDIA CONTROLS
%new 
-(void)presentMediaControls {
  [[%c(SBLockscreenView) sharedInstance] _layoutMediaControlsView];   
}

// HANDLE VOLUME EVENTS
-(BOOL)handleVolumeUpButtonPressed { 
  return %orig;
}

-(BOOL)handleVolumeDownButtonPressed {
  return %orig;
}

// DEVICE LOCKING FIX
-(BOOL)canUIUnlockFromSource:(int)arg1 {
  if (kEnabled == YES) {
    return YES;
  } else {
    return %orig;
  }
}

// HIDE DATE (MEDIA PLAYING)
-(BOOL)_shouldShowDate {
  if (kEnabled && mediaController.isPlaying) {
    return FALSE;
  } else {
    return %orig;
  }
}     

// SHOW STATUS BAR TIME (MEDIA PLAYING)
-(BOOL)shouldShowLockStatusBarTime {
  if (kEnabled && mediaController.isPlaying) {
    return TRUE;
  } else {
    return %orig;
  }
}     
    
// SHOW SLIDE TO UNLOCK
- (BOOL)shouldShowSlideToUnlockTextImmediately {
  if (kEnabled) {
    return TRUE;
  } else {
    return %orig;
  }
}

// SCREEN TIMEOUT FIX
- (void)_handleDisplayTurnedOnWhileUILocked:(id)arg1 {
  if (kEnabled && [self valueForKey:@"_isInScreenOffMode"]) {
    YES;
  } else {
    %orig;
  }
}
%end

// MEDIA CONTROLS
@implementation MTOMediaView
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self != nil) {
    _mediaController = [[%c(MPULockScreenMediaControlsViewController) alloc] init];
    _mediaController.view.frame = frame;
    [self addSubview:_mediaController.view];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlbumArtInfo:) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];	
  }
  return self;
}

- (void)layoutSubviews {
  int devicesHeight = [UIScreen mainScreen].bounds.size.height;
  
  switch (devicesHeight) {
    case 736: // iPhone 5.5in
      artworkFrame = CGRectMake(32.5, 230, 360, 360);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];
	    
      break;

    case 667: // iPhone 4.7in
      artworkFrame = CGRectMake(30, 230, 320, 320);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];
	    
      break;

    case 568: // iPhone 4in
      artworkFrame = CGRectMake(40, 210, 240, 240);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];  
	
      break;
    default: // iPad
      artworkFrame = CGRectMake(40, 210, 240, 240);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];	    
      break;
  }
  if (mediaController.isPlaying && mediaController.hasTrack) {
    [self performSelector:@selector(updateAlbumArtInfo:)];
  }
}

-(void)updateAlbumArtInfo:(id)completeAlbumInfoUpdate {
  MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    __block UIImage *artwork = [UIImage imageWithData:[(__bridge NSDictionary *)information objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]] ? [UIImage imageWithData:[(__bridge NSDictionary *)information objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]] : [[UIImage alloc] initWithContentsOfFile:noAlbumImagePath];
    _artworkImageView.image = artwork;
  });
}

-(void)dealloc {
  [_mediaController release];
  _mediaController = nil;
  [_artworkImageView release];
  _artworkImageView = nil;

  [[NSNotificationCenter defaultCenter] removeObserver:self];

  [super dealloc];
}
@end

// ----- Preferences -----
// -----------------------

HBPreferences *preferences;
extern NSString *const HBPreferencesDidChangeNotification;
static void loadPrefs() {
  
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ikilledappl3.meteora.plist"];
  
  if(prefs) {  
    kCustomText = ( [prefs objectForKey:@"kCustomText"] ? [prefs objectForKey:@"kCustomText"] : kCustomText );
    [kCustomText retain];
  }
}  
 
%ctor {
  preferences = [[HBPreferences alloc] initWithIdentifier:@"com.ikilledappl3.meteora"];

  [preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];
  [preferences registerBool:&kDoubleTap default:NO forKey:@"kDoubleTap"];
  [preferences registerBool:&kRemoveChevron default:NO forKey:@"kRemoveChevron"];
  [preferences registerBool:&kRemoveMediaPlayerBlur default:NO forKey:@"kRemoveMediaPlayerBlur"];
  [preferences registerBool:&kCustomSliderText default:NO forKey:@"kCustomSliderText"];

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.ikilledappl3.meteora-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
