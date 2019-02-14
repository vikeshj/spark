//
//  AlarmSchedulerDelegate.swift
//  spark
//
//  Created by Vikesh on 11/08/2017.
//  Copyright © 2017 Vikesh. All rights reserved.
//

import Foundation
protocol AlarmSchedulerDelegate
{
    func notification(_ date: Date, onWeekdaysForNotify:[Int], snooze: Bool, soundName: String, index: Int)
    func settings()
    func reschedule()
}
