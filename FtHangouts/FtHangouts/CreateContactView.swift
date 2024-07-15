//
//  CreateContactView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 10.07.2024.
//

import SwiftUI

struct CreateContactView: View {
    @ObservedObject var contactsManager: ContactsManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var details: [String: String] = ["firstName": "",
                                                    "lastName": "",
                                                    "mobile": "",
                                                    "email": "",
                                                    "street": "",
                                                    "city": "",
                                                    "country": "",
                                                    "relationship": "",
                                                    "birthday": "",
    ]

    // Define the order of the keys
    let keyOrder = ["firstName", "lastName", "mobile", "email", "street", "city", "country", "relationship", "birthday"]

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
                        let newContact = Contact(id: UUID(), firstName: details["firstName"], lastName: details["lastname"], mobile: details["mobile"], email: details["email"], address: Address(street: details["street"] ?? "", city: details["city"] ?? "", country: details["country"] ?? ""), relationship: details["relationship"] ?? ""
                        )
                        contactsManager.createContact(contact: newContact)
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
                    ForEach(Array(keyOrder), id: \.self) { key in
                        EditContactDetail(
                            labelText: Text(key),
                            text: self.binding(for: key)

                        ) {
                        }
                    }

//
                }

                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))
        }
    }

    private func binding(for key: String) -> Binding<String> {
        return .init(
            get: { self.details[key, default: ""] },
            set: { self.details[key] = $0 })
    }
}

// struct EditContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        let manager = ContactsManager()
//        manager.loadContacts()
//
//        return CreateContactView(
//            contact: .constant(manager.contacts.first!), // Assuming you want to preview the first contact
//            contactsManager: manager
//        )
//    }
// }

struct CreateContactDetail<Content: View>: View {
    var labelText: Text
    @Binding var text: String
    @ViewBuilder let content: Content

    var body: some View {
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
