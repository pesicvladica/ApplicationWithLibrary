//
//  ContactItem.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A model representing a contact item with phone numbers and emails.
public struct ContactItem: Item {
    public var id: String
    public var title: String

    public var phoneNumbers: [String]
    public var emails: [String]
}
