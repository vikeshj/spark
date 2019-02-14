//
//  SparkAlarmService.swift
//  spark
//
//  Created by Vikesh on 09/08/2017.
//  Copyright © 2017 Vikesh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SparkAlarmService: NSObject {
    
    static var shared: SparkAlarmService = SparkAlarmService()
    
  
    
    var current: DateComponents {
        get {
            let date = Date()
            let units: Set<Calendar.Component> = [.hour, .minute]
            return Calendar.current.dateComponents(units, from: date)
        }
    }
    
    func add(_ alarm: Alarm, completion: @escaping (_ success: Bool)->()) {
        let sa: SparkAlarm = SparkAlarm(context: context)
        sa.voice = alarm.voice
        sa.date = alarm.date as Date 
        sa.snooze = alarm.snooze
        sa.label = alarm.label
        sa.mediaId = alarm.mediaId
        sa.mediaLabel = alarm.mediaLabel
        sa.uuid = alarm.uuid
        sa.enabled = true
        DispatchQueue.main.async { 
            self.appDelegate.saveContext()
            completion(true)
        }
    }
    
    func update(_ alarm: Alarm) {
    
        
    }
    
    func remove(_ uuid: String, completion: @escaping (_ success: Bool)->()){
        let request: NSFetchRequest<SparkAlarm> = SparkAlarm.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "uuid ==%@", uuid)
        do  {
            let object = try context.fetch(request)
            context.delete(object.first!)
            DispatchQueue.main.async {
                self.appDelegate.saveContext()
                completion(true)
            }
        }
        catch let error { print(error.localizedDescription) }
        
    }
    

    
    //core data delegate
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var context: NSManagedObjectContext {
        get {
            return appDelegate.persistentContainer.viewContext
        }
    }

}
