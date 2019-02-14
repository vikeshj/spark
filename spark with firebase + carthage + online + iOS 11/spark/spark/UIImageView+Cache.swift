//
//  UIImageView+Cache.swift
//  spark
//
//  Created by Vikesh on 21/10/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import UIKit
//import Firebase

let imageCache = NSCache<NSString, UIImage>()

class SparkUIImageView: UIImageView {
    var fileSave: FileSave?
}

extension SparkUIImageView {
    
    func loadImageUsingCacheWithUrlString( _ urlString: String) {
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
    func loadFirebaseImageUsingCacheWith( _ urlString: String, subDirectory: String,  completion: @escaping (_ image:UIImage?) -> ()) {
        //self.image = #imageLiteral(resourceName: "placeholder")
        contentMode = .scaleAspectFit
        
        self.fileSave = FileSave(fileName: urlString, subDirectory: subDirectory)
        if(self.fileSave?.fileExists)! {
            do {
                self.image = try fileSave?.getImage()
                return
            }
            catch { print(FileErrors.fileNotFound) }
        }
        
        
        //check cache for image first
        /*if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            print("cache \(cachedImage)")
            self.image = cachedImage
            completion(cachedImage)
            return
        }*/
        
        //otherwise load image from firebase directory
        let imageReference = SparkDataService.shared.fireabaseStorageNode(subDirectory + "/"  + urlString)
        imageReference.getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
            DispatchQueue.main.async{
                if let bytes = data {
                    if let downloadedImage = UIImage(data: bytes) {
                        UIView.animate(withDuration: 0.3, animations: {
                                self.alpha = 0
                            })
                        self.image = downloadedImage
                        do { try self.fileSave?.saveFile(downloadedImage) } catch { print(FileErrors.fileNotSaved) }
                        //imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        
                        if let file = self.fileSave {
                            print(file.contentPath)
                        }
                        completion(downloadedImage)
                    }
                } else {
                    //backup image here
                }
            }
        })

    }
}

extension String
{
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    
}

