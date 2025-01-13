//
//  Webservices.swift
//  FuelSecuer
//
//  Created by VASP on 5/23/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import MobileCoreServices
import NetworkExtension


let imageCache = NSCache<NSString, UIImage>()

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




class Webservices:NSObject {
    var reply :String! = ""
    var replysentlog :String!
    var replygetpulsar :String!
    var replygetvehicledata :String!
    var replygetDeptdata :String!
    var sysdata:NSDictionary!
    var sysdata1:NSDictionary!
    var sysdataLast10trans:NSDictionary!
    let defaults = UserDefaults.standard
    var cf = Commanfunction()
    //var UDP = FuelquantityVCUDP()
    var isconect_toFS:String = ""
    var showstartbutton:String = ""
    var contents:Data!
    var image = UIImage()
    var LINKDisconnectionErrorcount = 0
    var pulsardata:String!
    var isLINKDisconnectionError = false
  //  private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
    var isUpgradeCurrentiotVersiontoserver = false
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
            self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
               
                //print(var backgroundTimeRemaining: TimeInterval { get })
                self.endBackgroundUpdateTask()
            })
        }

        func endBackgroundUpdateTask() {
            UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
            self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
        }
    
    func doBackgroundTask() {
                   DispatchQueue.main.async(execute: {
                       self.beginBackgroundUpdateTask()
                    
                    self.downloadthevehicles(url: URL(fileURLWithPath: Vehicaldetails.sharedInstance.PreAuthVehicleDataFilePath) as URL, completion:{_,_ in ((path:String?, error:NSError?) -> ()).self
                       
                    })
                       
                       self.downloadtheDepartment(url: URL(fileURLWithPath: Vehicaldetails.sharedInstance.PreAuthDepartmentDataFilePath) as URL, completion:{_,_ in ((path:String?, error:NSError?) -> ()).self
                          
                       })
                       // End the background task.
           
                       self.endBackgroundUpdateTask()
                   })
           
               }
    
   
    
    //Live
        @available(iOS 11.0, *)
        func wifisettings(pagename:String){
//            print(Vehicaldetails.sharedInstance.SSId)
//            let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
//            hotspotConfig.joinOnce = false
//
//
//            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
//                       print("error is \(String(describing: error))")
//                       if let error = error {
//                           let nsError = error as NSError
//                           if nsError.domain == "NEHotspotConfigurationErrorDomain" {
//                               if let configError = NEHotspotConfigurationError(rawValue: nsError.code) {
//                                   switch configError {
//                                   case .invalidWPAPassphrase:
//                                       print("password error: \(error.localizedDescription)")
//                                   case .invalid, .invalidSSID, .invalidWEPPassphrase,
//                                        .invalidEAPSettings, .invalidHS20Settings, .invalidHS20DomainName, .userDenied, .pending, .systemConfiguration, .unknown, .joinOnceNotSupported, .alreadyAssociated, .applicationIsNotInForeground, .internal:
//                                       print("other error: \(error.localizedDescription)")
//                                    self.sentlog(func_name: "other error: \(error.localizedDescription)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
//                                   @unknown default:
//                                       print("later added error: \(error.localizedDescription)")
//                                    self.sentlog(func_name: "later added error: \(error.localizedDescription)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
//                                   }
//                               }
//                           } else {
//                               print("some other error: \(error.localizedDescription)")
//                            self.sentlog(func_name: "some other error: \(error.localizedDescription)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
//
//                           }
//                       } else {
//                           print("perhaps connected")
//                        self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically ", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
//
//                       }
//                   }
//
////            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
////
////                if let error = error
////                {
////                  print("Error\(error)")
////                }
////                else {
////                    self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically ", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
//////                        print("Connected")
////                }
////            }
        }
    //UDP
        func wifi_settings_check(pagename:String)
        {
            
            print(Vehicaldetails.sharedInstance.SSId)
            let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
            hotspotConfig.joinOnce = false
            //print(hotspotConfig.signalStrength)

            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in

                if error?.localizedDescription == "already associated."
                                {
                                    print("Connected")
                                }
                if let error = error
                {
                  print("Error\(error)")
                    
                }
                else {
                    self.sentlog(func_name: "Connecting to \(Vehicaldetails.sharedInstance.SSId).", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                        print("Connected")
                  

                }
            }
        }
