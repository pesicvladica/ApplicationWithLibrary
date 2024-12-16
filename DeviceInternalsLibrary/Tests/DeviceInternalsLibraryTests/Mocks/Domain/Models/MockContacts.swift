//
//  MockContact.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import Contacts

// Mock for CNContact
class MockContact: CNContact {
    
    override var identifier: String {
        return contactID
    }
    
    override var givenName: String {
        return contactName
    }
    
    override var familyName: String {
        return contactSurname
    }
    
    override var phoneNumbers: [CNLabeledValue<CNPhoneNumber>] {
        var pNumbers = [CNLabeledValue<CNPhoneNumber>]()
        for pn in contactPhones {
            let number = CNLabeledValue(label: "Phone Number", value: CNPhoneNumber(stringValue: pn))
            pNumbers.append(number)
        }
        return pNumbers
    }
    
    override var emailAddresses: [CNLabeledValue<NSString>] {
        var pEmails = [CNLabeledValue<NSString>]()
        for pe in contactEmails {
            let email = CNLabeledValue(label: "Email", value: pe as NSString)
            pEmails.append(email)
        }
        return pEmails
    }
    
    private let contactID: String
    private let contactName: String
    private let contactSurname: String
    private let contactPhones: [String]
    private let contactEmails: [String]
    
    init(index: Int) {
        self.contactID = "\(index)"
        self.contactName = "Name\(index)"
        self.contactSurname = "Surname\(index)"
        self.contactPhones = ["Phone1\(index)","Phone2\(index)","Phone3\(index)"]
        self.contactEmails = ["Email1\(index)","Email1\(index)","Email1\(index)"]
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
