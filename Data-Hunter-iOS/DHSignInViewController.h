//
//  DHSignInViewController.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHSignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

- (IBAction)onClickSignIn:(id)sender;
- (IBAction)onClickSignUp:(id)sender;

@end
