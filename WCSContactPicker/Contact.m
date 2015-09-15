//
//  People.m
//  WCSContactPicker - iOS 9 Contacts
//
//  Created by Aaron C. Wright on 8/31/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

#import "Contact.h"

@implementation Contact

- (NSString*)addressString {
    return [NSString stringWithFormat:@"%@ %@, %@ %@ %@",
            _street1,
            _city,
            _state,
            _zip,
            _country
            ];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"first=%@, nickname=%@, last=%@, birthday=%@, company=%@, phones=%@, emails:%@, urls=%@, address=(%@)",
            _firstname,
            _nickname,
            _lastname,
            _birthday,
            _company,
            _phones,
            _emails,
            _urls,
            [self addressString]
            ];
}

- (NSString*)displayName {
    if ( self.firstname != nil && self.lastname != nil && ![self.firstname isEqualToString:@""] && ![self.lastname isEqualToString:@""] )
        return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
    if ( self.firstname != nil && ![self.firstname isEqualToString:@""] )
        return [NSString stringWithFormat:@"%@", self.firstname];
    if ( self.lastname != nil && ![self.lastname isEqualToString:@""] )
        return [NSString stringWithFormat:@"%@", self.lastname];
    else if ( self.nickname != nil && ![self.nickname isEqualToString:@""] )
        return [NSString stringWithFormat:@"%@", self.nickname];
    else if ( self.company != nil && ![self.company isEqualToString:@""] )
        return [NSString stringWithFormat:@"%@", self.company];
    else if ( self.phones.count )
        return [NSString stringWithFormat:@"%@", self.phones[0]];
    else if ( self.emails.count )
        return [NSString stringWithFormat:@"%@", self.emails[0]];
    return @"No name";
}
- (NSString *)detailText {
    if ( self.phones.count )
        return [NSString stringWithFormat:@"phone: %@", self.phones[0]];
    else if ( self.emails.count )
        return [NSString stringWithFormat:@"email: %@", self.emails[0]];
    else if ( self.company.length != 0 )
        return [NSString stringWithFormat:@"company: %@", self.company];
    else if ( self.nickname.length != 0 )
        return [NSString stringWithFormat:@"nickname: %@", self.nickname];
    return @"No details";
}

@end
