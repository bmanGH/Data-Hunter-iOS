//
//  DHEndUserVoiceRecordViewController.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface DHEndUserVoiceRecordViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *voiceText;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

- (IBAction)onClickRecord:(id)sender;
- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickNext:(id)sender;

@end
