//
//  SwiftDataContacts.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 13.07.2024.
//

import Foundation
import SwiftData

@Model
class SwiftDataContact: Identifiable {
    var id: UUID
    var firstName: String?
    var lastName: String?
    var imageName: String?
    var mobile: String?
    var email: String?
    var address: SwiftDataAddress?
    var relationship: String?
    var birthday: Date?

    init(id: UUID, firstName: String? = nil, lastName: String? = nil, imageName: String? = nil, mobile: String? = nil, email: String? = nil, address: SwiftDataAddress? = nil, relationship: String? = nil, birthday: Date? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageName = imageName
        self.mobile = mobile
        self.email = email
        self.address = address
        self.relationship = relationship
        self.birthday = birthday
    }
}

@Model
class SwiftDataAddress: Hashable {
    let street: String
    let city: String
    let country: String

    init(street: String, city: String, country: String) {
        self.street = street
        self.city = city
        self.country = country
    }
}
