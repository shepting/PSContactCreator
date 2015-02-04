ABContactHelper
===============

Objective-C Address Book wrapper. Provides functionality to create/update/delete contacts from the device address book.

```objective-c
#import "ABContactsHelper.h"

// Array of all contacts
NSArray *contacts = [ABContactsHelper contacts];

// Create a new contact
ABContact *contact = [ABContact contact];
contact.firstName = @"Jim";
contact.lastName = @"Thompson";

```

### Demo App 

Contains a demo app which shows listing, adding, and removing contacts from the device address book.

![Screenshot](https://raw.github.com/shepting/ABContactHelper/clearer_code_layout/Demo/Address-Book-Demo-App.png)
