//
//  ViewController.h
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/9/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"

@interface VideoViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *videoLink;
@property (nonatomic, strong) Annotation *annotations;
@property (nonatomic, strong) NSString *roomID;

@end

