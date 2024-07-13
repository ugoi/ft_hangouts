//
//  ContentView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 05.07.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = ContactsManager()
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack(alignment: .leading) {
                Text("Contacts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                List {
                    ForEach(manager.contacts) { contact in
                        NavigationLink(value: contact) {
                            Text("\(contact.name)")
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .navigationDestination(for: Contact.self) { contact in
                    VStack {
                        ContactDetailView(
                            contactsManager: manager, contact: $manager.contacts.first(where: { $0.id == contact.id })!)
                    }
                }

                Button(action: {
                    if let index = manager.contacts.firstIndex(where: { $0.id == manager.contacts[1].id }) {
                        manager.contacts.remove(at: index)
                    }
                }) {
                    Text("Delete Aaron")
                }
            }
            .padding(.horizontal, 20.0)
        }
        .onAppear {
            manager.loadContacts()
        }
    }
}

#Preview {
    ContentView()
}
