//
//  RequestModel.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 04/01/2022.
//

import Foundation

struct RequestEvent {
    var eventID: String
    var schoolID: String
    var requestID: String
    var eventName: String?
    var schoolName: String?
    var eventOrganizer: String?
    var date:Date?
    var time:String?
    var duration: String?
    var budget: String?
    var requestStatus: String?
}
