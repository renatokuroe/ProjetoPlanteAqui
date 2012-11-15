//
//  RootViewController.h
//  ARSSReader
//
//  Created by Renato Kuroe on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
    
    UILabel *cellTitle;
    UILabel *cellAddress;
}
@property (nonatomic, retain) IBOutlet UILabel *cellTitle;
@property (retain, nonatomic) IBOutlet UILabel *cellAdd;
 
@end
