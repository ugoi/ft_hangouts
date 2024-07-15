//
//  Contact.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 11.07.2024.
//

import Foundation
import SwiftData

class Contact: Identifiable, Hashable {
    var onUpdate: ((UUID, Contact) -> Void)?
    var onDelete: ((UUID) -> Void)?

    var id: UUID
    var firstName: String?
    var lastName: String?
    var imageName: String?
    var mobile: String?
    var email: String?
    var address: Address?
    var relationship: String?
    var birthday: Date?

    init(id: UUID, firstName: String? = nil, lastName: String? = nil, imageName: String? = nil, mobile: String? = nil, email: String? = nil, address: Address? = nil, relationship: String? = nil, birthday: Date? = nil, onUpdate: ((UUID, Contact) -> Void)? = nil, onDelete: ((UUID) -> Void)? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageName = imageName
        self.mobile = mobile
        self.email = email
        self.address = address
        self.relationship = relationship
        self.birthday = birthday
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }

    // Update a contact
    func update(newContact: Contact) {
        if let onUpdate = onUpdate {
            onUpdate(id, newContact)
        }
    }

    // Delete a contact
    func delete() {
        if let onDelete = onDelete {
            onDelete(id)
        }
    }

    // Manually implement Equatable
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.imageName == rhs.imageName &&
            lhs.mobile == rhs.mobile &&
            lhs.email == rhs.email &&
            lhs.address == rhs.address &&
            lhs.relationship == rhs.relationship &&
            lhs.birthday == rhs.birthday
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(imageName)
        hasher.combine(mobile)
        hasher.combine(email)
        hasher.combine(address)
        hasher.combine(relationship)
        hasher.combine(birthday)
    }
}

class Address: Hashable {
    let street: String
    let city: String
    let country: String

    init(street: String, city: String, country: String) {
        self.street = street
        self.city = city
        self.country = country
    }

    // Manually implement Equatable
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.street == rhs.street &&
            lhs.city == rhs.city &&
            lhs.country == rhs.country
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(street)
        hasher.combine(city)
        hasher.combine(country)
    }
}
