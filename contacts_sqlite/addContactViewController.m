//
//  addContactViewController.m
//  contacts_sqlite
//
//  Created by student14 on 04/10/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import "addContactViewController.h"
#import <sqlite3.h>
#import "ContactsTableViewController.h"
#import "Reachability.h"
#import "GlobalMethod.h"

@interface addContactViewController () {
    
// for alert view
GlobalMethod *globalFunction;
    
}

@end

@implementation addContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Add new Contact";
    _queue=dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    globalFunction = [[GlobalMethod alloc]init];
    
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

- (IBAction)saveContact:(id)sender {
    
    _msgLabel.hidden=YES;
    _msgLabel.text=@"";
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [globalFunction alertShow:self message:@"No internet connection"];
    }
    else if([_nameTxt.text isEqualToString:@""] || [_phoneTxt.text isEqualToString:@""] || [_addressTxt.text isEqualToString:@""])
    {
        [globalFunction alertShow:self message:@"Fields can't be empty"];
    }
    else
    {
        // start indicator here, when func is called, data will start sending from this func so indicator must be on
        [self.activityView startAnimating];
        
        NSString *s1 = [NSString stringWithFormat:@"name=%@&phone=%@&address=%@",_nameTxt.text,_phoneTxt.text,_addressTxt.text];
        //3.  Post tag to cloud
        NSData *postData = [s1 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kaamini.hashdemo.in/contacts/insert.php"]];
        
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
            
            //NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            //NSLog(@"%s - %d # responseStr = %@", __PRETTY_FUNCTION__, __LINE__, responseStr);
            
            if(responseData)  {
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments  error:&error];
                NSLog(@"res---%@", results);
            }
            
            // passing data to main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
        
        /***** using nsurlsession ******/
        /*
         NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
         [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         NSLog(@"Request reply: %@", requestReply);
         }] resume];
         */
        /****** using nsurlsession ****/
        
        
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}
@end
