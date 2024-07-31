//
//  EditContactView.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 10.07.2024.
//

import SwiftUI

struct EditContactView: View {
    var contact: Contact
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) var dismiss

    @State private var details: [(String, String)]

    init(contact: Contact) {
        self.contact = contact

        details = [
            ("firstName", contact.firstName ?? ""),
            ("lastName", contact.lastName ?? ""),
            ("mobile", contact.mobile ?? ""),
            ("email", contact.email ?? ""),
            ("street", contact.address?.street ?? ""),
            ("city", contact.address?.city ?? ""),
            ("country", contact.address?.country ?? ""),
            ("relationship", contact.relationship ?? ""),
        ]
    }

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
                        dismiss()
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
                            id: contact.id,
                            firstName: findDetail(for: "firstName"),
                            lastName: findDetail(for: "lastName"),
                            mobile: findDetail(for: "mobile"),
                            email: findDetail(for: "email"),
                            address: address,
                            relationship: findDetail(for: "relationship"),
                            birthday: birthday
                        )
                        contact.update(newContact: newContact)
                        dismiss()

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

                    //

                    DeleteContactButton(labelText: Text("delete")
                                        ,
                                        onDelete: {
                                            print("Deleting...")
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

struct EditContactDetail<Content: View>: View {
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
