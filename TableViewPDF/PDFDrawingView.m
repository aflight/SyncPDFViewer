//
//  PDFDrawingView.m
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import "PDFDrawingView.h"

@interface PDFDrawingView()

@end

@implementation PDFDrawingView
@synthesize currentPage;
@synthesize fileName = _fileName;
@synthesize pdfDocument = _pdfDocument;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initPDFWithPageIndex:(NSInteger)pageIndex andFileName:(NSString *)fileName
{
//    NSURL *docDirURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSURL *pdfURL = [docDirURL URLByAppendingPathComponent:fileName];
//    pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
   
    _fileName = fileName;
    currentPage = pageIndex;
}
- (NSInteger) getNumberOfPages
{
    return CGPDFDocumentGetNumberOfPages(_pdfDocument);
}
//- (void)initPDF:(NSInteger)pageIndex
//{
//    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("test1.pdf"),NULL,NULL);
//    pdfDocument = CGPDFDocumentCreateWithURL(pdfURL);
//    currentPage = pageIndex;
//}

- (void)drawIncontext:(CGContextRef)context

{
    CGContextTranslateCTM(context,0.0,self.frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    pdfPage = CGPDFDocumentGetPage(_pdfDocument, self.currentPage);
    
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pdfPage, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, pdfPage);
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawIncontext:UIGraphicsGetCurrentContext()];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
