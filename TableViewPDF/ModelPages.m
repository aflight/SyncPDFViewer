//
//  ModelPages.m
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import "ModelPages.h"
#import "ContentViewController.h"
#import "MtgManager.h"
#import "SynchronousInfo.h"

@interface ModelPages ()
//@property (strong,nonatomic)NSMutableArray *pageData;

@end

@implementation ModelPages

@synthesize fileName = _fileName;
//@synthesize pageData =_pageData;
@synthesize pageIndex = _pageIndex;
@synthesize totalPages = _totalPages;
@synthesize pdfDocument = _pdfDocument;
- (id)init
{
    self = [super init];
    if(self){
//        NSURL *docDirURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//        NSURL *pdfURL = [docDirURL URLByAppendingPathComponent:self.fileName];
//        pdfDocument = CGPDFDocumentCreateWithURL(( CFURLRef)pdfURL);
        _totalPages = CGPDFDocumentGetNumberOfPages(_pdfDocument);
    }
    return self;
}

- (ContentViewController *)viewControllerAtIndex:(NSInteger)index
{
    if ((_totalPages == 0) || (index > _totalPages)) {
        return  nil;
    }
    ContentViewController *viewController = [[ContentViewController alloc] init] ;
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    ContentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ContentView"];
//    viewController.navigationController.toolbarHidden = NO;
    viewController.pdfDocument = self.pdfDocument;
    viewController.fileName = self.fileName;
    //viewController = [viewController init];
    //viewController.dataObject =;
    viewController.pageIndex = index;
    self.pageIndex = index;
    
    
    return viewController;
    //[viewController release];
}

- (NSInteger)indexOfViewController:(ContentViewController *)contentViewController
{
    return contentViewController.pageIndex;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
   
    
    if(index == 1){
        return nil;
    }
    
    index--;
    
    // import
    SynchronousInfo *send = [[SynchronousInfo alloc]init];
    send.pageNumber = index;
    send.pathName = self.fileName;
    
    [[MtgManager instance]sendSynchronizationInfo:send];
    
    [send release];
    
     //[[self viewControllerAtIndex:index+1] release];
    return [self viewControllerAtIndex:index];
    //[viewController release];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    
    
                                                                                                                                                                                       
    if(index == _totalPages){
        return nil;
    }
    index++;
    
    // import
    SynchronousInfo *send = [[SynchronousInfo alloc]init];
    send.pageNumber = index;
    send.pathName = self.fileName;
    
    [[MtgManager instance]sendSynchronizationInfo:send];
    
    [send release];
    
    //[[self viewControllerAtIndex:index-1] release];
    return [self viewControllerAtIndex:index];
    //[viewController release];
}

- (void)dealloc{
   //CFRelease(pdfDocument);
   [super dealloc];
}
@end








