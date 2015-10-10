//
//  MainViewController.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/10/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "MainViewController.h"
#import "VideoViewController.h"
#import "Annotation.h"

@interface MainViewController ()

@property (nonatomic, strong) NSString *roomID;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIAlertView *roomIDAlert = [[UIAlertView alloc] initWithTitle:@"Room ID" message:@"Enter Room ID" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    roomIDAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [roomIDAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.title isEqualToString:@"Room ID"]) {
        self.roomID = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Entered: %@", self.roomID);
        
//        NSString *post = [NSString stringWithFormat:@"roomID=%@",self.roomID];
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSError* error;
    NSDictionary *loginSuccessful = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
    NSLog(@"%@", loginSuccessful);
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    //videoVC.annotations = [loginSuccessful objectForKey:@"annotations"];
    //videoVC.videoLink = [loginSuccessful objectForKey:@"videoLink"];
    //videoVC.roomID = self.roomID;
    [self presentViewController:videoVC animated:YES completion:nil];
    
    
}


@end
