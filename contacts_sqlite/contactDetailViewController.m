//
//  contactDetailViewController.m
//  contacts_sqlite
//
//  Created by student14 on 04/10/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import "contactDetailViewController.h"
#import <sqlite3.h>
#import "GlobalMethod.h"
#import "Reachability.h"

@interface contactDetailViewController (){

// for alert view
GlobalMethod *globalFunction;
}

@end

@implementation contactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _editName.text=_tempContact.name;
    _editPhone.text=[NSString stringWithFormat:@"%d",_tempContact.phoneno];
    _editAddress.text=_tempContact.address;
    _contactId=[NSMutableString stringWithFormat:@"%d",_tempContact.contactId];
    
    globalFunction = [[GlobalMethod alloc]init];
    _queue=dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.center=self.view.center;
    self.activityView.color=[UIColor redColor];
    //[self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)EditClick:(id)sender {
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [globalFunction alertShow:self message:@"No internet connection"];
    }
    else{
        _editButton.hidden=YES;
        _editButton.enabled=NO;
        
        _updateButton.hidden=NO;
        _updateButton.enabled=YES;
        _deleteButton.hidden=NO;
        _deleteButton.enabled=YES;
        
        _editName.enabled=YES;
        _editPhone.enabled=YES;
        _editAddress.enabled=YES;
    }
    
    
}

- (IBAction)updateContact:(id)sender {
    
    
    _errMsgLabel.hidden=YES;
    _errMsgLabel.text=@"";
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [globalFunction alertShow:self message:@"No internet connection"];
    } else if([_editName.text isEqualToString:@""] || [_editPhone.text isEqualToString:@""] || [_editAddress.text isEqualToString:@""])
    {
        [globalFunction alertShow:self message:@"Fields can't be empty"];
    }
    else {
        
    // start indicator here, when func is called, data will start sending from this func so indicator must be on
    [self.activityView startAnimating];
    
    NSString *s1 = [NSString stringWithFormat:@"name=%@&phone=%@&address=%@&cid=%@",_editName.text,_editPhone.text,_editAddress.text,_contactId];
    //3.  Post tag to cloud
    NSData *postData = [s1 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld", [postData length]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kaamini.hashdemo.in/contacts/updateRec.php"]];
    
    // here we are selecting secondary queue
    dispatch_async(_queue, ^{
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        
        //NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        //[request setURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response;
        NSError *error;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(responseData)  {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments  error:&error];
            NSLog(@"res---%@", results);
        }
        
        // passing data to main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            _errMsgLabel.hidden=NO;
            _errMsgLabel.text=@"Contact Updated successfully";
            //[globalFunction alertShow:self message:@"Contact updated successfully"];
            
            // start indicator here, when func is called, data will start sending from this func so indicator must be on
            [self.activityView stopAnimating];
            
            //[self.navigationController popViewControllerAnimated:YES];
        });
    });
        
 } // if net connection is on
    
}

- (IBAction)deleteContact:(id)sender {
    
    _errMsgLabel.hidden=YES;
    _errMsgLabel.text=@"";
    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [globalFunction alertShow:self message:@"No internet connection"];
    } else {
        
    // start indicator here, when func is called, data will start sending from this func so indicator must be on
    [self.activityView startAnimating];
    
    
    NSString *s1 = [NSString stringWithFormat:@"cid=%@",_contactId];
    //3.  Post tag to cloud
    NSData *postData = [s1 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld", [postData length]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kaamini.hashdemo.in/contacts/deleteRec.php"]];
    
    // here we are selecting secondary queue
    dispatch_async(_queue, ^{
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response;
        NSError *error;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(responseData)  {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments  error:&error];
            NSLog(@"res---%@", results);
        }
        
        // passing data to main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
        
  } // if net is on
    
}
@end
