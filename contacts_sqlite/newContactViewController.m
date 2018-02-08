//
//  newContactViewController.m
//  contacts_sqlite
//
//  Created by Student-001 on 29/09/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import "newContactViewController.h"
#import <sqlite3.h>
#import "ContactsTableViewController.h"
#import "contactsDB.h"

@interface newContactViewController ()

@end

@implementation newContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add new Contact";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveContact:(id)sender {
    
    _msgLabel.hidden=YES;
    _msgLabel.text=@"";
    
    // http://kaamini.hashdemo.in/contacts/ins.php?name=hari&phone=98765&address=mumbai
    
    NSArray *documentDirContents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbpath=[NSString stringWithFormat:@"%@/contactsdb.sqlite",[documentDirContents lastObject]];
    
    sqlite3 *db;
    if(sqlite3_open([dbpath UTF8String], &db)==SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"insert into contacts(name,phoneno,address) values('%@',%@,'%@')",_nameTxt.text,_phoneTxt.text,_addressTxt.text];
        
        if(sqlite3_exec(db, [query UTF8String], NULL, NULL, NULL)==SQLITE_OK)
        {
            _msgLabel.hidden=NO;
            _msgLabel.text=@"Contact added successfully";
        }
        else
        {
            _msgLabel.hidden=YES;
            _msgLabel.text=@"Failed to add contact";
        }
            
    }
    
    
    
}

- (IBAction)backToContacts:(id)sender {
    //ContactsTableViewController *ctvc=[[ContactsTableViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
