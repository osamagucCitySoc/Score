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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
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


#pragma mark table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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


@end
