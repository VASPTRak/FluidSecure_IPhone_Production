////
////  Webservices.swift
////  FuelSecuer
////
////  Created by VASP on 5/23/16.
////  Copyright © 2016 VASP. All rights reserved.
//
import UIKit
import MobileCoreServices
import NetworkExtension
import Foundation


extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
//let imageCache = NSCache<NSString, UIImage>()

////extension UIImageView {
////
////    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
////
////        self.image = nil
////        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
////            self.image = cachedImage
////            return
////        }
////
////        if let url = URL(string: URLString) {
////            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
////
////                //print("RESPONSE FROM API: \(response)")
////                if error != nil {
////                    // print("ERROR LOADING IMAGES FROM URL: \(error)")
////                    DispatchQueue.main.async {
////                        self.image = placeHolder
////                    }
////                    return
////                }
////                DispatchQueue.main.async {
////                    if let data = data {
////                        if let downloadedImage = UIImage(data: data) {
////                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
////                            self.image = downloadedImage
////                        }
////                    }
////                }
////            }).resume()
////        }
////    }
////}
//extension NSMutableData {
//
//    /// Append string to NSMutableData
//    ///
//    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
//    ///
//    /// - parameter string:       The string to be added to the `NSMutableData`.
//
//    func appendString(string: String) {
//        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        append(data!)
//    }
//}
//
//
//
//@available(iOS 12.0, *)
class Webservice:NSObject {
    var reply :String!
    var replysentlog :String!
    var replygetpulsar :String!

    var sysdata:NSDictionary!
    var sysdata1:NSDictionary!
    var sysdataLast10trans:NSDictionary!
    let defaults = UserDefaults.standard
    //var cf = Commanfunction()
    //var UDP = FuelquantityVCUDP()
    var isconect_toFS:String = ""
    var showstartbutton:String = ""
    var contents:Data!
    var image = UIImage()
    let fileManager: FileManager = FileManager()
    var pulsardata:String!
//  //  private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    
    var FSURL:String!
    
    
    var ConcateJsonString:String = ""
    var ResponceMessageUpload:String = ""
    var string_data = ""
   
    var fuelquantity:Double!
    
//    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
//    func beginBackgroundUpdateTask() {
//            self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
//
//                //print(var backgroundTimeRemaining: TimeInterval { get })
//                self.endBackgroundUpdateTask()
//            })
//        }
//
//        func endBackgroundUpdateTask() {
//            UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
//            self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
//        }

//    func doBackgroundTask() {
//                   DispatchQueue.main.async(execute: {
//                       self.beginBackgroundUpdateTask()
//
//                    self.downloadthevehicles(url: URL(fileURLWithPath: Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath) as URL, completion:{_,_ in ((path:String?, error:NSError?) -> ()).self
//
//                    })
//                       // End the background task.
//
//                       self.endBackgroundUpdateTask()
//                   })
//
//               }

    //For Testing
    @available(iOS 12.0, *)
    func wifisettings(pagename:String)
    {
        Vehicaldetails.sharedInstance.fsSSId = "FS-" + Vehicaldetails.sharedInstance.SSId

//        let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
//        hotspotConfig.joinOnce = false
//        print(Vehicaldetails.sharedInstance.fsSSId)
//
//        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
//
//            if let error = error {
//                print("Error\(error)")
//                Vehicaldetails.sharedInstance.fsSSId = Vehicaldetails.sharedInstance.SSId
//            }
//            else {
//
//                self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.fsSSId) wifi Automatically from \(pagename) Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.fsSSId == self.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.getSSID())")
//                print("Connected")
//            }
//        }
    }
//
//    //Live
//        @available(iOS 12.0, *)
//        func wifi_settings_check(pagename:String)
//        {
//            print(Vehicaldetails.sharedInstance.SSId)
//            let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
//            hotspotConfig.joinOnce = true
//
//            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
//
//                if let error = error
//                {
//                  print("Error\(error)")
//                }
//                else {
//                    self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from \(pagename) Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                        print("Connected")
//
//                }
//            }
//
//
//        }
//
//    //Live
//        @available(iOS 12.0, *)
//        func wifisettings_check(pagename:String)
//        {
//            print(Vehicaldetails.sharedInstance.SSId)
//            let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
//            hotspotConfig.joinOnce = true
//
//            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
//
//                if let error = error
//                {
//                  print("Error\(error)")
//                }
//                else {
//                    //self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from \(pagename) Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                        print("Connected")
//
//                }
//            }
//
//        }


//    func Checkurl()->String {
//        let Url:String = URL
//        self.sentlog(func_name: "Checkurl command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        let bodyData = ""
//        print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
//                //print(self.reply)
//                let text = self.reply
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                // print(newString)
//                self.sentlog(func_name: "Checkurl ,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink: "",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.getSSID())")
//
//            } else {
//                //print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                //print(newString)
//                self.sentlog(func_name: "Checkurl,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return reply
//    }

