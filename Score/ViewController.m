//
//  ViewController.m
//  Score
//
//  Created by Osama Rabie on 4/6/16.
//  Copyright © 2016 Osama Rabie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController
{
    __weak IBOutlet UITextField *userNameTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"])
    {
        [self performSegueWithIdentifier:@"startSeg" sender:self];
    }
    
    [userNameTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitClicked:(id)sender {
    
    NSString* userName = userNameTextField.text;
    
    if(userName.length == 0)
    {
#warning  HUSSAIN, show an alert that a user needs to input something in here.
    }else
    {
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self performSegueWithIdentifier:@"startSeg" sender:self];
    }
}

#pragma mark textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self submitClicked:nil];
    return YES;
}

@end
