//
//  DeviceContactStore.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts

/// A store that manages fetching contacts from the device with permission handling.
class DeviceContactStore: ListStore {
    
    // MARK: Properties
    
    private(set) var storeKey: any StoreType
    
    private let permissionManager: Permission
    private let contactStore: ContactStoreProtocol
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceContactStore` instance to fetch contacts.
    ///
    /// - Parameters:
    ///    - permissionManager: An object conforming to `PermissionProtocol` for handling permission requests.
    ///    - contactStore: The object conforming to `ContactStoreProtocol` used to fetch and manage contacts.
    init(permissionManager: Permission,
         contactStore: ContactStoreProtocol) {
        self.storeKey = InternalType.contact
        self.permissionManager = permissionManager
        self.contactStore = contactStore
    }
    
    // MARK: Store methods
    
    /// Fetches a list of contacts, respecting the given offset and limit. Requests permission before fetching.
    /// - Parameters:
    ///   - offset: The starting index for fetching contacts.
    ///   - limit: The maximum number of contacts to fetch.
    ///   
    /// - Returns:
    ///   - Asynchronously returns array of contacts
    func fetchList(offset: Int, limit: Int) async throws -> [Any] {
        try await self.permissionManager.requestPermission()
        
        do {
            let keysToFetch = [CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey,
                               CNContactEmailAddressesKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            var contacts: [ContactItem] = []
            var contactsCount = 0
            try self.contactStore.enumerateContacts(with: request) { contact, stop in
                
                // Pagination logic to stop once the offset and limit are met.
                if contacts.count >= limit {
                    stop.pointee = true
                }
                else if contactsCount < offset {
                    contactsCount += 1
                }
                else if contacts.count + contactsCount >= offset {
                    
                    // Creating the ContactItem based on contact details.
                    let identifier = contact.identifier
                    let fullName = "\(contact.givenName) \(contact.familyName)"
                    let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
                    let emails = contact.emailAddresses.map { $0.value as String }
                    
                    let contactItem = ContactItem(id: identifier,
                                                  title: fullName,
                                                  phoneNumbers: phoneNumbers,
                                                  emails: emails)
                    contacts.append(contactItem)
                }
            }
            
            return contacts
        }
        catch {
            throw StoreError.fetchFailed("Failed to fetch contacts.")
        }
    }
}
