//
//  contactDetailViewController.h
//  contacts_sqlite
//
//  Created by student14 on 04/10/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contactDb.h"

@interface contactDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *editName;
@property (weak, nonatomic) IBOutlet UITextField *editPhone;
@property (weak, nonatomic) IBOutlet UITextField *editAddress;
@property (weak, nonatomic) IBOutlet UILabel *errMsgLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property(nonatomic,retain)contactDb *tempContact;
@property(nonatomic,retain)NSMutableString *contactId;

- (IBAction)EditClick:(id)sender;
- (IBAction)updateContact:(id)sender;
- (IBAction)deleteContact:(id)sender;

@property(nonatomic,retain)dispatch_queue_t queue;
@property(nonatomic,retain)UIActivityIndicatorView *activityView;


@end
