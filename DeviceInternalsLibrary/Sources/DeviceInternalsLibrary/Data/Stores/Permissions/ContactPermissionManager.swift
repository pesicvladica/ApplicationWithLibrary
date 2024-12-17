//
//  ContactPermissionManager.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts

// MARK: - Utility for Contacts Permissions

/// A permission manager for handling contact access.
class ContactPermissionManager: Permission {
    
    private var contactStore: ContactStoreProtocol
    init(contactStore: ContactStoreProtocol) {
        self.contactStore = contactStore
    }
    
    /// Requests authorization for contact list access.
    private func requestContactsListAuthorization() async -> (granted: Bool, error: Error?) {
        await withCheckedContinuation { continuation in
            contactStore.requestAccess(for: .contacts) { granted, error in
                continuation.resume(returning: (granted, error))
            }
        }
    }
    
    /// Requests permission to access contacts.
    func requestPermission() async throws {
        let status = await requestContactsListAuthorization()
        
        if !status.granted {
            throw StoreError.accessDenied(status.error?.localizedDescription ?? "Access to contacts was denied.")
        }
    }
}
