//
//  Alarm.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 17.03.2022.
//

import Foundation

enum Day: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 4
    case wednesday = 8
    case thursday = 16
    case friday = 32
    case saturday = 64
    
    static func getDays() -> [Day] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }
    
    static func getWeekEndDays() -> [Day] {
        return [.saturday, .sunday]
    }
    
    func getName() -> String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }
}

class Alarm : Equatable {
    var hour: Int
    var minute: Int
    var repeatDays: [Day] = []
    
    init(hour: Int, minute: Int, repeatDays: [Day] = []) {
        self.hour = hour
        self.minute = minute
        self.repeatDays = repeatDays
    }
    
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        let differentRepeatDays = lhs.repeatDays.contains(where: {!rhs.repeatDays.contains($0)}) || rhs.repeatDays.contains(where: {!lhs.repeatDays.contains($0)})
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute && !differentRepeatDays
    }
    
    func getAlarmString() -> String {
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
    }
    
    func getRepeatDaysString() -> String {
        if repeatDays.count == 0 {
            return "No repeat"
        } else if repeatDays.count == 7 {
            return "All week"
        } else if repeatDays.count == 5 && !repeatDays.contains(where: {Day.getWeekEndDays().contains($0)}){
            return "Workdays"
        } else if repeatDays.count == 2 && repeatDays.contains(where: {Day.getWeekEndDays().contains($0)}){
            return "Weekends"
        } else {
            var text = ""
            for index in 0..<repeatDays.count {
                text += repeatDays[index].getName()
                if index < repeatDays.count-1 {
                    text += ", "
                }
            }
            return text
        }
    }
}

