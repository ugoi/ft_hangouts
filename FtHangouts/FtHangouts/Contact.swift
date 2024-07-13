//
//  Contact.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 11.07.2024.
//

import Foundation

struct Contact: Identifiable, Hashable {
    var onUpdate: (UUID, Contact) -> Void
    var onDelete: (UUID) -> Void

    var id: UUID
    var name: String
    var imageName: String?
    var mobile: String?
    var email: String?
    var address: Address?
    var relationship: String?
    var birthday: Date?

    init(id: UUID, name: String, imageName: String? = nil, mobile: String? = nil, email: String? = nil, address: Address? = nil, relationship: String? = nil, birthday: Date? = nil, onUpdate: @escaping (UUID, Contact) -> Void, onDelete: @escaping (UUID) -> Void) {
        self.id = id
        self.name = name
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
        onUpdate(id, newContact)
    }
    
    // Delete a contact
    func delete() {
        onDelete(self.id)
    }

    // Manually implement Equatable
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
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
        hasher.combine(name)
        hasher.combine(imageName)
        hasher.combine(mobile)
        hasher.combine(email)
        hasher.combine(address)
        hasher.combine(relationship)
        hasher.combine(birthday)
    }
}

struct Address: Hashable {
    let street: String
    let city: String
    let country: String
}
