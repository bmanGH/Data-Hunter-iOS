//
//  DHSignUpViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHSignUpViewController.h"

@interface DHSignUpViewController ()

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

- (IBAction)onClickCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
