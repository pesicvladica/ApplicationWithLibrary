//
//  ContactStoreProtocol.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation
import Contacts

public protocol ContactStoreProtocol {
    func requestAccess(for entityType: CNEntityType, 
                       completionHandler: @escaping (Bool, Error?) -> Void)
    func enumerateContacts(with fetchRequest: CNContactFetchRequest, 
                           usingBlock: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws
}

extension CNContactStore: ContactStoreProtocol {}
