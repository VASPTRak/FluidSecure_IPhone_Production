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


extension UIViewController {


    fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {

        let bundleName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String;
        let alertMessage = "\(bundleName) Version \(Version) is available on AppStore."
        let alertTitle = "New Version"


        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)


//        if !Force {
            let notNowButton = UIAlertAction(title: "Update Later", style: .default) { (action:UIAlertAction) in
                print("Don't Call API");


            }
            alertController.addAction(notNowButton)
//        }

        let updateButton = UIAlertAction(title: "Update Now", style: .default) { (action:UIAlertAction) in
            print("Call API");
            print("No update")

            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlert(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        // Change Message With Color and Font
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}


class Commanfunction {

    var fuelquantity:Double!
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


    func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                guard let info = result.results.first else { throw VersionError.invalidResponse }

                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    enum VersionError: Error {
        case invalidBundleInfo, invalidResponse
    }

    func showUpdateWithForce() {
        checkVersion()
    }

    func checkVersion() {
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        _ = getAppInfo { (info, error) in
            let appStoreAppVersion = info?.version
            if let error = error {
                print(error)
            } else if info?.version == currentVersion {
                print("updated")
            } else if appStoreAppVersion!.compare(currentVersion!, options: .numeric) == .orderedDescending {
                print("needs update")
                DispatchQueue.main.async {
                    let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!

                    topController.showAppUpdateAlert(Version: (info?.version)!, Force: false, AppURL: (info?.trackViewUrl)!)
                }
            }
        }
    }

    func calculate_fuelquantity(quantitycount: Int)-> Double
    {
        if(quantitycount == 0)
        {
            fuelquantity = 0
        }
        else{
            Vehicaldetails.sharedInstance.pulsarCount = "\(quantitycount)"
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            fuelquantity = (Double(quantitycount))/(PulseRatio as NSString).doubleValue
        }
        return fuelquantity
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

//        guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
//        let key = kCNNetworkInfoKeySSID as String
//        for interface in interfaces {
//            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else { continue }
//            return (interfaceInfo[key] as? String)!
//        }
//        return nil

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




