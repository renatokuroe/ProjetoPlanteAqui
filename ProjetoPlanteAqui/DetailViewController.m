//
//  DetailViewController.m
//  ProjetoPlanteAqui
//
//  Created by Renato Kuroe on 14/11/12.
//  Copyright (c) 2012 Renato Kuroe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"DetailDic: %@", self.detailDic);
    
    [self buildMessages];
}

- (void)buildMessages {
    float offSet = 49;
    for (int i = 0; i < [[self.detailDic valueForKey:@"messages"]count]; i ++) {
        UILabel *messageLabel = [[UILabel alloc]init];
        [messageLabel setText:[[self.detailDic valueForKey:@"messages"]objectAtIndex:i]];
        [messageLabel setNumberOfLines:3];
        CGSize maximumLabelSize = CGSizeMake(280, 200);
        
        CGSize expectedLabelSize = [[messageLabel text] sizeWithFont:[messageLabel font]
                                                   constrainedToSize:maximumLabelSize
                                                       lineBreakMode:[messageLabel lineBreakMode]];
        
        [messageLabel setFrame:CGRectMake(20, offSet, 280, expectedLabelSize.height)];
        
        [self.scroll addSubview:messageLabel];
        
        offSet += expectedLabelSize.height +10;
    }
    
    int points = [[self.detailDic valueForKey:@"tipo"]intValue];
    [self.pontosLabel setText:[NSString stringWithFormat:@"%i", points]];
    [self.tipoLabel setText:[self.detailDic valueForKey:@"tipo"]];
    
    [self.infoContentView setFrame:CGRectMake(self.infoContentView.frame.origin.x, offSet + 20, self.infoContentView.frame.size.width, self.infoContentView.frame.size.height)];
    [self.scroll setContentSize:CGSizeMake(320, self.infoContentView.frame.origin.y + self.infoContentView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scroll release];
    [_pontosLabel release];
    [_tipoLabel release];
    [_infoContentView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScroll:nil];
    [self setPontosLabel:nil];
    [self setTipoLabel:nil];
    [self setInfoContentView:nil];
    [super viewDidUnload];
}
@end
