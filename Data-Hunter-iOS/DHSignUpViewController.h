//
//  DHSignUpViewController.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHSignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextFieldAgain;
@property (weak, nonatomic) IBOutlet UITextField *userLocationTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmented;

- (IBAction)onClickSignUp:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end
