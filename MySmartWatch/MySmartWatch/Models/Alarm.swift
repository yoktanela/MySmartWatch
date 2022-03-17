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
}

