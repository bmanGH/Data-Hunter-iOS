//
//  DHEndUserVoiceRecordViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHEndUserVoiceRecordViewController.h"
#import "DHConfig.h"
#import "DHUserModel.h"
#import "DHTextModel.h"
#import "DHVoiceModel.h"
#import "DHMiniGameSlotsViewController.h"


#define kDHEndUserVoiceRecordAlertFinishRecording   (0)
#define kDHEndUserVoiceRecordAlertGotoMiniGame      (1)


@interface DHEndUserVoiceRecordViewController ()

@property (nonatomic, strong) DHTextModel* currentTextModel;
@property (nonatomic, strong) AVAudioRecorder* voiceRecorder;
@property (nonatomic, strong) AVAudioPlayer* voicePlayer;

@end


@implementation DHEndUserVoiceRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentTextModel = [[DHUserModel currentUserModel] fetchRandomTextModelWithoutRecordedVoice];
        
        // Set the audio file
        NSArray *pathComponents = @[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                         NSUserDomainMask, YES)
                                     lastObject],
                                    [NSString stringWithFormat:@"%@____%@.m4a",
                                     [DHUserModel currentUserModel].indexID,
                                     self.currentTextModel.indexID]];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        // Define the recorder setting
        NSDictionary* recordSetting = @{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                        AVSampleRateKey : @(44100.0),
                                        AVNumberOfChannelsKey : @(1)};
        
        // Initiate and prepare the recorder
        self.voiceRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL
                                                     settings:recordSetting
                                                        error:nil];
        self.voiceRecorder.delegate = self;
        self.voiceRecorder.meteringEnabled = YES;
        [self.voiceRecorder prepareToRecord];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.voiceText setText:self.currentTextModel.text];
    
    [self.playButton setEnabled:NO];
    
    // 进度
    NSInteger numerator = [DHUserModel currentUserModel].ownerVoiceModels.count;
    NSInteger denominator = [DHTextModel allObject].count;
    [self.progressBar setProgress:(float)numerator / denominator];
    [self.progressLabel setText:[NSString stringWithFormat:@"Progress %d / %d", numerator, denominator]];
}


#pragma mark - Action

- (IBAction)onClickRecord:(id)sender {
    if (self.voiceRecorder.recording) { // stop record
        [self.voiceRecorder stop];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
        
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [self.playButton setEnabled:YES];
        [self.nextButton setEnabled:YES];
    }
    else { // start record
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [self.voiceRecorder record];
        
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.playButton setEnabled:NO];
    }
}

- (IBAction)onClickPlay:(id)sender {
    if (self.voicePlayer) { // stop and release voice data
        [self.voicePlayer stop];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
        
        self.voicePlayer = nil;
        
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.recordButton setEnabled:YES];
    }
    else { // play voice
        self.voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.voiceRecorder.url error:nil];
        [self.voicePlayer setDelegate:self];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [self.voicePlayer play];
        
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.recordButton setEnabled:NO];
    }
}

- (IBAction)onClickNext:(id)sender {
    DHVoiceModel* newVoiceModel = [[DHVoiceModel alloc] init];
    newVoiceModel.referenceTextModelIndexID = self.currentTextModel.indexID;
    newVoiceModel.ownerUserModelIndexID = [DHUserModel currentUserModel].indexID;
    newVoiceModel.dataFileURL = self.voiceRecorder.url;
    
    if ([newVoiceModel upload]) {
        NSInteger numerator = [DHUserModel currentUserModel].ownerVoiceModels.count;
        NSInteger denominator = [DHTextModel allObject].count;
        if (numerator < denominator) {
            if (numerator % kDHHowManyProgressBeforeMiniGame == 0) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Play a game to take a rest?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Yes"
                                                      otherButtonTitles:@"No", nil];
                alert.tag = kDHEndUserVoiceRecordAlertGotoMiniGame;
                [alert show];
            }
            else {
                DHEndUserVoiceRecordViewController* nextEndUserVoiceRecordVC = [[DHEndUserVoiceRecordViewController alloc] initWithNibName:@"DHEndUserVoiceRecordViewController" bundle:nil];
                UIViewController* rootVC = self.navigationController.viewControllers[0];
                [self.navigationController setViewControllers:@[rootVC, nextEndUserVoiceRecordVC]
                                                     animated:YES];
            }
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Thanks for recording"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = kDHEndUserVoiceRecordAlertFinishRecording;
            [alert show];
            
            [self.progressBar setProgress:(float)numerator / denominator];
            [self.progressLabel setText:[NSString stringWithFormat:@"Progress %d / %d", numerator, denominator]];
        }
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case kDHEndUserVoiceRecordAlertGotoMiniGame: {
            if (buttonIndex == 0) { // Yes
                DHMiniGameSlotsViewController* miniGameSlotsVC = [[DHMiniGameSlotsViewController alloc] initWithNibName:@"DHMiniGameSlotsViewController" bundle:nil];
                UIViewController* rootVC = self.navigationController.viewControllers[0];
                [self.navigationController setViewControllers:@[rootVC, miniGameSlotsVC]
                                                     animated:YES];
            }
            else { // No
                DHEndUserVoiceRecordViewController* nextEndUserVoiceRecordVC = [[DHEndUserVoiceRecordViewController alloc] initWithNibName:@"DHEndUserVoiceRecordViewController" bundle:nil];
                UIViewController* rootVC = self.navigationController.viewControllers[0];
                [self.navigationController setViewControllers:@[rootVC, nextEndUserVoiceRecordVC]
                                                     animated:YES];
            }
            break;
        }
        case kDHEndUserVoiceRecordAlertFinishRecording: {
            // 如果录制完所有语言则跳回登陆界面
            NSInteger numerator = [DHUserModel currentUserModel].ownerVoiceModels.count;
            NSInteger denominator = [DHTextModel allObject].count;
            if (numerator >= denominator)
                [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
    }
}


#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.playButton setEnabled:YES];
}


#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    
    // release voice data
    if (self.voicePlayer) {
        self.voicePlayer = nil;
    }
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.recordButton setEnabled:YES];
}

@end