//
//    //Live
//
        func wifisettings_check(pagename:String) //-> String
        {
            
            print(Vehicaldetails.sharedInstance.SSId)
            let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
            hotspotConfig.joinOnce = true

            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in

                if error?.localizedDescription == "already associated."
                                {
                                    print("Connected")
//                                    isconnected = "true"
                                }
                if let error = error
                {
                  print("Error\(error)")
                    //return isconnected
                }
                else {
                    self.sentlog(func_name: "Connecting to \(Vehicaldetails.sharedInstance.SSId)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                        print("Connected")
//                    isconnected = "true"
                    //return isconnected
                }
            }
//            return isconnected
        }
    
    
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
//                self.sentlog(func_name: "Checkurl ,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink: "",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//
//            } else {
//                //print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                //print(newString)
//                self.sentlog(func_name: "Checkurl,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
    
    
    func Preauthrization(uuid:String,lat:String,long:String)->String {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Url:String = FSURL
        let Email = ""
        let string = uuid + ":" + Email + ":" + "SavePreAuthTransactions"
        
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "Authenticate:I:" + "\(lat),\(long),versionno.\(Version),Device Type:\(UIDevice().type),iOS:\(UIDevice.current.systemVersion)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                //   print(self.reply)
            } else {
                //  print(error!)
                
                self.reply = "-1" + "#" + "\(error!.localizedDescription)"
                //  print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                
                self.sentlog(func_name: "Preauthrization Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply// + "#" + ""
    }
    
    func downloadtheDepartment(url: URL, completion: @escaping (String?, Error?) -> Void)
    {

        if(Vehicaldetails.sharedInstance.PreAuthDepartmentDataFilePath == ""){}
        else{
        let newString = Vehicaldetails.sharedInstance.PreAuthDepartmentDataFilePath.replacingOccurrences(of: " " , with: "%20", options: .literal, range: nil)
        print(newString)
        print(Vehicaldetails.sharedInstance.PreAuthDepartmentDataFilePath)
        
                    let url = URL(string: newString)!
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                    let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
            print(destinationUrl)
            let filename = url.lastPathComponent
            
            defaults.set(filename, forKey: "dateof_DownloadPreAuthDepartmentData")
           

//
//                       // cf.DeleteFileInApp(fileName: destinationUrl.path)
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
                let filename = url.lastPathComponent
                
//                defaults.set(filename, forKey: "dateof_DownloadVehiclesForphonefilename")
               

//
//                       // cf.DeleteFileInApp(fileName: destinationUrl.path)
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
                                            self.defaults.set(filename, forKey: "dateof_DownloadVehiclesForphonefilename")
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

    func GetDepartmentsForPhone()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hhmmss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let startdate: String = dateFormatter.string(from: NSDate() as Date)

        print("\(startdate) started GetDepartmentsForPhone")
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        
        let uuid = defaults.string(forKey: "uuid")
        
        let Url:String =  Vehicaldetails.sharedInstance.URL + "api/Offline/GetDepartments?Email=\(Email)&IMEI=\(uuid!)"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
//        request.timeoutInterval = 1 //////timeout interval should be increased it is 4 earlier now i am convert it to 10
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                // DispatchQueue.main.async{
                self.replygetDeptdata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                self.doBackgroundTask()
                
                 print(self.replygetDeptdata)
                if(self.replygetDeptdata.contains("success"))
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE,dd/MM/yyyy"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    let dateofdownload: String = dateFormatter.string(from: NSDate() as Date)
                    self.defaults.set(dateofdownload, forKey: "dateof_DownloadPreAuthDepartmentData")//"dateof_DownloadDepartmentsForphone")
                    print("\(dateofdownload) dateofdownload")
                }
                
                
                
            } else {
                print(error!)
                
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
                self.sentlog(func_name: "GetDepartmentsForPhone Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.replygetDeptdata = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return replygetDeptdata + "#" + ""
    }
   
    
    func GetVehiclesForPhone()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hhmmss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let startdate: String = dateFormatter.string(from: NSDate() as Date)

        print("\(startdate) started getvehiclesforPhone")
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        
        let uuid = defaults.string(forKey: "uuid")
        
        let Url:String =  Vehicaldetails.sharedInstance.URL + "api/Offline/GetVehiclesForPhone?Email=\(Email)&IMEI=\(uuid!)"
        print(Url)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
//        request.timeoutInterval = 1 //////timeout interval should be increased it is 4 earlier now i am convert it to 10
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                // DispatchQueue.main.async{
                self.replygetvehicledata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                self.doBackgroundTask()
                
                 print(self.replygetvehicledata)
                if(self.replygetvehicledata.contains("success"))
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE,dd/MM/yyyy"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    let dateofdownload: String = dateFormatter.string(from: NSDate() as Date)
                    self.defaults.set(dateofdownload, forKey: "dateof_DownloadVehiclesForphone")
                    print("\(dateofdownload) dateofdownload")
                }
                
                
                
            } else {
                print(error!)
                
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
                self.sentlog(func_name: "GetVehiclesForPhone Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.replygetvehicledata = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return replygetvehicledata + "#" + ""
    }
    
    
    
    func checkApprove(uuid:String,lat:String!,long:String!)->String {
        if(Vehicaldetails.sharedInstance.Language == ""){
            ///Vehicaldetails.sharedInstance.Language = "en-ES"
        }
      var UUID_string = uuid
        //defaults.set("", forKey: "address")
        let Url:String = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        if(uuid == "")
        {
            print(" UUID Get \(uuid)")
            self.sentlog(func_name: " UUID:\(uuid))", errorfromserverorlink: "", errorfromapp: "")
            let preuuid = defaults.string(forKey: "uuid")
            if(preuuid == nil || preuuid == "")
            {
                 UUID_string = UIDevice.current.identifierForVendor!.uuidString
                KeychainService.savePassword(token: UUID_string as NSString)
                defaults.set(UUID_string, forKey: "uuid")
            }
            else{
                UUID_string = preuuid! as String
            }
                
        }
        
            let string = UUID_string + ":" + Email + ":" + "Other" + ":" + "\(Vehicaldetails.sharedInstance.Language)" + ":" + "\(brandname)"
            print(string)
       
//        let string = uuid + ":" + Email + ":" + "Other" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        print(Base64)
        self.sentlog(func_name: "checkApprove command sent to server.", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 15
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
        // print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        Vehicaldetails.sharedInstance.TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                 print(self.reply)
                let text = self.reply
                if text!.contains("ResponceMessage"){
                    
                }else{
                    self.reply = "-1"
                }
                //                var check = String((text?.{ !"ResponceMessage".contains($0)})!)
                
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                if(newString.contains("success"))
                {
                    self.sentlog(func_name: "<Check Approve> Authenticate:I: \(lat!),\(long!), Devicetype:\(UIDevice().type), uuid(\(uuid)), iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "")
                }
                else{
                    self.sentlog(func_name: "<Check Approve> Authenticate:I: \(lat!),\(long!), Devicetype:\(UIDevice().type), uuid(\(uuid)), iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: "response from sever \(newString) ",errorfromapp: "")
                }
                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
               
                self.sentlog(func_name: "<Check Approve> \(text) Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type), uuid(\(uuid)), iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
       // }
        return reply
    }
    
    
    func Login(_ Username:String,PWD:String,uuid:String)->String {
        let Url:String = Vehicaldetails.sharedInstance.URL + "LoginHandler.ashx"
        let string = uuid + ":" + Username + ":" + PWD + ":" + "\(Vehicaldetails.sharedInstance.Language)"
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
                self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                //print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
        
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)#:#I#:#\(brandname)#:#\(UIDevice().type)#:#iOS \(UIDevice.current.systemVersion)"
//        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)#:#I#:#\(brandname)"
        //        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) {  data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                
            } else {
                // print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.reply = "-1" + "#" + "\(error!)"
                self.sentlog(func_name: "Registration Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }
    
    func unsyncUpgradeTransactionStatus()
    {
        
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        if (uuid == nil)
        {
            
        }
        else{
            let string = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"
            let Base64 = convertStringToBase64(string: string)
            let Url:String = FSURL
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/unsyncTransstatus/")
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
                        let JData: String = cf.ReadFile(fileName: "data/unsyncTransstatus/" + filename)
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
                            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
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
                                            self.cf.DeleteFileInApp(fileName: "data/unsyncTransstatus/" + filename)
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
    }
    
    
    
    func UpdateInterruptedTransactionFlag(TransactionId:String)
    {
            FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let Url:String = FSURL
            let string = uuid! + ":" + Email! + ":" + "UpdateInterruptedTransactionFlag"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            print(TransactionId)
            request.httpMethod = "POST"
            
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            
        let bodyData = try! JSONSerialization.data(withJSONObject: ["TransactionId": TransactionId], options: [])
            request.httpBody = bodyData//.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10
            
            let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    
                    print(self.reply)
                    self.sentlog(func_name: "UpdateInterrupted TransactionFlag Service Function", errorfromserverorlink: " Response from Server $$ \(self.reply!)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                } else {
                    print(error!)
                    let text = (error?.localizedDescription)!// + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    self.reply = "-1"
                }
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
           
        
        
    }

    
    func UpgradeTransactionStatus(Transaction_id:String,Status:String)
    {   FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        
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
                    self.sentlog(func_name: "UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                                self.cf.SaveTransactionstatus(fileName: unsycnfileName, writeText: jsonstring)
                            }
                            
                        }
                        let text = (error?.localizedDescription)! //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        //  print(newString)
                        self.sentlog(func_name: "UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                }
            }
            task.resume()
        }
    }
    
    
//    func UpdateGetPulserTypeFromLINKFlag() -> String {
//        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
//       
//        let Siteid = Vehicaldetails.sharedInstance.siteID
//        let p_type = defaults.string(forKey: "UpdateSwitchTimeBounceForLink")
//        let Url:String = FSURL
//        let Email = defaults.string(forKey: "address")
//        let uuid = defaults.string(forKey: "uuid")
//        let string = uuid! + ":" + Email! + ":" + "UpdateGetPulserTypeFromLINKFlag"
//        let Base64 = convertStringToBase64(string: string)
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
//        
//        print(string)
//        request.httpMethod = "POST"
//        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//        let bodyData = "{\"SiteId\":\"\(Siteid)\",\"GetPulserTypeFromLINK\":\"\(p_type!)\"}"//
//        print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//        request.timeoutInterval = 10
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
//                // print(self.reply)
//                // print(response!)
//            } else {
//                //  print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                // print(newString)
//                self.sentlog(func_name: "UpdateGetPulserTypeFromLINKFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                self.reply = "-1" + "#" + "\(error!)"
//            }
//        }
//        task.resume()
//        return reply //+ "#" + ""
//    }
    
    
    
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
        self.sentlog(func_name: "Upgrade Current Version toserver body data \(bodyData)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " ")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                // print(self.reply)
                // print(response!)
                self.sentlog(func_name: "Upgrade Current Version toserver UpgradeCurrentVersionWithUgradableVersion Service Function", errorfromserverorlink: " Response from Server $$ \(self.reply!)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            } else {
                //  print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                self.sentlog(func_name: "Upgrade Current Version toserver UpgradeCurrentVersionWithUgradableVersion Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply //+ "#" + ""
    }
    
    
//    func UpdateSwitchTimeBounceForLink() -> String {
//        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
////        let Version = Vehicaldetails.sharedInstance.FirmwareVersion
////        let HoseId = Vehicaldetails.sharedInstance.HoseID
//
//        let Url:String = FSURL
//        let Email = defaults.string(forKey: "address")
//        let uuid = defaults.string(forKey: "uuid")
//        let string = uuid! + ":" + Email! + ":" + "UpdateSwitchTimeBounceForLink"
//        let Base64 = convertStringToBase64(string: string)
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
//
//        print(string)
//        request.httpMethod = "POST"
//        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//        let bodyData = "{\"SiteId\":\(Vehicaldetails.sharedInstance.siteID),\"IsResetSwitchTimeBounce\":0}"//
//        print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//        request.timeoutInterval = 10
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
//                 print(self.reply)
//                // print(response!)
//            } else {
//                //  print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                // print(newString)
//                self.sentlog(func_name: "Upgrade Current Version toserver UpdateSwitchTimeBounceForLink Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                self.reply = "-1" + "#" + "\(error!)"
//            }
//        }
//        task.resume()
//        return reply //+ "#" + ""
//    }
    
    func UpdateSwitch_TimeBounceForLink() -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
//        let Version = Vehicaldetails.sharedInstance.FirmwareVersion
//        let HoseId = Vehicaldetails.sharedInstance.HoseID
        
        let Url:String = FSURL
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpdatePulserTypeOfLINK"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        let p_type = defaults.string(forKey: "UpdateSwitchTimeBounceForLink")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let dtt: String = dateFormatter.string(from: NSDate() as Date)
        print(dtt)
        print(string,p_type)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"email\":\"\(Email!)\",\"IMEIUDID\":\"\(uuid!)\",\"PulserType\":\"\(p_type!)\",\"SiteId\":\"\(Vehicaldetails.sharedInstance.siteID)\",\"DateTimeFromApp\":\"\(dtt)\"}"//IMEIUDID,Email,HoseId,       PulserType
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                 print(self.reply)
                self.sentlog(func_name: "UpdatePulserTypeOfLINK Service Function \(bodyData)", errorfromserverorlink: " Response from Server $$ \(self.reply)!!", errorfromapp: " " )
                // print(response!)
            } else {
                //  print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                 print(newString)
                self.sentlog(func_name: "Upgrade Current Version toserver UpdateSwitchTimeBounceForLink Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                
                let unsycnfileName =  dtt1 + "#" + "Pulsar type" + "#" + Vehicaldetails.sharedInstance.SSId //
                if(bodyData != ""){
                    self.cf.Saveptype(fileName: unsycnfileName, writeText: bodyData)
                    self.sentlog(func_name: " Saved Pulsar type to Phone, data \(bodyData)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                   
                }
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply //+ "#" + ""
    }
    
    func UpdateSwitchTimeBounceForLink() -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
//        let Version = Vehicaldetails.sharedInstance.FirmwareVersion
//        let HoseId = Vehicaldetails.sharedInstance.HoseID
        
        let Url:String = FSURL
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpdateSwitchTimeBounceForLink" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        
        print(string)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"SiteId\":\(Vehicaldetails.sharedInstance.siteID),\"IsResetSwitchTimeBounce\":0}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                 print(self.reply)
                self.sentlog(func_name: "UpdateSwitchTimeBounceForLink Service Function", errorfromserverorlink: " Response from Server $$ \(self.reply)!!", errorfromapp: " " )
                // print(response!)
            } else {
                //  print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                 print(newString)
                self.sentlog(func_name: "Upgrade Current Version toserver UpdateSwitchTimeBounceForLink Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                
                let unsycnfileName =  dtt1 + "#" + "Pulsar type" + "#" + Vehicaldetails.sharedInstance.SSId //
                if(bodyData != ""){
                    self.cf.Saveptype(fileName: unsycnfileName, writeText: bodyData)
                    self.sentlog(func_name: " Saved Pulsar type to Phone, data \(bodyData)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                   
                }
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply //+ "#" + ""
    }
    
    func SetHoseNameReplacedFlag() //-> String
    { //-- service
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
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Set HoseName Replaced Flag SetHoseNameReplacedFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                print(response!)
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Set HoseName Replaced Flag SetHoseNameReplacedFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
//        return reply// + "#" + ""
    }
    
    
    func checkhour_odometer(_ vehicle_no:String,_ Barcodescanvalue:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL
        let FOBNumber = ""
        let string = uuid! + ":" + Email! + ":" + "CheckVehicleRequireOdometerEntryAndRequireHourEntry" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
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
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                {
                    if(newString.contains("fail"))
                    {
                        self.sentlog(func_name: "check if odometer or hour required. \(newString)", errorfromserverorlink: " ", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "")
                    }
                    else
                    {
                        self.sentlog(func_name: "check if odometer or hour required. Success", errorfromserverorlink: " ", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "")
                    }
                }
                else
                {
                    self.sentlog(func_name: "check if odometer or hour required. Success", errorfromserverorlink: " ", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                }
                
                
            } else {
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                {
                self.sentlog(func_name: "check if odometer or hour required. \(newString)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "")
                }else
                {
                    self.sentlog(func_name: "check if odometer or hour required. fail \(newString)", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                }
                
                self.reply = "-1" //+ "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""
    }
    
    
    func potentialfix()
    {
        if(Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {
            self.file()  // if internet is not availble here then log save into the files and we have to send it when internet is available.
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            let strDate = dateFormatter.string(from: NSDate() as Date)
            print(strDate)
            
            defaults.set(strDate, forKey: "potentialfix_ErrorGET_Date")
            defaults.set("True", forKey: "CollectDiagnosticLogs_Whengettingerror")
            
            print(defaults.string(forKey: "potentialfix_ErrorGET_Date")!)
            
        }
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
        
        
        
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/filedata/")
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
                            self.cf.DeleteFileInApp(fileName: "data/filedata/" + filename)
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
                let readdata = cf.getDocumentsURL().appendingPathComponent("data/unsyncdata/")
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
                              print(contents)
                            
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
                        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
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
                                    self.cf.DeleteFileInApp(fileName: "data/unsyncdata/" + filename)
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
        if(uuid == nil || uuid == ""){}
        else
            {
            let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogFile" + ":" + "iPhone"
            let Base64 = convertStringToBase64(string: string)
            let Url:String = FSURL
            
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/filedata/")
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
                        self.cf.DeleteFileInApp(fileName: "data/filedata/" + filename)
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
                                        self.cf.DeleteFileInApp(fileName: "data/filedata/" + filename)
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
    }
    
    //When ineternet is available send the Diagnostic log to server. if no internet connection then save the log into the file.
    //new change in this condition when CollectDiagnosticlogs flage is unchecked then also we need to store the diagnostic log for 45 days into the app.delete log from last thirty days.
    func sentlog(func_name:String,errorfromserverorlink:String,errorfromapp:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        print(Vehicaldetails.sharedInstance.CollectDiagnosticLogs,FSURL)
        if(Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "" || Vehicaldetails.sharedInstance.CollectDiagnosticLogs == nil)
        {
            Vehicaldetails.sharedInstance.CollectDiagnosticLogs = "True"
        }
        
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")  //if  CollectDiagnosticLogs is false saving the log into the file when CollectDiagnosticLogs is true the upload the appto server.
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            var bodyData = ""
            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
         
           
            
            if(transactionID == "0"){
                transactionID = "NA"
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "")
                {
                    bodyData = "@#^@#^\"\(dtt1),\(func_name),\(errorfromserverorlink),\(errorfromapp)\""
                }
                else{
                 bodyData = "@#^@#^\"\(dtt1),[TXTN-\(Vehicaldetails.sharedInstance.HubLinkCommunication)]  \(func_name),\(errorfromserverorlink),\(errorfromapp)\""
                }
            }
            else{
            
             bodyData = "@#^@#^\"\(dtt1),[TXTN-\(Vehicaldetails.sharedInstance.HubLinkCommunication)] TXTN ID - \(transactionID)" + " \(func_name),\(errorfromserverorlink),\(errorfromapp)\""
            }
           
            print(bodyData)
            
            //2020 06 12 DiagnosticLogs_iPhone.txt
            dateFormatter.dateFormat = "yyyy MM dd"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt2: String = dateFormatter.string(from: NSDate() as Date)
            
            if(self.cf.checkPath(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == true) {
                if(bodyData != ""){
                    self.cf.SaveLogFilesdata(fileName: "\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData) //save data into file.
                }
                //                let logdata = self.cf.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
                //                print(logdata)
            }
            else if(self.cf.checkPath(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == false){
                let readdata = cf.getDocumentsURL().appendingPathComponent("data/filedata/")
                let fromPath: String = (readdata!.path)
                do{ if(!FileManager.default.fileExists(atPath: fromPath))
                {
                    do{ try FileManager.default.createDirectory(atPath: fromPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch{print("error")}
                    }
                }
                self.cf.CreateTextFile(fileName: "data/filedata/\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData)
            }
            
        }
        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            var bodyData = ""
            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
            if(transactionID == "0"){
                transactionID = "NA"
                
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "")
                {
                    bodyData = "@#^@#^\"\(dtt1),\(func_name),\(errorfromserverorlink),\(errorfromapp)\""
                }
                else{
                 bodyData = "@#^@#^\"\(dtt1),[TXTN-\(Vehicaldetails.sharedInstance.HubLinkCommunication)]  \(func_name),\(errorfromserverorlink),\(errorfromapp)\""
                }
            }
            else{
            
             bodyData = "@#^@#^\"\(dtt1),[TXTN-\(Vehicaldetails.sharedInstance.HubLinkCommunication)] TXTN ID - \(transactionID)" + " \(func_name),\(errorfromserverorlink),\(errorfromapp)\""
            }
            print(bodyData)
            
            dateFormatter.dateFormat = "yyyy MM dd"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt2: String = dateFormatter.string(from: NSDate() as Date)
            
            if(self.cf.checkPath(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == true) {
                if(bodyData != ""){
                    self.cf.SaveLogFile(fileName: "\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData) //save data into file.
                    
                }
                //                let logdata = self.cf.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
                //                print(logdata)
            }
            else if(self.cf.checkPath(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt") == false){
                self.cf.CreateTextFile(fileName: "data/unsyncdata/\(dtt2) " + "DiagnosticLogs_iPhone.txt", writeText: bodyData)
            }
        }
    }
    
    
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
        let uuid = defaults.string(forKey: "uuid")
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
            "versionno":"\(Version)",
            "Device Type":"\(UIDevice().type)",
            "iOS": "\(UIDevice.current.systemVersion)",
            
            
        ],options: [])
        
        //        "{\"IMEIUDID\":\"\(uuid!)\",\"IsVehicleNumberRequire\":\"\(Vehicaldetails.sharedInstance.IsVehicleNumberRequire)\",\"VehicleNumber\":\"\(vehicle_no)\",\"OdoMeter\":\"\(Odometer)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\",\"DepartmentNumber\":\"\(isdept)\",\"PersonnelPIN\":\"\(isPPin)\",\"Other\":\"\(isother)\",\"Hours\":\"\(hour)\",\"CurrentLat\":\"\(Vehicaldetails.sharedInstance.Lat)\",\"CurrentLng\":\"\(Vehicaldetails.sharedInstance.Long)\",\"RequestFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 20
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply!)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
               // self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                        self.defaults.setValue("0", forKey: "previouspulsedata")
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
                        let IsFirstTimeUse  = ResponceData.value(forKey: "IsFirstTimeUse") as! String
                        if(ResponceData.value(forKey: "TransactionId") == nil){}
                        else{
                            TransactionId = ResponceData.value(forKey: "TransactionId") as! NSString as String
                            Vehicaldetails.sharedInstance.TransactionId = Int(TransactionId as String)!
                            Vehicaldetails.sharedInstance.pulsarCount = ""
                        }
                        let FilePath = ResponceData.value(forKey: "FilePath") as! NSString
                        let FirmwawareVersion = ResponceData.value(forKey: "FirmwareVersion") as! NSString
                        
                        print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio,FilePath)
                        
                        
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
                        Vehicaldetails.sharedInstance.IsFirstTimeUse = "\(IsFirstTimeUse)"
                        self.sentlog(func_name: "Fuel limit \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                    }
                    
                }
            } else {
                
                self.reply = "-1" + "#" + "\(error!)"
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply// + "#" + ""
    }
    
    
    func setimeiSelectCompany(Companyid:String)-> String
    {
            FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let Url:String = FSURL
            let string = uuid! + ":" + Email! + ":" + "SetIMEIToSelectedCompany" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            
            request.httpMethod = "POST"
            
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            
            let bodyData = try! JSONSerialization.data(withJSONObject: ["IMEIUDID": uuid!,"CompanyId":Companyid], options: [])
            request.httpBody = bodyData//.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10
            
            let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    
                    print(self.reply)
                    
                } else {
                    print(error!)
                    let text = (error?.localizedDescription)! //+ error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    //self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    self.reply = "-1"
                }
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
           
        return reply
        
    }
    
    
    func UpdateInterruptedTransactionFlag(TransactionId:String,Flag: String)
    {
            FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let Url:String = FSURL
            let string = uuid! + ":" + Email! + ":" + "UpdateInterruptedTransactionFlag" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            print(Vehicaldetails.sharedInstance.TransactionId)
            request.httpMethod = "POST"
            
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            
        let bodyData = try! JSONSerialization.data(withJSONObject: ["TransactionId": Vehicaldetails.sharedInstance.TransactionId,"IsInterrupted":"\(Flag)"], options: [])
            request.httpBody = bodyData//.data(using: String.Encoding.utf8)
            request.timeoutInterval = 10
            
            let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    
//                    print(self.reply)
                    self.sentlog(func_name: "UpdateInterrupted TransactionFlag Service Function IsInterrupted \(Flag)", errorfromserverorlink: " Response from Server $$ \(self.reply!)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                } else {
                    print(error!)
                    let text = (error?.localizedDescription)!// + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
            "versionno":"\(Version)",
            "Device Type":"\(UIDevice().type)",
            "iOS": "\(UIDevice.current.systemVersion)"], options: [])
        
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "checkhour_odometer ValidateDepartmentNumber Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "checkhour_odometer ValidateDepartmentNumber Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply// + "#" + ""
    }
    
    
    
    func Transactiondetails(bodyData:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
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
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
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
                self.sentlog(func_name: "Transactiondetails SavePreAuthTransactions Service Function, ", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
        let uuid = defaults.string(forKey: "uuid")
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
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                
                print(self.reply)
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }
    
    
    func tldsendserver(bodyData:Data) -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "SaveTankMonitorReading"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        self.sentlog(func_name: " send service call tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                //  print(self.reply)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                // print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }
    
    
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
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                // print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                {
                    self.sentlog(func_name: "<SendSiteID> set link busy on cloud {SiteId:\(siteid)}", errorfromserverorlink: " Response from Server \(newString).",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)")
                }
                else{
                self.sentlog(func_name: "<SendSiteID> set link busy on cloud {SiteId:\(siteid)}", errorfromserverorlink: " Response from Server \(newString).",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                }
            } else {
                print(error!)
                self.reply = "-1"
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                {
                self.sentlog(func_name: "<SendSiteID> set link busy on cloud {SiteId:\(siteid)}", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" )
                }
                else{
                self.sentlog(func_name: "<SendSiteID> set link busy on cloud {SiteId:\(siteid)}", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                }
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
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Sent GetRelay Function \(Url)", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)!// + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Sent GetRelay Function \(Url)", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return reply + "#" + ""
    }
    
    
    func tldlevel() -> String {
        
        let Url:String = "http://192.168.4.1:80/tld?level=info"
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        self.sentlog(func_name: "Get tldlevel from the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                // print(self.reply)
                self.sentlog(func_name: "Sent tldlevel Function to link", errorfromserverorlink:"",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
                
                if( self.reply == nil)
                {self.reply = ""}
                self.sentlog(func_name: "Get tldlevel Function", errorfromserverorlink: " Response from link $$ \(responsestring)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                //print(error!)
                let text = (error?.localizedDescription)!// + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
                self.reply = "-1"
                self.sentlog(func_name: "Get error in tldlevel Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        // print(reply)
        return reply
    }
    
    
    func getlastTrans_ID() -> String{
        let Url:String = "http://192.168.4.1:80/client?command=lasttxtnid"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
        request.httpMethod = "GET"
        
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                //  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Get LastTransaction_ID Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
                print("Response: \(String(describing: response))")
            } else {
                self.reply = "-1"
            }
            semaphore.signal()
        }
        
        task.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }
    
    
    func pulsarlastquantity(){
        let Url:String = "http://192.168.4.1:80/client?command=record10"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
        request.httpMethod = "GET"
        
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) {  data, response, error in
            if let data = data {
                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                //  print(self.pulsardata)
                let text = self.pulsardata
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Get Pulsar_LastQuantity Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                if(self.sysdata1 == nil){}
                else{
                    if(newString.contains("N/A"))
                    {
//                        let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
//                        let counts_data = objUserData.value(forKey: "1:") as! NSString
//                        if(counts_data == "N/A"){}
//                        else{
//                            let t_count = Int(truncating: Int(counts_data as String)! as NSNumber)
//                        print(t_count)
//                        Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//                        }
//
                    }
                    else{
                    let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
                    let counts_data = objUserData.value(forKey: "1:") as! NSNumber
                   
                        let t_count = Int(truncating: counts_data)
                    print(t_count)
                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
                
                    }
                }
            } else {
                print(error as Any)
                self.pulsardata = "-1"
            }
            semaphore.signal()
        }
        task.resume()
    }
    
    func cmtxtnid10(){
        Vehicaldetails.sharedInstance.Last10transactions = []
        let Url:String = "http://192.168.4.1:80/client?command=cmtxtnid10"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
        request.httpMethod = "GET"
        
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                  print(self.pulsardata)
                let text = self.pulsardata
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil) //"{ cmtxtnid_10_record :{ 1:TXTNINFO: : 7347954-2270 , 2:TXTNINFO: : 7344714-2191 , 3:TXTNINFO: : 7344710-92 , 4:TXTNINFO: : 7343905--41959432 , 5:TXTNINFO: : 7343510-2146926431 , 6:TXTNINFO: : 7339831--49185 , 7:TXTNINFO: : 7339485--545260097 , 8:TXTNINFO: : 7339456--67371009 , 9:TXTNINFO: : 7338746--4194305 , 10:TXTNINFO: : 7330954-N/A }}"//
                print(newString)
                if(newString == ""){
                     Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
                }
                self.sentlog(func_name: "Fueling Page Get Sending cmtxtnid10 command to Link (to get Last Single Txn) ", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
                do{
                    self.sysdataLast10trans = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.sysdataLast10trans = nil
                }
                if(self.sysdataLast10trans == nil){
                     Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
                }
                else{
                    
                    if(newString.contains("TXTNINFO")){
                          print(self.sysdataLast10trans)
                        let objUserData = self.sysdataLast10trans.value(forKey: "cmtxtnid_10_record") as! NSDictionary
                        let txtninfo1 = objUserData.value(forKey: "1:TXTNINFO:") as! String
                        let txtninfo2 = objUserData.value(forKey: "2:TXTNINFO:") as! String
                        let txtninfo3 = objUserData.value(forKey: "3:TXTNINFO:") as! String
                        let txtninfo4 = objUserData.value(forKey: "4:TXTNINFO:") as! String
                        let txtninfo5 = objUserData.value(forKey: "5:TXTNINFO:") as! String
                        let txtninfo6 = objUserData.value(forKey: "6:TXTNINFO:") as! String
                        let txtninfo7 = objUserData.value(forKey: "7:TXTNINFO:") as! String
                        let txtninfo8 = objUserData.value(forKey: "8:TXTNINFO:") as! String
                        let txtninfo9 = objUserData.value(forKey: "9:TXTNINFO:") as! String
                        let txtninfo10 = objUserData.value(forKey: "10:TXTNINFO:") as! String
                        
                        self.Splitedata1(trans_info: txtninfo2)
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
                    }
                    else {
                
                      print(self.sysdataLast10trans)
                    let objUserData = self.sysdataLast10trans.value(forKey: "cmtxtnid_10_record") as! NSDictionary
                    let txtninfo1 = objUserData.value(forKey:"1:") as! String
                    let txtninfo2 = objUserData.value(forKey:"2:") as! String
                    let txtninfo3 = objUserData.value(forKey:"3:") as! String
                    let txtninfo4 = objUserData.value(forKey:"4:") as! String
                    let txtninfo5 = objUserData.value(forKey:"5:") as! String
                    let txtninfo6 = objUserData.value(forKey:"6:") as! String
                    let txtninfo7 = objUserData.value(forKey:"7:") as! String
                    let txtninfo8 = objUserData.value(forKey:"8:") as! String
                    let txtninfo9 = objUserData.value(forKey:"9:") as! String
                    let txtninfo10 = objUserData.value(forKey:"10:") as! String
                    
                    self.Splitedata1(trans_info: txtninfo2)
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
                    
                    }
                    //                    let t_count = Int(truncating: counts)
                    //                    print(t_count)
                    //                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
                }
            } else {
                print(error as Any)
                self.pulsardata = "-1"
            }
            semaphore.signal()
        }
        task.resume()
    }
    
    
    func saveTrans(lastpulsarcount:String,lasttransID:String){
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        if(lastpulsarcount == "N/A"){}
        else{
            let fuelquantity = (Double(lastpulsarcount))!/(PulseRatio as NSString).doubleValue
            if(fuelquantity == 0.0 || lasttransID == "-1" || lasttransID == "0"){}
            else{
                let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"Pulses\":\"\(lastpulsarcount)\",\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"Transaction\":\"LastTransaction\"}"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                let unsycnfileName =  dtt1 + "#" + "transaction" + "#" + "lasttransID" + "#" + Vehicaldetails.sharedInstance.SSId
                if(bodyData != ""){
                    cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
                    self.sentlog(func_name:" Saved Last Transaction to Phone, Date\(dtt1) TransactionId:\(lasttransID),FuelQuantity:\((fuelquantity)),Pulses:\(lastpulsarcount)", errorfromserverorlink: "Selected Hose : \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link : \( self.cf.getSSID())")
                }
            }
        }
    }
    
    func Splitedata1(trans_info:String){
        if(trans_info.contains("--"))
        {
            
        }
        else{
        let Split = trans_info.components(separatedBy: "-")
        
        let transid = Split[0];
        let pulses = Split[1];
        
        Vehicaldetails.sharedInstance.Last_transactionformLast10 = transid
        saveTrans(lastpulsarcount:pulses,lasttransID:transid)
        }
        
    }
    
    func Splitedata(trans_info:String){
        if(trans_info.contains("--"))
        {
            
        }
        else{
        let Split = trans_info.components(separatedBy: "-")
        
        let transid = Split[0];
        let pulses = Split[1];
        if(pulses == "N/A"){}
        else{
        let quantity = self.cf.calculate_fuelquantity(quantitycount: Int(pulses as String)!)
            let transaction_details = Last10Transactions(Transaction_id: transid, Pulses: pulses, FuelQuantity: "\(quantity)", vehicle:"", date:"", dflag: "")
        Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
    }
    }
    }
    
    
    
    
    
    func GetPulser()->String {
        
        let Url:String = "http://192.168.4.1:80/client?command=pulsar"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5 //////timeout interval should be increased it is 4 earlier now i am convert it to 10
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                // DispatchQueue.main.async{
                self.replygetpulsar = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                // print(self.replygetpulsar)
                
                
                
            } else {
                print(error!)
                
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "GetPulser Service Function", errorfromserverorlink: " Response from Link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.replygetpulsar = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
            
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
       
        return replygetpulsar + "#" + ""
    }
    
    
    func LINKDisconnectionError()
    {   FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        if(TransactionId == 0){}
        else{
            let SiteId = Vehicaldetails.sharedInstance.siteID
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let LogDateTime: String = dateFormatter.string(from: NSDate() as Date)
           
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy MM dd"
            dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter1.string(from: NSDate() as Date)
            let ErrorLogFileName = "\(dtt1) DiagnosticLogs_iPhone"
            let Url:String = FSURL
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let string = uuid! + ":" + Email! + ":" + "LINKDisconnectionErrorLog"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
            print(string)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            let bodyData = "{\"SiteId\":\"\(SiteId)\",\"LogDateTime\":\"\(LogDateTime)\",\"TransactionId\":\"\(TransactionId)\",\"ErrorLogFileName\":\"\(ErrorLogFileName)\"}"
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
                    self.sentlog(func_name: "LINK Disconnection Error", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    self.reply = "-1"
                    if(self.reply == "-1"){
                        let jsonstring: String = bodyData
                        // let unsycnfileName = "#\(TransactionId)#0"
                        if(jsonstring != ""){
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                            
                            let unsycnfileName =  dtt1 + "LINKDisconnectionErrorLog" //
                            if(bodyData != ""){
                                self.cf.SaveTransactionstatus(fileName: unsycnfileName, writeText: jsonstring)
                            }
                            
                        }
                        let text = (error?.localizedDescription)! //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        //  print(newString)
                        self.sentlog(func_name: "LINK Disconnection ErrorLog Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    func LINKReconnectionEmail()
    {   FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        if(TransactionId == 0){}
        else{
            let SiteId = Vehicaldetails.sharedInstance.siteID
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let LogDateTime: String = dateFormatter.string(from: NSDate() as Date)
           
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy MM dd"
            dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter1.string(from: NSDate() as Date)
            let ErrorLogFileName = "\(dtt1) DiagnosticLogs_iPhone"
            let Url:String = FSURL
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let string = uuid! + ":" + Email! + ":" + "LINKReconnectionEmail"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
            print(string)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            let bodyData = "{\"SiteId\":\"\(SiteId)\",\"LogDateTime\":\"\(LogDateTime)\",\"TransactionId\":\"\(TransactionId)\",\"ErrorLogFileName\":\"\(ErrorLogFileName)\"}"
            print(bodyData)
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {  data, response, error in
                if let data = data {
                    // print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    print(self.reply!)
                    //print(response!)
                } else {
                    // print(error!)
                    let text = (error?.localizedDescription)! //+ error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    // print(newString)
                    self.sentlog(func_name: "LINK Reconnection send Email", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    self.reply = "-1"
                    if(self.reply == "-1"){
                        let jsonstring: String = bodyData
                        // let unsycnfileName = "#\(TransactionId)#0"
                        if(jsonstring != ""){
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                            
                            let unsycnfileName =  dtt1 + "LINKReconnectionEmail" //
                            if(bodyData != ""){
                                self.cf.SaveTransactionstatus(fileName: unsycnfileName, writeText: jsonstring)
                            }
                            
                        }
                        let text = (error?.localizedDescription)! //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        //  print(newString)
                        self.sentlog(func_name: "LINKReconnectionEmail Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    
    func UpdateMACAddress() -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")

        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL

        let string = uuid! + ":" + Email! + ":" + "UpdateMACAddress" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
       // print(Barcodescanvalue,uuid!,vehicle_no,FOBNumber,wifiSSID,siteid)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"
        //Vehicaldetails.sharedInstance.MacAddress = ""
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = try! JSONSerialization.data(withJSONObject: ["SiteId":siteid,
                                                                    "MACAddress":Vehicaldetails.sharedInstance.MacAddressfromlink,
                                                                    "RequestFrom":"I"], options: [])
        //"{\"IMEIUDID\":\"\(uuid!)\",\"VehicleNumber\":\"\(vehicle_no)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\"}"
        print(bodyData,Vehicaldetails.sharedInstance.MacAddressfromlink)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                  print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                self.sentlog(func_name: "UpdateMAC Address Function update \(Vehicaldetails.sharedInstance.MacAddressfromlink) to server\(newString)!.", errorfromserverorlink: " "/* Response from Server $$ \(newString)!!*/, errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                self.sentlog(func_name: "UpdateMAC Address Function Function", errorfromserverorlink: "  Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

                self.reply = "-1" //+ "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""
    }
    
    func Testtransaction() -> String
    {
        
        
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        
        
        
        //Add this change on 11Aug on testing
        var TransactionId:String!
        let ppin = ""
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        var Errorcode = Vehicaldetails.sharedInstance.Errorcode;
        if(Errorcode == "")
        {
            Errorcode = "0"
        }
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "AuthorizationsequenceForTestTransaction" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        
        request.httpMethod = "POST"
        
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        
        let bodyData = try! JSONSerialization.data(withJSONObject: [
            "IMEIUDID":uuid,
            "WifiSSId":wifiSSID,
            "SiteId":siteid,
            
            "PersonnelPIN":"\(ppin)",
            "IsTestTransaction":"y",
            "CurrentLat":"\(Vehicaldetails.sharedInstance.Lat)",
            "CurrentLng":"\(Vehicaldetails.sharedInstance.Long)",
            "RequestFrom":"I",
            "versionno":"\(Version)",
            "Device Type":"\(UIDevice().type)",
            "iOS": "\(UIDevice.current.systemVersion)",
                                                                
            
        ],options: [])
        
        //        "{\"IMEIUDID\":\"\(uuid!)\",\"IsVehicleNumberRequire\":\"\(Vehicaldetails.sharedInstance.IsVehicleNumberRequire)\",\"VehicleNumber\":\"\(vehicle_no)\",\"OdoMeter\":\"\(Odometer)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\",\"DepartmentNumber\":\"\(isdept)\",\"PersonnelPIN\":\"\(isPPin)\",\"Other\":\"\(isother)\",\"Hours\":\"\(hour)\",\"CurrentLat\":\"\(Vehicaldetails.sharedInstance.Lat)\",\"CurrentLng\":\"\(Vehicaldetails.sharedInstance.Long)\",\"RequestFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 20
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply!)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
               // self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                        self.defaults.setValue("0", forKey: "previouspulsedata")
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
                        let IsFirstTimeUse  = ResponceData.value(forKey: "IsFirstTimeUse") as! String
                        
                        let FilePath = ResponceData.value(forKey: "FilePath") as! NSString
                        let FirmwawareVersion = ResponceData.value(forKey: "FirmwareVersion") as! NSString
                        if(ResponceData.value(forKey: "TransactionId") == nil){}
                        else{
                            TransactionId = ResponceData.value(forKey: "TransactionId") as! NSString as String
                            Vehicaldetails.sharedInstance.TransactionId = Int(TransactionId as String)!
                            Vehicaldetails.sharedInstance.pulsarCount = ""
                        }
                        
                        print(MinLimit,PersonId,PhoneNumber,FuelTypeId,VehicleId,PulseRatio,FilePath)
                        
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
                        Vehicaldetails.sharedInstance.IsFirstTimeUse = "\(IsFirstTimeUse)"
                        self.sentlog(func_name: "Fuel limit \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                    }
                    
                    
                }
            } else {
                
                self.reply = "-1" + "#" + "\(error!)"
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "AuthorizationsequenceForTestTransaction Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply// + "#" + ""
        
    }
    
    
    
    func UpgradeCurrentiotVersiontoserver() -> String {
        if (isUpgradeCurrentiotVersiontoserver == true){}
        else{
        FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
            print(Vehicaldetails.sharedInstance.FirmwareVersion,Vehicaldetails.sharedInstance.iotversion)
            
        let Version = Vehicaldetails.sharedInstance.FirmwareVersion
        let HoseId = Vehicaldetails.sharedInstance.HoseID
    
        
        let Url:String = FSURL
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpgradeCurrentVersionWithUgradableVersion"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
            reply = ""
        print(string)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"HoseId\":\"\(HoseId)\",\"Version\":\"\(Vehicaldetails.sharedInstance.iotversion)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply!)
                if(self.reply == "{\"ResponceMessage\":\"success\",\"ResponceText\":\"Update completed successfully!\"}")
                {
                    self.isUpgradeCurrentiotVersiontoserver = true
                }
                // print(response!)
            } else {
                //  print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                // print(newString)
                self.sentlog(func_name: "Upgrade Current Version toserver UpgradeCurrentVersionWithUgradableVersion Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        
        return reply //+ "#" + ""
        }
        return ""
    }
    
//    private func getWifiStrengthOnDevicesExceptIphoneX() -> Int? {
//        var rssi: Int?
//        guard let statusBar = UIApplication.shared.value(forKey:"statusBar") as? UIView,
//              let foregroundView = statusBar.value(forKey:"foregroundView") as? UIView else {
//                  return rssi
//        }
//        for view in foregroundView.subviews {
//            if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"),
//               view.isKind(of: statusBarDataNetworkItemView) {
//                  if let val = view.value(forKey:"wifiStrengthRaw") as? Int {
//                      rssi = val
//                      break
//                  }
//            }
//        }
//        return rssi
//    }
    
    
    
    func getinfo() -> String {
//        let rssi = getWifiStrengthOnDevicesExceptIphoneX()
        let Url:String = "http://192.168.4.1:80/client?command=info"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        let semaphore = DispatchSemaphore(value: 0)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                //                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                
                print(self.reply!)
                let text = self.reply!
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                if(newString.contains("iot_version"))
                {
//                    self.showstartbutton = "true"
//                    print(rssi,Signal strength \(rssi))
                    self.sentlog(func_name: "Sent info command to Link:\(Url)", errorfromserverorlink: " Response from link $$\(newString)!! Mac address from server \(Vehicaldetails.sharedInstance.MacAddress)",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                }
//                    else{
                    
                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                    do{
                        //  print(self.sysdata)
                        self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        let Version = self.sysdata.value(forKey: "Version") as! NSDictionary
                        
                        let iot_version = Version.value(forKey: "iot_version") as! NSString
                        let mac_address = Version.value(forKey: "mac_address") as! NSString
                        
                        if(newString.contains("AP_mac_address"))
                        {
                            let AP_mac_address = Version.value(forKey: "AP_mac_address") as! NSString
                            if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)")
                            {
                                self.showstartbutton = "true"
                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                            }else
                            if(Vehicaldetails.sharedInstance.MacAddress == "\(AP_mac_address)")
                            {
                                self.showstartbutton = "true"
                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(AP_mac_address)"
                            }
                            else
                            {
                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                                if(Vehicaldetails.sharedInstance.MacAddress == "")
                                {
                                    self.showstartbutton = "true"
                                    Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                                }
                                else{
                                self.showstartbutton = "MACNotSame"
    //                            print(Vehicaldetails.sharedInstance.FS_MacAddress)
                                    self.sentlog(func_name: "Mac address Mismatched ", errorfromserverorlink: "Mac address from server \(Vehicaldetails.sharedInstance.MacAddress), Mac address from Link \(Vehicaldetails.sharedInstance.MacAddressfromlink)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                               }
                            }
                        }
                        
                        else
                        {
                            if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)")
                            {
                                self.showstartbutton = "true"
                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                            }else {
                                if(Vehicaldetails.sharedInstance.MacAddress == "")
                                {
                                    self.showstartbutton = "true"
                                    Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                                }
                                else{
                                self.showstartbutton = "MACNotSame"
    //                            print(Vehicaldetails.sharedInstance.FS_MacAddress)
                                    self.sentlog(func_name: "Mac address Mismatched ", errorfromserverorlink: "Mac address from server \(Vehicaldetails.sharedInstance.MacAddress), Mac address from Link \(Vehicaldetails.sharedInstance.MacAddressfromlink)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
                               }
                            }
                        }
//                        let AP_mac_address = Version.value(forKey: "AP_mac_address") as! NSString
                        
//                        self.showstartbutton = "true"
//                        Vehicaldetails.sharedInstance.iotversion = iot_version as String
//                        print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
//                        if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){
//
//                        }else {
//                            print(Vehicaldetails.sharedInstance.FS_MacAddress)
//                            Vehicaldetails.sharedInstance.FS_MacAddress = mac_address as String
//                        }
//                        self.showstartbutton = "true"
                        Vehicaldetails.sharedInstance.iotversion = iot_version as String
                        print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                        {
                            if(Vehicaldetails.sharedInstance.FirmwareVersion == iot_version as String)
                            {
                                Vehicaldetails.sharedInstance.IsUpgrade = "N"
                            }

                        }
//                        if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)")
//                        {
//                            self.showstartbutton = "true"
//                            Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
//                        }else {
//                            if(Vehicaldetails.sharedInstance.MacAddress == "")
//                            {
//                                self.showstartbutton = "true"
//                                Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
//                            }
//                            else{
//                            self.showstartbutton = "MACNotSame"
////                            print(Vehicaldetails.sharedInstance.FS_MacAddress)
//                                self.sentlog(func_name: "Mac address Mismatched ", errorfromserverorlink: "Mac address from server \(Vehicaldetails.sharedInstance.MacAddress), Mac address from Link \(Vehicaldetails.sharedInstance.MacAddressfromlink)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                            Vehicaldetails.sharedInstance.MacAddressfromlink = "\(mac_address)"
//                           }
//                        }
                        if(Vehicaldetails.sharedInstance.FirmwareVersion == "\(iot_version)"){
                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                        }
                        else if(Vehicaldetails.sharedInstance.FirmwareVersion != "\(iot_version)"){
                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = true
//                            Vehicaldetails.sharedInstance.FirmwareVersion = "\(iot_version)"
                        }
                        
                        if(self.isLINKDisconnectionError == true)
                        {
                            self.LINKReconnectionEmail()
                        }
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        let text = error.localizedDescription //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString)
                        
                        self.sentlog(func_name: "Sent info command to Link \(Url)", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp:" Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                        self.isconect_toFS = "false"
                        if(self.isconect_toFS == "true"){
                            self.showstartbutton = "false"
                        }else
                            if(self.isconect_toFS == "false"){
                                self.showstartbutton = "false"
                        }
//                    }
                        
                    }
            } else {
                print(error!)
                
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
                self.LINKDisconnectionErrorcount += 1
                if(self.LINKDisconnectionErrorcount >= 2)
                {
                    self.LINKDisconnectionError()
                    self.isLINKDisconnectionError = true
                    
                }
                
                self.sentlog(func_name: "Sent info command to Link \(Url):", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return showstartbutton
    }
    
    func getinfo_ssid() -> String {
        
        let Url:String = "http://192.168.4.1:80/config?command=wifi"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let semaphore = DispatchSemaphore(value: 0)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                //                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                
                // print(self.reply)
                let text = self.reply
                //                let test = String((text?.filter { !" \n".contains($0) })!)
                //                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //                print(newString)
                if((text?.contains("Connect_Softap"))!)
                {
                    //                    self.showstartbutton = "true"
                                        self.sentlog(func_name: "Sent info command to Link \(Url):", errorfromserverorlink: " Response from link $$\(text)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    //                }else{
                    
                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                    do{
                        //print(self.sysdata)
                        self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        // print(self.sysdata)
                        let Version = self.sysdata.value(forKey: "Response") as! NSDictionary
                        let Softap = Version.value(forKey: "Softap") as! NSDictionary
                        let Connect_Softap = Softap.value(forKey: "Connect_Softap") as! NSDictionary
                        let ssid = Connect_Softap.value(forKey: "ssid") as! NSString
                        let password = Connect_Softap.value(forKey: "password") as! NSString
                        //                        let serial_number = Version.value(forKey: "serial_number") as! NSString
                        if(ssid as String == Vehicaldetails.sharedInstance.SSId){
                            Vehicaldetails.sharedInstance.checkSSIDwithLink = "true"
                            self.showstartbutton = "true"
                            
                        }else
                        {
                            Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
                            self.showstartbutton = "false"
                        }
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
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        let text = error.localizedDescription //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString)
                        self.sentlog(func_name: "Sent info command to Link \(Url):", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                        self.isconect_toFS = "false"
                        if(self.isconect_toFS == "true"){
                            self.showstartbutton = "false"
                        }else
                            if(self.isconect_toFS == "false"){
                                self.showstartbutton = "false"
                        }
                    }
                    
                }
                else
                {
                    self.showstartbutton = "invalid"
                }
            } else {
                print(error!)
                let text = (error?.localizedDescription)!// + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Sent info command to Link \(Url):", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return showstartbutton
    }
    
    func SetPulser0() -> String {
        let Url:String = "http://192.168.4.1:80/config?command=pulsar"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        let bodyData = "{\"pulsar_request\":{\"counter_set\":0}}"
        
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                // print(self.reply)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if(httpResponse.statusCode != 200)
                    {
                        self.reply = "true"
                    }
                    else {
                        self.reply = "false"
                    }
                }
                
            } else {
                print(error!)
                self.reply = "-1"
            }
        }
        task.resume()
        return reply
    }
    
    func convertStringToBase64(string: String) -> String
    {
        let utf8str = string.data(using: String.Encoding.utf8)!
        let base64str = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        return base64str
    }
    
    
    
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
}
