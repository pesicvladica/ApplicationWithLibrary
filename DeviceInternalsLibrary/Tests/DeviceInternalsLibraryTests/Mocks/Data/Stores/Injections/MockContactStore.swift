//
//  MockCNContactStore.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import Contacts
@testable import DeviceInternalsLibrary

class MockCNContactStore: ContactStoreProtocol {
    
    var accessGranted: Bool = true
    var accessError: StoreError?
    
    var contactsToReturn: [CNContact] = []

    func generateContacts(_ count: Int = 1) {
        var contacts = [MockContact]()
        for i in 1..<(count + 1) {
            contacts.append(MockContact(index: i))
        }
        contactsToReturn = contacts
    }
    
    var shouldThrowError = false
    
    // MARK: ContactStoreProtocol
    
    func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void) {
        if !accessGranted {
            completionHandler(accessGranted, accessError)
        }
        else {
            completionHandler(accessGranted, nil)
        }
    }
    
    func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        if shouldThrowError {
            throw StoreError.fetchFailed("Some error")
        }
        
        var stop: ObjCBool = false
        for contact in contactsToReturn {
            block(contact, &stop)
            if stop.boolValue { break }
        }
    }
}
