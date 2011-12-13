//
//  AlertController.m
//  FootballScore
//
//  Created by Orange on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AlertController.h"
#import "UITableViewCellUtil.h"
#import "ColorManager.h"
#import "LocaleConstants.h"
#import "ConfigManager.h"
#import "UserManager.h"

#define TITLE_HEIGHT    36
#define CONTENT_HEIGHT  52

enum{
    GOALS_TIPS_SECTION = 0,
    PUSH_SCORE_SECTION = 1,
    REFRESH_TIME_SECTION = 2
};

enum{
    GOALS_TIPS_ROW = 0,
    SOUND_TIPS_ROW = 1,
    VIBRATION_TIPS_ROW = 2
};

enum{
    PUSH_SCORE_ROW = 0,
    NOT_PUSH_ROW = 1,
    PUSH_ROW = 2
};

enum{
    REFRESH_TIME_ROW = 0,
    SLIDER_ROW = 1,
};

@implementation AlertController

@synthesize pushType;
@synthesize alertTitles;
@synthesize alertGroupsInfor;
@synthesize array;
@synthesize dictionary;

@synthesize timeIntervalSlider;
@synthesize sliderValueLable;
@synthesize secondLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.timeIntervalSlider = [[UISlider alloc] initWithFrame:CGRectMake(8, 0, 236, CONTENT_HEIGHT)];
        
        self.sliderValueLable = [[UILabel alloc] initWithFrame:CGRectMake(245, 0, 30, CONTENT_HEIGHT)];
        
        self.secondLable = [[UILabel alloc] initWithFrame:CGRectMake(278, 0, 15, CONTENT_HEIGHT)];
        
    }
    return self;
}

- (void)timeIntervalSliderChange:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    int sliderValue = (int)(slider.value + 0.5);
    [ConfigManager saveRefreshInterval:sliderValue];
    sliderValueLable.text = [[NSNumber numberWithFloat:sliderValue] stringValue];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier =@"AlertSettings";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell=[[[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

            
    NSString *scoreAlert =[alertGroupsInfor objectAtIndex:[indexPath section]];
    NSArray * TitlesSections=[alertTitles objectForKey:scoreAlert]; 
    
    cell.textLabel.text=[TitlesSections objectAtIndex:[indexPath row]];
    
    
    [cell setCellBackgroundForRow:indexPath.row 
                         rowCount:[self tableView:tableView numberOfRowsInSection:indexPath.section ] 
                  singleCellImage:@"bfsz_top.png" 
                   firstCellImage:@"bfsz_top.png" 
                  middleCellImage:@"bfsz_midd.png" 
                    lastCellImage:@"bfsz_bottom.png" 
                        cellWidth:290];
    
    
    
    if (indexPath.row == 0){    
        cell.textLabel.textColor = [ColorManager scoreAlertColor];
    }
    else{
        cell.textLabel.textColor = [ColorManager soundsAlertColor];
    }

    
    
    if (indexPath.section == GOALS_TIPS_SECTION) 
    {
        if (indexPath.row == 1) 
        {
            cell.detailTextLabel.text = FNS(@"进球时声音会提示");
            if ([ConfigManager getHasSound]) 
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(indexPath.row == 2)
        {
            cell.detailTextLabel.text = FNS(@"进球时手机会发出震动");
            if ([ConfigManager getIsVibration])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == PUSH_SCORE_SECTION)
    {
        if ([UserManager getIsPush])
        {
            if (indexPath.row == 1)
                cell.accessoryType = UITableViewCellAccessoryNone;
            else if (indexPath.row == 2)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            if (indexPath.row == 1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else if (indexPath.row == 2)
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == REFRESH_TIME_SECTION && indexPath.row == 1)
    {
        [cell.contentView addSubview:timeIntervalSlider];
        [cell.contentView addSubview:sliderValueLable];
        [cell.contentView addSubview:secondLable];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor =[UIColor clearColor];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];   
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == GOALS_TIPS_SECTION) 
    {
        if (cell.accessoryType == UITableViewCellAccessoryNone)
        {
            if (indexPath.row == 1)
                [ConfigManager saveHasSound:YES];
            else if (indexPath.row == 2)
                [ConfigManager saveIsVibration:YES];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            if (indexPath.row == 1)
                [ConfigManager saveHasSound:NO];
            else if (indexPath.row == 2)
                [ConfigManager saveIsVibration:NO];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    else if (indexPath.section == PUSH_SCORE_SECTION)
    {
        if (indexPath.row == 1) 
        {
            if (cell.accessoryType == UITableViewCellAccessoryNone)
            {
                [UserManager saveIsPush:NO];
                
                UITableViewCell *anotherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]];
                
                anotherCell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else if (indexPath.row == 2)
        {
            if (cell.accessoryType == UITableViewCellAccessoryNone)
            {
                [UserManager saveIsPush:YES];
                
                UITableViewCell *anotherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
                
                anotherCell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row == 0) 
        return nil;
    return indexPath;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
}


//return the height of the cell 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 || indexPath.section == PUSH_SCORE_SECTION) 
        return TITLE_HEIGHT; 
    else
        return CONTENT_HEIGHT;
}


//return the number of the  row in the sections 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString *scoreAlert =[alertGroupsInfor objectAtIndex: section];
    
    NSArray *TitlesSections =[alertTitles objectForKey:scoreAlert];
    
    return [TitlesSections count];
}


//return the number of the sections 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [alertGroupsInfor count];
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.navigationItem  setTitle:FNS(@"提示设置")];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png" action:@selector(clickBack:)];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyAlertSettings" 
													 ofType:@"plist"];	
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.alertTitles = dict;
	[dict release];
    
    //sort the array
     self.array = [[self.alertTitles allKeys] 
					  sortedArrayUsingSelector:@selector(compare:)];

    self.alertGroupsInfor = self.array;
    

    timeIntervalSlider.minimumValue = REFRESH_INTERVAL_MIN;
    timeIntervalSlider.maximumValue = REFRESH_INTERVAL_MAX;
    timeIntervalSlider.value = [ConfigManager getRefreshInterval];
    
    
    sliderValueLable.text = [[NSNumber numberWithFloat:timeIntervalSlider.value] stringValue];
    [sliderValueLable setFont:[UIFont systemFontOfSize:15]];
    [sliderValueLable setTextAlignment:UITextAlignmentRight];
    [timeIntervalSlider addTarget:self action:@selector(timeIntervalSliderChange:) forControlEvents:UIControlEventValueChanged];
    
    
    secondLable.text = FNS(@"秒");
    [secondLable setFont:[UIFont systemFontOfSize:15]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    
    [alertGroupsInfor release];
    [alertTitles release];
    [array release];
    [dictionary release];
    
    [timeIntervalSlider release];
    [sliderValueLable release];
    [secondLable  release];
   
    [super dealloc];
}
@end
