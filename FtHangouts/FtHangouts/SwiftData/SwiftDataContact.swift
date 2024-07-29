//
//  SwiftDataContacts.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 13.07.2024.
//

import Foundation
import SwiftData

@Model
class SwiftDataContact: Identifiable {
    var id: UUID
    var firstName: String?
    var lastName: String?
    var imageName: String?
    var mobile: String?
    var email: String?
    var address: SwiftDataAddress?
    var relationship: String?
    var birthday: Date?

    init(id: UUID, firstName: String? = nil, lastName: String? = nil, imageName: String? = nil, mobile: String? = nil, email: String? = nil, address: SwiftDataAddress? = nil, relationship: String? = nil, birthday: Date? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageName = imageName
        self.mobile = mobile
        self.email = email
        self.address = address
        self.relationship = relationship
        self.birthday = birthday
    }

    static func fromContact(contact: Contact) -> SwiftDataContact {
        var swiftDataAddress: SwiftDataAddress?

        if let address = contact.address {
            swiftDataAddress = SwiftDataAddress(street: address.street, city: address.city, country: address.country)
        }

        return SwiftDataContact(id: contact.id, firstName: contact.firstName, lastName: contact.lastName, imageName: contact.imageName, mobile: contact.mobile, email: contact.email, address: swiftDataAddress, relationship: contact.relationship, birthday: contact.birthday)
    }

    func toContact(onUpdate: @escaping ((UUID, Contact) -> Void), onDelete: @escaping ((UUID) -> Void)) -> Contact {
        var contactAddress: Address?

        if let address = address {
            contactAddress = Address(street: address.street, city: address.city, country: address.country)
        }

        return Contact(id: id, firstName: firstName, lastName: lastName, imageName: imageName, mobile: mobile, email: email, address: contactAddress, relationship: relationship, birthday: birthday, onUpdate: onUpdate, onDelete: onDelete)
    }
}

struct SwiftDataAddress: Codable {
    let street: String
    let city: String
    let country: String

    init(street: String, city: String, country: String) {
        self.street = street
        self.city = city
        self.country = country
    }
}
