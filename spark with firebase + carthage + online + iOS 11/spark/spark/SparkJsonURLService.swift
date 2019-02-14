//
//  SparkJsonService.swift
//  spark
//  //http://videos.letsbuildthatapp.com/playlist/YouTube/video/How-to-Fetch-Multiple-Feeds
//  Created by Vikesh on 26/09/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit

class SparkJsonURLService: NSObject {
    
    static let sharedInstance = SparkJsonURLService()
    
    let baseUrl = "http://localhost:8888/iOS/Meditation%20-%20App/Spark%20iOS%20App/json"
    
    func fetchUserPlaylists(_ completion: @escaping ([AnyObject]) -> ()) {
        //fetchVoices(urlString: "\(baseUrl)/UserPlaylists.json", completion: completion)
    }
    
    func fetchDefaultPlaylists(_ completion: @escaping ([AnyObject]) -> ()) {
        //fetchVoices(urlString: "\(baseUrl)/DefaultPlaylists.json", completion: completion)
    }
    
    /*private func fetchVoices(urlString: String, completion:@escaping ([PlayList]) -> ()) {
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData , options: .mutableContainers) as? [[String: AnyObject]] {
                    
                    DispatchQueue.main.sync {
                        completion(jsonDictionaries.map({return PlayList(dictionary: $0)}))
                    }
                }
                    
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }*/
}
