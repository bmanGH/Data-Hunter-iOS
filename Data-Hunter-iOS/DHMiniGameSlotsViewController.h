//
//  DHMiniGameSlotsViewController.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHMiniGameSlotsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *slotsPicker;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

- (IBAction)onClickPush:(UIButton *)sender;
- (IBAction)onClickExit:(UIButton *)sender;

@end
