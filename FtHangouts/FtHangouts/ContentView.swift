//
//  ContentView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 05.07.2024.
//

import SwiftData
import SwiftUI

enum DatabaseTabOption: Hashable, Codable {
    case createContactView, editContactView(id: UUID), contactDetailView(id: UUID)
}

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

                    NavigationLink(value: DatabaseTabOption.createContactView) {
                        Image(systemName: "plus")
                    }
                }

                List {
                    ForEach(manager.contacts) { contact in
                        NavigationLink(value: DatabaseTabOption.contactDetailView(id: contact.id)) {
                            Text("\(contact.firstName ?? "")")
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .navigationDestination(for: DatabaseTabOption.self, destination: { value in
                    switch value {
                    case .createContactView:
                        CreateContactView(contactsManager: manager)
                    case let .contactDetailView(id):
                        ContactDetailView(
                            contact: manager.contacts.first(where: { $0.id == id })!)
                    case let .editContactView(id: id):
                        EditContactView(contact: manager.contacts.first(where: { $0.id == id })!)
                    }
                })
            }
            .padding(.horizontal, 20.0)
        }
    }
}

#Preview {
    ContentView(modelContext: (try! ModelContainer(for: SwiftDataContact.self)).mainContext)
        .environmentObject(NavigationManager())
}
