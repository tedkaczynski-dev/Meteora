#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <MediaRemote/MediaRemote.h>
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
// #import <AudioUnit/AudioUnit.h>

NSString *unlockSound = [[NSBundle bundleWithPath:@"/Library/Application Support/Meteora/"] pathForResource:@"unlock" ofType:@"caf"];

@interface SBLockScreenNotificationScrollView : UIScrollView 
@end

@interface SBDashBoardUnlockBehavior : NSObject {

}
@end

@interface SBLockScreenViewControllerBase : NSObject {

}
+(id)sharedInstance;
-(void)setAuthenticated:(BOOL)arg1;
-(BOOL)isAuthenticated;
@end

@protocol BiometricKitDelegate <NSObject>
@end

@interface BiometricKit : NSObject <BiometricKitDelegate>
+ (id)manager;
@end

@interface SBUIBiometricResource : NSObject <BiometricKitDelegate>{

}
+(id)sharedInstance;
-(BOOL)hasEnrolledFingers;
-(void)_reallySetAuthenticated:(BOOL)arg1 keybagState:(id)arg2;
-(void)_stopMatching;

@end


@interface SBDashBoardMesaUnlockBehavior : NSObject  {

}
+(id)sharedInstance;
-(void)mesaUnlockTriggerFired:(id)arg1;
-(void)handleBiometricEvent:(unsigned long long)arg1;
-(void)setMesaUnlockBehaviorDelegate:(id)arg1;
@end


@interface SBFUserAuthenticationController : NSObject {

}
+(id)sharedInstance;
-(void)_handleSuccessfulAuthentication:(id)arg1 responder:(id)arg2;
-(void)_handleFailedAuthentication:(id)arg1 error:(id)arg2 responder:(id)arg3;
@end


@class VolumeControl;
@interface VolumeControl : NSObject { 
}
-(void)increaseVolume;
-(void)decreaseVolume;
-(void)cancelVolumeEvent;
-(float)volumeStepUp;
-(float)volumeStepDown;
+(id)sharedVolumeControl;
@end

@interface SBBiometricEventLogger : NSObject
@end

@interface SBLockScreenViewController : UIViewController {
	BOOL _isInScreenOffMode;
}
+(id)sharedInstance;
-(BOOL)requiresPasscodeInputForUIUnlockFromSource:(int)arg1 withOptions:(id)arg2;
-(BOOL)shouldAutoUnlockForSource:(int)arg1;
-(BOOL)handleVolumeUpButtonPressed;
-(BOOL)handleVolumeDownButtonPressed;

-(BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2 ;
-(BOOL)gestureRecognizerShouldBegin:(id)arg1 ;

-(void)shakeSlideToUnlockTextWithCustomText:(id)arg1;
-(void)finishUIUnlockFromSource:(int)arg1;
-(void)handleBiometricEvent:(unsigned long long)arg1;
-(void)handleSuccessfulAuthenticationRequest:(id)arg1 ;
-(void)handleFailedAuthenticationRequest:(id)arg1 error:(id)arg2;
-(void)passcodeLockViewPasscodeEnteredViaMesa:(id)arg1;
-(void)viewDidLoad;
//New
-(void)presentMediaControls;
// -(void)disableLeftSwipeGestures:(UIView)view;
@end

@interface SBLockScreenManager : NSObject {
//SBLockScreenViewController* _lockScreenViewController;
}
+ (id)sharedInstance;
- (void)_runUnlockActionBlock:(BOOL)arg1;
// - (void)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;
-(BOOL)unlockUIFromSource:(int)arg1 withOptions:(id)arg2 ;
-(BOOL)unlockWithRequest:(id)arg1 completion:(/*^block*/id)arg2 ;
- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2;
-(void)startUIUnlockFromSource:(int)arg1 withOptions:(id)arg2;
//new from SBDashBoardMesaUnlockBehavior we'll add it here to handle things if needed
- (void)_handleMesaFailure;
-(void)attemptUnlockWithMesa;
-(void)_attemptUnlockWithPasscode:(id)arg1 mesa:(BOOL)arg2 finishUIUnlock:(BOOL)arg3;
-(void)dashBoardViewController:(id)arg1 unlockWithRequest:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)setUIUnlocking:(BOOL)arg1 ;
@property(readonly) BOOL isUILocked;
@property(readonly, nonatomic) SBLockScreenViewController *lockScreenViewController;
@property(readonly) BOOL bioAuthenticatedWhileMenuButtonDown;
@end

@interface UIScrollViewPagingSwipeGestureRecognizer
@end

