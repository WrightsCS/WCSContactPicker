//
//  WCSContactPicker.m
//  WCSContactPicker - iOS 9 Contacts
//
//  Created by Aaron C. Wright on 8/31/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

#import "ContactCell.h"
#import "WCSContactPicker.h"

@interface WCSContactPicker () {
    CNContactStore * _contactStore;
}
@property (assign) BOOL contactsError;
@property (nonatomic, strong) NSArray * contacts;
@end

@implementation WCSContactPicker

- (instancetype _Nonnull)initWithDelegate:(id<WCSContactPickerDelegate> _Nullable)delegate {
    self = [super initWithStyle:UITableViewStylePlain];
    if ( self ) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Contacts", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)reloadContacts
{
    [self getContacts:^(NSArray *contacts, NSError *error) {
        _contacts = contacts;
        _contactsError = error != nil ? YES : NO;
        [self.tableView reloadData];
    }];
}

- (void)getContacts:(void (^)(NSArray * contacts, NSError * error))completion
{
    if ( !_contactStore )
          _contactStore = [[CNContactStore alloc] init];
    
    NSError * _contactError = [NSError errorWithDomain:@"WCSContactsErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Not authorized to access Contacts."}];
    
    switch ( [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] )
    {
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted: {
            if ( [self.delegate respondsToSelector:@selector(picker:didFailToAccessContacts:)] )
                 [self.delegate picker:self didFailToAccessContacts:_contactError];
            completion(nil, _contactError);
            break;
        }
        case CNAuthorizationStatusNotDetermined:
        {
            [_contactStore requestAccessForEntityType:CNEntityTypeContacts
                                    completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                        if ( ! granted ) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                completion(nil, _contactError);
                                            });
                                        }
                                        else
                                            [self getContacts:completion];
                                    }];
            break;
        }
            
        case CNAuthorizationStatusAuthorized:
        {
            NSMutableArray * _contactsTemp = [NSMutableArray new];
            CNContactFetchRequest * _contactRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self contactKeys]];
            [_contactStore enumerateContactsWithFetchRequest:_contactRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                [_contactsTemp addObject:contact];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(_contactsTemp, nil);
            });
            break;
        }
    }
}

- (UIImage*)contactImage:(UIImage*)original
{
    if ( original == nil )
         original = [UIImage imageNamed:@"contact-image-none"];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 60), NO, [UIScreen mainScreen].scale);
    
    UIBezierPath* clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, 60, 60), 0.5,0.5)];
    [clipPath addClip];
    
    [original drawInRect:CGRectMake(0, 0, 60, 60)];
    
    UIImage * renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return renderedImage;
}

- (Contact*)personFromContact:(CNContact*)contact
{
    Contact * _contact = [Contact new];
    /*
     <CNContact: 0x7f8e53534fb0: identifier=0A8D6C61-3D32-4001-AFE9-29EC1F9CD6AC, givenName=John, familyName=Appleseed, organizationName=, phoneNumbers=(
     "<CNLabeledValue: 0x7f8e53538470: identifier=7558D0EC-EC30-4DBD-A880-E9D5BCCA4361, label=_$!<Mobile>!$_, value=<CNPhoneNumber: 0x7f8e53538a10: countryCode=us, digits=8885555512>>",
     "<CNLabeledValue: 0x7f8e5358efa0: identifier=A012C265-FF72-47E4-9DDA-5330699B1034, label=_$!<Home>!$_, value=<CNPhoneNumber: 0x7f8e5355b150: countryCode=us, digits=8885551212>>"
     ), emailAddresses=(
     "<CNLabeledValue: 0x7f8e53538380: identifier=E58988F0-02AB-439A-8DF4-70DDA520016A, label=_$!<Work>!$_, value=John-Appleseed@mac.com>"
     ), postalAddresses=(
     "<CNLabeledValue: 0x7f8e5353c990: identifier=46402008-1878-43A4-A3FD-EDE315B5D616, label=_$!<Work>!$_, value=<CNPostalAddress: 0x7f8e5353cae0: street=3494 Kuhl Avenue, city=Atlanta, state=GA, postalCode=30303, country=USA, countryCode=ca, formattedAddress=(null)>>",
     "<CNLabeledValue: 0x7f8e5353cba0: identifier=7CD0A2D0-F7E1-4A80-933B-B4447BB4F041, label=_$!<Home>!$_, value=<CNPostalAddress: 0x7f8e5353cbe0: street=1234 Laurel Street, city=Atlanta, state=GA, postalCode=30303, country=USA, countryCode=us, formattedAddress=(null)>>"
     )>
     */
    _contact.photo = [self contactImage:[UIImage imageWithData:contact.imageData]];
    _contact.thumb = [self contactImage:[UIImage imageWithData:contact.thumbnailImageData]];
    _contact.firstname = contact.givenName;
    _contact.lastname = contact.familyName;
    _contact.nickname = contact.nickname;
    _contact.company = contact.organizationName;
    _contact.birthday = contact.birthday != nil ? [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:contact.birthday] : [NSDate date];
    
    if ( contact.phoneNumbers.count )
    {
        NSMutableArray * _tempPhones = [NSMutableArray new];
        for ( CNLabeledValue * _contactPhone in contact.phoneNumbers ) {
            CNPhoneNumber * _phoneNumber = _contactPhone.value;
            [_tempPhones addObject:_phoneNumber.stringValue];
        }
        _contact.phones = _tempPhones;
    }
    
    if ( contact.emailAddresses.count )
    {
        NSMutableArray * _tempEmails = [NSMutableArray new];
        for ( CNLabeledValue * _contactEmail in contact.emailAddresses )
            [_tempEmails addObject:_contactEmail.value];
        _contact.emails = _tempEmails;
    }
    
    if ( contact.postalAddresses.count )
    {
        CNLabeledValue * _contactAddress = contact.postalAddresses[0];
        CNPostalAddress * _address = _contactAddress.value;
        _contact.street1 = _address.street;
        _contact.city = _address.city;
        _contact.state = _address.state;
        _contact.zip = _address.postalCode;
        _contact.country = _address.country;
    }
    
    if ( contact.urlAddresses.count )
    {
        NSMutableArray * _tempUrls = [NSMutableArray new];
        for ( CNLabeledValue * _contactUrl in contact.urlAddresses )
            [_tempUrls addObject:_contactUrl.value];
        _contact.urls = _tempUrls;
    }
    
    return _contact;
}

