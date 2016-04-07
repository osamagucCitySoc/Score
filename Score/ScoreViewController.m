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
    __weak IBOutlet UIActivityIndicatorView *busy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    [self initData];
    [self initTableView];
}



#pragma mark views methods
-(void)initData
{
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    scoresDataSource = [[NSMutableArray alloc]init];
    gameDictionary = [[NSDictionary alloc]init];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://almasdarapp.com/Score/getGame.php"]];
        gameDictionary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] firstObject];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"%@",[NSString stringWithFormat:@"http://almasdarapp.com/Score/getScores.php?name=%@&matchID=%@",userName,[gameDictionary objectForKey:@"id"]]);
            NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://almasdarapp.com/Score/getScores.php?name=%@&matchID=%@",userName,[gameDictionary objectForKey:@"id"]]]];
            scoresDataSource = [[NSMutableArray alloc]initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
            dispatch_async( dispatch_get_main_queue(), ^{
                [busy setAlpha:0];
                [self initTableView];
            });
        });
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
                            borderColor:[UIColor redColor]
                             completion:^(UIImage * resultImage, NSError * error){
                                 [firstTeamIcon setImage:resultImage];
                             }];
    
    [secondItemIcon setImageWithURL:[NSURL URLWithString:[gameDictionary objectForKey:@"secondTeamIcon"]]
                       placeholder:[UIImage imageNamed:@"female-placeholder.jpg"]
                     progressColor:[UIColor orangeColor]
               progressBarLineWidh:JDAvatarDefaultProgressBarLineWidth
                       borderWidth:JDAvatarDefaultBorderWidth
                       borderColor:[UIColor redColor]
                        completion:^(UIImage * resultImage, NSError * error){
                            [secondItemIcon setImage:resultImage];
                        }];
    
    [firstTeamName setText:[gameDictionary objectForKey:@"firstTeamName"]];
    [secondTeamName setText:[gameDictionary objectForKey:@"secondTeamName"]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSDate* currentDate = [NSDate date];
    NSDate* gameDate = [formatter dateFromString:[gameDictionary objectForKey:@"matchDate"]];
    
    NSLog(@"%f",[gameDate timeIntervalSinceDate:currentDate]);
    
    counterLabel.timeLabel.font = [UIFont systemFontOfSize:20.0f];
    counterLabel.timeLabel.textColor = [UIColor redColor];
    [counterLabel setCountDownTime:[gameDate timeIntervalSinceDate:currentDate]];
    [counterLabel start];
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


#pragma mark table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return scoresDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[scoresDataSource objectAtIndex:section] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"توقاعتي السابقة للمباراة";
    }else if(section == 1)
    {
        return  @"أكبر ٥ توقعات من كل المشاركين";
    }
    return @"";
}

-(UITableViewCell*)tableView:(UITableView *)tableVieww cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellID = @"scoreCell";
    
    UITableViewCell* cell = [tableVieww dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [[cell textLabel]setText:[[scoresDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (IBAction)submitClicked:(id)sender {
    
    BOOL eligible = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"lastScore"])
    {
        NSTimeInterval lastScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastScore"] floatValue];
        NSTimeInterval currentTime = NSTimeIntervalSince1970;
        NSTimeInterval diff = currentTime-lastScore;
        if(diff<86400)
        {
            eligible = NO;
#warning Hussain, show here that he has to wait (diff) seconds to re submit and we will notify him :)
        }
    }
    if(eligible)
    {
        [busy setAlpha:1.0f];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://almasdarapp.com/Score/submitScore.php?name=%@&matchID=%@&teamOne=%@&teamTwo=%@",userName,[gameDictionary objectForKey:@"id"],firstTeamGoals.text,secondTeamGoals.text]]];
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            dispatch_async( dispatch_get_main_queue(), ^{
                [busy setAlpha:0];
                NSTimeInterval currentTime = NSTimeIntervalSince1970;
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",currentTime] forKey:@"lastScore"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSMutableArray* scores = [[NSMutableArray alloc]init];
                [scores addObject:[NSString stringWithFormat:@"%@ - %@",secondTeamGoals.text,firstTeamGoals.text]];
                [scores addObjectsFromArray:[scoresDataSource objectAtIndex:0]];
                [scoresDataSource setObject:scores atIndexedSubscript:0];
                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                NSDate *alertTime = [[NSDate date]
                                     dateByAddingTimeInterval:86400];
                UIApplication* app = [UIApplication sharedApplication];
                UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
                                                    init];
                if (notifyAlarm)
                {
                    notifyAlarm.fireDate = alertTime;
                    notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
                    notifyAlarm.repeatInterval = 0;
                    //notifyAlarm.soundName = @"bell_tree.mp3";
                    notifyAlarm.alertBody = @"Staff meeting in 30 minutes";
                    [app scheduleLocalNotification:notifyAlarm];
                }
            });
        });

    }
}

@end
