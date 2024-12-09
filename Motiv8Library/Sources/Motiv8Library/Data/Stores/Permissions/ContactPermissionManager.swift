//
//  ContactPermissionManager.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts

// MARK: - Utility for Contacts Permissions

/// A class that manages the permission request for contacts using the `CNContactStore` API.
class ContactPermissionManager: Permission {
    
    private func requestContactsListAuthorization() async -> (Bool, Error?) {
        await withCheckedContinuation { continuation in
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                continuation.resume(returning: (granted, error))
            }
        }
    }
    
    /// Requests permission to access contacts.
    func requestPermission() async throws {
        Task {
            let status = await requestContactsListAuthorization()
            
            if !status.0 {
                throw StoreError.accessDenied(status.1?.localizedDescription ?? "Access to contacts was denied.")
            }
        }
    }
}
