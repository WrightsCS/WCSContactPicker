WCSContactPicker
===========

iOS 9 Contact picker — Apples replacement for the AddressBook framework.

![enter image description here](https://raw.githubusercontent.com/WrightsCS/WCSContactPicker/master/screens/screen-1.png) ![enter image description here](https://raw.githubusercontent.com/WrightsCS/WCSContactPicker/master/screens/screen-2.png) ![enter image description here](https://raw.githubusercontent.com/WrightsCS/WCSContactPicker/master/screens/screen-3.png)

Requirements
------------

Requires **iOS 9,** the `ContactsUI.framework` and `Contacts.framework`.


Usage
------------

1. Include `WCSContactPicker` in your project and import the header file.
2. Create an instance of `WCSContactPicker` and present a navigation controller.
3. Receive delegate call back with a `Contact` object.

>     #import "WCSContactPicker.h"
>     @interface ViewController () <WCSContactPickerDelegate>
>     @end
>     
>     WCSContactPicker * _picker = [[WCSContactPicker alloc] initWithDelegate:self];
>     UINavigationController * controller = [[UINavigationController alloc] initWithRootViewController:_picker];
>     [self presentViewController:controller animated:YES completion:NULL];

Delegate
------------

Use the delegate callbacks for receive information about authorization, get a generic `Contact` object or be informed if the user simply cancels Contact selection.

```objc
- (void)picker:(WCSContactPicker*)picker didSelectContact:(Contact*)contact;
- (void)picker:(WCSContactPicker*)picker didFailToAccessContacts:(NSError*)error;
- (void)didCancelContactSelection;
```

Contact Object
------------

This object contains simple to access basic Contact information from `CNContact` such as the First, Last, Nick, Phones, Email, Urls, etc.

@WrightsCS
------------

Comments and feedback are welcome. Let me know if you contribute, find any bugs, have suggestions, etc. 
Twitter: @WrightsCS
http://www.wrightscsapps.com 
