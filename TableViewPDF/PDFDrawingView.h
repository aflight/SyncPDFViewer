//
//  PDFDrawingView.h
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFDrawingView : UIView
{
    
    CGPDFPageRef pdfPage;
    
}
@property (nonatomic)CGPDFDocumentRef pdfDocument;
@property int currentPage;
@property (assign)NSString *fileName;

- (void)drawInContext:(CGContextRef)context;
- (void)initPDFWithPageIndex:(NSInteger)pageIndex andFileName:(NSString *)fileName;
- (NSInteger)getNumberOfPages;
@end