@interface SBLockScreenScrollView : UIScrollView
-(BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2;
@end

@interface SBUILegibilityLabel : UIView {

}
@end

@interface SBLockScreenDateViewController : UIView 
@end

@interface FBSDisplay : NSObject
@end

@interface FBDisplayManager : NSObject
+ (instancetype)sharedInstance;
+ (FBSDisplay*)mainDisplay;
@end

@interface FBSystemGestureManager : NSObject <UIGestureRecognizerDelegate>
+ (instancetype)sharedInstance;
- (void)addGestureRecognizer:(id)arg1 toDisplay:(id)arg2;
@end

@interface SpringBoard : NSObject
- (void)_simulateLockButtonPress;
@end

@interface SBNotificationCenterController: NSObject {

}
+(id)sharedInstance;
-(void)presentAnimated:(BOOL)arg1;
@end

@protocol SBHomeButtonShowPasscodeRecognizerDelegate <NSObject>
@required
-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1;
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1;

@end

@class SBControlCenterController;
@class CCUIControlCenterViewController;
@interface SBControlCenterController : NSObject
+ (id)sharedInstance;
-(void)presentAnimated:(BOOL)arg1;
@end

@interface _UIGlintyStringView : UILabel {
      UILabel* _label;
}
@end

@interface SBLockScreenView : UIView {

}
+(id)sharedInstance;
-(void)getScrollview;
-(void)_layoutMediaControlsView;
-(void)setCustomSlideToUnlockText:(id)arg1;
-(void)didMoveToSuperview;
- (void)presentingController:(id)arg1 willHandleGesture:(UIGestureRecognizer *)arg2;
-(BOOL)presentingController:(id)arg1 gestureRecognizer:(id)arg2 shouldReceiveTouch:(id)arg3;
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (void)viewDidLoad;
// - (BOOL)isNotificationCell:(UIView *)view;
@end

@interface SBWallpaperEffectView : UIView 
@end

@interface SBLockScreenPluginManager : NSObject {

}
+(id)sharedInstance;
-(void)_handleUIRelock;
-(void)setEnabled:(BOOL)arg1;
-(BOOL)isEnabled;
-(void)_refreshLockScreenPlugin;
@end

@interface SBLockScreenSettings : NSObject {

}
+(id)sharedInstance;
-(BOOL)showNowPlaying;
-(void)setShowNowPlaying:(BOOL)arg1;
@end

@interface SBLockScreenNowPlayingController : UIViewController {
}
@property (assign, nonatomic) BOOL enabled;
-(BOOL)isEnabled;
-(void)_updateNowPlayingPlugin;
+(id)sharedInstance;
-(void)setEnabled:(BOOL)arg1;
@end
 
@interface SBUIChevronView : UIView {

}
@end

@interface SBSlideUpAppGrabberView : UIView {
	UIImage* _grabberImage;
}
@end

@interface SBSaturatedIconView : UIImageView {

}
@end

@interface SBUIBannerItem : NSObject {

}
@end

@interface SBMediaController : NSObject {
	BOOL _lastNowPlayingAppIsPlaying;
}
-(void)setVolume:(float)arg1;
-(float)volume;
+(id)sharedInstance;
-(void)increaseVolume;
-(void)decreaseVolume;
-(BOOL)isPlaying;
-(BOOL)isPaused;
-(BOOL)hasTrack;
-(BOOL)pause;
@end

@interface SBFLockScreenDateView : UIView {

}
@end

@interface MPUNowPlayingArtworkView : UIView {
	UIImage* _placeholderImage;
}
-(UIImage *)artworkImage;
+(id)sharedInstance;
@end

@interface MPULockScreenMediaControlsViewController : UIViewController
@end

@interface MPUNowPlayingController : NSObject {

}
+(id)sharedInstance;
-(UIImage *)currentNowPlayingArtwork;
@end

@interface HBPreferences
+ (id)alloc;
- (id)initWithIdentifier:(id)arg1;
- (void)registerBool:(BOOL *)arg1 default:(BOOL)arg2 forKey:(id)arg3;
@end

// -------------------
// Notifications
// -------------------

@interface UITableViewWrapperView : UIScrollView {

	NSMutableArray* _stuckToBackViews;
}
@property (nonatomic,readonly) NSArray * stuckToBackViews;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)dealloc;
-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 ;
-(BOOL)pointInside:(CGPoint)arg1 withEvent:(id)arg2 ;
-(void)setBounds:(CGRect)arg1 ;
-(BOOL)gestureRecognizerShouldBegin:(id)arg1 ;
-(void)touchesBegan:(id)arg1 withEvent:(id)arg2 ;
-(void)touchesMoved:(id)arg1 withEvent:(id)arg2 ;
-(void)touchesEnded:(id)arg1 withEvent:(id)arg2 ;
-(void)touchesCancelled:(id)arg1 withEvent:(id)arg2 ;
-(void)willRemoveSubview:(id)arg1 ;
-(BOOL)_forwardsToParentScroller;
-(void)handleSwipeBeginning:(id)arg1 ;
-(void)_stickViewToBack:(id)arg1 ;
-(void)_unstickView:(id)arg1 ;
-(NSArray *)stuckToBackViews;
@end

