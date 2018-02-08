//
//  customTableViewCell.h
//  contacts_sqlite
//
//  Created by Student-001 on 29/09/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *conImage;
@property (weak, nonatomic) IBOutlet UILabel *conName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNo;

@end
