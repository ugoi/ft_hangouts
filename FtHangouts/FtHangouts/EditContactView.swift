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

    enum Field: Hashable {
        case firstName
        case lastName
        case mobile
        case email
        case street
        case city
        case country
        case relationship
        case birthday
    }

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var mobile = ""
    @State private var email = ""
    @State private var street = ""
    @State private var city = ""
    @State private var country = ""
    @State private var relationship = ""
    @State private var birthday: Date? = nil

    @FocusState private var focusedField: Field?

    init(contact: Contact) {
        self.contact = contact
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
                        let address: Address? = {
                            Address(street: street, city: city, country: country)
                        }()
                        let newContact = Contact(
                            id: contact.id,
                            firstName: firstName,
                            lastName: lastName,
                            mobile: mobile,
                            email: email,
                            address: address,
                            relationship: relationship,
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
                    EditContactDetail(
                        labelText: Text("firstName"),
                        text: $firstName
                    ) {}
                        .focused($focusedField, equals: .firstName)
                        .onSubmit {
                            focusedField = .lastName
                        }

                    EditContactDetail(
                        labelText: Text("lastName"),
                        text: $lastName
                    ) {}
                        .focused($focusedField, equals: .lastName)
                        .onSubmit {
                            focusedField = .mobile
                        }

                    EditContactDetail(
                        labelText: Text("mobile"),
                        text: $mobile
                    ) {}
                        .focused($focusedField, equals: .mobile)
                        .onSubmit {
                            focusedField = .email
                        }

                    EditContactDetail(
                        labelText: Text("email"),
                        text: $email
                    ) {}
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .street
                        }

                    EditContactDetail(
                        labelText: Text("street"),
                        text: $street
                    ) {}
                        .focused($focusedField, equals: .street)
                        .onSubmit {
                            focusedField = .city
                        }

                    EditContactDetail(
                        labelText: Text("city"),
                        text: $city
                    ) {}
                        .focused($focusedField, equals: .city)
                        .onSubmit {
                            focusedField = .country
                        }

                    EditContactDetail(
                        labelText: Text("country"),
                        text: $country
                    ) {}
                        .focused($focusedField, equals: .country)
                        .onSubmit {
                            focusedField = .relationship
                        }

                    EditContactDetail(
                        labelText: Text("relationship"),
                        text: $relationship
                    ) {}
                        .focused($focusedField, equals: .relationship)
                        .onSubmit {
                            focusedField = .birthday
                        }

                    VStack(alignment: .leading) {
                        Button(action: {
                        }) {
                            Text("add birthday")
                        }
                        .overlay {
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
        .onAppear {
            // Initialize the state variables when the view appears
            firstName = contact.firstName ?? ""
            lastName = contact.lastName ?? ""
            mobile = contact.mobile ?? ""
            email = contact.email ?? ""
            street = contact.address?.street ?? ""
            city = contact.address?.city ?? ""
            country = contact.address?.country ?? ""
            relationship = contact.relationship ?? ""
            birthday = contact.birthday
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
    @FocusState private var textfieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            TextField("\(labelText)", text: Binding(
                get: { self.text.isEmpty ? "" : self.text },
                set: { newValue in self.text = newValue.isEmpty ? "" : newValue }
            ))
            .frame(alignment: .leading)
            .multilineTextAlignment(.leading)
            .focused($textfieldFocused)
            .onLongPressGesture(minimumDuration: 0.0) {
                textfieldFocused = true
            }
            .autocorrectionDisabled()
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
