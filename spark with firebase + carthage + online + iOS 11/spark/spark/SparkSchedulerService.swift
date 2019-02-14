//
//  SparkSchedulerService.swift
//  spark
//
//  Created by Vikesh on 10/08/2017.
//  Copyright © 2017 Vikesh. All rights reserved.
//

import UIKit
import UserNotifications


class SparkSchedulerService: AlarmSchedulerDelegate {
    
    static let shared: SparkSchedulerService = SparkSchedulerService()
    
    func settings() {
        
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.subtitle = "Message subtitle"
        content.body = "Don't forget to bring coffee."
       
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in })
       
    }

    func notification(_ date: Date, onWeekdaysForNotify: [Int], snooze: Bool, soundName: String, index: Int) {
        
    }
    
    func reschedule() {
        
    }


}
