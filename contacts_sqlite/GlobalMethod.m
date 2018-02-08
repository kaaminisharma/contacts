//
//  GlobalMethod.m
//  contacts_sqlite
//
//  Created by Amit Mishra on 07/02/18.
//  Copyright © 2018 kaamini. All rights reserved.
//

#import "GlobalMethod.h"

@implementation GlobalMethod

-(void)alertShow:(UIViewController *)AlertVc message: (NSString *)message{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@" Alert Message"
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [AlertVc presentViewController:alert animated:YES completion:nil];

}

@end
