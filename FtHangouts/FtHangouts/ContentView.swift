//
//  ContentView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 05.07.2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var manager: ContactsManager
    @EnvironmentObject var navigationManager: NavigationManager
    @Query private var swiftDataContacts: [SwiftDataContact]

    init(modelContext: ModelContext) {
        let manager = ContactsManager(context: modelContext)
        _manager = StateObject(wrappedValue: manager)
    }

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Contacts")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    NavigationLink(destination: CreateContactView(contactsManager: manager)) {
                        Image(systemName: "plus")
                    }
                }

                List {
                    ForEach(manager.contacts) { contact in
                        NavigationLink(value: contact) {
                            Text("\(contact.firstName ?? "")")
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
            }
            .padding(.horizontal, 20.0)
        }
        .onAppear {
        }
    }
}

#Preview {
    ContentView(modelContext: (try! ModelContainer(for: SwiftDataContact.self)).mainContext)
        .environmentObject(NavigationManager())
}
