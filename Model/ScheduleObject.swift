//
//  ScheduleObject.swift
//  KnightHacks
//
//  Created by KnightHacks on 12/24/18.
//  Copyright © 2018 KnightHacks. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ScheduleGroup {
    var day: String
    var objects: [ScheduleObject]
}

class ScheduleObject {
    static let API_START_TIME_PARAMETER_KEY: String = "startTime"
    static let API_TITLE_PARAMETER_KEY: String = "title"
    static let API_EVENT_TYPE_PARAMETER_KEY: String = "eventType"
    static let API_LOCATION_PARAMETER_KEY: String = "location"
    static let API_END_TIME_PARAMETER_KEY: String = "endTime"
    
    var title: String
    var eventType: String
    var location: String
    var startTime: String
    var endTime: String
    var formattedTime: String = "invalid time"
    var formattedHeader: String = "Invalid Header"
    
    var startDateObject: Date?
    var endDateObject: Date?
    
    init(json: JSON) {
        title = json[ScheduleObject.API_TITLE_PARAMETER_KEY].stringValue
        eventType = json[ScheduleObject.API_EVENT_TYPE_PARAMETER_KEY].stringValue
        location = json[ScheduleObject.API_LOCATION_PARAMETER_KEY].stringValue
        startTime = json[ScheduleObject.API_START_TIME_PARAMETER_KEY].stringValue
        endTime = json[ScheduleObject.API_END_TIME_PARAMETER_KEY].stringValue
                
        parseDateObjects()
        parseHeaderInfo()
    }
    
    init(title: String, eventType: String, location: String, startTime: String, endTime: String) {
        self.title = title
        self.eventType = eventType
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        
        parseDateObjects()
    }
    
    func parseHeaderInfo() {
        var formattedHeaderTitle: String = ""
        
        if let startDateObject = self.startDateObject {
            formattedHeaderTitle += StringDateFormatter.getFormattedTime(from: startDateObject, with: .dayOfWeek) ?? ""
            formattedHeaderTitle += ", \(StringDateFormatter.getFormattedTime(from: startDateObject, with: .monthAndDay) ?? "")"
            
            self.formattedHeader = formattedHeaderTitle
        }
    }
    
    func parseDateObjects() {
        guard let parsedStartTime = StringDateFormatter.convertStringToZuluDate(dateString: startTime),
            let hourMinuteFormat = StringDateFormatter.getFormattedTime(from: parsedStartTime, with: .hourMinuteTwelve) else {
            print("Start time parsing error")
            return
        }
        startDateObject = parsedStartTime
        formattedTime = hourMinuteFormat
        
        guard let parsedEndTime = StringDateFormatter.convertStringToZuluDate(dateString: endTime) else {
            print("End time parsing error")
            return
        }
        endDateObject = parsedEndTime
    }
}
