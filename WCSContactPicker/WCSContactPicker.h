//
//  WCSContactPicker.h
//  WCSContactPicker - iOS 9 Contacts
//
//  Created by Aaron C. Wright on 8/31/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

@import Contacts;
@import ContactsUI;
#import <UIKit/UIKit.h>
#import "Contact.h"

@class WCSContactPicker;

@protocol WCSContactPickerDelegate <NSObject>
@optional
- (void)picker:(nullable WCSContactPicker*)picker didSelectContact:(nonnull Contact*)contact;
- (void)picker:(nullable WCSContactPicker*)picker didFailToAccessContacts:(nullable NSError*)error;
- (void)didCancelContactSelection;
@end

@interface WCSContactPicker : UITableViewController
- (instancetype _Nonnull)initWithDelegate:(id<WCSContactPickerDelegate> _Nullable) delegate;
@property (nullable, assign, nonatomic) id<WCSContactPickerDelegate> delegate;
@end
