//
//  Alarm.swift
//  spark
//
//  Created by Vikesh on 09/08/2017.
//  Copyright © 2017 Vikesh. All rights reserved.
//

import Foundation

struct Alarm {
    
    var voice: String /// selected voice
    var voiceId: String /// voice uuid
    var label: String /// set date label
    //var timeStamp: String /// date in string
    var date: Date /// date
    var snooze: Bool /// snooze
    var uuid: String /// unique id
    var mediaId: String /// playlistID
    var mediaLabel: String /// Playlist Title
    //var repeatWeekdays: [Int] /// mon,tues,wed,thu,fri,sat,sun
}
