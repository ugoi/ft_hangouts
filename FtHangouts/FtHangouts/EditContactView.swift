//
//  EditContactView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 10.07.2024.
//

import SwiftUI

struct EditContactView: View {
    @Binding var contact: Contact
    @ObservedObject var contactsManager: ContactsManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var name: String = ""
    // UI
    var body: some View {
        VStack {
            // Back Button and Edit Button
            VStack {
                HStack {
                    Button(action: {
                        // Action for back button
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancle")
                            .foregroundColor(.blue)
                            .padding(.horizontal, 11.0).padding(.vertical, 6)
                    }
                    Spacer()
                    Button(action: {
                        var newContact = contact
                        newContact.name = name
//                        contact = newContact
//                        contactsManager.updateContact(id: contact.id, newContact: newContact)
                        contact.update(newContact: newContact)
                        self.presentationMode.wrappedValue.dismiss()

                    }) {
                        Text("Done").fontWeight(.bold)
                            .foregroundStyle(.blue).padding(.horizontal, 11.0).padding(.vertical, 6)
                    }
                }

                // Profile Image and Name
                VStack(spacing: 13) {
                    Image("Avatar") // Replace with your image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 10)

                    VStack {
                        Text("Add photo")
                    }
                    .padding(.horizontal, 23.0)
                    .padding(.vertical, 8.0)
                    .background(Color("ButtonBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 13.0)
            .background(LinearGradient(gradient: Gradient(colors: [Color("ContactHeaderTop"), Color("ContactHeaderBottom")]), startPoint: .top, endPoint: .bottom))

            // Contact details
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    EditContactDetail(
                        labelText: Text("name"),
                        text: $name

                    ) {
                    }

//                    EditContactDetail(labelText: Text("mobile"), text: <#T##Binding<String>#>
//
//                    ) {
//                    }

//                    EditContactDetail(labelText: Text("email")
//                    ) {
//                    }
//
//                    EditContactDetail(labelText: Text("street")
//                    ) {
//                    }
//                    EditContactDetail(labelText: Text("city")
//                    ) {
//                    }
//
//                    EditContactDetail(labelText: Text("country")
//                    ) {
//                    }
//
//                    EditContactDetail(labelText: Text("relationship")
//                    ) {
//                    }
//
//                    EditContactDetail(labelText: Text("birthday")
//                    ) {
//                    }
//
                    DeleteContactButton(labelText: Text("delete")
                                        ,
                                        onDelete: {
//                                            contactsManager.deleteContact(id: contact.id)
                                            contact.delete()
                                            navigationManager.path.removeLast(navigationManager.path.count)
                                        }
                    ) {
                        Text("Delete Contact")
                            .foregroundStyle(Color.red)
                    }
                }

                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))
        }
    }

    // Logic
    func sendIMessage() {
        let phoneNumber = contact.mobile ?? ""

        if let url = URL(string: "sms:\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func call() {
        let phoneNumber = contact.mobile ?? ""

        if let url = URL(string: "tel:\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct EditContactView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = ContactsManager()
        manager.loadContacts()

        return EditContactView(
            contact: .constant(manager.contacts.first!), // Assuming you want to preview the first contact
            contactsManager: manager
        )
    }
}

struct EditContactDetail<Content: View>: View {
    var labelText: Text
    @Binding var text: String
    @ViewBuilder let content: Content

    var body: some View {
        Button(action: {
        }) {
            VStack(alignment: .leading) {
                TextField("\(labelText)", text: $text)
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)

//                if Content.self == EmptyView.self {
//                    labelText
//                        .foregroundStyle(Color("PlaceHolderText"))
//                } else {
//                    content
//                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 12.0)
            .background(Color("ContactDetail"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct DeleteContactButton<Content: View>: View {
    var labelText: Text
    var onDelete: (() -> Void)?
    @ViewBuilder let content: Content

    var body: some View {
        Button(action: { onDelete?() }) {
            VStack(alignment: .leading) {
                if Content.self == EmptyView.self {
                    labelText
                        .foregroundStyle(Color("PlaceHolderText"))
                } else {
                    content
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 12.0)
            .background(Color("ContactDetail"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
