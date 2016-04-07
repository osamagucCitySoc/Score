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

@interface ScoreViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    NSString* userName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    [self initTableView];
}


#pragma mark views methods
-(void)initData
{
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    scoresDataSource = [[NSMutableArray alloc]init];
    gameDictionary = [[NSDictionary alloc]init];
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"getScores.php?name=%@",userName]]];
        scoresDataSource = [[NSMutableArray alloc]initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self initTableView];
        });
    });
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"getGame.php"]];
        gameDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self initGameView];
        });
    });
    
}


-(void)initGameView
{
    [firstTeamIcon setImageWithURL:[NSURL URLWithString:[gameDictionary objectForKey:@"firstTeamIcon"]]
                            placeholder:[UIImage imageNamed:@"female-placeholder.jpg"]
                          progressColor:[UIColor orangeColor]
                    progressBarLineWidh:JDAvatarDefaultProgressBarLineWidth
                            borderWidth:JDAvatarDefaultBorderWidth
                            borderColor:nil
                             completion:^(UIImage * resultImage, NSError * error){}];
    
    [secondItemIcon setImageWithURL:[NSURL URLWithString:[gameDictionary objectForKey:@"secondTeamIcon"]]
                       placeholder:[UIImage imageNamed:@"female-placeholder.jpg"]
                     progressColor:[UIColor orangeColor]
               progressBarLineWidh:JDAvatarDefaultProgressBarLineWidth
                       borderWidth:JDAvatarDefaultBorderWidth
                       borderColor:nil
                        completion:^(UIImage * resultImage, NSError * error){}];
    
    [firstTeamName setText:[gameDictionary objectForKey:@"firstTeamName"]];
    [secondTeamName setText:[gameDictionary objectForKey:@"secondTeamName"]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-YYYY HH:mm"];
    
    NSDate* currentDate = [NSDate date];
    NSDate* gameDate = [formatter dateFromString:[gameDictionary objectForKey:@"matchDate"]];
    
    counterLabel.timeLabel.font = [UIFont systemFontOfSize:20.0f];
    counterLabel.timeLabel.textColor = [UIColor redColor];
    [counterLabel setCountDownTime:[gameDate timeIntervalSinceDate:currentDate]];
}

-(void)initTableView
{
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    [tableView reloadData];
    [tableView setNeedsDisplay];
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
