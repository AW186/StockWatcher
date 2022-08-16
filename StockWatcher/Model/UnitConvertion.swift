//
//  UnitConvertion.swift
//  StockWatcherr
//
//  Created by Arthur Wang on 8/4/22.
//

import Foundation
class UnitConvertion {
    static func timeFromNow(format: String, time: TimeInterval) -> String {
        let now = NSDate().timeIntervalSince1970 + time
        return timeToString(time: now, format: format)
    }
    static func fiveYearsAgo(format: String) -> String {
        let now = NSDate().timeIntervalSince1970 - 5 * 365 * 24 * 3600
        return timeToString(time: now, format: format)
    }
    static func stringToTime(date: String) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: date)
        return date?.timeIntervalSince1970 ?? 0
    }
    static func timeToString(time: TimeInterval, format: String) -> String {
        let date = NSDate.init(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date as Date)
    }
}
