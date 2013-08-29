//
//  ContentViewController.h
//  PDFPageTuringViewer
//
//  Created by 周跃翔 on 13-4-22.
//  Copyright (c) 2013年 Ziling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFDrawingView.h"
#import "MtgManager.h"
#import "SynchronousInfo.h"

@interface ContentViewController : UIViewController
{
    BOOL isFlag;
}

@property (assign,nonatomic) CGPDFDocumentRef pdfDocument;
@property (strong,nonatomic) id dataObject;
@property (strong,nonatomic) PDFDrawingView *pdfView;
@property NSInteger pageIndex;
@property (assign)NSString *fileName;
@property (nonatomic,assign)UILabel *label;

@end
