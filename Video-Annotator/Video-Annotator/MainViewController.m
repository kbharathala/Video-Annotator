//
//  MainViewController.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/10/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "MainViewController.h"
#import "VideoViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Annotation.h"

@interface MainViewController ()

@property (nonatomic, strong) NSString *roomID;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:69.0/255 green:202.0/255 blue:255.0/255 alpha:1];
    
    int size = 60;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"searchIcon.png"] forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(114-size/2, self.view.frame.size.height - 125, size, size)];
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(115-size/2,self.view.frame.size.height-80,size,size)];
    searchLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.text = @"Search";
    [self.view addSubview:searchLabel];
    
    UIButton *chooseExisting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chooseExisting setBackgroundImage:[UIImage imageNamed:@"linkIcon.png"] forState:UIControlStateNormal];
    [chooseExisting setFrame:CGRectMake(self.view.frame.size.width/2-size/2, self.view.frame.size.height - 125, size, size)];
    [chooseExisting addTarget:self action:@selector(chooseExisting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseExisting];
    
    UILabel *chooseExistingLabel = [[UILabel alloc] initWithFrame:CGRectMake(253,self.view.frame.size.height-80, size*2, size)];
    chooseExistingLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    chooseExistingLabel.textColor = [UIColor whiteColor];
    chooseExistingLabel.text = @"By Link";
    [self.view addSubview:chooseExistingLabel];
    
    UIButton *fromRoomID = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fromRoomID setBackgroundImage:[UIImage imageNamed:@"roomIcon.png"] forState:UIControlStateNormal];
    [fromRoomID setFrame:CGRectMake(self.view.frame.size.width-150, self.view.frame.size.height - 125, size, size)];
    [fromRoomID addTarget:self action:@selector(fromRoomID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fromRoomID];
    
    UILabel *fromRoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(410,self.view.frame.size.height-80, size*2, size)];
    fromRoomLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    fromRoomLabel.textColor = [UIColor whiteColor];
    fromRoomLabel.text = @"By Room";
    [self.view addSubview:fromRoomLabel];
    
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logoButton setBackgroundImage:[UIImage imageNamed:@"yannotate-logo.png"] forState:UIControlStateNormal];
    [logoButton setUserInteractionEnabled:NO];
    [logoButton setFrame:CGRectMake(self.view.frame.size.width/2-size*2, -50, size*4, size*4)];
    [self.view addSubview:logoButton];
}

- (void)search {
    UIAlertView *searchTermAlert = [[UIAlertView alloc] initWithTitle:@"Search Term" message:nil delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:@"Cancel", nil];
    searchTermAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [searchTermAlert show];
}

- (void) chooseExisting {
    UIAlertView *videoLinkAlert = [[UIAlertView alloc] initWithTitle:@"Video Link" message:nil delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:@"Cancel", nil];
    videoLinkAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [videoLinkAlert show];
}

- (void)fromRoomID {
    UIAlertView *roomIDAlert = [[UIAlertView alloc] initWithTitle:@"Room ID" message:nil delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:@"Cancel", nil];
    roomIDAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [roomIDAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        if([alertView.title isEqualToString:@"Room ID"]) {
            NSString *roomID = [[alertView textFieldAtIndex:0] text];
            NSLog(@"Entered: %@", roomID);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hotbox-x.xyz/annotate/%@", roomID]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                                   cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval: 10 ];
            [request setHTTPMethod: @"GET"];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if(!conn) {
                [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
            }
            
        } else if([alertView.title isEqualToString:@"Search Term"]) {
            NSString *term = [[alertView textFieldAtIndex:0] text];
            NSLog(@"Entered: %@", term);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hotbox-x.xyz/search/%@", term]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                                   cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval: 10 ];
            [request setHTTPMethod: @"GET"];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if(!conn) {
                [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
            }
        } else {
            NSString *video = [[alertView textFieldAtIndex:0] text];
            NSLog(@"Entered: %@", video);
            
            video = [video substringFromIndex:([video rangeOfString:@"="].location+1)];
            NSLog(@"%@", video);
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hotbox-x.xyz/newroom/%@", video]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                                   cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval: 10 ];
            [request setHTTPMethod: @"GET"];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if(!conn) {
                [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSError* error;
    NSDictionary *loginSuccessful = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
    NSLog(@"%@", loginSuccessful);
    
    if([[loginSuccessful objectForKey:@"type"] isEqualToString:@"search"]) {
        
        NSString *video = [loginSuccessful objectForKey:@"data"];
        video = [video substringFromIndex:([video rangeOfString:@"="].location+1)];
        NSLog(@"%@", video);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hotbox-x.xyz/newroom/%@", video]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                               cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval: 10 ];
        [request setHTTPMethod: @"GET"];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn) {
            [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
            
        }
    } else {
        VideoViewController *videoVC = [[VideoViewController alloc] init];
        videoVC.annotations = [loginSuccessful objectForKey:@"annotations"];
        videoVC.videoLink = [loginSuccessful objectForKey:@"video"];
        videoVC.roomID = [loginSuccessful objectForKey:@"roomID"];
        [self presentViewController:videoVC animated:YES completion:nil];
        
        [SVProgressHUD showSuccessWithStatus: @"Room Joined"];
    }
}


@end
