//
//  RootViewController.h
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MtgManager.h"
#import "SynchronousInfo.h"

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>
{
    UIBarButtonItem *hostButton;
    UIBarButtonItem *syncButton;
    UIBarButtonItem *exitButton;
}


@property (strong,nonatomic) UIPageViewController *uiPageViewController;
@property (assign)NSString *fileName;
@property (assign)NSInteger pageIndex;
@property (assign,nonatomic)CGPDFDocumentRef pdfDocument;

- (IBAction)hostButtonPressed:(id)sender;
- (IBAction)syncButtonPressed:(id)sender;
- (IBAction)exitButtonPressed:(id)sender;
@end
