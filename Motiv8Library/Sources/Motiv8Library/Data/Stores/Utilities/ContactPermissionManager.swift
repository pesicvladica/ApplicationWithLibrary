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
class ContactPermissionManager: PermissionProtocol {
    
    /// Requests permission to access contacts. Calls the completion handler with either success or failure.
    /// - Parameter completion: A closure that returns a success or failure result based on permission request.
    func requestPermission(completion: @escaping (Result<Void, Error>) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            // If granted, return success. If not, return failure with an error description.
            granted ?
            completion(.success(())) :
            completion(.failure(StoreError.accessDenied(error?.localizedDescription ?? "Access to contacts was denied.")))
        }
    }
}
