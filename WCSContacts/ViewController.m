//
//  ViewController.m
//  WCSContacts
//
//  Created by Aaron C. Wright on 9/14/15.
//  Copyright © 2015 Wrights Creative Services, L.L.C. All rights reserved.
//
//  aaron@wrightscs.com
//  http://www.wrightscs.com, http://www.wrightscsapps.com
//

#import "WCSContactPicker.h"
#import "ViewController.h"

@interface ViewController () <WCSContactPickerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * imageThumb;
@property (nonatomic, weak) IBOutlet UILabel * labelName, * labelPhone, * labelEmail;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods



#pragma mark IBActions

- (IBAction)selectContact:(id)sender {
    WCSContactPicker * _picker = [[WCSContactPicker alloc] initWithDelegate:self];
    UINavigationController * controller = [[UINavigationController alloc] initWithRootViewController:_picker];
    [self presentViewController:controller animated:YES completion:NULL];
}

#pragma mark - WCSContactPicker Delegates

- (void)didCancelContactSelection {
    NSLog(@"Canceled Contact Selection.");
}
- (void)picker:(WCSContactPicker *)picker didFailToAccessContacts:(NSError *)error {
    NSLog(@"Failed to Access Contacts: %@", error.description);
}
- (void)picker:(WCSContactPicker *)picker didSelectContact:(Contact *)contact {
    NSLog(@"Selected Contact: %@", contact.description);
    _imageThumb.image = contact.photo;
    _labelName.text = contact.displayName;
    _labelPhone.text = contact.phones[0];
    _labelEmail.text = contact.emails[0];
}

@end
