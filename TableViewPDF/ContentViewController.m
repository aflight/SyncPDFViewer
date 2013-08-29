//
//  ContentViewController.m
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize dataObject = _dataObject;
@synthesize pageIndex = _pageIndex;
@synthesize pdfView =_pdfView;
@synthesize fileName = _fileName;
@synthesize pdfDocument = _pdfDocument;
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//#pragma mark onClick
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isFlag = !isFlag;
//    [self.navigationController setNavigationBarHidden:isFlag animated:TRUE];
//    [self.navigationController setToolbarHidden:isFlag animated:TRUE];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _pdfView = [[PDFDrawingView alloc] initWithFrame:CGRectMake(0,-20,self.view.bounds.size.width,self.view.bounds.size.height)];
    //[_pdfView initPDF:self.pageIndex];
    [_pdfView initPDFWithPageIndex:self.pageIndex andFileName:self.fileName];
    _pdfView.pdfDocument = self.pdfDocument;
    //[_pdfView autorelease];
    _pdfView.backgroundColor = [UIColor whiteColor];
    self.label.text = [[NSString alloc] initWithFormat:@"%d/%d Pages",_pageIndex,[_pdfView getNumberOfPages]];
    self.label.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_pdfView];
    [self.view addSubview:self.label];
    [self.label release];
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.bounds.size.height-100), self.view.frame.size.width, 44)];
//    [self.view addSubview:toolbar];
//    [toolbar release];
}

- (UILabel *)label
{
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 768, 21)];
    }
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //[_pdfView release];
}


@end
