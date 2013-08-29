//
//  RootViewController.m
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import "RootViewController.h"
#import "ModelPages.h"
#import "ContentViewController.h"

@interface RootViewController ()
{
    UIAlertView *hostAlert;
}
@property (strong,nonatomic) ModelPages *modelController;

@end

@implementation RootViewController

@synthesize uiPageViewController = _uiPageViewController;
@synthesize modelController = _modelController;
@synthesize fileName = _fileName;
@synthesize pageIndex = _pageIndex;
@synthesize pdfDocument = _pdfDocument;

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
	// Do any additional setup after loading the view.
    [[MtgManager instance] initWithMtgDelegate:self];
    
    // Get file path
    NSURL *docDirURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *pdfURL = [docDirURL URLByAppendingPathComponent:self.fileName];
    _pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
    self.uiPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.uiPageViewController.delegate = self;
    ContentViewController *startingViewController = [self.modelController viewControllerAtIndex:1];
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    [self.uiPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    self.uiPageViewController.dataSource = self.modelController;
    [self addChildViewController:self.uiPageViewController];
    [self.view addSubview:self.uiPageViewController.view];
    self.view.gestureRecognizers = self.uiPageViewController.gestureRecognizers;
    [startingViewController release];
    //[self.uiPageViewController release];
    
    
    
    // Add navi-bar buttons
    exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonPressed:)];
    exitButton.tintColor = [UIColor redColor];
     syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target:self action:@selector(syncButtonPressed:)];
    hostButton = [[UIBarButtonItem alloc] initWithTitle:@"Be Host/Give Up Host" style:UIBarButtonItemStyleBordered target:self action:@selector(hostButtonPressed:)];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:exitButton,syncButton,hostButton,nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    // Send sync info
    SynchronousInfo *send = [[SynchronousInfo alloc]init];
    send.pageNumber = 1;
    send.pathName = self.fileName;
    
    [[MtgManager instance]sendSynchronizationInfo:send];
    
    [send release];
}

#pragma mark button

- (IBAction)hostButtonPressed:(id)sender
{
    NSLog(@"VC - requestPresenterButtonIsTapped");
    if ([MtgManager instance].isPresenter)
    {
        NSLog(@"VC - giveUpPresenter");
        [[MtgManager instance]giveUpPresenter];
        hostButton.style = UIBarButtonItemStyleBordered;
        hostAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Give Up Host" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [hostAlert show];
        [hostAlert release];
        
    }
    else
    {
        NSLog(@"VC - begin to apply presenter");
        [[MtgManager instance]applyPresenter];
    }
    //NSLog(@"%@",@"host");
}


- (IBAction)syncButtonPressed:(id)sender
{
    NSLog(@"VC - setSynchronizationButtonIsTapped");
    
    if ([MtgManager instance].isSynchronizing)
    {
        [[MtgManager instance]setSynchronizationState:NO];
        syncButton.style = UIBarButtonItemStyleBordered;
    }
    else
    {
        [[MtgManager instance]setSynchronizationState:YES];
        syncButton.style = UIBarButtonItemStyleDone;
    }
    
    NSLog(@"VC - isSynchronizing is changed, new value is: %@", [MtgManager instance].isSynchronizing?@"YES":@"NO");
}

- (IBAction)exitButtonPressed:(id)sender
{
    exit(0);
}
//#pragma mark - host alert cancel
//
//- (void)alertDismiss:(NSTimer *)timer
//{
//    [hostAlert dismissWithClickedButtonIndex:0 animated:NO];
//    [hostAlert release];
//    hostAlert = nil;
//}

#pragma mark - delegate

- (void) onReceiveResultOfApplyingPresenter:(BOOL)isAgreed
{
    hostAlert = [UIAlertView alloc];
    NSString *message = nil;
    NSLog(@"VC - onReceiveResultOfApplyingPresenter, result: %@", isAgreed?@"YES":@"NO");
    if (isAgreed) {
        message = @"Being host ! Others will see the same page with you.";
        hostButton.style = UIBarButtonItemStyleDone;
    } else {
        message = @"Failed,host is already existed!";
        hostButton.style = UIBarButtonItemStyleBordered;
    }
    hostAlert = [hostAlert initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [hostAlert show];
    [hostAlert release];
}

- (void) onReceiveSynchronizationInfo:(SynchronousInfo*)info
{
    if (info)
    {
        NSLog(@"VC - onReceiveSynchronizationInfo: %@, %d", info.pathName, info.pageNumber);
        self.modelController.fileName = info.pathName;
        ContentViewController *syncViewController = [self.modelController viewControllerAtIndex:info.pageNumber];
        NSArray *viewControllers = [NSArray arrayWithObject:syncViewController];
        [self.uiPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        self.title = info.pathName;
        
        // 根据同步页面设置总页数
        NSURL *docDirURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *pdfURL = [docDirURL URLByAppendingPathComponent:info.pathName];
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL(( CFURLRef)pdfURL);
        self.modelController.totalPages = CGPDFDocumentGetNumberOfPages(pdfDocument);
        [self addChildViewController:self.uiPageViewController];
        [self.view addSubview:self.uiPageViewController.view];
        [syncViewController release];
    }
    else
        NSLog(@"VC - onReceiveSynchronizationInfo: unvalid info");
}

- (void) onReceiveActiveInfoRequest
{
    SynchronousInfo *info = [[SynchronousInfo alloc]init];
    info.pathName = self.fileName;
    info.pageNumber = self.modelController.pageIndex;
    [[MtgManager instance]sendSynchronizationInfo:info];
    [info release];
}

#pragma mark ModelController getter

- (ModelPages *)modelController
{
    if (!_modelController) {
        _modelController = [ModelPages alloc];
        _modelController.fileName = self.fileName;
        _modelController.pdfDocument = self.pdfDocument;
        _modelController = [_modelController init];
    }
    return _modelController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidUnload
{
    [_uiPageViewController release];
    [_modelController release];
}
@end






















