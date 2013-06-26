//
//  DHMiniGameSlotsViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHMiniGameSlotsViewController.h"
#import "DHEndUserVoiceRecordViewController.h"


#define kDHMiniGamePushState          (0)
#define kDHMiniGameStopStateOnce      (1)
#define kDHMiniGameStopStateTwice     (2)
#define kDHMiniGameStopStateThird     (3)


@interface DHMiniGameSlotsViewController () {
    NSInteger _state;
    NSArray* _component1ImageViews;
    NSArray* _component2ImageViews;
    NSArray* _component3ImageViews;
}

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) AVAudioPlayer* sfxPushPlayer;
@property (nonatomic, strong) AVAudioPlayer* sfxWinPlayer;


- (void) onTimer;

@end

@implementation DHMiniGameSlotsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _state = kDHMiniGamePushState;
    }
    return self;
}

- (void) dealloc {
    [self.timer invalidate];
    [self.sfxPushPlayer stop];
    [self.sfxWinPlayer stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 读取音效
    NSString* sfxPath = [[NSBundle mainBundle] pathForResource:@"push" ofType:@"mp3"];
    NSURL* sfxURL = [[NSURL alloc] initFileURLWithPath:sfxPath];
    self.sfxPushPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sfxURL error:nil];
    [self.sfxPushPlayer prepareToPlay];
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"mp3"];
    sfxURL = [[NSURL alloc] initFileURLWithPath:sfxPath];
    self.sfxWinPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sfxURL error:nil];
    [self.sfxWinPlayer prepareToPlay];
    
    // 读取图片
    UIImage *slot1Img = [UIImage imageNamed:@"slots_1.png"];
    UIImage *slot2Img = [UIImage imageNamed:@"slots_2.png"];
    UIImage *slot3Img = [UIImage imageNamed:@"slots_3.png"];
    UIImage *slot4Img = [UIImage imageNamed:@"slots_4.png"];
    UIImage *slot5Img = [UIImage imageNamed:@"slots_5.png"];
    UIImage *slot6Img = [UIImage imageNamed:@"slots_6.png"];
    
    {
        UIImageView *slot0 = [[UIImageView alloc] initWithImage:slot6Img]; slot0.tag = 6;
        UIImageView *slot1 = [[UIImageView alloc] initWithImage:slot1Img]; slot1.tag = 1;
        UIImageView *slot2 = [[UIImageView alloc] initWithImage:slot2Img]; slot2.tag = 2;
        UIImageView *slot3 = [[UIImageView alloc] initWithImage:slot3Img]; slot3.tag = 3;
        UIImageView *slot4 = [[UIImageView alloc] initWithImage:slot4Img]; slot4.tag = 4;
        UIImageView *slot5 = [[UIImageView alloc] initWithImage:slot5Img]; slot5.tag = 5;
        UIImageView *slot6 = [[UIImageView alloc] initWithImage:slot6Img]; slot6.tag = 6;
        UIImageView *slot7 = [[UIImageView alloc] initWithImage:slot1Img]; slot7.tag = 1;
        _component1ImageViews = @[slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7];
    }
    
    {
        UIImageView *slot0 = [[UIImageView alloc] initWithImage:slot4Img]; slot0.tag = 4;
        UIImageView *slot1 = [[UIImageView alloc] initWithImage:slot3Img]; slot1.tag = 3;
        UIImageView *slot2 = [[UIImageView alloc] initWithImage:slot2Img]; slot2.tag = 2;
        UIImageView *slot3 = [[UIImageView alloc] initWithImage:slot1Img]; slot3.tag = 1;
        UIImageView *slot4 = [[UIImageView alloc] initWithImage:slot6Img]; slot4.tag = 6;
        UIImageView *slot5 = [[UIImageView alloc] initWithImage:slot5Img]; slot5.tag = 5;
        UIImageView *slot6 = [[UIImageView alloc] initWithImage:slot4Img]; slot6.tag = 4;
        UIImageView *slot7 = [[UIImageView alloc] initWithImage:slot3Img]; slot7.tag = 3;
        _component2ImageViews = @[slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7];
    }
    
    {
        UIImageView *slot0 = [[UIImageView alloc] initWithImage:slot4Img]; slot0.tag = 4;
        UIImageView *slot1 = [[UIImageView alloc] initWithImage:slot1Img]; slot1.tag = 1;
        UIImageView *slot2 = [[UIImageView alloc] initWithImage:slot6Img]; slot2.tag = 6;
        UIImageView *slot3 = [[UIImageView alloc] initWithImage:slot2Img]; slot3.tag = 2;
        UIImageView *slot4 = [[UIImageView alloc] initWithImage:slot5Img]; slot4.tag = 5;
        UIImageView *slot5 = [[UIImageView alloc] initWithImage:slot3Img]; slot5.tag = 3;
        UIImageView *slot6 = [[UIImageView alloc] initWithImage:slot4Img]; slot6.tag = 4;
        UIImageView *slot7 = [[UIImageView alloc] initWithImage:slot1Img]; slot7.tag = 1;
        _component3ImageViews = @[slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7];
    }
    
    [self.slotsPicker reloadAllComponents];
    
    [self.slotsPicker selectRow:1 inComponent:0 animated:NO];
    [self.slotsPicker selectRow:1 inComponent:1 animated:NO];
    [self.slotsPicker selectRow:1 inComponent:2 animated:NO];
}

