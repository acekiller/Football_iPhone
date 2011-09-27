//
//  SelectMatchTypeController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectMatchTypeController : UIViewController {
    
    UILabel *statusText;
    
}
@property (nonatomic, retain) IBOutlet UILabel *statusText;
-(IBAction)integrityScore:(id)sender;
-(IBAction)singleMatchScore:(id)sender;
-(IBAction)lottery:(id)sender;
-(IBAction)smg:(id)sender;
-(IBAction)topGame:(id)sender;

@end
