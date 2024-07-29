//
//  ContactsManager.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 10.07.2024.
//

import Foundation
import SwiftData
import SwiftUI

class ContactsManager: ObservableObject {
    // Array to store contacts
    @Published var contacts: [Contact] = []
    public var context: ModelContext
    var swiftDataContacts = [SwiftDataContact]()

    init(context: ModelContext) {
        self.context = context
        loadContacts()
    }

    func loadContacts() {
        do {
            let descriptor = FetchDescriptor<SwiftDataContact>()
            swiftDataContacts = try context.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }

        if swiftDataContacts.isEmpty {
            contacts = []
        } else {
            contacts = swiftDataContacts.map { $0.toContact(onUpdate: updateContact, onDelete: deleteContact) }
        }
    }

    // Function to add a contact
    func createContact(contact: Contact) {
        let swiftDataContact = SwiftDataContact.fromContact(contact: contact)
        var newContact = swiftDataContact.toContact(onUpdate: updateContact, onDelete: deleteContact)
        contacts.append(newContact)
        context.insert(swiftDataContact)
        loadContacts()
    }

    // Update a contact
    func updateContact(id: UUID, newContact: Contact) {
        print("Update contact")
        if let index = contacts.firstIndex(where: { $0.id == id }) {
            var modifiedContact = newContact

            modifiedContact.onDelete = deleteContact
            modifiedContact.onUpdate = updateContact
            contacts[index] = modifiedContact
        }

        if let index = swiftDataContacts.firstIndex(where: { $0.id == id }) {
            swiftDataContacts[index].firstName = newContact.firstName
            swiftDataContacts[index].lastName = newContact.lastName
            swiftDataContacts[index].email = newContact.email
            swiftDataContacts[index].imageName = newContact.imageName
            swiftDataContacts[index].mobile = newContact.mobile
            swiftDataContacts[index].relationship = newContact.relationship

            if let address = newContact.address {
                swiftDataContacts[index].address = SwiftDataAddress(street: address.street, city: address.city, country: address.country)
            }
            swiftDataContacts[index].birthday = newContact.birthday
        }
    }

    // Function to remove a contact
    func deleteContact(id: UUID) {
        print("Delete Contact")
        print(id.uuidString)
        if let index = contacts.firstIndex(where: { $0.id == id }) {
            contacts.remove(at: index)
        }

        if let index = swiftDataContacts.firstIndex(where: { $0.id == id }) {
            context.delete(swiftDataContacts[index])
        }
    }
}
