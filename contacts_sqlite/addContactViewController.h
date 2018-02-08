//
//  addContactViewController.h
//  contacts_sqlite
//
//  Created by student14 on 04/10/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addContactViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt;

@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

- (IBAction)saveContact:(id)sender;

@property(nonatomic,retain)dispatch_queue_t queue;
@property(nonatomic,retain)UIActivityIndicatorView *activityView;

@end
