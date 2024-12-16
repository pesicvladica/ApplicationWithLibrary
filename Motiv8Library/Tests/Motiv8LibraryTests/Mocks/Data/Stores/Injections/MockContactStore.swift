//
//  MockCNContactStore.swift
//  
//
//  Created by Vladica Pesic on 12/13/24.
//

import Foundation
import Contacts
@testable import Motiv8Library

class MockCNContactStore: ContactStoreProtocol {
    
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
        func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void) {
            completionHandler(false, StoreError.accessDenied("Wrong permission requested"))
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
