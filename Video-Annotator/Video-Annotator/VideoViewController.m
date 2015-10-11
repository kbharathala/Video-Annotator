//
//  ViewController.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/9/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "VideoViewController.h"
#import "MainViewController.h"
#import <OneDriveSDK/OneDriveSDK.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Wit/Wit.h>
#import "SimpleNetworking.h"

@interface VideoViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSMutableDictionary *annotationDict;
@property (nonatomic, strong) UILabel *currLabel;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currLabel = [[UILabel alloc] init];
    
    self.annotationDict = [[NSMutableDictionary alloc] init];
    
    for(NSDictionary *a in self.annotations) {
        int start = [[a objectForKey:@"timeStampStart"] integerValue];
        int end = [[a objectForKey:@"timeStampEnd"] integerValue];
        for(int i = start; i <= end; i++) {
            NSString *key = [NSString stringWithFormat: @"%d", i];
            NSMutableArray *temp = [self.annotationDict objectForKey:key];
            if(temp) {
                [temp addObject: [a objectForKey:@"comment"]];
                [self.annotationDict setObject:temp forKey:key];
            } else {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:[a objectForKey:@"comment"]];
                [self.annotationDict setObject:array forKey:key];
            }
        }
    }
    NSLog(@"%@", self.annotationDict);
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.webView setAllowsInlineMediaPlayback:YES];
    [self.webView setMediaPlaybackRequiresUserAction:NO];
    
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    NSString *key = self.videoLink;
    
    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <body style='margin:0px;padding:0px;'>\
                           <script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>\
                           <script type='text/javascript'>\
                           function onYouTubeIframeAPIReady()\
                           {\
                           ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})\
                           }\
                           function onPlayerReady(a)\
                           { \
                           a.target.playVideo(); \
                           }\
                           </script>\
                           <iframe id='playerId' type='text/html' width='%d' height='%d' src='http://www.youtube.com/embed/%@?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'>\
                           </body>\
                           </html>", (int) self.view.frame.size.width, (int) self.view.frame.size.height, key];
    [self.webView loadHTMLString:embedHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self startCheckingValue];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setFrame:CGRectMake(523, 11, 28, 28)];
    [shareButton setImage:[UIImage imageNamed:@"shareIcon.png"] forState:UIControlStateNormal];
    [shareButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:shareButton];
    
    /*UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(453, 8.5, 32, 32)];
    [addButton setImage:[UIImage imageNamed:@"plusIcon.png"] forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:addButton];*/
    
    UIButton *clockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clockButton addTarget:self action:@selector(uploadToOneDrive) forControlEvents:UIControlEventTouchUpInside];
    [clockButton setFrame:CGRectMake(491, 13, 23, 23)];
    [clockButton setImage:[UIImage imageNamed:@"clockIcon60F.png"] forState:UIControlStateNormal];
    [clockButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:clockButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(350, 9, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"backIcon.png"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:backButton];
    
    /*UIButton *easelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [easelButton addTarget:self action:@selector(draw) forControlEvents:UIControlEventTouchUpInside];
    [easelButton setFrame:CGRectMake(385, 9, 30, 30)];
    [easelButton setImage:[UIImage imageNamed:@"easelIcon.png"] forState:UIControlStateNormal];
    [easelButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:easelButton]; */
    
    /*WITMicButton* witButton = [[WITMicButton alloc] initWithFrame:CGRectMake(422, 12, 24, 24)];
    [self.view addSubview:witButton];*/
}

- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id) customData error:(NSError*)e {
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        return;
    }
    NSDictionary *firstOutcome = [outcomes objectAtIndex:0];
    NSLog(@"%@", firstOutcome);
    
    ///[self.view addSubview:labelView];
}

-(void) back {
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self presentViewController:mainVC animated:YES completion:nil];
}

