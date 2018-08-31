//
//  commanfunction.swift
//  FuelSecure
//
//  Created by VASP on 9/14/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation

class Commanfunction {

    let fileManager: FileManager = FileManager()
    var currentSSID:String!
    public var dateUpdated: String {

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"

        if let date = dateFormatterGet.date(from: "\(NSDate())") {

            return dateFormatterGet.string(from: date)
        }
        else {
            return "There was an error decoding the string"
        }
    }

    func showAlert(message: String)
    {
        let alert = UIAlertController(title: "", message:message, preferredStyle: UIAlertControllerStyle.alert )
        let okAction = UIAlertAction(title: NSLocalizedString("addButtonWithTitleyes", comment:""), style: UIAlertActionStyle.default){ (submity) -> Void in
        }
        alert.addAction(okAction)
    }

    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL as NSURL
    }

    func CreateTextFile(fileName: String, writeText: String)
    {
        let createfile = getDocumentsURL().appendingPathComponent(fileName)
        let fromPath: String = (createfile!.path)
        do{
            do{try writeText.write(toFile: fromPath, atomically: true, encoding: String.Encoding.utf8)}
            catch{print("error")}
        }
    }


    func SaveTransaction_status(fileName: String, writeText: String,Path:String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("\(Path)/")
        let fromPath: String = (readdata!.path)
        do{
            do{ if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{print("error")}
                }
            }
            let writePath = getDocumentsURL().appendingPathComponent("\(Path)/" + fileName)
            let wPath: String = (writePath!.path)
            do { try writeText.write(toFile: wPath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
    }


    func checkPath(fileName: String) -> Bool
    {
        var flag: Bool = false
        let fileManager: FileManager = FileManager()
        let fileURL = getDocumentsURL().appendingPathComponent(fileName)
        let fromPath: String = (fileURL!.path)
        flag = fileManager.fileExists(atPath: fromPath)
        return flag
    }

    func DeleteFileInApp(fileName:String)
    {
        let deletePath = getDocumentsURL().appendingPathComponent(fileName)
        let fromPath: String = (deletePath!.path)
        do{
            try fileManager.removeItem(atPath: fromPath)
        }
        catch{print("error")}
    }


    func readFile(fileName: String) -> String
    {
        var readData: String! = ""
        let readdata = getDocumentsURL().appendingPathComponent(fileName)
        let fromPath: String = (readdata!.path)
        do{
            do{ readData = try String(contentsOfFile: fromPath, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
        return readData
    }


    func delay(_ delay:Double, closure:@escaping ()->()) {

        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    func getSSID() -> String{

        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    currentSSID = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    print(currentSSID)
                    break
                }
                else {
                    currentSSID = ""
                }
            }
        }
        return currentSSID!
    }

    func getInterfaces() -> Bool {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)")
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
            }
        }
        return true
    }

    func saveBinFile(fileName: String, writeText: String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("bin/")
        let fromPath: String = (readdata!.path)
        do{
            do{ if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{print("error")}
                }
            }
            let writePath = getDocumentsURL().appendingPathComponent("bin/" + fileName)
            let wPath: String = (writePath!.path)
            do { try writeText.write(toFile: wPath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
    }

    func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        return ""
    }

    func SaveLogFile(fileName: String, writeText: String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("data/unsyncdata/" + fileName)
        let fromPath: URL = URL(fileURLWithPath: readdata!.path)

        do {
            let fileHandle = try FileHandle(forWritingTo: fromPath)
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeText.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print("Error writing to file \(error)")
        }
    }


    func SaveTextFile(fileName: String, writeText: String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("data/test/")
        let fromPath: String = (readdata!.path)
        do{
            do{ if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{print("error")}
                }
            }
            let writePath = getDocumentsURL().appendingPathComponent("data/test/" + fileName)
            let wPath: String = (writePath!.path)
            do { try writeText.write(toFile: wPath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
    }

    func preauthSaveTextFile(fileName: String, writeText: String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("data/preauth/")
        let fromPath: String = (readdata!.path)
        do{
            do{ if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{print("error")}
                }
            }
            let writePath = getDocumentsURL().appendingPathComponent("data/preauth/" + fileName)
            let wPath: String = (writePath!.path)
            do { try writeText.write(toFile: wPath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
    }

    func DeleteReportTextFile(fileName: String, writeText: String)
    {
        let deletePath = getDocumentsURL().appendingPathComponent("data/test/" + fileName)
        let fromPath: String = (deletePath!.path)
        do{
            try fileManager.removeItem(atPath: fromPath)
        }
        catch{print("error")}
    }

    func preauthDeleteReportTextFile(fileName: String, writeText: String)
    {
        let deletePath = getDocumentsURL().appendingPathComponent("data/preauth/" + fileName)
        let fromPath: String = (deletePath!.path)
        do{
            try fileManager.removeItem(atPath: fromPath)
        }
        catch{print("error")}
    }


    func stringFromQueryParameters(_ queryParameters : Dictionary<String, String>) -> String {
        var parts: [String] = []
        for (name, value) in queryParameters {
            let part = NSString(format: "%@=%@",
                                name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                                value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }


    func NSURLByAppendingQueryParameters(URL : NSURL!, queryParameters : Dictionary<String, String>) -> NSURL {
        let URLString : NSString = NSString(format: "%@?%@", URL.absoluteString!, self.stringFromQueryParameters(queryParameters))
        return NSURL(string: URLString as String)!
    }

    func ReadReportFile(fileName: String) -> String
    {
        var readData: String!
        let readdata = getDocumentsURL().appendingPathComponent("data/test/" + fileName)
        let fromPath: String = (readdata!.path)
        do{
            do{ readData = try String(contentsOfFile: fromPath, encoding: String.Encoding.utf8)
                if(readData == nil){
                    readData = ""
                }
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            
        }
        return readData
    }

    func preauthReadReportFile(fileName: String) -> String
    {
        var readData: String!

        let readdata = getDocumentsURL().appendingPathComponent("data/preauth/" + fileName)
        let fromPath: String = (readdata!.path)
        do{
            do{ readData = try String(contentsOfFile: fromPath, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
        return readData
    }


    func ReadCompleteFile(fileName: String) -> String
    {
        var readData: String!
        let readdata = getDocumentsURL().appendingPathComponent("URL/" + fileName)
        let fromPath: String = (readdata!.path)
        do{

            do{ readData = try String(contentsOfFile: fromPath, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
        return readData
    }

    func ReadDeleteOrder(fileName: String) -> String
    {
        var readData: String!
        let readdata = getDocumentsURL().appendingPathComponent("Order/" + fileName)
        let fromPath: String = (readdata!.path)
        do{
            do{ readData = try String(contentsOfFile: fromPath, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
        return readData
    }


    func ReadFile(fileName: String) -> String
    {
        var readData: String! = ""

        let readdata = getDocumentsURL().appendingPathComponent(fileName)
        let fromPath: String = (readdata!.path)
        do{
            do{ readData = try String(contentsOfFile: fromPath, encoding: String.Encoding.utf8)
            }
            catch{print("error")}
        }
        return readData
    }

    func convertStringToBase64(_ string: String) -> String
    {
        let plainData = string.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
}