- (void) onTimer {
    NSInteger slot1 = [self.slotsPicker selectedRowInComponent:0];
    NSInteger slot2 = [self.slotsPicker selectedRowInComponent:1];
    NSInteger slot3 = [self.slotsPicker selectedRowInComponent:2];
    
    ++slot1; if (slot1 + 1 > 7) slot1 = 1;
    ++slot2; if (slot2 + 1 > 7) slot2 = 1;
    ++slot3; if (slot3 + 1 > 7) slot3 = 1;
    
    switch (_state) {
        case kDHMiniGameStopStateOnce:
            [self.slotsPicker selectRow:slot1 inComponent:0 animated:NO];
        case kDHMiniGameStopStateTwice:
            [self.slotsPicker selectRow:slot2 inComponent:1 animated:NO];
        case kDHMiniGameStopStateThird:
            [self.slotsPicker selectRow:slot3 inComponent:2 animated:NO];
    }
}


#pragma mark - Action

- (IBAction)onClickPush:(UIButton *)sender {
    switch (_state) {
        case kDHMiniGamePushState: {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
            [self.pushButton setTitle:@"Stop" forState:UIControlStateNormal];
            [self.exitButton setEnabled:NO];
            
            [self.sfxPushPlayer play];
            
            _state = kDHMiniGameStopStateOnce;
            break;
        }
        case kDHMiniGameStopStateOnce: {
            [self.sfxPushPlayer play];
            
            _state = kDHMiniGameStopStateTwice;
            break;
        }
        case kDHMiniGameStopStateTwice: {
            [self.sfxPushPlayer play];
            
            _state = kDHMiniGameStopStateThird;
            break;
        }
        case kDHMiniGameStopStateThird: {
            [self.sfxPushPlayer play];
            
            [self.timer invalidate];
            self.timer = nil;
            
            [self.pushButton setTitle:@"Push" forState:UIControlStateNormal];
            [self.exitButton setEnabled:YES];
            
            _state = kDHMiniGamePushState;
            
            // 判断是否胜利
            UIImageView* slot1 = (UIImageView*)[self.slotsPicker
                                 viewForRow:[self.slotsPicker selectedRowInComponent:0] forComponent:0];
            UIImageView* slot2 = (UIImageView*)[self.slotsPicker
                                 viewForRow:[self.slotsPicker selectedRowInComponent:1] forComponent:1];
            UIImageView* slot3 = (UIImageView*)[self.slotsPicker
                                 viewForRow:[self.slotsPicker selectedRowInComponent:2] forComponent:2];
            if ( (slot1.tag == slot2.tag) && (slot2.tag == slot3.tag) ) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"You win!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [self.sfxWinPlayer play];
            }
            
            break;
        }
    }
}

- (IBAction)onClickExit:(UIButton *)sender {
    DHEndUserVoiceRecordViewController* nextEndUserVoiceRecordVC = [[DHEndUserVoiceRecordViewController alloc] initWithNibName:@"DHEndUserVoiceRecordViewController" bundle:nil];
    UIViewController* rootVC = self.navigationController.viewControllers[0];
    [self.navigationController setViewControllers:@[rootVC, nextEndUserVoiceRecordVC]
                                         animated:YES];
}


#pragma mark - UIPickerViewDelegate

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    switch (component) {
        case 0:
            return _component1ImageViews[row];
        case 1:
            return _component2ImageViews[row];
        case 2:
            return _component3ImageViews[row];
    }
    return nil;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return @"Slot component 1";
        case 1:
            return @"Slot component 2";
        case 2:
            return @"Slot component 3";
    }
    return nil;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 80;
}


#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}

@end
