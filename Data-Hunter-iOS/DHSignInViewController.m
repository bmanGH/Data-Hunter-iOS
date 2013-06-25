//
//  DHSignInViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHSignInViewController.h"
#import "DHSignUpViewController.h"
#import "DHEndUserVoiceRecordViewController.h"
#import "DHUserModel.h"
#import "DHTextModel.h"

@interface DHSignInViewController () {
    CGRect _origViewFrame;
}

- (void) onKeyboardWillShow:(NSNotification*)notification;
- (void) onKeyboardWillHide:(NSNotification*)notification;
- (void) onKeyboardWillChangeFrame:(NSNotification*)notification;

@end


@implementation DHSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Keyboard

- (void) onKeyboardWillShow:(NSNotification*)notification {
    // 当键盘显示时，移动界面，防止被键盘遮挡
    
    _origViewFrame = self.view.frame;
    
    NSValue* keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber* keyboardAnimationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* keyboardAnimationDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    UITextField* textField = nil;
    if ([self.userNameTextField isFirstResponder])
        textField = self.userNameTextField;
    else if ([self.userPasswordTextField isFirstResponder])
        textField = self.userPasswordTextField;
    else
        return;
    
    CGFloat offset = textField.frame.origin.y + textField.frame.size.height + _origViewFrame.size.height / 5 - keyboardBounds.origin.y;
    if (offset > 0) {
        CGRect newFrame = CGRectMake(_origViewFrame.origin.x,
                                     _origViewFrame.origin.y - offset,
                                     _origViewFrame.size.width,
                                     _origViewFrame.size.height);
        
        [UIView beginAnimations:@"KeyboardWillShow" context:NULL];
        [UIView setAnimationCurve:[keyboardAnimationCurve intValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[keyboardAnimationDuration doubleValue]];
        
        self.view.frame = newFrame;
        
        [UIView commitAnimations];
    }
}

- (void) onKeyboardWillHide:(NSNotification*)notification {
    // 键盘消失时还原界面位置
    
    NSNumber* keyboardAnimationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* keyboardAnimationDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView beginAnimations:@"KeyboardWillHide" context:NULL];
    [UIView setAnimationCurve:[keyboardAnimationCurve intValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[keyboardAnimationDuration doubleValue]];
    
    self.view.frame = _origViewFrame;
    
    [UIView commitAnimations];
}

- (void) onKeyboardWillChangeFrame:(NSNotification*)notification {
    
}


#pragma mark - Touch

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
    
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - Action

- (IBAction)onClickSignIn:(id)sender {
    [DHUserModel signOut];
    
    if ([DHUserModel signInWithUserName:self.userNameTextField.text userPassword:self.userPasswordTextField.text]) {
        NSInteger numerator = [DHUserModel currentUserModel].ownerVoiceModels.count;
        NSInteger denominator = [DHTextModel allObject].count;
        
        if (numerator < denominator) {
            DHEndUserVoiceRecordViewController* nextEndUserVoiceRecordVC = [[DHEndUserVoiceRecordViewController alloc] initWithNibName:@"DHEndUserVoiceRecordViewController" bundle:nil];
            [self.navigationController pushViewController:nextEndUserVoiceRecordVC animated:YES];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Thanks for recording, there is no more text"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"No exist user or wrong password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)onClickSignUp:(id)sender {
    DHSignUpViewController* signUpVC = [[DHSignUpViewController alloc] init];
    [self presentViewController:signUpVC animated:YES completion:nil];
}

@end