    func downloadCompanylogoImage()->UIImage
    {
        let URL_IMAGE = URL(string: Vehicaldetails.sharedInstance.CompanyBrandLogoLink)
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession(configuration: .default)

        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in

            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")

            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {

                    //checking if the response contains an image
                    if let imageData = data {

                        //getting the image
                        self.image = UIImage(data: imageData)!

                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
            semaphore.signal()
        }

        //starting the download task
        getImageFromUrl.resume()

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return image

    }


//    func Preauthrization(uuid:String,lat:String,long:String)->String {
//        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
//        let Url:String = FSURL
//        let Email = ""
//        let string = uuid + ":" + Email + ":" + "SavePreAuthTransactions"
//
//        let Base64 = convertStringToBase64(string: string)
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 10
//        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//        let bodyData = "Authenticate:I:" + "\(lat),\(long),versionno.\(Version),Device Type:\(UIDevice().type),iOS:\(UIDevice.current.systemVersion)"
//        print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//
//        let session = URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
//                //   print(self.reply)
//            } else {
//                //  print(error!)
//
//                self.reply = "-1" + "#" + "\(error!.localizedDescription)"
//                //  print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                // print(newString)
//
//                self.sentlog(func_name: "Preauthrization Function", errorfromserverorlink: " Response from link $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return reply + "#" + ""
//    }



        func downloadthevehicles(url: URL, completion: @escaping (String?, Error?) -> Void)
        {

            if(Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath == ""){}
            else{
            let newString = Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath.replacingOccurrences(of: " " , with: "%20", options: .literal, range: nil)
            print(newString)
            print(Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath)

                        let url = URL(string: newString)!
                        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
                print(destinationUrl)

//
//                       // DeleteFileInApp(fileName: destinationUrl.path)
//                        if FileManager().fileExists(atPath: destinationUrl.path)
//                        {
//                            print("File already exists [\(destinationUrl.path)]")
//                            completion(destinationUrl.path, nil)
//                        }
//                        else
//                        {
                             //let URL = URL(string: Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath)
                            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                            var request = URLRequest(url: url)
                            request.httpMethod = "GET"
                            let task = session.dataTask(with: request, completionHandler:
                            {
                                data, response, error in
                                if error == nil
                                {
                                    if let response = response as? HTTPURLResponse
                                    {
                                        if response.statusCode == 200
                                        {
                                            if let data = data
                                            {

                                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                                {
                                                    completion(destinationUrl.path, error)
                                                }
                                                else
                                                {
                                                    completion(destinationUrl.path, error)
                                                }
                                            }
                                            else
                                            {
                                                completion(destinationUrl.path, error)
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            })
                            task.resume()
                        }
                    }
//    }




//    func GetVehiclesForPhone()->String {
//
//        var Email :String
//        if(defaults.string(forKey: "address") == nil){
//            Email = ""
//        }else {
//            Email = defaults.string(forKey: "address")!
//        }
//
//        let uuid = defaults.string(forKey: "uuid")
//
//        let Url:String =  Vehicaldetails.sharedInstance.URL + "/api/Offline/GetVehiclesForPhone?Email=\(Email)&IMEI=\(uuid!)"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 5 //////timeout interval should be increased it is 4 earlier now i am convert it to 10
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                // DispatchQueue.main.async{
//                self.replygetpulsar = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                self.doBackgroundTask()
//                // print(self.replygetpulsar)
//
//            } else {
//                print(error!)
//
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "GetPulser Service Function", errorfromserverorlink: " Response from Link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                self.replygetpulsar = "-1" + "#" + "\(error!)"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return replygetpulsar + "#" + ""
//    }



    func checkApprove(uuid:String,lat:String!,long:String!)->String {
        if(Vehicaldetails.sharedInstance.Language == ""){
            ///Vehicaldetails.sharedInstance.Language = "en-ES"
        }
        defaults.set("", forKey: "address")
        let Url:String = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        let string = uuid + ":" + Email + ":" + "Other" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        print(Base64)
//        self.sentlog(func_name: "checkApprove command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
        // print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        Vehicaldetails.sharedInstance.TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                // print(self.reply)
                let text = self.reply
                if text!.contains("ResponceMessage"){

                }else{
                    self.reply = "-1"
                }
                //                var check = String((text?.{ !"ResponceMessage".contains($0)})!)

                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "")
                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
//                self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


    func Login(_ Username:String,PWD:String,uuid:String)->String {
        let Url:String = Vehicaldetails.sharedInstance.URL + "LoginHandler.ashx"
        let string = uuid + ":" + Username + ":" + PWD
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Login")
        request.timeoutInterval = 10
        let bodyData = ""
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                //self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            } else {
                //print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
               // self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                self.reply = "-1"

                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""
    }


    func registration(Name:String,Email:String,Base64:String,mobile:String,uuid:String,company:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Url:String = FSURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        var brandname = "FluidSecure"
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)#:#I#:#\(brandname)"
        //        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
       // request.timeoutInterval = 15
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) {  data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                  print(self.reply)
                
            } else {
                // print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.reply = "-1" + "#" + "\(error!)"
//                self.sentlog(func_name: "Registration Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }
    func unsyncUpgradeTransactionStatus()
    {

        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"
        let Base64 = convertStringToBase64(string: string)
        let Url:String = FSURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        var reportsArray: [AnyObject]!
        let fileManager: FileManager = FileManager()
        let readdata = getDocumentsURL().appendingPathComponent("data/unsyncTransstatus/")
        let fromPath: String = (readdata!.path)
        do{
            do{ if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{print("error")}
                }
            }
            reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
            for x in 0  ..< reportsArray.count
            {
                let filename: String = "\(reportsArray[x])"
                do {
                    let JData: String = ReadFile(fileName: "data/unsyncTransstatus/" + filename)
                    if(JData != "")
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
                        //                               dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        //                               let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                        //                               dateFormatter.dateFormat = "yyyy MM dd"
                        //                               let dtt: String = dateFormatter.string(from: NSDate() as Date)
                        //                               let dataString = String(data: contents, encoding: String.Encoding.utf8)
                        //                               let newString = dataString?.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        //                               print(newString!)
                        let bodyData = JData
                        request.httpBody = bodyData.data(using: String.Encoding.utf8)
                        //request.timeoutInterval = 2
                        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
                            if let data = data {
                                //  print(String(data: data, encoding: String.Encoding.utf8)!)
                                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                                //  print(self.replysentlog)
                                let data1 = self.reply.data(using: String.Encoding.utf8)!
                                do{
                                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                }catch let error as NSError {
                                    print ("Error: \(error.domain)")
                                }
                                print(self.sysdata)
                                if(self.sysdata == nil){}
                                else{
                                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                let ResponceMessage = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                                if(ResponceMessage == "fail"){

                                }
                                if(ResponceMessage == "success"){
                                    self.DeleteFileInApp(fileName: "data/unsyncTransstatus/" + filename)
                                }
                            }
                            } else {
                                print(error!)
//                               // self.replysentlog = "-1" + "#" + "\(error?.localizedDescription)"
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "ddMMyyyy"
//                                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//                                let dtt2: String = dateFormatter.string(from: NSDate() as Date)

                            }
                        }
                        task.resume()// contents
                    }
                    //                            let url = URL(fileURLWithPath: fromPath + "/\(filename)")
                    //                            contents = try Data(contentsOf: url)
                    //                            print(contents)

                } catch let error as NSError {
                    print ("Error: \(error.domain)")

                    // contents could not be loaded
                }
            }
        }
    }





    func UpgradeTransactionStatus(Transaction_id:String,Status:String){
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"

        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        if(TransactionId == 0){}
        else{

            let Url:String = FSURL
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let string = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
            print(string)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            let bodyData = "{\"TransactionId\":\"\(TransactionId)\",\"Status\":\"\(Status)\"}"
            print(bodyData)
            request.httpBody = bodyData.data(using: String.Encoding.utf8)

            let task = URLSession.shared.dataTask(with: request as URLRequest) {  data, response, error in
                if let data = data {
                    // print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    print(self.reply)
                    //print(response!)
                } else {
                    // print(error!)
                    let text = (error?.localizedDescription)! //+ error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    // print(newString)
//                    self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                    self.reply = "-1"
                    if(self.reply == "-1"){
                        let jsonstring: String = bodyData
                        // let unsycnfileName = "#\(TransactionId)#0"
                        if(jsonstring != ""){

                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                            let dtt1: String = dateFormatter.string(from: NSDate() as Date)

                            let unsycnfileName =  dtt1 + "UpgradeTransactionStatus" //
                            if(bodyData != ""){
                                self.SaveTransactionstatus(fileName: unsycnfileName, writeText: jsonstring)
                            }

                        }
                        let text = (error?.localizedDescription)! //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        //  print(newString)
                       // self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                    }
                }
            }
            task.resume()
        }
    }


    func UpgradeCurrentVersiontoserver() -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Version = Vehicaldetails.sharedInstance.FirmwareVersion
        let HoseId = Vehicaldetails.sharedInstance.HoseID

        let Url:String = FSURL
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpgradeCurrentVersionWithUgradableVersion"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        print(string)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"HoseId\":\"\(HoseId)\",\"Version\":\"\(Version)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                // print(self.reply)
                // print(response!)
            } else {
                //  print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
//                self.sentlog(func_name: "Upgrade Current Version toserver UpgradeCurrentVersionWithUgradableVersion Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply + "#" + ""
    }


    func SetHoseNameReplacedFlag() -> String{ //-- service
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let SiteId = Vehicaldetails.sharedInstance.siteID
        let HoseId = Vehicaldetails.sharedInstance.HoseID
        let IsHoseNameReplaced = "Y"
        let Url:String = FSURL//
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "SetHoseNameReplacedFlag"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        print(string)
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"SiteId\":\"\(SiteId)\",\"HoseId\":\"\(HoseId)\",\"IsHoseNameReplaced\":\"\(IsHoseNameReplaced)\"}"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "Set HoseName Replaced Flag SetHoseNameReplacedFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                print(response!)

            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "Set HoseName Replaced Flag SetHoseNameReplacedFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply + "#" + ""
    }


    func checkhour_odometer(vehicle_no:String, Barcodescanvalue:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid") //"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C"//"31A3557D-5913-42FA-A2D4-540446B2DBB2"
        //"6F90251E-71F2-449D-A721-31C1D1669E24"/ /
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID),\(Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx")")
        let Url:String = FSURL
        let FOBNumber = ""
        let string = uuid! + ":" + Email! + ":" + "CheckVehicleRequireOdometerEntryAndRequireHourEntry" + ":" + ""
        let Base64 = convertStringToBase64(string: string)
        print(Barcodescanvalue,uuid!,vehicle_no,FOBNumber,wifiSSID,siteid)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = try! JSONSerialization.data(withJSONObject: ["IMEIUDID": uuid!,
                                                                    "VehicleNumber": vehicle_no,
                                                                    "Barcode":Barcodescanvalue,
                                                                    "FOBNumber":FOBNumber,
                                                                    "WifiSSId": wifiSSID,"SiteId":siteid], options: [])
        //"{\"IMEIUDID\":\"\(uuid!)\",\"VehicleNumber\":\"\(vehicle_no)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\"}"
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {[unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
//                self.sentlog(func_name: "checkhour_odometer CheckVehicleRequireOdometerEntryAndRequireHourEntry Service Function", errorfromserverorlink: " ", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            } else {
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
//                self.sentlog(func_name: "checkhour_odometer CheckVehicleRequireOdometerEntryAndRequireHourEntry Service Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

                self.reply = "-1" //+ "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""
    }


    func sentlogFile()
    {
        
//        if(defaults.string(forKey: "potentialfix_ErrorGET_Date") == nil){
           
//        }else {
//            defaults.string(forKey: "potentialfix_ErrorGET_Date")
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "ddMMyyyy"
//
//            // start and end date object from string dates
//
//            let Currentdate =  Date()   //Currentd date save
//            //  print(contents)
//            let cal = Calendar.current
//            //error date when user get the error
//            let errordate = dateFormatter.date(from: String(defaults.string(forKey: "potentialfix_ErrorGET_Date")!.prefix(8))) ?? Date()
//
//            let d1 = errordate
//            let d2 = Currentdate
//            print(d1,d2)
//            //Date.init(timeIntervalSince1970: 1524787200) // April 27, 2018 12:00:00 AM
//            let components = cal.dateComponents([.day], from: d2, to: d1)
//            let diff = components.day!
//            print(diff)
//
//            if(diff < 0)
//            { defaults.set("", forKey: "potentialfix_ErrorGET_Date") }
//            else{
//            if(diff >= 7 ){
//                defaults.set("", forKey: "potentialfix_ErrorGET_Date")
//            }
//            else
//            {
//                 Vehicaldetails.sharedInstance.CollectDiagnosticLogs = "True"
//            }
//            }
//        }
        
        
        Vehicaldetails.sharedInstance.URL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"/
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = getDocumentsURL().appendingPathComponent("data/filedata/")
            let fromPath: String = (readdata!.path)
            do{
                    reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    do {
                       
                        //2020 06 12 DiagnosticLogs_iPhone.txt
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "ddMMyyyy"
                        
                        let predate = String(filename.prefix(10))
                                              
                        // start and end date object from string dates
                      
                        let endDate = dateFormatter.date(from: predate) ?? Date()
                        //  print(contents)
                        let cal = Calendar.current
                        let d1 = Date()
                        let d2 = endDate//Date.init(timeIntervalSince1970: 1524787200) // April 27, 2018 12:00:00 AM
                        let components = cal.dateComponents([.day], from: d2, to: d1)
                        let diff = components.day!
                        print(diff)
                        
                        if(diff > 60){
                            self.DeleteFileInApp(fileName: "data/filedata/" + filename)
                        }
                        
                    } catch let error as NSError {
                        print ("Error: \(error.domain)")
                        
                        // contents could not be loaded
                    }
                }
            }
        }
       
            else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
                
                file()
                
                let Email = defaults.string(forKey: "address")
                let uuid = defaults.string(forKey: "uuid")
                let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogs" + ":" + "iPhone"
                let Base64 = convertStringToBase64(string: string)
                let Url:String = FSURL
                let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
                request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                var reportsArray: [AnyObject]!
                let fileManager: FileManager = FileManager()
                let readdata = getDocumentsURL().appendingPathComponent("data/unsyncdata/")
                let fromPath: String = (readdata!.path)
                do{
                    do{ if(!FileManager.default.fileExists(atPath: fromPath))
                    {
                        do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                        }
                        catch{print("error")}
                        }
                    }
                    reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                    for x in 0  ..< reportsArray.count
                    {
                        let filename: String = "\(reportsArray[x])"
                        do {
                            let url = URL(fileURLWithPath: fromPath + "/\(filename)")
                            contents = try Data(contentsOf: url)
                            //  print(contents)
                            
                        } catch let error as NSError {
                            print ("Error: \(error.domain)")
                            
                            // contents could not be loaded
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        let predate = String(filename.prefix(10))
                        let dtt1 = dateFormatter.date(from: predate) ?? Date()
                        print(dtt1)
                        //let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                        dateFormatter.dateFormat = "yyyy MM dd"
                        let dtt: String = dateFormatter.string(from: dateFormatter.date(from: predate)! as Date)//= dateFormatter.string(from: NSDate() as Date)
                        let dataString = String(data: contents, encoding: String.Encoding.utf8)
                        let newString = dataString?.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString!)
                        let bodyData = "{\"Collectedlogs\":\"\(dtt1),\(String(describing: newString!))\",\"LogFrom\":\"iPhone\",\"FileName\":\"\(dtt) DiagnosticLogs_iPhone\"}"
                        request.httpBody = bodyData.data(using: String.Encoding.utf8)
                        //request.timeoutInterval = 2
                        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
                            if let data = data {
                                //  print(String(data: data, encoding: String.Encoding.utf8)!)
                               // print(self.replysentlog)
                                self.replysentlog = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                                 // print(self.replysentlog)
                                let data1 = self.replysentlog.data(using: String.Encoding.utf8)!
                                do{
                                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                }catch let error as NSError {
                                    print ("Error: \(error.domain)")
                                }
                               // print(self.sysdata)
                                if(self.sysdata == nil){}
                                else{
                                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                let ResponceMessage = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String
                                
                                if(ResponceMessage == "fail"){
                                    
                                }
                                if(ResponceMessage == "success"){
                                    self.DeleteFileInApp(fileName: "data/unsyncdata/" + filename)
                                }
                            }
                            } else {
                                print(error!)
                                //self.replysentlog = "-1" + "#" + "\(error!)"
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "ddMMyyyy"
//                                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//                                let dtt2: String = dateFormatter.string(from: NSDate() as Date)
                                
                            }
                        }
                        task.resume()
                    }
                }
            }
        
    }
    
    
    func file()
    {
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogFile" + ":" + "iPhone"
        let Base64 = convertStringToBase64(string: string)
        let Url:String = FSURL
       
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        var reportsArray: [AnyObject]!
        let fileManager: FileManager = FileManager()
        let readdata = getDocumentsURL().appendingPathComponent("data/filedata/")
        let fromPath: String = (readdata!.path)
        do{
            do
            {
                if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{print("error")}
                }
            }
            reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
            for x in 0  ..< reportsArray.count
            {
               
                let filename: String = "\(reportsArray[x])"
                do {
//                    let url = URL(fileURLWithPath: fromPath + "/\(filename)")
//                    contents = try Data(contentsOf: url)
                    //  print(contents)
                    
                } catch let error as NSError {
                    print ("Error: \(error.domain)")
                    
                    // contents could not be loaded
                }
                let dateFormatter = DateFormatter()
                                 dateFormatter.dateFormat = "ddMMyyyy"
                                 
                                 let predate = String(filename.prefix(10))
                                            print(predate)
                                 // start and end date object from string dates
                               
                                 let endDate = dateFormatter.date(from: predate) ?? Date()
                                 //  print(contents)
                                 let cal = Calendar.current
                                 let d1 = Date()
                                 let d2 = endDate//Date.init(timeIntervalSince1970: 1524787200) // April 27, 2018 12:00:00 AM
                                    print(d1,d2)
                                 let components = cal.dateComponents([.day], from: d2, to: d1)
                                 let diff = components.day!
                                 print(diff)
                                 
                                 if(diff > 60){
                                     self.DeleteFileInApp(fileName: "data/filedata/" + filename)
                                 }
                if(diff > 45){}
                else{
                
                
                let req = createRequest(authBase64: Base64, filename : filename, path: fromPath + "/\(filename)")
                
                
                let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                    if let data = data {
                        //  print(String(data: data, encoding: String.Encoding.utf8)!)
                        self.replysentlog = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                        //  print(self.replysentlog)
                        let data1 = self.replysentlog.data(using: String.Encoding.utf8)!
                        do{
                            self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        }catch let error as NSError {
                            print ("Error: \(error.domain)")
                        }
                        print(self.sysdata)
                        if(self.sysdata == nil){}
                        else{
                        // let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                        let ResponceMessage = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String
                        
                        if(ResponceMessage == "fail"){
                            
                        }
                        if(ResponceMessage == "success"){
                            self.DeleteFileInApp(fileName: "data/filedata/" + filename)
                        }
                        }
                    } else {
                        print(error!)
                        self.replysentlog = "-1" + "#" + "\(error!)"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "ddMMyyyy"
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        let dtt2: String = dateFormatter.string(from: NSDate() as Date)
                        
                    }
                }
                task.resume()
            }
            }
        }
    }
    
    //When ineternet is available send the Diagnostic log to server. if no internet connection then save the log into the file.
    //new change in this condition when CollectDiagnosticlogs flage is unchecked then also we need to store the diagnostic log for 30 days into the app.delete log from last thirty days.
    func sentlog(func_name:String,errorfromserverorlink:String,errorfromapp:String)
    {
        Vehicaldetails.sharedInstance.URL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"//
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        //print(Vehicaldetails.sharedInstance.CollectDiagnosticLogs,FSURL)
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")  //if  CollectDiagnosticLogs is false saving the log into the file when CollectDiagnosticLogs is true the upload the appto server.
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            
            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
            if(transactionID == "0"){
                transactionID = "NA"
            }
            
            let bodyData = "\(dtt1), TXTN ID - \(transactionID)" + "\(func_name),\(errorfromserverorlink),\(errorfromapp)***** \n\n"
            print(bodyData)
            
            //2020 06 12 DiagnosticLogs_iPhone.txt
            dateFormatter.dateFormat = "yyyy MM dd"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt2: String = dateFormatter.string(from: NSDate() as Date)
            
            if(self.checkPath(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == true) {
                if(bodyData != ""){
                    self.SaveLogFilesdata(fileName: "\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData) //save data into file.
                }
                //                let logdata = self.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
                //                print(logdata)
            }
            else if(self.checkPath(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == false){
                let readdata = getDocumentsURL().appendingPathComponent("data/filedata/")
                let fromPath: String = (readdata!.path)
                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                    }
                }
                self.CreateTextFile(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData)
            }
            
        }
        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            
            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
            if(transactionID == "0"){
                transactionID = "NA"
            }
            
            let bodyData = "@#^@#^\"\(dtt1), TXTN ID - \(transactionID)" + "\(func_name),\(errorfromserverorlink),\(errorfromapp)*****\""
            print(bodyData)
            
            dateFormatter.dateFormat = "yyyy MM dd"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt2: String = dateFormatter.string(from: NSDate() as Date)
            
            if(self.checkPath(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == true) {
                if(bodyData != ""){
                    self.SaveLogFile(fileName: "\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData) //save data into file.
                }
                //                let logdata = self.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
                //                print(logdata)
            }
            else if(self.checkPath(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == false){
                self.CreateTextFile(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData)
            }
        }
    }
    
    
//    func sentlog(func_name:String,errorfromserverorlink:String,errorfromapp:String)
//    {
////        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
////        print(Vehicaldetails.sharedInstance.CollectDiagnosticLogs)
////        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")  //if  CollectDiagnosticLogs is false saving the log into the file when CollectDiagnosticLogs is true the upload the appto server.
////        {
//////            let dateFormatter = DateFormatter()
//////            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
//////            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//////            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
//////
//////            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
//////            if(transactionID == "0"){
//////                transactionID = "NA"
//////            }
//////
//////            let bodyData = "\(dtt1), Transaction ID - \(transactionID)" + "\(func_name),\(errorfromserverorlink),\(errorfromapp)***** \n\n"
//////            print(bodyData)
//////
//////            //2020 06 12 DiagnosticLogs_iPhone.txt
//////            dateFormatter.dateFormat = "yyyy MM dd"
//////            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//////            let dtt2: String = dateFormatter.string(from: NSDate() as Date)
//////
//////            if(self.checkPath(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == true) {
//////                if(bodyData != ""){
//////                    self.SaveLogFilesdata(fileName: "\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData) //save data into file.
//////                }
//////                //                let logdata = self.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
//////                //                print(logdata)
//////            }
//////            else if(self.checkPath(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == false){
//////                let readdata = getDocumentsURL().appendingPathComponent("data/filedata/")
//////                let fromPath: String = (readdata!.path)
//////                do{ if(!FileManager.default.fileExists(atPath: fromPath))
//////                {
//////                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
//////                    }
//////                    catch{print("error")}
//////                    }
//////                }
//////                self.CreateTextFile(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData)
//////            }
////
////        }
////        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
////
////            let Email = defaults.string(forKey: "address")
////                            let uuid = defaults.string(forKey: "uuid")
////                            let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogs" + ":" + "iPhone"
////                            let Base64 = convertStringToBase64(string: string)
////                            let Url:String = FSURL
////                            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
////                            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
////                            request.httpMethod = "POST"
////            request.timeoutInterval = 10
////            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
////            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
////            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
////
////            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
////            if(transactionID == "0"){
////                transactionID = "NA"
////            }
////
////            let bodyData1 = "@#^@#^\"\(dtt1), Transaction ID - \(transactionID)" + "\(func_name),\(errorfromserverorlink),\(errorfromapp)*****\""
////            print(bodyData1)
////
////                                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
////                                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
////
////                                    let dtt: String = dateFormatter.string(from: NSDate() as Date)
////                                    dateFormatter.dateFormat = "yyyy MM dd"
////
////
////                                    let bodyData = "{\"Collectedlogs\":\"\(dtt1),\(String(describing: bodyData1))\",\"LogFrom\":\"iPhone\",\"FileName\":\"\(dtt) DiagnosticLogs_iPhone\"}"
////                                    request.httpBody = bodyData.data(using: String.Encoding.utf8)
////                                    //request.timeoutInterval = 2
////                                    let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
////                                        if let data = data {
////                                            //  print(String(data: data, encoding: String.Encoding.utf8)!)
////                                           // print(self.replysentlog)
////                                            self.replysentlog = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
////                                             // print(self.replysentlog)
////                                            let data1 = self.replysentlog.data(using: String.Encoding.utf8)!
////                                            do{
////                                                self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
////                                            }catch let error as NSError {
////                                                print ("Error: \(error.domain)")
////                                            }
////                                           // print(self.sysdata)
////                                            if(self.sysdata == nil){}
////                                            else{
////                                            let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
////                                            let ResponceMessage = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String
////
////                                            if(ResponceMessage == "fail"){
////
////                                            }
////                                            if(ResponceMessage == "success"){
////                                                //self.DeleteFileInApp(fileName: "data/unsyncdata/" + filename)
////                                            }
////                                        }
////                                        } else {
////                                            print(error!)
////                                            //self.replysentlog = "-1" + "#" + "\(error!)"
////            //                                let dateFormatter = DateFormatter()
////            //                                dateFormatter.dateFormat = "ddMMyyyy"
////            //                                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
////            //                                let dtt2: String = dateFormatter.string(from: NSDate() as Date)
////
////                                        }
////
////
////                                }
////            task.resume()
////
//////            dateFormatter.dateFormat = "yyyy MM dd"
//////            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//////            let dtt2: String = dateFormatter.string(from: NSDate() as Date)
////
//////            if(self.checkPath(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == true) {
//////                if(bodyData != ""){
//////                    self.SaveLogFile(fileName: "\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData) //save data into file.
//////                }
//////                //                let logdata = self.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
//////                //                print(logdata)
//////            }
//////            else if(self.checkPath(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == false){
//////                self.CreateTextFile(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData)
//////            }
////        }
//    }


    func vehicleAuth(vehicle_no:String,Odometer:Int,isdept:String,isppin:String,isother:String, Barcodescanvalue:String) -> String {

        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"

        let isdept = Vehicaldetails.sharedInstance.deptno
        let isPPin = Vehicaldetails.sharedInstance.Personalpinno
        let isother = Vehicaldetails.sharedInstance.Other
        var Odometer:String = Vehicaldetails.sharedInstance.Odometerno

        //Add this change on 11Aug on testing
        if(Vehicaldetails.sharedInstance.Odometerno == "")
        {
            Odometer = "0"
        }
        //
        let hour = Vehicaldetails.sharedInstance.hours
        // let vehiclerequired = Vehicaldetails.sharedInstance
        var TransactionId:String!
        let FOBNumber = ""
        var VehicleExtraOther = ""
        let Barcode = Barcodescanvalue
        let Email = defaults.string(forKey: "address")
        let uuid =  defaults.string(forKey: "uuid") //"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C"//"31A3557D-5913-42FA-A2D4-540446B2DBB2"//"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C"
        //
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        var Errorcode = Vehicaldetails.sharedInstance.Errorcode;
        if(Errorcode == "")
        {
            Errorcode = "0"
        }
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "AuthorizationSequence" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        if(Vehicaldetails.sharedInstance.IsExtraOther == "False"){
            VehicleExtraOther = ""
        }else if(Vehicaldetails.sharedInstance.IsExtraOther == "True")
        {
            VehicleExtraOther = Vehicaldetails.sharedInstance.ExtraOther
        }
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

        let bodyData = try! JSONSerialization.data(withJSONObject: ["IMEIUDID":uuid,
                                                                    "IsVehicleNumberRequire":"\(Vehicaldetails.sharedInstance.IsVehicleNumberRequire)",
            "VehicleNumber": vehicle_no,
            "Odometer":Odometer,
            "ErrorCode":Errorcode,
            "FOBNumber":FOBNumber,
            "Barcode":Barcode,
            "WifiSSId":wifiSSID,
            "SiteId":siteid,
            "DepartmentNumber":isdept,
            "PersonnelPIN":"\(isPPin)",
            "Other":"\(isother)",
            "Hours":"\(hour)",
            "VehicleExtraOther": VehicleExtraOther,
            "CurrentLat":"\(Vehicaldetails.sharedInstance.Lat)",
            "CurrentLng":"\(Vehicaldetails.sharedInstance.Long)",
            "RequestFrom":"I",
            "versionno":"Apple watch 6",
            "Device Type":"Apple watch 6)",
            "iOS": "Apple watch 6",


        ],options: [])
//        "versionno":"\(Version)",
//        "Device Type":"\(UIDevice().type)",
//        "iOS": "\(UIDevice.current.systemVersion)",
        //        "{\"IMEIUDID\":\"\(uuid!)\",\"IsVehicleNumberRequire\":\"\(Vehicaldetails.sharedInstance.IsVehicleNumberRequire)\",\"VehicleNumber\":\"\(vehicle_no)\",\"OdoMeter\":\"\(Odometer)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\",\"DepartmentNumber\":\"\(isdept)\",\"PersonnelPIN\":\"\(isPPin)\",\"Other\":\"\(isother)\",\"Hours\":\"\(hour)\",\"CurrentLat\":\"\(Vehicaldetails.sharedInstance.Lat)\",\"CurrentLng\":\"\(Vehicaldetails.sharedInstance.Long)\",\"RequestFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {

                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply!)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
               // self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                // print(self.sysdata)
                if(self.sysdata == nil){}
                else{
                    let ResponceMessage = self.sysdata.value(forKey: "ResponceMessage") as! String

                    if(ResponceMessage == "success")
                    {
                        let ResponceData = self.sysdata.value(forKey: "ResponceData") as! NSDictionary
                        let MinLimit = ResponceData.value(forKey: "MinLimit") as! NSNumber
                        let PulseRatio = ResponceData.value(forKey: "PulseRatio") as! NSNumber
                        let VehicleId = ResponceData.value(forKey: "VehicleId") as! NSNumber
                        let FuelTypeId = ResponceData.value(forKey: "FuelTypeId") as! NSNumber
                        let PersonId = ResponceData.value(forKey: "PersonId") as! NSNumber
                        let PhoneNumber = ResponceData.value(forKey: "PhoneNumber") as! NSString
                        let PulserStopTime = ResponceData.value(forKey: "PulserStopTime") as! NSString
                        let ServerDate = ResponceData.value(forKey: "ServerDate") as! String
                        let pumpoff_time = ResponceData.value(forKey: "PumpOffTime") as! String
                        let pumpon_time = ResponceData.value(forKey: "PumpOnTime") as! String
                        let LimitReachedMessage = ResponceData.value(forKey: "LimitReachedMessage") as! String
                        if(ResponceData.value(forKey: "TransactionId") == nil){}
                        else{
                            TransactionId = ResponceData.value(forKey: "TransactionId") as! NSString as String
                            Vehicaldetails.sharedInstance.TransactionId = Int(TransactionId as String)!
                            Vehicaldetails.sharedInstance.pulsarCount = ""
                        }
                        let FilePath = ResponceData.value(forKey: "FilePath") as! NSString
                        let FirmwawareVersion = ResponceData.value(forKey: "FirmwareVersion") as! NSString

                        print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio)

                        Vehicaldetails.sharedInstance.FirmwareVersion = FirmwawareVersion as String
                        Vehicaldetails.sharedInstance.FilePath = FilePath as String
                        Vehicaldetails.sharedInstance.MinLimit = "\(MinLimit)"
                        Vehicaldetails.sharedInstance.PulseRatio = "\(PulseRatio)"
                        Vehicaldetails.sharedInstance.VehicleId = "\(VehicleId)"
                        Vehicaldetails.sharedInstance.FuelTypeId = "\(FuelTypeId)"
                        Vehicaldetails.sharedInstance.PersonId = "\(PersonId)"
                        Vehicaldetails.sharedInstance.PhoneNumber = "\(PhoneNumber)"
                        Vehicaldetails.sharedInstance.PulserStopTime = "\(PulserStopTime)"
                        Vehicaldetails.sharedInstance.date = "\(ServerDate)"
                        Vehicaldetails.sharedInstance.pumpoff_time = "\(pumpoff_time)" //Send pump off time to pulsar off time.
                        Vehicaldetails.sharedInstance.pumpon_time = "\(pumpon_time)" //Send pump off time to pulsar off time.
                        Vehicaldetails.sharedInstance.LimitReachedMessage = "\(LimitReachedMessage)"
                    }

                }
            } else {

                self.reply = "-1" + "#" + "\(error!)"
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""
    }


    func setimeiSelectCompany(Companyid:String)-> String
    {
            FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let Url:String = FSURL
            let string = uuid! + ":" + Email! + ":" + "SetIMEIToSelectedCompany"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

            request.httpMethod = "POST"

            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

            let bodyData = try! JSONSerialization.data(withJSONObject: ["IMEIUDID": uuid!,"CompanyId":Companyid], options: [])
            request.httpBody = bodyData//.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10

            let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request as URLRequest) { [unowned self]  data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String

//                    print(self.reply)

                } else {
                    print(error!)
                    let text = (error?.localizedDescription)! //+ error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    //self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                    self.reply = "-1"
                }
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return reply

    }


    func UpdateInterruptedTransactionFlag()
    {
            FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let Url:String = FSURL
            let string = uuid! + ":" + Email! + ":" + "UpdateInterruptedTransactionFlag"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            print(Vehicaldetails.sharedInstance.TransactionId)
            request.httpMethod = "POST"

            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

        let bodyData = try! JSONSerialization.data(withJSONObject: ["TransactionId": Vehicaldetails.sharedInstance.TransactionId], options: [])
            request.httpBody = bodyData//.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10

            let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request as URLRequest) { [unowned self]  data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String

//                    print(self.reply)
//                    self.sentlog(func_name: "UpdateInterrupted TransactionFlag Service Function", errorfromserverorlink: " Response from Server $$ \(reply!)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                } else {
                    print(error!)
                    let text = (error?.localizedDescription)!// + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    //self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                    self.reply = "-1"
                }
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)



    }


    func departmentAuth(_ DepartmentNumber:String) ->String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL
        //        let FOBNumber = ""
        let string = uuid! + ":" + Email! + ":" + "ValidateDepartmentNumber" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        //        print(Barcodescanvalue,uuid!,vehicle_no,FOBNumber,wifiSSID,siteid)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        let PersonnalPIN = ""
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = try! JSONSerialization.data(withJSONObject: ["IMEIUDID": uuid!,
                                                                    "DepartmentNumber": DepartmentNumber,
                                                                    //"Barcode":Barcodescanvalue,
            "PersonnelPIN":PersonnalPIN,
            "WifiSSId": wifiSSID,"SiteId":siteid, "RequestFrom":"I",
            "versionno":"Apple watch 6",
            "Device Type":"Apple watch 6",
            "iOS": "Apple watch 6"], options: [])

