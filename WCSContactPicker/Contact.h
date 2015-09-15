//
//  People.h
//  WCSContactPicker - iOS 9 Contacts
//
//  Created by Aaron C. Wright on 8/31/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

@import UIKit;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Contact : NSObject

@property (nonnull, strong, nonatomic) NSString * displayName;
@property (nonnull, strong, nonatomic) NSString * detailText;

@property (nonnull, strong, nonatomic) NSString * firstname;
@property (nonnull, strong, nonatomic) NSString * nickname;
@property (nonnull, strong, nonatomic) NSString * lastname;

@property (nonnull, strong, nonatomic) NSString * street1;
@property (nonnull, strong, nonatomic) NSString * street2;
@property (nonnull, strong, nonatomic) NSString * city;
@property (nonnull, strong, nonatomic) NSString * state;
@property (nonnull, strong, nonatomic) NSString * zip;
@property (nonnull, strong, nonatomic) NSString * country;

@property (nonnull, strong, nonatomic) NSString * company;
@property (nonnull, strong, nonatomic) NSArray * urls;

@property (nonnull, strong, nonatomic) NSDate * birthday;

@property (nonnull, strong, nonatomic) NSArray * address;
@property (nonnull, strong, nonatomic) NSArray * phones;
@property (nonnull, strong, nonatomic) NSArray * emails;

@property (nonnull, strong, nonatomic) UIImage * photo;
@property (nonnull, strong, nonatomic) UIImage * thumb;

- (NSString*)addressString;

@end

NS_ASSUME_NONNULL_END
