//
//  ContactsTableViewController.m
//  contacts_sqlite
//
//  Created by Student-001 on 29/09/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "customTableViewCell.h"
#import "contactDetailViewController.h"
#import "contactDb.h"
#import "addContactViewController.h"
#import <sqlite3.h>
#import "Reachability.h"
#import "GlobalMethod.h"

@interface ContactsTableViewController (){
    
    // for alert view
    GlobalMethod *globalFunction;
}

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contactInfo=[[NSMutableArray alloc]init];
    
    globalFunction = [[GlobalMethod alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"customTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    
    self.activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.center=self.tableView.center;
    self.activityView.color=[UIColor redColor];
    //[self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
}

-(void)fetchContactsFromServer{
    
    
    [_contactInfo removeAllObjects];
    [self.tableView reloadData];
    
    _queue=dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    NSString *url=@"http://kaamini.hashdemo.in/contacts/allcontacts.php";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];
    
    // here we are selecting secondary queue
    dispatch_async(_queue, ^{
        
        NSURLSessionDataTask *task=[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSArray *array =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            for(NSDictionary *tempdic in array)
            {
                contactDb *conn=[[contactDb alloc]init];
                conn.contactId=[[tempdic objectForKey:@"id"] intValue];
                conn.name=[tempdic objectForKey:@"name"];
                conn.phoneno=[[tempdic objectForKey:@"phone"] intValue];
                conn.address=[tempdic objectForKey:@"address"];
                [_contactInfo addObject:conn];
            }
            
            // passing data to main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                // dismiss indicator here, when data gets reloaded
                [self.activityView stopAnimating];
            });
            
        }];
        
        [task resume];
        
    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:NO];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [globalFunction alertShow:self message:@"No internet connection"];
    }
    else
    {
        // start indicator here, when func is called, data will start loading from this func so indicator must be on
        [self.activityView startAnimating];
        
        [self fetchContactsFromServer];
    }
    
    
}

- (IBAction)addScheduleBtn:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    addContactViewController *acvc=[story instantiateViewControllerWithIdentifier:@"addcontact"];
    [self.navigationController pushViewController:acvc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contactInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.layer.borderColor =CGColorCreate(<#CGColorSpaceRef  _Nullable space#>, <#const CGFloat * _Nullable components#>);
    //cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 12;
    cell.clipsToBounds = true;
    
    
    cell.conImage.image=[UIImage imageNamed:@"anonymus"];
    contactDb *contactinfo=[_contactInfo objectAtIndex:indexPath.row];
    cell.conName.text=contactinfo.name;
    cell.phoneNo.text=[NSString stringWithFormat:@"%d",contactinfo.phoneno];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    contactDetailViewController *cdvc=[story instantiateViewControllerWithIdentifier:@"contactdetail"];
    cdvc.tempContact=[_contactInfo objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:cdvc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hview=[[UIView alloc]init];
    hview.backgroundColor = [UIColor clearColor];
    return hview;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"contactdetail" sender:self];
}

 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"contactdetail"])
    {
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        contactDetailViewController *cdvc=[segue destinationViewController];
        cdvc.tempContact=[_contactInfo objectAtIndex:path.row];
    }
    
}
*/
 
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
