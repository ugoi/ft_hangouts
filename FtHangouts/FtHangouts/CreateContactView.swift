//
//  CreateContactView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 10.07.2024.
//

import SwiftData
import SwiftUI

struct CreateContactView: View {
    @ObservedObject var contactsManager: ContactsManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var navigationManager: NavigationManager

    init(contactsManager: ContactsManager) {
        self.contactsManager = contactsManager
    }

    @State private var details: [(String, String)] =
        [
            ("firstName", ""),
            ("lastName", ""),
            ("mobile", ""),
            ("email", ""),
            ("street", ""),
            ("city", ""),
            ("country", ""),
            ("relationship", ""),
        ]

    @State private var birthday: Date? = nil

    private func findDetail(for key: String) -> String? {
        let detail = details.first(where: { $0.0 == key })?.1 as? String ?? nil

        guard let detail = detail, !detail.isEmpty else {
            return nil
        }
        return detail
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
                        Text("Cancle")
                            .foregroundColor(.blue)
                            .padding(.horizontal, 11.0).padding(.vertical, 6)
                    }
                    Spacer()
                    Button(action: {
                        let street = findDetail(for: "street")
                        let city = findDetail(for: "city")
                        let country = findDetail(for: "country")

                        let address: Address? = {
                            if let street = street, !street.isEmpty,
                               let city = city, !city.isEmpty,
                               let country = country, !country.isEmpty {
                                return Address(street: street, city: city, country: country)
                            } else {
                                return nil
                            }
                        }()
                        let newContact = Contact(
                            id: UUID(),
                            firstName: findDetail(for: "firstName"),
                            lastName: findDetail(for: "lastName"),
                            mobile: findDetail(for: "mobile"),
                            email: findDetail(for: "email"),
                            address: address,
                            relationship: findDetail(for: "relationship"),
                            birthday: birthday
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
                    ForEach($details, id: \.0) { $detail in
                        EditContactDetail(
                            labelText: Text(detail.0),
                            text: $detail.1

                        ) {
                        }
                    }
                    VStack(alignment: .leading) {
                        Button(action: {
                        }) {
                            Text("add birthday")
                        }.overlay {
                            DatePicker(
                                "",
                                selection: Binding<Date>(get: { self.birthday ?? Date() }, set: { self.birthday = $0 }),
                                in: ...Date(),
                                displayedComponents: .date
                            )
                            .blendMode(.destinationOver)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20.0)
                    .padding(.vertical, 12.0)
                    .background(Color("ContactDetail"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    ContentView(modelContext: (try! ModelContainer(for: SwiftDataContact.self)).mainContext)
        .environmentObject(NavigationManager())
}

struct CreateContactDetail<Content: View>: View {
    var labelText: Text
    @Binding var text: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading) {
            TextField("\(labelText)", text: $text)
                .frame(alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20.0)
        .padding(.vertical, 12.0)
        .background(Color("ContactDetail"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
