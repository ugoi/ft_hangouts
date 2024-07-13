//
//  ContactDetailView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 08.07.2024.
//

import SwiftUI

struct ContactDetailView: View {
    @ObservedObject var contactsManager: ContactsManager
    @State private var showPage2 = false
    @Binding var contact: Contact
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.horizontal, 11.0).padding(.vertical, 6)
                            .background(Color("ButtonBackgroundLight"))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Button(action: {
                        // Action for edit button
                    }) {
                        NavigationLink(destination: EditContactView(contact: $contact, contactsManager: contactsManager)) {
                            Text("Edit")
                                .font(.title3).foregroundStyle(.white).padding(.horizontal, 11.0).padding(.vertical, 6).background(Color("ButtonBackgroundLight")).clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    }
                }

                // Profile Image and Name
                VStack {
                    Image("Avatar") // Replace with your image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 10)

                    Text(contact.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .foregroundStyle(Color.white)

                    // Message and Call buttons
                    HStack {
                        Button(action: {
                            // Action for message button
                            sendIMessage()
                        }) {
                            VStack {
                                Image(systemName: "message.fill")
                                Text("message")
                            }
                            .frame(width: 98, height: 58)
                            .background(Color("ButtonBackground"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .foregroundStyle(Color.white)
                        Button(action: {
                            // Action for call button
                            call()
                        }) {
                            VStack {
                                Image(systemName: "phone.fill")
                                Text("call")
                            }
                            .frame(width: 98, height: 58)
                            .background(Color("ButtonBackground"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .foregroundStyle(Color.white)
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 13.0)
            .background(LinearGradient(gradient: Gradient(colors: [Color("ContactHeaderTop"), Color("ContactHeaderBottom")]), startPoint: .top, endPoint: .bottom))

            // Contact details
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if let mobile = contact.mobile {
                        ContactDetail(labelText: Text("mobile")
                            .font(.headline)) {
                                Text(mobile)
                                    .foregroundColor(.blue)
                            }
                    }

                    if let email = contact.email {
                        ContactDetail(labelText: Text("email")
                            .font(.headline)) {
                                Text(email)
                                    .foregroundColor(.blue)
                            }
                    }

                    if let address = contact.address {
                        ContactDetail(labelText: Text("address")
                            .font(.headline)) {
                                Text(address.street)
                                Text(address.city)
                                Text(address.country)
                            }
                    }
                    if let relationship = contact.relationship {
                        ContactDetail(labelText: Text("relationship")
                            .font(.headline)) {
                                Text(relationship)
                            }
                    }

                    if let birthday = contact.birthday {
                        ContactDetail(labelText: Text("birthday")
                            .font(.headline)) {
                                Text(birthday.formatted(date: .numeric, time: .omitted))
                            }
                    }
                }
                .padding()

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

// struct ContactDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        var manager = ContactsManager()
//        ContactDetailView(
//            contactsManager: manager,
//            contact: Contact(
//                id: UUID(), name: "Aaron",
//                mobile: "+41 78 626 18 09",
//                email: "aaron@icloud.com",
//                address: Address(street: "Musterstrasse 12", city: "8047 Zürich", country: "Switzerland"),
//                relationship: "X-Classmate",
//                birthday: Date()
//            )
//        )
//    }
// }

struct ContactDetail<Content: View>: View {
    var labelText: Text
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading) {
            labelText
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20.0)
        .padding(.vertical, 12.0)
        .background(Color("ContactDetail"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
