//
//  ViewController.m
//  ProjetoPlanteAqui
//
//  Created by Renato Kuroe on 14/11/12.
//  Copyright (c) 2012 Renato Kuroe. All rights reserved.
//

#import "ViewController.h"
#import "MapAnnotation.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "AddViewController.h"

NSString *getUrlString =  @"http://www.planteaqui.org/api/position?ll=%f,%f";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    receivedArray = [[NSArray alloc]init];
    dataSource = [[NSArray alloc]init];
        
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStyleDone target:self action:@selector(addPlace)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    [self initLocation];
    [self.spin setHidesWhenStopped:YES];
    [self.spin startAnimating];
}

-(void)initLocation {
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)addPlace {
    AddViewController *addVC = [[AddViewController alloc]initWithNibName:@"AddViewController" bundle:nil];
    [self presentViewController:addVC animated:YES completion:^{}];
    [addVC release];
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [locationManager stopUpdatingLocation];

    float lat = newLocation.coordinate.latitude;
    float lng = newLocation.coordinate.longitude;
    
    [self setLocation:lat and:lng andDelta:.1];
}

- (void) setLocation:(float)latitude and:(float)longitude andDelta:(float)delta {
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
	span.latitudeDelta=delta;
	span.longitudeDelta=delta;
	region.span=span;
    
    CLLocationCoordinate2D southCorner;
    southCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 3.5);
    southCorner.longitude = center.longitude;
    
    region.center = southCorner;
        
    [self.map setRegion:region animated:YES];
    
    [self requestFromApiWithLocation:center];
}

- (void)requestFromApiWithLocation:(CLLocationCoordinate2D)coordinates {
    if (!isReceivedData) {
        NSString *urlString = [NSString stringWithFormat:getUrlString, coordinates.latitude, coordinates.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
        receivedData = [[NSMutableData alloc]init];
        isReceivedData = YES;
    }
}

#pragma mark - Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    
    if (!error) {
        NSString* jsonString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        receivedArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        dataSource = [NSArray arrayWithArray:receivedArray];
        [dataSource retain];
        [self filterArray];
    }
}

- (void)filterArray {
    NSPredicate *predicate;
    if (isPlantados) {
       predicate = [NSPredicate predicateWithFormat:@"tipo != %@", @"plante_aqui"];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"tipo == %@", @"plante_aqui"];
    }
    
    receivedArray = [dataSource filteredArrayUsingPredicate:predicate];
    [receivedArray retain];
    
    annotationArray = [[NSMutableArray alloc]init];
    [annotationArray retain];
    [self addPins];
    [self.table reloadData];
    [self.table setHidden:NO];
    [self.spin stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Não foi possível receber os dados do local." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    NSLog(@"errorMessage: %@", [error localizedDescription]);
}

#pragma mark - Map Delegate

- (void) addPins {
    
    [self.map removeAnnotations:[self.map annotations]];

    for (int i = 0; i < [receivedArray count]; i ++) {
        
        NSDictionary *location = [receivedArray objectAtIndex:i];
        NSString *lat = [[location valueForKey:@"positions"]valueForKey:@"lat"];
        NSString *lng = [[location valueForKey:@"positions"]valueForKey:@"lon"];
        
        CLLocationCoordinate2D local;
        local.latitude = [lat floatValue];
        local.longitude = [lng floatValue];
        
        MapAnnotation *mapPin = [[MapAnnotation alloc] initWitCoordinate:local];
        
        NSArray *usersArray = [location valueForKey:@"user"];
        NSString *users = [self concateArray:usersArray];
    
        mapPin.title = users;
        mapPin.subtitle = [location valueForKey:@"tipo"];
        mapPin.data = location;
        mapPin.pinTag = [NSNumber numberWithInt:i];
        [self.map addAnnotation:mapPin];
        [annotationArray addObject:mapPin];
        [mapPin release];
    }
}

#pragma mark MapView Delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView* annotationView;
    
    if (annotation == mapView.userLocation)
        return nil;
    else {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"mapPin"];
        
        if (annotationView != nil)
            annotationView.annotation = annotation;
        else {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:@"mapPin"]autorelease];
        }
        
        //annotationView.image = [UIImage imageNamed:@"mapPin.png"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control {
    MapAnnotation *ann = (MapAnnotation *)aView.annotation;
    
    DetailViewController *detailView = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    detailView.detailDic = ann.data;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
}

- (NSString *)concateArray:(NSArray*)array {
    NSString *allUsersString = [[NSString alloc]init];
    int countUsers = 0;
    for (NSString *userString in array) {
        allUsersString = [allUsersString stringByAppendingString:userString];
        if (countUsers < [array count]-1) {
            allUsersString = [allUsersString stringByAppendingString:@", "];
        }
        countUsers ++;
    }
    return allUsersString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [receivedArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
													 owner:self
												   options:nil];
		for (id obj in nib) {
			if ([obj isKindOfClass:[CustomCell class]])
				cell = (CustomCell *)obj;
		}
        
    }

    NSDictionary *tempArray = [receivedArray objectAtIndex:indexPath.row];
    
    cell.cellTitle.text = [self concateArray:[tempArray valueForKey:@"user"]];
    cell.cellAdd.text = [tempArray valueForKey:@"tipo"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *location = [receivedArray objectAtIndex:indexPath.row];
    NSString *lat = [[location valueForKey:@"positions"]valueForKey:@"lat"];
    NSString *lng = [[location valueForKey:@"positions"]valueForKey:@"lon"];
    
    [self setLocation:[lat floatValue] and:[lng floatValue] andDelta:.01];
    
    MapAnnotation *annotation = [annotationArray objectAtIndex:indexPath.row];
    [self.map selectAnnotation:annotation animated:YES];
    
    /*
    int intIndex = indexPath.row;
    NSNumber *numIndex = [NSNumber numberWithInt:intIndex];
    
    for (int i = 0; i < [self.map.annotations count]-1; i ++) {
        MapAnnotation *annotation = [self.map.annotations objectAtIndex:i];
        if (annotation.pinTag == numIndex) {
            [self.map selectAnnotation:annotation animated:YES];
        }
    }
     */
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_map release];
    [_table release];
    [_spin release];
    [locationManager release];
    [receivedData release];
    [receivedArray release];
    [annotationArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSpin:nil];
    [super viewDidUnload];
}
- (IBAction)segmentedDidChange:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl *)sender;
    if (segmented.selectedSegmentIndex == 0) {
        isPlantados = NO;
    } else if (segmented.selectedSegmentIndex == 1) {
        isPlantados = YES;
    }
    [self filterArray];
}
@end
