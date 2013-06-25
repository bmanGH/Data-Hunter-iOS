//
//  DHSignUpViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHSignUpViewController.h"
#import "DHUserModel.h"

@interface DHSignUpViewController () {
    CGRect _origViewFrame;
}

- (void) onKeyboardWillShow:(NSNotification*)notification;
- (void) onKeyboardWillHide:(NSNotification*)notification;
- (void) onKeyboardWillChangeFrame:(NSNotification*)notification;

@end


@implementation DHSignUpViewController

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
    else if ([self.userPasswordTextFieldAgain isFirstResponder])
        textField = self.userPasswordTextFieldAgain;
    else if ([self.userLocationTextField isFirstResponder])
        textField = self.userLocationTextField;
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
    [self.userPasswordTextFieldAgain resignFirstResponder];
    [self.userLocationTextField resignFirstResponder];
    
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - Action

- (IBAction)onClickSignUp:(id)sender {
    // 检测用户名和密码是否为空
    if (self.userNameTextField.text == nil || [self.userNameTextField.text isEqualToString:@""] ||
        self.userPasswordTextField.text == nil || [self.userPasswordTextField.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"User e-mail and password should not be empty"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 确认两次密码是否一致
    if (![self.userPasswordTextField.text isEqual:self.userPasswordTextFieldAgain.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Password is not same"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    DHUserModel* newUserModel = [[DHUserModel alloc] init];
    newUserModel.userName = self.userNameTextField.text;
    newUserModel.userPassword = self.userPasswordTextField.text;
    newUserModel.gender = (NSString*)(self.genderSegmented.selectedSegmentIndex == 0 ? kDHMaleGenderValue : kDHFemaleGenderValue);
    newUserModel.location = self.userLocationTextField.text;
    
    if ([newUserModel upload]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
