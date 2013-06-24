//
//  DHViewController.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/24/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHRootViewController.h"

@interface DHRootViewController ()

@end

@implementation DHRootViewController

- (id) initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setNavigationBarHidden:YES animated:NO];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
