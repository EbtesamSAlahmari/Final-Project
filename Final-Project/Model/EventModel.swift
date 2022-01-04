//
//  EventModel.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import Foundation

struct Event {
    var type: String
    var eventName: String
    var eventOrganizer: String?
    var eventDescription: String?
    var eventEmail: String?
    var eventCity: String?
    var eventKind: String?
    var eventImage: String?
    var requests: [SchoolRequest]?
}

struct SchoolRequest {
    var requestID: String
    var schoolName: String
    var schoolPhone: String
    var date:Date
    var time:String
    var duration: String
    var budget: String
    var requestStatus: String
}
