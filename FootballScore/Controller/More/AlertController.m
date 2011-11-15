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
@implementation AlertController
@synthesize pushType;


@synthesize alertTitles;
@synthesize alertGroupsInfor;


@synthesize array;
@synthesize dictionary;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row==1) {
            
            cell.detailTextLabel.text =@"进球时声音会提示";
            
        }
        else if(indexPath.row ==2){
            
           cell.detailTextLabel.text = @"进球时手机会发出震动";
           cell.detailTextLabel.textColor = [ColorManager soundSubtitlesColor];
            
            
        
        }
    }
    
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor =[UIColor clearColor];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];   
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    return cell;

    
}


//return the height of the cell 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 0  && indexPath.row ==0 ) {
        
        return 36; 
    }
    
    
    else if (indexPath.section ==1) {
            
            
        return 36;
        
    }
    
    return 52;
    
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


-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return  nil;
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
    [self.navigationItem  setTitle:@"提示设置"];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png" action:@selector(clickBack:)];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AlertSettings" 
													 ofType:@"plist"];	

    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    
    self.alertTitles = dict;
	[dict release];
    
    
    //sort the array
     self.array = [[self.alertTitles allKeys] 
					  sortedArrayUsingSelector:@selector(compare:)];

//    
//
//    self.array = [self.alertTitles  keysSortedByValueUsingComparator:^(id obj1,id obj2){
//        
//        if ([obj1 integerValue] > [obj2 integerValue]) {
//            return NSOrderedAscending;
//        } else{
//            return NSOrderedDescending;
//        }
//    }];
//    
    self.alertGroupsInfor = self.array;

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
   
    [super dealloc];
}
@end
