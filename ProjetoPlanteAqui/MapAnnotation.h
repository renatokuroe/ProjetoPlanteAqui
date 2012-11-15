//
//  MapAnnotation.h
//  Mapas
//
//  Created by Renato on 19/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
    NSDictionary *data;
    NSNumber *pinTag;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, copy) NSNumber *pinTag;


- (id) initWitCoordinate:(CLLocationCoordinate2D)locationCoordinate;

@end
