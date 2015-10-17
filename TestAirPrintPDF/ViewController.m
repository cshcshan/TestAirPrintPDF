//
//  ViewController.m
//  TestAirPrintPDF
//
//  Created by Han Chen on 2015/10/10.
//  Copyright © 2015年 Han Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *documentsDirectory;
    NSString *tmpDirectory;
    NSString *filePathInSandBox;
}

@end

@implementation ViewController

NSString * const fileName = @"swift-language-traditional-chinese.pdf";
NSString * const fileExtension = @".pdf";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    tmpDirectory = NSTemporaryDirectory();
    filePathInSandBox = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"%@", documentsDirectory);
    NSLog(@"%@", tmpDirectory);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePathInSandBox]) {
        [fileManager copyItemAtPath:
         [[NSBundle mainBundle] pathForResource:[fileName stringByReplacingOccurrencesOfString:fileExtension withString:@""]
                                         ofType:[fileExtension stringByReplacingOccurrencesOfString:@"." withString:@""]]
                             toPath:filePathInSandBox error:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)printButton:(UIButton *)sender {
    [self printDocumentFile:[NSData dataWithContentsOfFile:filePathInSandBox] fileName:fileName];
}

-(void)printDocumentFile:(NSURL *)iFilePath {
    if([UIPrintInteractionController canPrintURL:iFilePath]) {
        UIPrintInfo *aPrintInfo = [UIPrintInfo printInfo];
        aPrintInfo.outputType = UIPrintInfoOutputGeneral;
        aPrintInfo.jobName = [iFilePath lastPathComponent];
        // You can also set the orientation and duplex on print info.
        
        UIPrintInteractionController *aPrintController = [UIPrintInteractionController sharedPrintController];
        aPrintController.printingItem = iFilePath;
        aPrintController.printInfo = aPrintInfo;
        aPrintController.showsPageRange = YES;
        [aPrintController presentAnimated:YES completionHandler:nil];
    }
}

-(void)printDocumentFile:(NSData *)data fileName:(NSString *)fileName {
    if ([UIPrintInteractionController canPrintData:data]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = fileName;
        // You can also set the orientation and duplex on print info.
        
        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        printController.printingItem = data;
        printController.showsPageRange = YES;
        [printController presentAnimated:YES completionHandler:nil];
    }
}
@end
