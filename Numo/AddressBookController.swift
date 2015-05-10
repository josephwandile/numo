//
//  AddressBookController.swift
//  


import Foundation
import AddressBook
import AddressBookUI

class AddressBookController {
    var addressBook: ABAddressBookRef?
    init() {
        
    }
    func createAddressBook() {
        var error: Unmanaged<CFError>?
        
        addressBook = ABAddressBookCreateWithOptions(nil,
            &error).takeRetainedValue()
        
        /* You can use the address book here */
        
    }
    
    class func newPersonWithFirstName(firstName: String,
        lastName: String, emailAddress: String, phoneNumber: String,
        inAddressBook: ABAddressBookRef) -> ABRecordRef?{
            
            let person: ABRecordRef = ABPersonCreate().takeRetainedValue()
            
            let couldSetFirstName = ABRecordSetValue(person,
                kABPersonFirstNameProperty,
                firstName as CFTypeRef,
                nil)
            
            let couldSetLastName = ABRecordSetValue(person,
                kABPersonLastNameProperty,
                lastName as CFTypeRef,
                nil)
            
            // deal with email address
            let emails: ABMutableMultiValue = ABMultiValueCreateMutable(UInt32(kABMultiStringPropertyType)).takeUnretainedValue()
            ABMultiValueAddValueAndLabel(emails, emailAddress, kABOtherLabel, nil);
            ABRecordSetValue(person, kABPersonEmailProperty, emails, nil)
            
            // deal with phone number
            let phones: ABMutableMultiValue = ABMultiValueCreateMutable(UInt32(kABMultiStringPropertyType)).takeUnretainedValue()
            ABMultiValueAddValueAndLabel(phones, phoneNumber, kABPersonPhoneMobileLabel, nil);
            ABRecordSetValue(person, kABPersonPhoneProperty, phones, nil)
            
            var error: Unmanaged<CFErrorRef>? = nil
            
            let couldAddPerson = ABAddressBookAddRecord(inAddressBook, person, &error)
            
            if couldAddPerson{
                println("Successfully added the person.")
            } else {
                println("Failed to add the person.")
                return nil
            }
            
            if ABAddressBookHasUnsavedChanges(inAddressBook){
                
                var error: Unmanaged<CFErrorRef>? = nil
                let couldSaveAddressBook = ABAddressBookSave(inAddressBook, &error)
                
                if couldSaveAddressBook{
                    println("Successfully saved the address book.")
                } else {
                    println("Failed to save the address book.")
                }
            }
            
            if couldSetFirstName && couldSetLastName{
                println("Successfully set the first name " +
                    "and the last name of the person")
            } else {
                println("Failed to set the first name and/or " +
                    "the last name of the person")
            }
            
            return person
            
    }
    
    class func addToContact(user: PFObject) /* return user object for history view controller */ {
        
        // extract data from object
        var first = user["first_name"] as String
        var last = user["last_name"] as String
        var email = user["email_address"] as String
        var number = user["number"] as String
        // var description = user["description"] as String
        
        // use newPersonWithFirstName to add to address book
        let abController = AddressBookController()
        abController.createAddressBook()
        newPersonWithFirstName(first, lastName: last, emailAddress: email, phoneNumber: number, inAddressBook: abController.addressBook!)
        
        // get transaction date
        /*
        var date = NSDate()
        var formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.stringFromDate(date)
        */
        
        // get address of transfer location
        
    }
    
}