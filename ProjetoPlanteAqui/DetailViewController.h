//
//  DetailViewController.h
//  ProjetoPlanteAqui
//
//  Created by Renato Kuroe on 14/11/12.
//  Copyright (c) 2012 Renato Kuroe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic,retain) NSDictionary *detailDic;
@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) IBOutlet UIView *infoContentView;
@property (retain, nonatomic) IBOutlet UILabel *pontosLabel;
@property (retain, nonatomic) IBOutlet UILabel *tipoLabel;

@end
