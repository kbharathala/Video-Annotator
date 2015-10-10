//
//  ViewController.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/9/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "VideoViewController.h"
#import <OneDriveSDK/OneDriveSDK.h>

@interface VideoViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.webView setAllowsInlineMediaPlayback:YES];
    [self.webView setMediaPlaybackRequiresUserAction:NO];
    
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
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
                           </html>", (int) self.view.frame.size.width, (int) self.view.frame.size.height, @"9MxBaqZ3ZtA"];
    [self.webView loadHTMLString:embedHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[self startCheckingValue];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setFrame:CGRectMake(523, 11, 28, 28)];
    [shareButton setImage:[UIImage imageNamed:@"shareIcon.png"] forState:UIControlStateNormal];
    [shareButton setTintColor:[UIColor redColor]];
    [self.view addSubview:shareButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(453, 8.5, 32, 32)];
    [addButton setImage:[UIImage imageNamed:@"plusIcon.png"] forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor redColor]];
    [self.view addSubview:addButton];
    
    UIButton *clockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clockButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [clockButton setFrame:CGRectMake(491, 13, 23, 23)];
    [clockButton setImage:[UIImage imageNamed:@"clockIcon60F.png"] forState:UIControlStateNormal];
    [clockButton setTintColor:[UIColor redColor]];
    [self.view addSubview:clockButton];
}

-(void) share {
    NSString *script = @"ytplayer.pauseVideo()";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:nil applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void) add {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:@"Add Annotation" message:@"Add Annotation" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    addAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *script = @"ytplayer.getCurrentTime()";
    int timeStamp = (int)[[self.webView stringByEvaluatingJavaScriptFromString:script] floatValue];
    
    if([alertView.title isEqualToString:@"Add Annotation"]) {
        NSString *comment = [[alertView textFieldAtIndex:0] text];
        
//        NSString *post = [NSString stringWithFormat:@"roomID=%@&start=%d&end=%d&comment=%@",self.roomID,timeStamp, timeStamp+2, comment];
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//        [request setURL:[NSURL URLWithString:@"http://pickup.azurewebsites.net/auth"]];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
        
        /* NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
         if(!conn) {
            [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
         } */
    }
}

-(void)startCheckingValue {
    NSTimer *mainTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkValue:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:mainTimer forMode:NSDefaultRunLoopMode];
}

-(void)checkValue:(NSTimer *)mainTimer {
    NSString *script = @"ytplayer.getCurrentTime()";
    NSLog(@"Time is: %d", (int)[[self.webView stringByEvaluatingJavaScriptFromString:script] floatValue]);
}

-(void) uploadToOneDrive {
    
    NSLog(@"In One Drive");
    
    __block NSString *oneDriveToken;
    
    [ODClient clientWithCompletion:^(ODClient *client, NSError *error){
        if (!error){
            oneDriveToken = client.authProvider.accountSession.accessToken;
        }
    }];
}


@end
