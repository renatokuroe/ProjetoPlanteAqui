//
//  MapAnnotation.m
//  Mapas
//
//  Created by Renato on 19/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize data;
@synthesize pinTag;

- (NSString *)subtitle{
    return _subtitle;
}

- (NSString *)title{
    return  _title;
}

- (id)initWitCoordinate:(CLLocationCoordinate2D)locationCoordinate {
    
    self = [super init];
    if (self) {
        _coordinate = locationCoordinate;
        _title = [[NSString alloc] initWithString:@""];
        _subtitle = [[NSString alloc] initWithString:@""];
    }
    return self;
}

@end
