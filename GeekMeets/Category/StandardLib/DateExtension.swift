//
//  DateExtension.swift
//  SuccessDance
//
//  Created by SOTSYS044 on 02/04/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

extension Date {

    
    func dateString(with formatter: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatter
        return dateFormatterGet.string(from: self)
    }
    
    func getDateFromTimeStamp(from timestamp: Int, with formatter: String = "MM/dd/yyyy" ) -> (dateStr: String, date: Date?, sinceAgoFormate: String) {
        guard let timeInterval = TimeInterval(exactly: timestamp) else {return (dateStr: "", date: nil, sinceAgoFormate: "")}
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current//(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = formatter //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        let sinceAgoStr = date.agoStringFromTime()
        return (dateStr: strDate, date: date, sinceAgoFormate: sinceAgoStr)
    }
    
    func getDateWithCustomFormate(from date: Date, with formatter: String = "MM/dd/yyyy" ) -> (dateStr: String, date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current//(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = formatter //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return (dateStr: strDate, date: date)
    }
    
    static func getFormattedDate(dateStr: String , formatter:String, requiredDateFormatter: String) -> (date: Date, dateStr: String){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatter
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = requiredDateFormatter
        
        let date: Date? = dateFormatterGet.date(from: dateStr)
        return (date: date!, dateStr: dateFormatterPrint.string(from: date!))
    }
    
    
    static func differenceFrom(date: Date, as type: [Calendar.Component]) -> DateComponents{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let components = Set<Calendar.Component>(type)
        let differenceOfDate = Calendar.current.dateComponents(components, from: date, to: Date())
        return differenceOfDate
    }
    
    func agoStringFromTime()-> String {
        let timeScale = ["just now"  :1,
                         "minutes"  :60,
                         "hours"   :3600,
                         "days"  :86400,
                         "weeks" :605800,
                         "years" :31556926];
        
        var scale : String = ""
        var timeAgo = 0 - Int(self.timeIntervalSinceNow)
        if (timeAgo < 60) {
            scale = "just now";
        } else if (timeAgo < 3600) {
            scale = "minutes";
        } else if (timeAgo < 86400) {
            scale = "hours";
        } else if (timeAgo < 605800) {
            scale = "days";
        } else if (timeAgo < 31556926) {
            scale = "weeks";
        } else {
            scale = "years";
        }
        
        timeAgo = timeAgo / Int(timeScale[scale]!)
        if scale == "just now"{
            return scale
        }else{
            return "\(timeAgo) \(scale) ago"
        }
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

