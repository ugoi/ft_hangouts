//
//  SwiftDataTimeSetInBackground.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 02.08.2024.
//

import Foundation
import SwiftData

@Model
class SwiftDataTimeSetInBackground {
    var timeSetInBackground: Date

    init(timeSetInBackground: Date) {
        self.timeSetInBackground = timeSetInBackground
    }
}