//        "versionno":"\(Version)",
//        "Device Type":"\(UIDevice().type)",
//        "iOS": "\(UIDevice.current.systemVersion)"]
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
               // self.sentlog(func_name: "checkhour_odometer ValidateDepartmentNumber Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            } else {
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
               // self.sentlog(func_name: "checkhour_odometer ValidateDepartmentNumber Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }



    func Transactiondetails(bodyData:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid") //"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C"//"31A3557D-5913-42FA-A2D4-540446B2DBB2"//"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C" //
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "SavePreAuthTransactions"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)

            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "Transactiondetails SavePreAuthTransactions Service Function, ", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" )
                self.reply = "-1"

            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


    func Transaction_details(bodyData:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid") //"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C"//"31A3557D-5913-42FA-A2D4-540446B2DBB2"//"4E2E9DA6-0AFF-4F72-AC1F-C41421B4BC8C" //
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "TransactionComplete"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { [unowned self]  data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String

//                print(self.reply)

            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" )
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


//    func tldsendserver(bodyData:Data) -> String {
//        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
//        let Email = defaults.string(forKey: "address")
//        let uuid = defaults.string(forKey: "uuid")
//        let Url:String = FSURL
//        let string = uuid! + ":" + Email! + ":" + "SaveTankMonitorReading"
//        let Base64 = convertStringToBase64(string: string)
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
//        self.sentlog(func_name: " send service call tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)")
//        request.httpMethod = "POST"
//        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 10
//        print(bodyData)
//        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
//                //  print(self.reply)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
//                // print(self.reply)
//                let text = self.reply
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//            } else {
//                print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return reply
//    }


    func sendSiteID() -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "UpgradeIsBusyStatus"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"SiteId\":\"\(siteid)\"}"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 30

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                // print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "SendSiteID with command: UpgradeIsBusyStatus {SiteId:\(siteid)}", errorfromserverorlink: " Response from link $$ \(newString)!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            } else {
                print(error!)
                self.reply = "-1"
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "SendSiteID with command: UpgradeIsBusyStatus {SiteId:\(siteid)}", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


    func getrelay() -> String {
        let Url:String = "http://192.168.4.1:80/config?command=relay"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        request.timeoutInterval = 5

        request.httpMethod = "GET"

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "Start Button Tapped GetRelay Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")

            } else {
                print(error!)
                let text = (error?.localizedDescription)!// + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
//                self.sentlog(func_name: "Start Button Tapped GetRelay Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return reply + "#" + ""
    }


//    func tldlevel() -> String {
//
//        let Url:String = "http://192.168.4.1:80/tld?level=info"
//
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 5
//        self.sentlog(func_name: "Get tldlevel from the link ", errorfromserverorlink: self.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                // print(self.reply)
//                self.sentlog(func_name: "Send tldlevel Function to link", errorfromserverorlink:"",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                let text = self.reply
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//
//                if( self.reply == nil)
//                {self.reply = ""}
//                self.sentlog(func_name: "Get tldlevel Function", errorfromserverorlink: " Response from link $$ \(responsestring)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//
//            } else {
//                //print(error!)
//                let text = (error?.localizedDescription)!// + error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//
//                self.reply = "-1"
//                self.sentlog(func_name: "Get error in tldlevel Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        // print(reply)
//        return reply
//    }


//    func getlastTrans_ID() -> String{
//        let Url:String = "http://192.168.4.1:80/client?command=lasttxtnid"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
//        request.httpMethod = "GET"
//
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                //  print(self.reply)
//                let text = self.reply
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "Fueling Page Get LastTransaction_ID Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//
//                print("Response: \(String(describing: response))")
//            } else {
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return reply
//    }


//    func pulsarlastquantity(){
//        let Url:String = "http://192.168.4.1:80/client?command=record10"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
//        request.httpMethod = "GET"
//
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                //  print(self.pulsardata)
//                let text = self.pulsardata
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "Fueling Page Get Pulsar_LastQuantity Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
//                do{
//                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                }catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                }
//                if(self.sysdata1 == nil){}
//                else{
//                    if(newString.contains("N/A"))
//                    {
//                        let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
//                        let counts_data = objUserData.value(forKey: "1:") as! NSString
//                        if(counts_data == "N/A"){}
//                        else{
//                            let t_count = Int(truncating: Int(counts_data as String)! as NSNumber)
//                        print(t_count)
//                        Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//                        }
//
//                    }
//                    else{
//                    let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
//                    let counts_data = objUserData.value(forKey: "1:") as! NSNumber
//
//                        let t_count = Int(truncating: counts_data)
//                    print(t_count)
//                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//
//                    }
//                }
//            } else {
//                print(error as Any)
//                self.pulsardata = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//    }

//    func cmtxtnid10(){
//        Vehicaldetails.sharedInstance.Last10transactions = []
//        let Url:String = "http://192.168.4.1:80/client?command=cmtxtnid10"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
//        request.httpMethod = "GET"
//
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                 // print(self.pulsardata)
//                let text = self.pulsardata
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                if(newString == ""){
//                     Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
//                }
////                self.sentlog(func_name: "Fueling Page Get cmtxtnid10 Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
//                do{
//                    self.sysdataLast10trans = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                }catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                    self.sysdataLast10trans = nil
//                }
//                if(self.sysdataLast10trans == nil){
//                     Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
//                }
//                else{
//
//                    if(newString.contains("TXTNINFO")){
//                        //  print(self.sysdataLast10trans)
//                        let objUserData = self.sysdataLast10trans.value(forKey: "cmtxtnid_10_record") as! NSDictionary
//                        let txtninfo1 = objUserData.value(forKey: "1:TXTNINFO:") as! String
//                        let txtninfo2 = objUserData.value(forKey: "2:TXTNINFO:") as! String
//                        let txtninfo3 = objUserData.value(forKey: "3:TXTNINFO:") as! String
//                        let txtninfo4 = objUserData.value(forKey: "4:TXTNINFO:") as! String
//                        let txtninfo5 = objUserData.value(forKey: "5:TXTNINFO:") as! String
//                        let txtninfo6 = objUserData.value(forKey: "6:TXTNINFO:") as! String
//                        let txtninfo7 = objUserData.value(forKey: "7:TXTNINFO:") as! String
//                        let txtninfo8 = objUserData.value(forKey: "8:TXTNINFO:") as! String
//                        let txtninfo9 = objUserData.value(forKey: "9:TXTNINFO:") as! String
//                        let txtninfo10 = objUserData.value(forKey: "10:TXTNINFO:") as! String
//
//                        self.Splitedata1(trans_info: txtninfo1)
//                        self.Splitedata(trans_info: txtninfo1)
//                        self.Splitedata(trans_info: txtninfo2)
//                        self.Splitedata(trans_info: txtninfo3)
//                        self.Splitedata(trans_info: txtninfo4)
//                        self.Splitedata(trans_info: txtninfo5)
//                        self.Splitedata(trans_info: txtninfo6)
//                        self.Splitedata(trans_info: txtninfo7)
//                        self.Splitedata(trans_info: txtninfo8)
//                        self.Splitedata(trans_info: txtninfo9)
//                        self.Splitedata(trans_info: txtninfo10)
//                    }
//                    else {
//
//                    //  print(self.sysdataLast10trans)
//                    let objUserData = self.sysdataLast10trans.value(forKey: "cmtxtnid_10_record") as! NSDictionary
//                    let txtninfo1 = objUserData.value(forKey:"1:") as! String
//                    let txtninfo2 = objUserData.value(forKey:"2:") as! String
//                    let txtninfo3 = objUserData.value(forKey:"3:") as! String
//                    let txtninfo4 = objUserData.value(forKey:"4:") as! String
//                    let txtninfo5 = objUserData.value(forKey:"5:") as! String
//                    let txtninfo6 = objUserData.value(forKey:"6:") as! String
//                    let txtninfo7 = objUserData.value(forKey:"7:") as! String
//                    let txtninfo8 = objUserData.value(forKey:"8:") as! String
//                    let txtninfo9 = objUserData.value(forKey:"9:") as! String
//                    let txtninfo10 = objUserData.value(forKey:"10:") as! String
//
//                    self.Splitedata1(trans_info: txtninfo1)
//                    self.Splitedata(trans_info: txtninfo1)
//                    self.Splitedata(trans_info: txtninfo2)
//                    self.Splitedata(trans_info: txtninfo3)
//                    self.Splitedata(trans_info: txtninfo4)
//                    self.Splitedata(trans_info: txtninfo5)
//                    self.Splitedata(trans_info: txtninfo6)
//                    self.Splitedata(trans_info: txtninfo7)
//                    self.Splitedata(trans_info: txtninfo8)
//                    self.Splitedata(trans_info: txtninfo9)
//                    self.Splitedata(trans_info: txtninfo10)
//
//                    }
//                    //                    let t_count = Int(truncating: counts)
//                    //                    print(t_count)
//                    //                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//                }
//            } else {
//                print(error as Any)
//                self.pulsardata = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//    }


    func Splitedata1(trans_info:String){
        let Split = trans_info.components(separatedBy: "-")

        let transid = Split[0];
        //let pulses = Split[1];

        Vehicaldetails.sharedInstance.Last_transactionformLast10 = transid


    }

//    func Splitedata(trans_info:String){
//        let Split = trans_info.components(separatedBy: "-")
//
//        let transid = Split[0];
//        let pulses = Split[1];
//        if(pulses == "N/A"){}
//        else{
//        let quantity = self.calculate_fuelquantity(quantitycount: Int(pulses as String)!)
//        let transaction_details = Last10Transactions(Transaction_id: transid, Pulses: pulses, FuelQuantity: "\(quantity)")
//        Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
//    }
//    }





//    func GetPulser()->String {
//
//        let Url:String = "http://192.168.4.1:80/client?command=pulsar"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 5 //////timeout interval should be increased it is 4 earlier now i am convert it to 10
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                // DispatchQueue.main.async{
//                self.replygetpulsar = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                // print(self.replygetpulsar)
//
//
//
//            } else {
//                print(error!)
//
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "GetPulser Service Function", errorfromserverorlink: " Response from Link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                self.replygetpulsar = "-1" + "#" + "\(error!)"
//            }
//            semaphore.signal()
//
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//
//        return replygetpulsar + "#" + ""
//    }


//    func getinfo() -> String {
//
//        let Url:String = "http://192.168.4.1:80/client?command=info"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task =  URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                //                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//
//                print(self.reply!)
//                let text = self.reply!
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                if(newString.contains("iot_version"))
//                {
//                    self.showstartbutton = "true"
//                    self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$\(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                }else{
//
//                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
//                    do{
//                        //  print(self.sysdata)
//                        self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                        let Version = self.sysdata.value(forKey: "Version") as! NSDictionary
//
//                        let iot_version = Version.value(forKey: "iot_version") as! NSString
//                        let mac_address = Version.value(forKey: "mac_address") as! NSString
//
//                        self.showstartbutton = "true"
//                        print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
//                        if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){
//
//                        }else {
//                            print(Vehicaldetails.sharedInstance.FS_MacAddress)
//                            Vehicaldetails.sharedInstance.FS_MacAddress = mac_address as String
//                        }
//
//                        if(Vehicaldetails.sharedInstance.FirmwareVersion == "\(iot_version)"){
//                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
//                        }
//                        else if(Vehicaldetails.sharedInstance.FirmwareVersion != "\(iot_version)"){
//                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = true
//                            Vehicaldetails.sharedInstance.FirmwareVersion = "\(iot_version)"
//                        }
//                    }
//                    catch let error as NSError {
//                        print ("Error: \(error.domain)")
//                        let text = error.localizedDescription //+ error.debugDescription
//                        let test = String((text.filter { !" \n".contains($0) }))
//                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                        print(newString)
//                        self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.getSSID())")
//                        self.isconect_toFS = "false"
//                        if(self.isconect_toFS == "true"){
//                            self.showstartbutton = "false"
//                        }else
//                            if(self.isconect_toFS == "false"){
//                                self.showstartbutton = "false"
//                        }
//                    }}
//            } else {
//                print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//
//        return showstartbutton
//    }

//    func getinfo_ssid() -> String {
//
//        let Url:String = "http://192.168.4.1:80/config?command=wifi"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task =  URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                //                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//
//                // print(self.reply)
//                let text = self.reply
//                //                let test = String((text?.filter { !" \n".contains($0) })!)
//                //                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                //                print(newString)
//                if((text?.contains("Connect_Softap"))!)
//                {
//                    //                    self.showstartbutton = "true"
//                    //                    self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$\(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//                    //                }else{
//
//                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
//                    do{
//                        //print(self.sysdata)
//                        self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                        // print(self.sysdata)
//                        let Version = self.sysdata.value(forKey: "Response") as! NSDictionary
//                        let Softap = Version.value(forKey: "Softap") as! NSDictionary
//                        let Connect_Softap = Softap.value(forKey: "Connect_Softap") as! NSDictionary
//                        let ssid = Connect_Softap.value(forKey: "ssid") as! NSString
//                        let password = Connect_Softap.value(forKey: "password") as! NSString
//                        //                        let serial_number = Version.value(forKey: "serial_number") as! NSString
//                        if(ssid as String == Vehicaldetails.sharedInstance.SSId){
//                            Vehicaldetails.sharedInstance.checkSSIDwithLink = "true"
//                            self.showstartbutton = "true"
//
//                        }else
//                        {
//                            Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
//                            self.showstartbutton = "false"
//                        }
//                        //                        print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
//                        //                        if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){
//                        //
//                        //                        }else {
//                        //                            print(Vehicaldetails.sharedInstance.FS_MacAddress)
//                        //                            Vehicaldetails.sharedInstance.FS_MacAddress = mac_address as String
//                        //                        }
//                        //
//                        //                        if(Vehicaldetails.sharedInstance.FirmwareVersion == "\(iot_version)"){
//                        //                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
//                        //                        }
//                        //                        else if(Vehicaldetails.sharedInstance.FirmwareVersion != "\(iot_version)"){
//                        //                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = true
//                        //                            Vehicaldetails.sharedInstance.FirmwareVersion = "\(iot_version)"
//                        //                        }
//                    }
//                    catch let error as NSError {
//                        print ("Error: \(error.domain)")
//                        let text = error.localizedDescription //+ error.debugDescription
//                        let test = String((text.filter { !" \n".contains($0) }))
//                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                        print(newString)
//                        self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.getSSID())")
//                        self.isconect_toFS = "false"
//                        if(self.isconect_toFS == "true"){
//                            self.showstartbutton = "false"
//                        }else
//                            if(self.isconect_toFS == "false"){
//                                self.showstartbutton = "false"
//                        }
//                    }
//
//                }
//                else
//                {
//                    self.showstartbutton = "invalid"
//                }
//            } else {
//                print(error!)
//                let text = (error?.localizedDescription)!// + error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.getSSID())")
//
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//
//        return showstartbutton
//    }

//    func SetPulser0() -> String {
//        let Url:String = "http://192.168.4.1:80/config?command=pulsar"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        let bodyData = "{\"pulsar_request\":{\"counter_set\":0}}"
//
//        request.httpMethod = "POST"
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                // print(self.reply)
//
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("Status code: (\(httpResponse.statusCode))")
//                    if(httpResponse.statusCode != 200)
//                    {
//                        self.reply = "true"
//                    }
//                    else {
//                        self.reply = "false"
//                    }
//                }
//
//            } else {
//                print(error!)
//                self.reply = "-1"
//            }
//        }
//        task.resume()
//        return reply
//    }
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
    
    
    
    
    func CreateunsyncFile(fileName: String, writeText: String)
    {
        //        let createfile = getDocumentsURL().appendingPathComponent("data/unsyncdata/" + fileName)
        //        let fromPath: String = (createfile!.path)
        
        let _: FileManager = FileManager()
        let readdata = getDocumentsURL().appendingPathComponent("data/unsyncdata/")
        let fromPath: String = (readdata!.path)
        do{ if(!FileManager.default.fileExists(atPath: fromPath))
        {
            do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch{print("error")}
            }
        }
        //        do{
        //            do{try writeText.write(toFile: fromPath + fileName, atomically: true, encoding: String.Encoding.utf8)}
        //            catch{print("error")}
        //        }
    }
    
    // Create Directory :
    
    func createDirectory(){
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        
        if !fileManager.fileExists(atPath: paths){
            
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            
        }else{
            
            print("Already dictionary created.")
            
        }
        
    }
    
    func saveImageDocumentDirectory(Image:UIImage){
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("logoimage.jpg")
        //
        //        let image = UIImage(named: "apple.jpg")
        
        print(Image)
        
        let imageData = Image.jpegData(compressionQuality: 0.5)//UIImageJPEGRepresentation(Image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
    }
    
    func getDirectoryPath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
    
    
    
    //    Delete Directory :
    
    func deleteDirectory(){
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        
        if fileManager.fileExists(atPath: paths){
            
            try! fileManager.removeItem(atPath: paths)
            
        }else{
            
            print("Something wronge.")
            
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
    
//    var locationManager = CLLocationManager()
//    var currentNetworkInfos: Array<NetworkInfo>? {
//        get {
//            return SSID.fetchNetworkInfo()
//        }
//    }
    
//    public class SSID {
//        class func fetchNetworkInfo() -> [NetworkInfo]? {
//            if let interfaces: NSArray = CNCopySupportedInterfaces() {
//                var networkInfos = [NetworkInfo]()
//                for interface in interfaces {
//                    let interfaceName = interface as! String
//                    var networkInfo = NetworkInfo(interface: interfaceName,
//                                                  success: false,
//                                                  ssid: nil)
//
//                    if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
//                        networkInfo.success = true
//                        networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
//                        //networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
//                    }
//                    networkInfos.append(networkInfo)
//                }
//                return networkInfos
//            }
//            return nil
//        }
//    }
//
//
    
    
//    func getSSID() -> String {
//        var ssid = ""
//        if #available(iOS 13.0, *) {
//            let status = CLLocationManager.authorizationStatus()
//            if status == .authorizedWhenInUse {
//                ssid = updateWiFi()
//                if(Vehicaldetails.sharedInstance.SSId == ssid)
//                {
//                    Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
//                    return ssid
//                }else
//                {
//                    if(ssid == "")
//                    {
//
//                        if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
//                            return Vehicaldetails.sharedInstance.SSId
//                        }
//                    }
//                    // return Vehicaldetails.sharedInstance.SSId
//                }
//
//            } else {
//                locationManager.delegate = self as? CLLocationManagerDelegate
//                locationManager.requestWhenInUseAuthorization()
//
//            }
//        } else {
//            ssid = updateWiFi()
//            return ssid
//        }
//        if(ssid == "")
//        {
//
//            if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
//                return Vehicaldetails.sharedInstance.SSId
//            }
//        }
//
//        return ssid
//    }
//
//    struct NetworkInfo {
//        var interface: String
//        var success: Bool = false
//        var ssid: String?
//        //  var bssid: String?
//    }
    //        }
    
//    func updateWiFi() -> String {
//        if(currentNetworkInfos?.first?.ssid == nil){
//            return ""
//        }else{
//            print("SSID: \(currentNetworkInfos?.first?.ssid ?? "")")
//                   // print(currentNetworkInfos?.first?.ssid)
//            //        print(currentNetworkInfos?.first?.bssid)
//            if(currentNetworkInfos?.first?.ssid == nil){
//                return ""
//            }else{
//                return (currentNetworkInfos?.first?.ssid)!
//            }}}
//
        
//
    
    
    //    func getInterfaces() -> Bool {
    //        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
    //            print("this must be a simulator, no interfaces found")
    //            return false
    //        }
    //        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
    //            print("System error: did not come back as array of Strings")
    //            return false
    //        }
    //        for interface in swiftInterfaces {
    //            print("Looking up SSID info for \(interface)")
    //            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
    //                print("System error: \(interface) has no information")
    //                return false
    //            }
    //            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
    //                print("System error: interface information is not a string-keyed dictionary")
    //                return false
    //            }
    //            for d in SSIDDict.keys {
    //                print("\(d): \(SSIDDict[d]!)")
    //            }
    //        }
    //        return true
    //    }
    
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
    
    func SaveTransactionstatus(fileName: String, writeText: String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("data/unsyncTransstatus/")
        let fromPath: String = (readdata!.path)
        do{
            do{ if(!FileManager.default.fileExists(atPath: fromPath))
            {
                do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch
                {print("error")}
                }
            }
            let writePath = getDocumentsURL().appendingPathComponent("data/unsyncTransstatus/" + fileName)
            let wPath: String = (writePath!.path)
            do { try writeText.write(toFile: wPath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch
            {print("error")}
        }
    }
    
    func SaveLogFilesdata(fileName: String, writeText: String)
    {
        let readdata = getDocumentsURL().appendingPathComponent("data/filedata/" + fileName)
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
    func convertStringToBase64(string: String) -> String
    {
        let utf8str = string.data(using: String.Encoding.utf8)!
        let base64str = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        return base64str
    }
//
//
//
    func createRequest (authBase64:String,filename:String, path:String) -> NSURLRequest {
        let param = ["Authorization"  : authBase64]  // build your dictionary however appropriate

        let boundary = generateBoundaryString()
        let url = NSURL(string:FSURL)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(authBase64)", forHTTPHeaderField: "Authorization")

        let path1 = path
        print(path1)
        // let filename = filename

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "",filename: filename, paths: [path1], boundary: boundary) as Data
        return request
    }

    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request

    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?,filename:String?, paths: [String]?, boundary: String) -> NSData {
        let body = NSMutableData()

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        if paths != nil {
            for path in paths! {
                let url = URL(fileURLWithPath: path)
                let filename = url.lastPathComponent

                do {
                    contents = try Data(contentsOf: url)
                    //print(contents)
                } catch {
                    // contents could not be loaded
                }

                //let data = Data(contentsOfURL: url as URL)!

                let mimetype = mimeTypeForPath(path: path)

                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                body.append(contents)
                body.appendString(string: "\r\n")
                // }
            }
        }

        body.appendString(string: "--\(boundary)--\r\n")
        print(body)
        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.

    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    
    
    func UploadUnsyncdata(jsonstring: String,siteName:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL

        string_data = uuid! + ":" + Email! + ":" + "\(siteName)"//TransactionComplete"
        print(string_data,jsonstring)
        let Base64 = convertStringToBase64(string_data)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        print(jsonstring)
        request.httpBody = jsonstring.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) {  data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                //print(self.reply)
                //"\(self.reply)"
                let data1 = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
               // print(self.sysdata)

                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                self.ResponceMessageUpload = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                if(self.ResponceMessageUpload == "fail"){
                    if(ResponceText == "TransactionId not found."){
                       
                    }
                    // self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                }
                if(self.ResponceMessageUpload == "success"){
                    self.defaults.set(nil, forKey: "LastCount")
                    self.defaults.set(nil, forKey: "transactionID")
                    self.defaults.set(nil, forKey: "pulsarratio")
                    self.defaults.set(nil,forKey: "InterruptedTransactionFlag")
                    
                    self.sentlog(func_name: "Complete Transaction send to server", errorfromserverorlink: " Response from Server $$ \(jsonstring)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " ")
                    if(siteName == "TransactionComplete"){
                        
                      //  self.Send10trans()
                    }
                }
            } else {
               // print(error as Any)
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func syncTransactions()
    {
        let count_Last = defaults.string(forKey: "LastCount")
        let transactionid_Last = defaults.string(forKey: "transactionID")
        let pulsarratio = defaults.string(forKey: "pulsarratio")
        let InterruptedTransactionFlag = defaults.bool(forKey: "InterruptedTransactionFlag")
            
       
        
        if(count_Last == nil || transactionid_Last == nil || pulsarratio == nil){}
        else{
            print(count_Last!,transactionid_Last!,pulsarratio!)
            let lastcount = Int(count_Last!)
            
            let fuelQuantity = calculate_fuelquantity(quantitycount: lastcount!, pulsarratio: pulsarratio!)
            let bodyData = "{\"TransactionId\":\(transactionid_Last!),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(count_Last!),\"TransactionFrom\":\"I\",\"versionno\":\"\(8.4)\",\"Device Type\":Apple Watch,\"iOS\": \"watchos\",\"Transaction\":\"Current_Transaction\"}"
            UploadUnsyncdata(jsonstring: bodyData,siteName:"TransactionComplete")
        }
        if(InterruptedTransactionFlag == true)
        {
            if(transactionid_Last == nil){
                
            }
            else{
           // self.web.UpdateInterruptedTransactionFlag(TransactionId: transactionid_Last!,Flag: "y") /// 1168 if relay off is not working then app sends to server Transaction id.
                }
        }
    }

    func unsyncTransaction() //-> String
    {
        
        syncTransactions()
        
        if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
        {
            sentlogFile()
            unsyncUpgradeTransactionStatus()
            let logdata = self.ReadFile(fileName: "Sendlog.txt")
            print(logdata)
            self.sentlog(func_name: "unsyncTransaction", errorfromserverorlink: "\(logdata)", errorfromapp: "")

            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
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
                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    let Split = filename.components(separatedBy: "#")
                    _ = Split[1]
                    let quantity = Split[2]
                    let siteName = Split[3]
                    if(quantity == "0" ){
                        //web.UpgradeTransactionStatus(Transaction_id:Transaction_id,Status: "1")
                        self.DeleteReportTextFile(fileName: filename, writeText: "")
                    }else if(quantity == "" ){
                        self.DeleteReportTextFile(fileName: filename, writeText: "")
                    }

                    let JData: String = ReadReportFile(fileName: filename)
                    if(JData != "")
                    {
                        if(siteName == "SaveTankMonitorReading"){
                            Upload(jsonstring: JData,filename: filename,siteName:"SaveTankMonitorReading")
                        }

                        else {
                            Upload(jsonstring: JData,filename: filename,siteName:"TransactionComplete")
                        }
                        if(ResponceMessageUpload == "success"){
//                            self.notify(site: siteName)
                        }
                    }
                }
            }
        }

        else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
        {
            sentlogFile()
            unsyncUpgradeTransactionStatus()
            
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = getDocumentsURL().appendingPathComponent("data/test/")!
            let fromPath: String = (readdata.path)
            do{

                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                    }
                }

                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
                for x in 0  ..< reportsArray.count
                {
                    let filename: String = "\(reportsArray[x])"
                    let Split = filename.components(separatedBy: "#")
                    _ = Split[1]
                    let quantity = Split[2]
                    let siteName = Split[3]
                    self.sentlog(func_name: "unsyncTransaction", errorfromserverorlink: "\(filename)", errorfromapp: "")
                    if(quantity == "0" ){
                        //web.UpgradeTransactionStatus(Transaction_id:Transaction_id,Status: "1")
                        self.sentlog(func_name: "unsyncTransaction", errorfromserverorlink: "\(filename)", errorfromapp: "")
                        
                        self.DeleteReportTextFile(fileName: filename, writeText: "")
                        
                    }else if(quantity == "" ){
                        self.DeleteReportTextFile(fileName: filename, writeText: "")
                    }
                    else {
                        let JData: String = ReadReportFile(fileName: filename)
                        print(JData)
                        if(JData != "")
                        {
                            if(siteName == "SaveTankMonitorReading"){
                                Upload(jsonstring: JData,filename: filename,siteName:"SaveTankMonitorReading")
                            }
                            else{
                                Upload(jsonstring: JData,filename: filename,siteName:"TransactionComplete")
                            }

                            if(ResponceMessageUpload == "success"){
//                                self.notify(site: siteName)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = getDocumentsURL().appendingPathComponent("data/test/")
            let fromPath: String = (readdata!.path)
           
                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                    }
                }
                reportsArray = fileManager.subpaths(atPath: fromPath)! as [AnyObject]
            if(reportsArray.count > 0)
            {
                Vehicaldetails.sharedInstance.Warningunsync_transaction = "True"
            }else if(reportsArray.count == 0)
            {
                Vehicaldetails.sharedInstance.Warningunsync_transaction = "Flase"
            }
        }
        //stopbutton = false
        //  }
    }



    func Upload(jsonstring: String,filename:String,siteName:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL

        string_data = uuid! + ":" + Email! + ":" + "\(siteName)"//TransactionComplete"
        print(string_data,jsonstring)
        let Base64 = convertStringToBase64(string_data)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        print(jsonstring)
        request.httpBody = jsonstring.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) {  data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                //print(self.reply)
                //"\(self.reply)"
                if(self.reply.contains("html"))
                                {
                                    self.DeleteReportTextFile(fileName: filename, writeText: "")
                                }
                                else{
                let data1 = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
               // print(self.sysdata)

                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                self.ResponceMessageUpload = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                if(self.ResponceMessageUpload == "fail"){
                    if(ResponceText == "TransactionId not found."){
                       
                    }
                    // self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                }
                if(self.ResponceMessageUpload == "success"){
                    self.defaults.set(nil, forKey: "LastCount")
                    self.defaults.set(nil, forKey: "transactionID")
                    self.defaults.set(nil, forKey: "pulsarratio")
                    self.defaults.set(nil,forKey: "InterruptedTransactionFlag")
                    
                    self.DeleteReportTextFile(fileName: filename, writeText: "")
                    self.sentlog(func_name: "Complete Transaction send to server", errorfromserverorlink: " Response from Server $$ \(jsonstring)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)")
                    if(siteName == "TransactionComplete"){
                        
                      //  self.Send10trans()
                    }
                }
                }
            } else {
               // print(error as Any)
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    func calculate_fuelquantity(quantitycount: Int,pulsarratio:String)-> Double
    {
        
        if(quantitycount == 0)
        {
            fuelquantity = 0
        }
        else{
            Vehicaldetails.sharedInstance.pulsarCount = "\(quantitycount)"
            let pulsarratio = Vehicaldetails.sharedInstance.PulseRatio
            fuelquantity = (Double(quantitycount))/(pulsarratio as NSString).doubleValue
        }
        return fuelquantity
    }

//    func notify(site:String) {
//        let userNotificationCenter = UNUserNotificationCenter.current()
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = "FluidSecure"
//            notificationContent.body = NSLocalizedString("Notify", comment:"") + "\(site)."
//        notificationContent.sound = UNNotificationSound.default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
//                                                            repeats: false)
//            let request = UNNotificationRequest(identifier: "testNotification",
//                                                content: notificationContent,
//                                                trigger: trigger)
//
//            userNotificationCenter.add(request) { (error) in
//                if let error = error {
//                    print("Notification Error: ", error)
//                }}
////        let localNotification: UILocalNotification = UILocalNotification()
////        localNotification.alertAction = "open"
////        localNotification.alertBody = NSLocalizedString("Notify", comment:"") + "\(site)."//"Your Transaction is Successfully Completed at \(site)."
////        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
////        localNotification.soundName = "button-24.mp3"//UILocalNotificationDefaultSoundName
////        UIApplication.shared.scheduleLocalNotification(localNotification)
//    }
//

//    func Send10trans() {
//        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
//        let Email = defaults.string(forKey: "address")
//        let uuid = defaults.string(forKey: "uuid")
//        let Url:String = FSURL
//        let string = uuid! + ":" + Email! + ":" + "SaveMultipleTransactions"
//        let Base64 = convertStringToBase64(string: string)
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//
//        request.httpMethod = "POST"
//        if(Vehicaldetails.sharedInstance.Last10transactions.count == 0){}
//        else {
//        for i in 0  ..< Vehicaldetails.sharedInstance.Last10transactions.count
//        {
//            let obj : Last10Transactions = Vehicaldetails.sharedInstance.Last10transactions[i] as! Last10Transactions
//            let Transid = obj.Transaction_id
//            let pulse = obj.Pulses
//            let quantity = obj.FuelQuantity
//
//            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//            let bodyData = try! JSONSerialization.data(withJSONObject:["TransactionId":Transid,
//                                                                       "Pulses":pulse,
//                                                                       "FuelQuantity":"\(quantity)",
//                ],options: [])
//            if let JSONString = String(data: bodyData, encoding: String.Encoding.utf8) {
//                print(JSONString)
//
//                ConcateJsonString += JSONString + ","
//
//            }
//            print(ConcateJsonString)
//        }
//        print(ConcateJsonString)
//        print(ConcateJsonString.dropLast())
//        let JSONdata = ConcateJsonString.dropLast()
//            let bodyData = "{cmtxtnid_10_record:[" + "\(JSONdata)" + "]}"
//        print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//        //        RequestFrom":"I",
//        //        "Device Type":"\(UIDevice().type)",
//        //        "iOS": "\(UIDevice.current.systemVersion)"
//        request.timeoutInterval = 10
//
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//              //  print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
//                //print(self.reply)
//                Vehicaldetails.sharedInstance.Last10transactions = []
//
//            } else {
//              //  print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//             //   print(newString)
//                sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" )
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        //        return reply
//        }
//
//    }
}