@interface BBAppearance : NSObject
@property (nonatomic,copy) NSString * title;
@end

@interface BBAction : NSObject
@property (nonatomic,copy) NSString * launchBundleID;
@property (assign,nonatomic) long long actionType;
@property (nonatomic,copy) BBAppearance * appearance;
+(id)actionWithLaunchBundleID:(id)arg1 callblock:(/*^block*/id)arg2 ;
+(id)actionWithLaunchURL:(id)arg1 ;
-(void)setLaunchBundleID:(NSString *)arg1;
-(BOOL)hasPluginAction;
-(BOOL)hasRemoteViewAction;
-(void)setIdentifier:(NSString *)arg1 ;

@end

@interface BBBulletin : NSObject
@property(nonatomic, copy)NSString* sectionID;
@property(nonatomic, copy)NSString* recordID;
@property (nonatomic,copy) NSString * bulletinID; 
@property(nonatomic, copy)NSString* publisherBulletinID;
@property(nonatomic, copy)NSString* title;
@property (nonatomic,copy) NSString * subtitle; 
@property(nonatomic, copy)NSString* message;
@property(nonatomic, retain)NSDate* date;
@property(assign, nonatomic)BOOL clearable;
@property(nonatomic)BOOL showsMessagePreview;

@property(nonatomic, copy)BBAction* defaultAction;
@property (nonatomic,copy) BBAction * alternateAction; 
@property (nonatomic,copy) BBAction * acknowledgeAction; 
@property (nonatomic,copy) BBAction * snoozeAction; 
@property (nonatomic,copy) BBAction * raiseAction;

@property(nonatomic, retain)NSDate* lastInterruptDate;
@property(nonatomic, retain)NSDate* publicationDate;

+(id)bulletinWithBulletin:(id)arg1 ;
-(void)setShowsMessagePreview:(BOOL)arg1 ;
-(void)setSubtitle:(NSString *)arg1 ;
-(void)setDefaultAction:(BBAction *)arg1 ;
-(void)setClearable:(BOOL)arg1 ;
-(NSString *)sectionID;
-(id)responseForAction:(id)arg1;
-(id)actionForResponse:(id)arg1;
-(id)actionWithIdentifier:(id)arg1 ;
-(NSString *)bulletinID;
-(NSString *)universalSectionID;
-(NSString *)parentSectionID;
-(id)supplementaryActions;
-(void)setActions:(NSMutableDictionary *)arg1 ;
@end

@interface SBAwayBulletinListItem
-(void)removeAllBulletins;
-(BBBulletin *)activeBulletin;
@end

@interface BBBulletinRequest : BBBulletin
@end

@interface BBServer : NSObject
- (void)_addBulletin:(id)arg1;
- (void)publishBulletin:(BBBulletin *)arg1 destinations:(NSUInteger)arg2 alwaysToLockScreen:(BOOL)arg3;
- (void)publishBulletinRequest:(id)arg1 destinations:(unsigned long long)arg2 alwaysToLockScreen:(BOOL)arg3;
-(void)withdrawBulletinID:(id)arg1 ;
-(void)observer:(id)arg1 removeBulletins:(id)arg2 inSection:(id)arg3 fromFeeds:(unsigned long long)arg4 ;
-(void)observer:(id)arg1 finishedWithBulletinID:(id)arg2 transactionID:(unsigned long long)arg3 ;
@end

@interface SBBulletinBannerController
-(void)removeCachedBannerForBulletinID:(id)arg1 ;
-(id)dequeueNextBannerItemForTarget:(id)arg1 ;
-(void)observer:(id)arg1 removeBulletin:(id)arg2 ;
-(void)removeAllCachedBanners;
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(/*^block*/id)arg5 ;
@end

@interface SBLockStateAggregator : NSObject
-(unsigned long long)lockState;
@end