-(void) share {
    NSString *script = @"ytplayer.pauseVideo()";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:nil applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void) add {
    NSLog(@"Adding an Annotation");
    
    NSString *script = @"ytplayer.pauseVideo()";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:@"Add Annotation" message:nil delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:@"Cancel", nil];
    addAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *script = @"ytplayer.getCurrentTime()";
    NSNumber *timeStamp = @([[self.webView stringByEvaluatingJavaScriptFromString:script] floatValue]);
    
    if([alertView.title isEqualToString:@"Add Annotation"]) {
        if(buttonIndex == 0) {
            NSString *comment = [[alertView textFieldAtIndex:0] text];
            
            /*NSLog(@"Entered: %@", comment);
            NSString *urlString = [NSString stringWithFormat:@"http://www.hotbox-x.xyz/annotate/add/%@/%@/%d/%d/%@", self.videoLink, self.roomID, timeStamp, timeStamp+2, comment];
            NSLog(@"%@", urlString);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]
                                                                   cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval: 10 ];
            [request setHTTPMethod: @"GET"];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if(!conn) {
                [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
            } */
            
            NSString *url = @"http://www.hotbox-x.xyz/annotate/add";
            
            NSDictionary *param = @{@"video":self.videoLink,@"roomID":self.roomID,@"timeStampStart":timeStamp,@"timeStampEnd":timeStamp, @"annotation":comment};
            
            [SimpleNetworking postToURL:url param:param returned:^(id responseObject, NSError *error){
                if (error) {
                    NSLog(@"error %@", error.localizedDescription);
                } else {
                    NSLog(@"%@", responseObject);
                }
            }];
        }
        NSString *script = @"ytplayer.playVideo()";
        [self.webView stringByEvaluatingJavaScriptFromString:script];
    }
}

-(void)startCheckingValue {
    NSTimer *mainTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkValue:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:mainTimer forMode:NSDefaultRunLoopMode];
}

-(void)checkValue:(NSTimer *)mainTimer {
    NSString *script = @"ytplayer.getCurrentTime()";
    int time = (int)[[self.webView stringByEvaluatingJavaScriptFromString:script] floatValue];
    NSLog(@"%@", [self.annotationDict objectForKey:[NSString stringWithFormat:@"%d", time]]);
    NSArray *tempArray = [self.annotationDict objectForKey:[NSString stringWithFormat:@"%d", time]];
    if(tempArray) {
        self.currLabel.text = [tempArray componentsJoinedByString:@" "];
        NSLog(@"%@", self.currLabel.text);
    } else {
        self.currLabel.text = @"";
    }
    [self.currLabel sizeToFit];
    [self.currLabel setTextColor:[UIColor whiteColor]];
    [self.currLabel setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 50)];
    [self.view addSubview:self.currLabel];
    
}

-(void) uploadToOneDrive {
    
    NSString *script = @"ytplayer.pauseVideo()";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    //__block NSString *oneDriveToken;
    
//    [ODClient clientWithCompletion:^(ODClient *client, NSError *error){
//        if (!error){
//            oneDriveToken = client.authProvider.accountSession.accessToken;
//            
//            NSString *post = [NSString stringWithFormat:@"roomID=%@&start=%d&end=%d&annotate=%@",self.roomID,timeStamp, timeStamp+2, comment];
//            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//            
//            [request setURL:[NSURL URLWithString:@"http://yannotator.azurewebsites.net/onedrive"]];
//            [request setHTTPMethod:@"POST"];
//            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [request setHTTPBody:postData];
//            
//            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            if(!conn) {
//                [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
//            }
//
//        }
//        NSLog(@"%@", oneDriveToken);
//        NSString *script = @"ytplayer.playVideo()";
//        [self.webView stringByEvaluatingJavaScriptFromString:script];
//    }];
    
    NSString *post = [NSString stringWithFormat:@"roomID=%@",self.roomID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:@"http://yannotator.azurewebsites.net/onedrive"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn) {
        [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
    }
    script = @"ytplayer.playVideo()";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
}


@end
