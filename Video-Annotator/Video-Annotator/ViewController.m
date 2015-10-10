//
//  ViewController.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/9/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

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
    [self startCheckingValue];
}

-(void)startCheckingValue {
    NSTimer *mainTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkValue:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:mainTimer forMode:NSDefaultRunLoopMode];
}

-(void)checkValue:(NSTimer *)mainTimer {
    NSString *script = @"ytplayer.getCurrentTime()";
    NSLog(@"Time is: %d", (int)[[self.webView stringByEvaluatingJavaScriptFromString:script] floatValue]);
}


@end
