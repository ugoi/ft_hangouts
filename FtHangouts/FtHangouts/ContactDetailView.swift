//
//  ContactDetailView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 08.07.2024.
//

import SwiftData
import SwiftUI

struct ContactDetailView: View {
    @ObservedObject var contactsManager: ContactsManager
    @State private var showPage2 = false
    @Binding var contact: Contact
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private var contactAttributes: [(String, String?)] {
        [
            ("First Name", contact.firstName),
            ("Last Name", contact.lastName),
            ("Mobile", contact.mobile),
            ("Email", contact.email),
            ("Address", contact.address != nil ? "\(contact.address!.street), \(contact.address!.city), \(contact.address!.country)" : nil),
            ("Relationship", contact.relationship),
            ("Birthday", contact.birthday?.formatted(date: .numeric, time: .omitted)),
        ]
    }

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

                    Text("\(contact.firstName ?? "") \(contact.lastName ?? "")")
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
                    ForEach(contactAttributes, id: \.0) { attributeName, attributeValue in
                        if let attributeValue = attributeValue {
                            ContactDetail(labelText: Text(attributeName)
                                .font(.headline)) {
                                    Text(attributeValue)
                                        .foregroundColor(.blue)
                                }
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

#Preview {
    ContentView(modelContext: (try! ModelContainer(for: SwiftDataContact.self)).mainContext)
        .environmentObject(NavigationManager())
}

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
