//
//  ContactCell.m
//  WCSContactPicker - iOS 9 Contacts
//
//  Created by Aaron C. Wright on 8/31/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

#import "ContactCell.h"

@interface ContactCell ()
@property (nonatomic, weak) IBOutlet UIImageView * imageThumbnail;
@property (nonatomic, weak) IBOutlet UILabel * labelDisplayName, * labelPhoneNumber, * labelEmailAddress;

@end

@implementation ContactCell

- (void)awakeFromNib
{
    _labelDisplayName.textColor = [UIColor blackColor];
    _labelPhoneNumber.textColor = [UIColor grayColor];
    _labelEmailAddress.textColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - Private Methods

- (void)setThumbnail:(UIImage *)thumbnail {
    _imageThumbnail.image = thumbnail;
}

- (void)setDisplayName:(NSString *)displayName {
    _labelDisplayName.text = displayName;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _labelPhoneNumber.text = phoneNumber;
}

- (void)setEmailAddress:(NSString *)emailAddress {
    _labelEmailAddress.text = emailAddress;
}

@end
