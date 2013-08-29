//
//  ModelPages.h
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ContentViewController;

@interface ModelPages : NSObject <UIPageViewControllerDataSource>

@property CGPDFDocumentRef pdfDocument;

@property NSInteger totalPages;
@property (assign)NSString *fileName;
@property (assign)NSInteger pageIndex;
- (ContentViewController *)viewControllerAtIndex:(NSInteger)index;
- (NSInteger)indexOfViewController:(ContentViewController *)contentViewController;

@end
