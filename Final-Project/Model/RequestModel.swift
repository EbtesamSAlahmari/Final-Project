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
    var startDate:String?
    var endDate:String?
    var totalPrice: Double?
    var requestStatus: String?
}
