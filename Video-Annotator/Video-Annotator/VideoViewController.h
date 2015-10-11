//
//  ViewController.h
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/9/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"
#import <Wit/Wit.h>

@interface VideoViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate, WitDelegate>

@property (nonatomic, strong) NSString *videoLink;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSString *roomID;

@end

