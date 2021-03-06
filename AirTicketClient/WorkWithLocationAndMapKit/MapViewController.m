//
//  MapViewController.m
//  AirTicketClient
//
//  Created by Дмитрий Федоринов on 05.05.2018.
//  Copyright © 2018 Geekbrains. All rights reserved.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "ProgressView.h"
#define MARK_ID @"MarkerIdentifier"

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) LocationService *locationService;
@property (nonatomic,strong) City *origin;
@property (nonatomic,strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ProgressView sharedInstance] show:^{
        self.title = @"Price's map";
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        [self.view addSubview: _mapView];
        
        [[DataManager sharedInstance] loadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
        
    }];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dataLoadedSuccessfully{
    _locationService = [[LocationService alloc] init];
    
}
-(void)updateCurrentLocation:(NSNotification *)notification{
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion:region animated:YES];
    
    if(currentLocation){
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin){
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}
-(void)setPrices:(NSArray *)prices {
    _prices = prices;
//    [_mapView removeAnnotation:_mapView.annotations];
    
    for (MapPrice *price in prices){
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld rub.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            
            [_mapView addAnnotation: annotation];
        });
    }
    [[ProgressView sharedInstance] dismiss:nil];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MARK_ID];
    if(!annotationView){
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MARK_ID];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }
    annotationView.annotation = annotation;
    return annotationView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
