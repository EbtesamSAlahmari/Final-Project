//
//  School.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import Foundation

struct School {
    var type: String
    var schoolName: String
    var schoolDescription: String?
    var schoolPhone: String?
    var schoolEmail: String?
    var schoolLocation: String?
    var requests: [Request]?
}

struct Request {
    var requestID: String
    var eventName: String
    var eventOrganizer: String
    var date:Date
    var time:String
    var duration: String
    var budget: String
    var requestStatus: String
}
