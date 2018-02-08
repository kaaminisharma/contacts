//
//  contactDb.h
//  contacts_sqlite
//
//  Created by student14 on 04/10/17.
//  Copyright © 2017 kaamini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contactDb : NSObject

@property int contactId,phoneno;
@property(nonatomic,retain)NSString *name,*address;

@end