- (NSArray*)contactKeys
{
    return @[CNContactNamePrefixKey,
             CNContactGivenNameKey,
             CNContactMiddleNameKey,
             CNContactFamilyNameKey,
             CNContactPreviousFamilyNameKey,
             CNContactNameSuffixKey,
             CNContactNicknameKey,
             CNContactPhoneticGivenNameKey,
             CNContactPhoneticMiddleNameKey,
             CNContactPhoneticFamilyNameKey,
             CNContactOrganizationNameKey,
             CNContactDepartmentNameKey,
             CNContactJobTitleKey,
             CNContactBirthdayKey,
             CNContactNonGregorianBirthdayKey,
             CNContactNoteKey,
             CNContactImageDataKey,
             CNContactThumbnailImageDataKey,
             CNContactImageDataAvailableKey,
             CNContactTypeKey,
             CNContactPhoneNumbersKey,
             CNContactEmailAddressesKey,
             CNContactPostalAddressesKey,
             CNContactDatesKey,
             CNContactUrlAddressesKey,
             CNContactRelationsKey,
             CNContactSocialProfilesKey,
             CNContactInstantMessageAddressesKey];
}

#pragma mark IBActions

- (IBAction)cancel:(id)sender {
    if ( [self.delegate respondsToSelector:@selector(didCancelContactSelection)] )
         [self.delegate didCancelContactSelection];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count ? _contacts.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _contacts.count )
    {
        static NSString *CellIdentifier = @"ContactCell";
        ContactCell * cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray  *nib = [[NSBundle  mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        Contact * _contact = [self personFromContact:(CNContact*)_contacts[indexPath.row]];
        cell.thumbnail = _contact.thumb;
        cell.displayName = _contact.displayName;
        cell.phoneNumber = _contact.phones[0];
        cell.emailAddress = _contact.emails[0];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if ( cell ) cell = nil;
        if ( ! cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if ( _contactsError )
        {
            cell.textLabel.text = NSLocalizedString(@"Contacts Error", nil);
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = NSLocalizedString(@"Enable Contacts under iOS Settings -> Privacy -> Contacts.", nil);
        }
        else
        {
            cell.textLabel.text = NSLocalizedString(@"No Contacts", nil);
            cell.detailTextLabel.numberOfLines = 1;
            cell.detailTextLabel.text = NSLocalizedString(@"There are no Contacts available.", nil);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _contacts.count )
    {
        if ( [self.delegate respondsToSelector:@selector(picker:didSelectContact:)] )
             [self.delegate picker:self didSelectContact:[self personFromContact:(CNContact*)_contacts[indexPath.row]]];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        if ( _contactsError ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            /* There is no need to compare address ti NULL pointer since COntacts are only available in iOS 9.
                (&UIApplicationOpenSettingsURLString != NULL)
             */
        }
    }
}
 
@end
