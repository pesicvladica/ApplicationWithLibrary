//
//  MockContacts.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts
@testable import Motiv8Library

// MARK: - Mock Implementations

// Mock for CNContact
class MockContact: CNContact {
    
    override var identifier: String {
        return mID
    }
    
    override var givenName: String {
        return mGN
    }
    
    override var familyName: String {
        return mFN
    }
    
    override var phoneNumbers: [CNLabeledValue<CNPhoneNumber>] {
        var pNumbers = [CNLabeledValue<CNPhoneNumber>]()
        for pn in mPN {
            let number = CNLabeledValue(label: "Phone Number", value: CNPhoneNumber(stringValue: pn))
            pNumbers.append(number)
        }
        return pNumbers
    }
    
    override var emailAddresses: [CNLabeledValue<NSString>] {
        var pEmails = [CNLabeledValue<NSString>]()
        for pe in mEA {
            let email = CNLabeledValue(label: "Email", value: pe as NSString)
            pEmails.append(email)
        }
        return pEmails
    }
    
    private let mID: String
    private let mGN: String
    private let mFN: String
    private let mPN: [String]
    private let mEA: [String]
    
    init(index: Int) {
        self.mID = "\(index)"
        self.mGN = "Name\(index)"
        self.mFN = "Surname\(index)"
        self.mPN = ["Phone1\(index)","Phone2\(index)","Phone3\(index)"]
        self.mEA = ["Email1\(index)","Email1\(index)","Email1\(index)"]
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Mock for CNContactStore
class MockCNContactStore: CNContactStore {
    
    var contactsToReturn: [CNContact] = []
    
    func generateContacts(_ count: Int = 1) {
        var contacts = [MockContact]()
        for i in 1..<(count + 1) {
            contacts.append(MockContact(index: i))
        }
        contactsToReturn = contacts
    }
    
    override func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        var stop: ObjCBool = false
        for contact in contactsToReturn {
            block(contact, &stop)
            if stop.boolValue { break }
        }
    }
}
