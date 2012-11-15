//
//  ViewController.h
//  ProjetoPlanteAqui
//
//  Created by Renato Kuroe on 14/11/12.
//  Copyright (c) 2012 Renato Kuroe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate> {
    CLLocationManager *locationManager;
    BOOL isReceivedData;
    BOOL isPlantados;
    NSMutableData *receivedData;
    NSArray *dataSource;
    NSArray *receivedArray;
    NSMutableArray *annotationArray;
}

@property (retain, nonatomic) IBOutlet MKMapView *map;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spin;
- (IBAction)segmentedDidChange:(id)sender;

@end