@interface SBLockScreenActionContext : NSObject
@property (nonatomic,retain) NSString * identifier;                      //@synthesize identifier=_identifier - In the implementation block
@property (nonatomic,retain) NSString * lockLabel;                       //@synthesize lockLabel=_lockLabel - In the implementation block
@property (nonatomic,retain) NSString * shortLockLabel;                  //@synthesize shortLockLabel=_shortLockLabel - In the implementation block
@property (nonatomic,copy) id action;                                    //@synthesize action=_action - In the implementation block
@property (assign,nonatomic) BOOL requiresUIUnlock;                      //@synthesize requiresUIUnlock=_requiresUIUnlock - In the implementation block
@property (assign,nonatomic) BOOL deactivateAwayController;              //@synthesize deactivateAwayController=_deactivateAwayController - In the implementation block
@property (assign,nonatomic) BOOL canBypassPinLock;                      //@synthesize canBypassPinLock=_canBypassPinLock - In the implementation block
@property (assign,nonatomic) BOOL requiresAuthentication;                //@synthesize requiresAuthentication=_requiresAuthentication - In the implementation block
@property (assign,nonatomic) BBBulletin * bulletin;               //@synthesize bulletin=_bulletin - In the implementation block
@property (assign,nonatomic) int source;                                 //@synthesize source=_source - In the implementation block
@property (assign,nonatomic) int intent;                                 //@synthesize intent=_intent - In the implementation block
@property (nonatomic,readonly) BOOL hasCustomUnlockLabel;
-(void)setBulletin:(BBBulletin *)arg1 ;
@end

@interface SBLockScreenNotificationCell
@end

@interface BBObserver : NSObject
-(void)removeBulletins:(id)arg1 inSection:(id)arg2 ;
-(void)getSectionInfoForSectionIDs:(id)arg1 withCompletion:(/*^block*/id)arg2 ;
@end

@interface MTOMediaView : UIView {
	MPULockScreenMediaControlsViewController *_mediaController;
}
@end

@interface SBBulletinObserverViewController : UIView
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3;
@end

@interface SBLockScreenNotificationListView : UIView
-(void)setHasAnyContent:(BOOL)arg1 ;
-(void)_updateModelAndViewForAdditionOfItem:(id)arg1 ;
-(long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2;
@end

// LS LIST ITEMS TEST
@interface SBAwayListItem : NSObject
@end

@interface SBLockScreenNotificationBannerItem : UIView {
	SBAwayListItem* _listItem;
}
@property (nonatomic,readonly) SBAwayListItem * listItem;
-(SBAwayListItem *)listItem;
-(id)subtitle;
-(id)message;
-(id)title;
-(BOOL)showMessagePreview;
@end 
// ------

@interface SBLockScreenNotificationListController : UIViewController {
	BBObserver* _observer;
}
// -(void)presentAlertItem:(id)arg1 animated:(BOOL)arg2;
// -(void)dismissAlertItem:(id)arg1 animated:(BOOL)arg2;
// - (void)_addItem:(id)arg1 forBulletin:(id)arg2 playLightsAndSirens:(BOOL)arg3 withReply:(/*^block*/id)arg4;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(/*^block*/id)arg5;
// -(id)_newItemForBulletin:(id)arg1 shouldPlayLightsAndSirens:(BOOL)arg2;
-(void)setHasAnyContent:(BOOL)arg1 ;
-(void)_showTestBulletin;
-(void)handleLockScreenActionWithContext:(id)arg1;
-(void)setLockScreenActionContext:(SBLockScreenActionContext *)arg1 ;
-(void)presentingController:(id)arg1 willHandleGesture:(id)arg2 ;
-(id)_firstBulletin;
@end

// @interface NCNotificationListViewController : UICollectionViewController
// @end

// @interface NCNotificationPriorityListViewController : NCNotificationListViewController
// - (NSOrderedSet*)allNotificationRequests;
// - (NCNotificationPriorityList *)notificationRequestList;
// - (NCNotificationRequest*)notificationRequestAtIndexPath:(NSIndexPath*)path;
// - (void)insertNotificationRequest:(NCNotificationRequest*)request forCoalescedNotification:(id)notification;
// - (void)modifyNotificationRequest:(NCNotificationRequest*)request forCoalescedNotification:(id)notification;
// - (void)removeNotificationRequest:(NCNotificationRequest*)request forCoalescedNotification:(id)notification;
// - (void)_reloadNotificationViewControllerForHintTextAtIndexPaths:(id)arg1;
// - (void)_reloadNotificationViewControllerForHintTextAtIndexPath:(id)arg1;
// @end

// @interface NCNotificationSectionListViewController : NCNotificationListViewController
// @end
  
@interface MTONotificationsView : UIView {
	SBLockScreenNotificationListController *_notificationController;
}
// -(BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2;
// - (BOOL)isNotificationCell:(UIView *)view;
@end
