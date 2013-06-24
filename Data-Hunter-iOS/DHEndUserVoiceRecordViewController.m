//
//  DHEndUserVoiceRecordViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHEndUserVoiceRecordViewController.h"

@interface DHEndUserVoiceRecordViewController ()

@property (nonatomic, readwrite, assign) NSInteger voiceIndex;
@property (nonatomic, readwrite, strong) AVAudioRecorder* voiceRecorder;
@property (nonatomic, readwrite, strong) AVAudioPlayer* voicePlayer;

@end


@implementation DHEndUserVoiceRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil voiceIndex:(NSInteger)voiceIndex
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.voiceIndex = voiceIndex;
        
        // Set the audio file
        NSArray *pathComponents = @[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                         NSUserDomainMask, YES)
                                     lastObject],
                                    [NSString stringWithFormat:@"%d.m4a", voiceIndex]];
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
    
    NSString* textContentPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", self.voiceIndex] ofType:@"txt"];
    NSString* textContent = [NSString stringWithContentsOfFile:textContentPath encoding:NSUTF8StringEncoding error:nil];
    [self.voiceText setText:textContent];
    
    [self.playButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)onClickRecord:(id)sender {
    if (self.voiceRecorder.recording) { // stop record
        [self.voiceRecorder stop];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
        
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [self.playButton setEnabled:YES];
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
    DHEndUserVoiceRecordViewController* nextEndUserVoiceRecordVC = [[DHEndUserVoiceRecordViewController alloc] initWithNibName:@"DHEndUserVoiceRecordViewController" bundle:nil voiceIndex:self.voiceIndex + 1];
    [self.navigationController pushViewController:nextEndUserVoiceRecordVC animated:YES];
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
