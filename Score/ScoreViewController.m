//
//  ScoreViewController.m
//  Score
//
//  Created by Osama Rabie on 4/6/16.
//  Copyright © 2016 Osama Rabie. All rights reserved.
//

#import "ScoreViewController.h"
#import "MZTimerLabel.h"
#import "JDAvatarProgress.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
{
    __weak IBOutlet JDAvatarProgress *firstTeamIcon;
    __weak IBOutlet UILabel *firstTeamName;
    __weak IBOutlet JDAvatarProgress *secondItemIcon;
    __weak IBOutlet UILabel *secondTeamName;
    __weak IBOutlet MZTimerLabel *counterLabel;
    __weak IBOutlet UITextField *firstTeamGoals;
    __weak IBOutlet UITextField *secondTeamGoals;
    __weak IBOutlet UITableView *tableView;
    NSMutableArray* scoresDataSource;
    NSDictionary* gameDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
