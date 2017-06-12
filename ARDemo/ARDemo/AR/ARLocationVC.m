//
//  FLFTARNewMsgVC.m
//  FeelfelCode
//
//  Created by 李策 on 2017/5/29.
//  Copyright © 2017年 李策. All rights reserved.
//

#import "ARLocationCompassView.h"
#import "ARLocationSensorManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#include "Math.h"
#import "ARLocationVC.h"
#import "ARLocationModel.h"
#import "ARLocationCalculator.h"
#import "ARLocationCameraView.h"
#import "ARLocationThumbnailView.h"


@implementation ARLocationDataModel
@end
@implementation ARLocationLabelStyle
@end

@interface ARLocationVC (){
    AVCaptureInput *input;
    AVCaptureDevice *backCamera;
    AVCaptureSession *session;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *previewLayer;
}

@property (strong, nonatomic) ARLocationSensorManager *manager;
@property (strong, nonatomic) ARLocationCompassView *compassView;
@property (strong, nonatomic) ARLocationThumbnailView *dataView;
@property (strong, nonatomic) ARLocationCameraView *cameraView;
@property (strong, nonatomic) ARLocationDataModel *currentLocation;
@property (strong, nonatomic) NSArray<ARLocationDataModel *> *aroundLocations;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation ARLocationVC


-(instancetype)initWithCurrentLocation:(ARLocationDataModel *)location aroundLocations:(NSArray<ARLocationDataModel *> *)locations delegate:(id<ARLocationDelegate>)delegate{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.currentLocation = location;
        self.aroundLocations = locations;
        self.delegate = delegate;
    }
    return self;
}

-(instancetype)initWithDelegate:(id<ARLocationDelegate>)delegate{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self loadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initCapture];
    [self startSensor];
}

-(void)reloadData{
    if ([self.delegate respondsToSelector:@selector(ARLocationCurrentLocation)]) {
        self.currentLocation = [self.delegate ARLocationCurrentLocation];
    }
    
    if ([self.delegate respondsToSelector:@selector(ARLocationAroundLocations)]) {
        self.aroundLocations = [self.delegate ARLocationAroundLocations];
    }
    if ([self.delegate respondsToSelector:@selector(ARLocationLabelStyle)]) {
        self.cameraView.style = [self.delegate ARLocationLabelStyle];
    }
    [self loadData];
}

-(void)configUI{
    self.compassView = [ARLocationCompassView sharedWithRect:CGRectMake(100, self.view.frame.size.height - (self.view.frame.size.width - 200), self.view.frame.size.width - 200, self.view.frame.size.width - 200) radius:(self.view.bounds.size.width-200)/2];
    _compassView.backgroundColor = [UIColor clearColor];
    _compassView.textColor = [UIColor whiteColor];
    _compassView.calibrationColor = [UIColor whiteColor];
    _compassView.horizontalColor = [UIColor purpleColor];
    [self.view addSubview:_compassView];
    
    self.cameraView = [[ARLocationCameraView alloc] initWithFrame:CGRectMake(0, 0, (360/SCREEN_ANGLE + 1) * self.view.bounds.size.width, self.view.bounds.size.height)];
    self.cameraView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.cameraView];
    
    self.dataView = [[ARLocationThumbnailView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 20, 120, 120)];
    self.dataView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dataView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"return@2x.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius = backBtn.frame.size.width*.5;
    backBtn.layer.borderColor = [UIColor blackColor].CGColor;
    backBtn.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    backBtn.layer.borderWidth = .5;
    [self.view addSubview:backBtn];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 20, self.view.bounds.size.height/2 - 20, 40, 40)];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

-(void)loadData{
    if (!self.currentLocation || !self.aroundLocations.count) {
        return;
    }
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    [self.dataView clear];
    [self.cameraView clear];
    NSMutableArray *locationArr = [NSMutableArray array];
    for (ARLocationDataModel *location in self.aroundLocations) {
        ARLocationModel *locationModel = [ARLocationCalculator getPointWithCenterLocation:self.currentLocation.location radius:1000 viewRadius:60 aroundLocation:location.location];
        locationModel.name = location.name;
        [locationArr addObject:locationModel];
        [self.dataView addDataWithLocationModel:locationModel];
    }
    [self.cameraView addLocations:locationArr];
}

- (void)backAction{
    [self stopSensor];
    [session stopRunning];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)stopSensor{
    [_manager stopSensor];
    [_manager stopGyroscope];
    _manager = nil;
}

/**
 *  启动传感器
 */
- (void)startSensor{
    __weak typeof(self)mySelf = self;
    _manager = [ARLocationSensorManager shared];
    
    _manager.didUpdateHeadingBlock = ^(CLLocationDirection theHeading){
        [mySelf.cameraView transformWithAngle:theHeading];
        [mySelf.compassView updateHeading:theHeading];
        [mySelf.dataView updateHeading:theHeading];
        
    };
    _manager.updateDeviceMotionBlock = ^(CMDeviceMotion *data){
        CATransform3D r_Y = CATransform3DMakeRotation(data.gravity.x * M_PI/2, 0, 0, -1);
        CATransform3D r_X = CATransform3DMakeRotation(data.gravity.y * M_PI/2*0.8, 1, 0, 0);
        CATransform3D r_xy = CATransform3DConcat(r_X, r_Y);
        mySelf.compassView.layer.transform = CATransform3DConcat(r_xy, CATransform3DMakeRotation(data.gravity.x * M_PI/2, 0, 1, 0));
    };
    
    [_manager startSensor];
    [_manager startGyroscope];
}

- (void)initCapture{
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in devices) {
        if (camera.position == AVCaptureDevicePositionFront) {
        }else{
            backCamera = camera;
        }
    }
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    output = [[AVCaptureMetadataOutput alloc]init];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode];
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    previewLayer.transform = CATransform3DMakeTranslation(0, 0, -(self.view.bounds.size.width));
    [session startRunning];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end




