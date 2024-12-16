//
//  ContactStoreProtocol.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Contacts

/// Protocol for accessing contact store operations.
public protocol ContactStoreProtocol {
    /// Requests access for a specific entity type.
    func requestAccess(for entityType: CNEntityType,
                       completionHandler: @escaping (Bool, Error?) -> Void)
    /// Enumerates contacts based on a fetch request.
    func enumerateContacts(with fetchRequest: CNContactFetchRequest,
                           usingBlock: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws
}

extension CNContactStore: ContactStoreProtocol {}
