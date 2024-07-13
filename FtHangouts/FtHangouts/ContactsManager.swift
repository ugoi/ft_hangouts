//
//  ContactsManager.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 10.07.2024.
//

import Foundation

class ContactsManager: ObservableObject {
    // Array to store contacts
    @Published var contacts: [Contact] = []

    init() {
        loadContacts()
    }

    func loadContacts() {
        contacts = [
            .init(id: UUID(), name: "Aaron",
                  mobile: "+41 78 626 18 09",
                  email: "aaron@icloud.com",
                  address: Address(street: "Musterstrasse 12", city: "8047 Zürich", country: "Switzerland"),
                  relationship: "X-Classmate",
                  birthday: Date(),
                  onUpdate: updateContact,
                  onDelete: deleteContact

            ),
            .init(id: UUID(), name: "Ali",
                  mobile: "+41 78 626 18 08",
                  email: "ali@icloud.com",
                  address: Address(street: "Musterstrasse 12", city: "8047 Zürich", country: "Switzerland"),
                  relationship: "Example",
                  birthday: Date(),
                  onUpdate: updateContact,
                  onDelete: deleteContact
            ),
        ]
    }

    // Function to add a contact
    func createContact(contact: Contact) {
        contacts.append(contact)
    }

    // Update a contact
    func updateContact(id: UUID, newContact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == id }) {
            contacts[index] = newContact
        }
    }

    // Function to remove a contact
    func deleteContact(id: UUID) {
        if let index = contacts.firstIndex(where: { $0.id == id }) {
            contacts.remove(at: index)
        }
    }
}
