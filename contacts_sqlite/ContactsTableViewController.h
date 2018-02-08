//
//  ContactsTableViewController.h
//  contacts_sqlite
//
//  Created by Student-001 on 29/09/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController


@property(nonatomic,retain)NSMutableArray *contactInfo;
@property(nonatomic,retain)dispatch_queue_t queue;
- (IBAction)addScheduleBtn:(id)sender;
@property(nonatomic,retain)UIActivityIndicatorView *activityView;

@end
