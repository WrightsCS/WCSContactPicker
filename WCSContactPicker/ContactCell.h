//
//  ContactCell.h
//  WCSContactPicker - iOS 9 Contacts
//
//  Created by Aaron C. Wright on 8/31/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (strong, nonatomic) UIImage * thumbnail;
@property (strong, nonatomic) NSString * displayName;
@property (strong, nonatomic) NSString * phoneNumber;
@property (strong, nonatomic) NSString * emailAddress;

@end
