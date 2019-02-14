//
//  AlarmNavigationController
//  spark
//
//  Created by Vikesh on 09/08/2017.
//  Copyright © 2017 Vikesh. All rights reserved.
//

import UIKit


class AlarmNavigationController: UINavigationController {
    
    var vc:AlarmViewController = AlarmViewController()
    
    var dataprovider: FirePlaylist! {
        didSet {
            let alarm = Alarm(voice: dataprovider.peopleName,
                           voiceId: dataprovider.peopleId,
                           label: "", date: Date(),
                           snooze: false, uuid: UUID().uuidString,
                           mediaId: dataprovider.id, mediaLabel: dataprovider.title)
            vc.alarm = alarm
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc.onDismiss = {
            self.dismiss(animated: true, completion: {})
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addChildViewController(vc)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        
    }
    
}
