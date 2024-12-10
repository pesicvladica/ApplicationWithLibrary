//
//  DeviceContactStore.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts

/// A store that manages fetching contacts from the device with permission handling.
class DeviceContactStore: Store {
    
    // MARK: Properties
    
    private(set) var storeKey: StoreKey
    
    private let permissionManager: Permission
    private let contactStore: CNContactStore
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceContactStore` instance to fetch contacts.
    ///
    /// - Parameters:
    ///    - permissionManager: An object conforming to `PermissionProtocol` for handling permission requests (defaults to `ContactPermissionManager`).
    ///    - contactStore: The object used to fetch and manage contacts (defaults to `CNContactStore`).
    init(permissionManager: Permission = ContactPermissionManager(),
         contactStore: CNContactStore = CNContactStore()) {
        
        self.storeKey = StoreKey.contact
        self.permissionManager = permissionManager
        self.contactStore = contactStore
    }
    
    // MARK: Store methods
    
    /// Fetches a list of contacts, respecting the given offset and limit. Requests permission before fetching.
    /// - Parameters:
    ///   - offset: The starting index for fetching contacts.
    ///   - limit: The maximum number of contacts to fetch.
    func fetchList(offset: Int = 0, limit: Int = 0) async throws -> [Any] {
        do {
            try await self.permissionManager.requestPermission()
        }
        catch (let error) {
            throw error
        }
        
        do {
            let keysToFetch = [CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey,
                               CNContactEmailAddressesKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            var contacts: [ContactItem] = []
            var contactsCount = 0
            try self.contactStore.enumerateContacts(with: request) { contact, stop in
                
                // Increase counter until element on offset index is reached
                while contactsCount < offset {
                    contactsCount += 1
                }
                
                // Pagination logic to stop once the offset and limit are met.
                if contacts.count >= limit {
                    stop.pointee = true
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
    
    // MARK: Unsupported methods
    
    func fetchItem() async throws -> Any {
        throw StoreError.methodNotSupported("\(type(of: self))", #function)
    }
    
    func stream() -> AsyncThrowingStream<Any, Error> {
        AsyncThrowingStream {
            throw StoreError.methodNotSupported("\(type(of: self))", #function)
        }
    }
}
