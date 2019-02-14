//
//  FileSaveHelper.swift
//  SavingFiles
//  https://github.com/jjessel/FileSaveHelper
//  Created by Jeremiah Jessel on 9/14/15.
//  Copyright © 2015 JCubedApps. All rights reserved.
//

/**
 * If you don't want to specify the directory or sub directory for the file use:
 * let file = FileSaveHelper(fileName: "myTextFile", fileExtension: .TXT)
 *
 * To specify a sub directory use:
 * let file = FileSaveHelper(fileName: "myTextFile", fileExtension: .TXT, subDirectory: "files")
 *
 * let file = FileSaveHelper(fileName: "myTextFile", fileExtension: .TXT, subDirectory: "files", directory: .documentDirectory)
 *
 **/

import Foundation
import UIKit

// MARK:- Error Types

enum FileErrors:Error {
    case jsonNotSerialized
    case fileNotSaved
    case imageNotConvertedToData
    case fileNotRead
    case fileNotFound
    case plistNotSerialized
}

class FileSave {
    
    
    
    // MARK:- File Extension Types
    enum FileExtension:String {
        case TXT = ".txt"
        case JPG = ".jpg"
        case PNG = ".png"
        case JSON = ".json"
        case PLIST = ".plist"
        case M4A = ".m4a"
    }
    
    // MARK:- Private Properties
    fileprivate let directory:FileManager.SearchPathDirectory
    fileprivate let directoryPath: String
    fileprivate let fileManager = FileManager.default
    fileprivate let fileName:String
    fileprivate let filePath:String
    fileprivate let fullyQualifiedPath:String
    fileprivate let subDirectory:String
    
    // MARK:- Public Properties
    var fileExists:Bool {
        get {
            return fileManager.fileExists(atPath: fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
        }
    }
    
    
    var contentPath: String {
        get { return self.fullyQualifiedPath }
    }
    
    
    // MARK:- Initializers
    convenience init(fileName:String, fileExtension:FileExtension){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.documentDirectory)
    }
    
    convenience init(fileName:String, fileExtension:FileExtension, subDirectory:String){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.documentDirectory)
    }
    
    convenience init(fileName:String, subDirectory:String) {
        self.init(fileName:fileName, subDirectory:subDirectory, directory:.documentDirectory)
    }
    
    /**
     Initialize the FileSaveHelper Object with parameters
     
     :param: fileName      The name of the file
     :param: fileExtension The file Extension
     :param: directory     The desired sub directory
     :param: saveDirectory Specify the NSSearchPathDirectory to save the file to
     
     */
    init(fileName:String, fileExtension:FileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        createDirectory()
    }
    
    init(fileName:String, subDirectory:String, directory:FileManager.SearchPathDirectory) {
        self.fileName = fileName
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        createDirectory()
    }
    
    /**
     If the desired directory does not exist, then create it.
     */
    fileprivate func createDirectory(){
        
        if !directoryExists {
            do {
                try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError {
                print(error.localizedDescription);
            }
        }
    }
    
    // MARK:- File saving methods
    
    /**
     Save the contents to file
     
     :param: fileContents A String that will be saved in the file
     */
    func saveFile(string fileContents:String) throws{
        
        do {
            try fileContents.write(toFile: fullyQualifiedPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch  {
            throw error
        }
    }

    
    /**
     Save the image to file.
     
     :param: image UIImage
     */
    func saveFile(_ image:UIImage) throws {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw FileErrors.imageNotConvertedToData
        }
        if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
            throw FileErrors.fileNotSaved
        }
    }
    
    func savePng(_ image: UIImage) throws {
        guard let data = UIImagePNGRepresentation(image) else {
            throw FileErrors.imageNotConvertedToData
        }
        if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
            throw FileErrors.fileNotSaved
        }
    }
    
    /**
     Save a JSON file
     
     :param: dataForJson NSData
     */
    func saveFile(_ json:AnyObject) throws{
        do {
            let jsonData = try convertObjectToData(json)
            if !fileManager.createFile(atPath: fullyQualifiedPath, contents: jsonData as Data, attributes: nil){
                throw FileErrors.fileNotSaved
            }
        } catch {
            print(error)
            throw FileErrors.fileNotSaved
        }
        
    }
    
    func getContentsOfFile() throws -> String {
        guard fileExists else {
            throw FileErrors.fileNotFound
        }
        
        var returnString:String
        do {
            returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: String.Encoding.utf8)
        } catch {
            throw FileErrors.fileNotRead
        }
        return returnString
    }
    
    func getImage() throws -> UIImage {
        guard fileExists else {
            throw FileErrors.fileNotFound
        }
        
        guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
            throw FileErrors.fileNotRead
        }
        
        return image
        
    }
    
    /*func getJSONData() throws -> NSDictionary {
        guard fileExists else {
            throw FileErrors.fileNotFound
        }
        do {
            let data = try Data(contentsOfFile: fullyQualifiedPath, options: Data.ReadingOptions.mappedIfSafe)
            let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
            return jsonData
        } catch {
            throw FileErrors.fileNotRead
        }
        
    }*/
    // MARK:- Json Converting
    
    /**
     Convert the NSData to Json Data
     
     :param: data NSData
     
     :returns: Json Serialized NSData
     */
    fileprivate func convertObjectToData(_ data:AnyObject) throws -> Data {
        
        do {
            let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return (newData as NSData) as Data
        }
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.jsonNotSerialized
    }
    
    // MARK:- Array Convertion to Plist Object
    
    fileprivate func ConvertArrayToPlist(_ data: Data) throws -> NSMutableArray {
        
        do {
            let newArray = try PropertyListSerialization.propertyList(from: data as Data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
            return newArray
        } catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.plistNotSerialized
    }
    
}
