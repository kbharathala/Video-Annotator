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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"circle60.png"] forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(100, self.view.frame.size.height/2-40, 80, 80)];
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTintColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]];
    [self.view addSubview:searchButton];
    
    UIButton *chooseExisting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chooseExisting setTitle:@"From Link" forState:UIControlStateNormal];
    [chooseExisting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseExisting setBackgroundImage:[UIImage imageNamed:@"circle60.png"] forState:UIControlStateNormal];
    [chooseExisting setFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-40, 80, 80)];
    [chooseExisting addTarget:self action:@selector(chooseExisting) forControlEvents:UIControlEventTouchUpInside];
    [chooseExisting setTintColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5]];
    [self.view addSubview:chooseExisting];
    
    UIButton *fromRoomID = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fromRoomID setTitle:@"Room ID" forState:UIControlStateNormal];
    [fromRoomID setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fromRoomID setBackgroundImage:[UIImage imageNamed:@"circle60.png"] forState:UIControlStateNormal];
    [fromRoomID setFrame:CGRectMake(self.view.frame.size.width-180, self.view.frame.size.height/2-40, 80, 80)];
    [fromRoomID setTintColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
    [fromRoomID addTarget:self action:@selector(fromRoomID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fromRoomID];
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
    if([alertView.title isEqualToString:@"Room ID"]) {
        NSString *roomID = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Entered: %@", roomID);
        
        NSString *post = [NSString stringWithFormat:@"roomID=%@",roomID];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:@"http://yannotator.azurewebsites.net/annotate"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn) {
            [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
        }
        
    } else if([alertView.title isEqualToString:@"Search Term"]) {
        NSString *searchTerm = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Entered: %@", searchTerm);
        
        NSString *post = [NSString stringWithFormat:@"searchTerm=%@",searchTerm];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:@"http://yannotator.azurewebsites.net/search"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn) {
            [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
        }
    } else {
        NSString *video = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Entered: %@", video);
        
        NSString *post = [NSString stringWithFormat:@"video=%@",video];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:@"http://yannotator.azurewebsites.net/newRoom"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn) {
            [SVProgressHUD showErrorWithStatus:@"Connection could not be made"];
        }

    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSError* error;
    NSDictionary *loginSuccessful = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
    NSLog(@"%@", loginSuccessful);
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.annotations = [loginSuccessful objectForKey:@"annotations"];
    videoVC.videoLink = [loginSuccessful objectForKey:@"video"];
    videoVC.roomID = [loginSuccessful objectForKey:@"roomID"];
    [self presentViewController:videoVC animated:YES completion:nil];
    
    [SVProgressHUD showSuccessWithStatus: @"Room Joined"];
}


@end
