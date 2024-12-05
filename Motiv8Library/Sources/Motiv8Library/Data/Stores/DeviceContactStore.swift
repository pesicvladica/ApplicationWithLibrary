//
//  DeviceContactStore.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts

/// A store that manages fetching contacts from the device with permission handling.
class DeviceContactStore: Store<ContactItem> {

    // MARK: Properties
    
    private let permissionManager: PermissionProtocol
    private let contactStore: CNContactStore
    
    // MARK: Initialization
    
    /// Initializes a new `DeviceContactStore` instance to fetch contacts.
    ///
    /// - Parameters:
    ///    - permissionManager: An object conforming to `PermissionProtocol` for handling permission requests (defaults to `ContactPermissionManager`).
    ///    - contactStore: The object used to fetch and manage contacts (defaults to `CNContactStore`).
    init(permissionManager: PermissionProtocol = ContactPermissionManager(),
         contactStore: CNContactStore = CNContactStore()) {
        
        self.permissionManager = permissionManager
        self.contactStore = contactStore
    }
    
    // MARK: Store<> methods
    
    /// Fetches a list of contacts, respecting the given offset and limit. Requests permission before fetching.
    /// - Parameters:
    ///   - offset: The starting index for fetching contacts.
    ///   - limit: The maximum number of contacts to fetch.
    ///   - onCompletion: A closure that returns a success or failure result with the list of contacts.
    override func fetchList(offset: Int = 0, limit: Int = 0, _ onCompletion: @escaping (Result<[ContactItem], Error>) -> Void ) {
        self.permissionManager.requestPermission { [weak self] result in
            guard let self else {
                onCompletion(.failure(StoreError.fetchFailed("Unexpected error.")))
                return
            }
            
            switch result {
            case .success():

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
                    
                    onCompletion(.success(contacts))
                }
                catch {
                    onCompletion(.failure(StoreError.fetchFailed("Failed to fetch contacts.")))
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}
