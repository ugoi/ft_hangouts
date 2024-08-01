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
    @State private var toolbarColor: Color = Color.red
    @State private var toolbarVisibility: Visibility = Visibility.hidden

    init(modelContext: ModelContext) {
        let manager = ContactsManager(context: modelContext)
        _manager = StateObject(wrappedValue: manager)
    }

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack(alignment: .leading) {
                List {
                    ForEach(manager.contacts) { contact in
                        NavigationLink(value: DatabaseTabOption.contactDetailView(id: contact.id)) {
                            Text("\(contact.firstName ?? "")")
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .navigationTitle("Contacts")
                .toolbarBackground(toolbarColor, for: .navigationBar)
                .toolbarBackground(toolbarVisibility, for: .navigationBar)
                .listStyle(PlainListStyle())
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: DatabaseTabOption.createContactView) {
                            Image(systemName: "plus")
                        }
                    }

                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button(action: {
                                toolbarVisibility = .hidden
                            }) {
                                Text("Default")
                            }
                            Button(action: {
                                toolbarVisibility = .visible
                                toolbarColor = .green
                            }) {
                                Text("Green")
                            }
                            Button(action: {
                                toolbarVisibility = .visible
                                toolbarColor = .red
                            }) {
                                Text("Red")
                            }

                        } label: {
                            Label(title: { Text("Menu") }, icon: { Image(systemName: "slider.horizontal.3") })
                        }
                    }
                }
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
