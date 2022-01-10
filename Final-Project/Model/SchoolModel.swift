//
//  School.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import Foundation

struct School {
    var type: String
    var schoolID: String?
    var schoolName: String
    var schoolDescription: String?
    var schoolPhone: String?
    var schoolEmail: String?
    var schoolLocation: String?
    var loca: [location]
}

struct location {
    var lat: Double
    var lag: Double
}

