//
//  City.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 06/01/2022.
//

import Foundation

struct AllCity : Codable{
    var cities:[City]?
}

struct City : Codable {
    var name_ar: String
}
