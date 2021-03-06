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

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                   // print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
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
    var reply :String!
    var replysentlog :String!
    var replygetpulsar :String!

    var sysdata:NSDictionary!
    var sysdata1:NSDictionary!
    var sysdataLast10trans:NSDictionary!
    let defaults = UserDefaults.standard
    var cf = Commanfunction()
    var isconect_toFS:String = ""
    var showstartbutton:String = ""
    var contents:Data!
    var image = UIImage()
   
    var pulsardata:String!
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"


    
    //For Testing
    @available(iOS 11.0, *)
    func wifisettings(pagename:String)
    {
         

        let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
        hotspotConfig.joinOnce = false
        print(Vehicaldetails.sharedInstance.fsSSId)

        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in

            if let error = error {
              print("Error\(error)")
                 Vehicaldetails.sharedInstance.fsSSId = Vehicaldetails.sharedInstance.SSId
            }
            else {

                self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.fsSSId) wifi Automatically from \(pagename) Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.fsSSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                    print("Connected")
            }
        }
    }

    
   

    func Checkurl()->String {
        let Url:String = URL
        self.sentlog(func_name: "Checkurl command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let bodyData = ""
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                //print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
               // print(newString)
                self.sentlog(func_name: "Checkurl ,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink: "",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")

            } else {
                //print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.sentlog(func_name: "Checkurl,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }

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
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
               // print(newString)
                
                self.sentlog(func_name: "Preauthrization Function", errorfromserverorlink: " Response from link $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }
    
    
    func checkApprove(uuid:String,lat:String!,long:String!)->String {
        if(Vehicaldetails.sharedInstance.Language == ""){
            ///Vehicaldetails.sharedInstance.Language = "en-ES"
        }
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
        self.sentlog(func_name: "checkApprove command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
       // print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        Vehicaldetails.sharedInstance.TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
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
                self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: "",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                //print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Url:String = FSURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 15
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
              //  print(self.reply)

            } else {
               // print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
                self.reply = "-1" + "#" + "\(error!)"
                self.sentlog(func_name: "Registration Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                                    //   print(self.sysdata)

                                       let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                       let ResponceMessage = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                                       if(ResponceMessage == "fail"){

                                       }
                                       if(ResponceMessage == "success"){
                                           self.cf.DeleteFileInApp(fileName: "data/unsyncTransstatus/" + filename)
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
                               task.resume()// contents
                            }
                            

                        } catch let error as NSError {
                            print ("Error: \(error.domain)")

                            // contents could not be loaded
                        }

                        
                    }
                }
            }
        

    
    

    func UpgradeTransactionStatus(Transaction_id:String,Status:String)
    {   FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"

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

            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                   // print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    print(self.reply)
                    //print(response!)
                } else {
                   // print(error!)
                    let text = (error?.localizedDescription)! + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                   // print(newString)
                    self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                        let text = (error?.localizedDescription)! + error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                      //  print(newString)
                        self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                }
            }
            task.resume()
        }
    }


    func UpgradeCurrentVersiontoserver() -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
               // print(self.reply)
               // print(response!)
            } else {
              //  print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
               // print(newString)
                self.sentlog(func_name: "Upgrade Current Version toserver UpgradeCurrentVersionWithUgradableVersion Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply + "#" + ""
    }


    func SetHoseNameReplacedFlag() -> String{ //-- service
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
                self.sentlog(func_name: "Set HoseName Replaced Flag SetHoseNameReplacedFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                print(response!)

            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Set HoseName Replaced Flag SetHoseNameReplacedFlag Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1" + "#" + "\(error!)"
            }
        }
        task.resume()
        return reply + "#" + ""
    }
    
    
    func checkhour_odometer(_ vehicle_no:String,_ Barcodescanvalue:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
                self.sentlog(func_name: "checkhour_odometer CheckVehicleRequireOdometerEntryAndRequireHourEntry Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
               // print(newString)
                self.sentlog(func_name: "checkhour_odometer CheckVehicleRequireOdometerEntryAndRequireHourEntry Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

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
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {}
        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){

            if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
            {}
            else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
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
                          //  print(contents)

                        } catch let error as NSError {
                            print ("Error: \(error.domain)")

                            // contents could not be loaded
                        }

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                        dateFormatter.dateFormat = "yyyy MM dd"
                        let dtt: String = dateFormatter.string(from: NSDate() as Date)
                        let dataString = String(data: contents, encoding: String.Encoding.utf8)
                        let newString = dataString?.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString!)
                        let bodyData = "{\"Collectedlogs\":\"\(dtt1),\(String(describing: newString!))\",\"LogFrom\":\"iPhone\",\"FileName\":\"\(dtt) DiagnosticLogs_iPhone\"}"
                        request.httpBody = bodyData.data(using: String.Encoding.utf8)
                        //request.timeoutInterval = 2
                        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
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
                             //   print(self.sysdata)

                                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                let ResponceMessage = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                                if(ResponceMessage == "fail"){

                                }
                                if(ResponceMessage == "success"){
                                    self.cf.DeleteFileInApp(fileName: "data/unsyncdata/" + filename)
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
    func sentlog(func_name:String,errorfromserverorlink:String,errorfromapp:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {}
        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)

            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
            if(transactionID == "0"){
                transactionID = "NA"
            }

            let bodyData = "@#^@#^\"\(dtt1), Transaction ID - \(transactionID)" + "\(func_name),\(errorfromserverorlink),\(errorfromapp)*****\""
            print(bodyData)

            dateFormatter.dateFormat = "ddMMyyyy"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt2: String = dateFormatter.string(from: NSDate() as Date)

            if(self.cf.checkPath(fileName: "data/unsyncdata/\(dtt2)" + "Sendlog.txt") == true) {
                if(bodyData != ""){
                    self.cf.SaveLogFile(fileName: "\(dtt2)" + "Sendlog.txt", writeText: bodyData) //save data into file.
                }
//                let logdata = self.cf.ReadFile(fileName: "\(dtt2)" + "Sendlog.txt")
//                print(logdata)
            }
            else if(self.cf.checkPath(fileName: "data/unsyncdata/\(dtt2)" + "Sendlog.txt") == false){
                self.cf.CreateTextFile(fileName: "data/unsyncdata/\(dtt2)" + "Sendlog.txt", writeText: bodyData)
            }
        }
    }


    func vehicleAuth(vehicle_no:String,Odometer:Int,isdept:String,isppin:String,isother:String, Barcodescanvalue:String) -> String {

        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"

        let isdept = Vehicaldetails.sharedInstance.deptno
        let isPPin = Vehicaldetails.sharedInstance.Personalpinno
        let isother = Vehicaldetails.sharedInstance.Other
        let Odometer:String = Vehicaldetails.sharedInstance.Odometerno
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


        print(bodyData)
        request.httpBody = bodyData//.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {

                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply!)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                    if(ResponceData.value(forKey: "TransactionId") == nil){}
                    else{
                        TransactionId = ResponceData.value(forKey: "TransactionId") as! NSString as String
                        Vehicaldetails.sharedInstance.TransactionId = Int(TransactionId as String)!
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
                }
                
            }
            } else {

                self.reply = "-1" + "#" + "\(error!)"
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }


    func departmentAuth(_ DepartmentNumber:String) ->String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
                self.sentlog(func_name: "checkhour_odometer ValidateDepartmentNumber Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "checkhour_odometer ValidateDepartmentNumber Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

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
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Transactiondetails SavePreAuthTransactions Service Function, ", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
               // print(self.reply)

            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Transactiondetails TransactionComplete Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


    func tldsendserver(bodyData:Data) -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "SaveTankMonitorReading"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        self.sentlog(func_name: " send service call tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


    func sendSiteID() -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
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
                self.sentlog(func_name: "SendSiteID with command: UpgradeIsBusyStatus {SiteId:\(siteid)}", errorfromserverorlink: " Response from link $$ \(newString)!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                print(error!)
                self.reply = "-1"
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "SendSiteID with command: UpgradeIsBusyStatus {SiteId:\(siteid)}", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                self.sentlog(func_name: "Start Button Tapped GetRelay Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Start Button Tapped GetRelay Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                self.sentlog(func_name: "Send tldlevel Function to link", errorfromserverorlink:"",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)

                if( self.reply == nil)
                {self.reply = ""}
                self.sentlog(func_name: "Get tldlevel Function", errorfromserverorlink: " Response from link $$ \(responsestring)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                //print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
                self.reply = "-1"
                self.sentlog(func_name: "Get error in tldlevel Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                self.sentlog(func_name: "Fueling Page Get LastTransaction_ID Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

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
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
              //  print(self.pulsardata)
                let text = self.pulsardata
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Fueling Page Get Pulsar_LastQuantity Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                if(self.sysdata1 == nil){}
                else{
                    let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
                    let counts = objUserData.value(forKey: "1:") as! NSNumber

                    let t_count = Int(truncating: counts)
                    print(t_count)
                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
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
              //  print(self.pulsardata)
                let text = self.pulsardata
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Fueling Page Get cmtxtnid10 Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
                do{
                    self.sysdataLast10trans = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.sysdataLast10trans = nil
                }
                if(self.sysdataLast10trans == nil){}
                else{
                  //  print(self.sysdataLast10trans)
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

                    self.Splitedata(trans_info: txtninfo1)
                    self.Splitedata(trans_info: txtninfo2)
                    self.Splitedata(trans_info: txtninfo3)
                    self.Splitedata(trans_info: txtninfo4)
                    self.Splitedata(trans_info: txtninfo5)
                    self.Splitedata(trans_info: txtninfo6)
                    self.Splitedata(trans_info: txtninfo7)
                    self.Splitedata(trans_info: txtninfo8)
                    self.Splitedata(trans_info: txtninfo9)
                    self.Splitedata(trans_info: txtninfo10)


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


    func Splitedata(trans_info:String){
        let Split = trans_info.components(separatedBy: "-")
        let transid = Split[0];
        let pulses = Split[1];
        let quantity = self.cf.calculate_fuelquantity(quantitycount: Int(pulses as String)!)
        let transaction_details = Last10Transactions(Transaction_id: transid, Pulses: pulses, FuelQuantity: "\(quantity)")
        Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
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
                
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "GetPulser Service Function", errorfromserverorlink: " Response from Link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.replygetpulsar = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return replygetpulsar + "#" + ""
    }


    func getinfo() -> String {

        let Url:String = "http://192.168.4.1:80/client?command=info"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        let semaphore = DispatchSemaphore(value: 0)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String

                //print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                if(newString.contains("iot_version"))
                {
                    self.showstartbutton = "true"
                    self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$\(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                }else{

                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                  //  print(self.sysdata)
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    let Version = self.sysdata.value(forKey: "Version") as! NSDictionary

                    let iot_version = Version.value(forKey: "iot_version") as! NSString
                    let mac_address = Version.value(forKey: "mac_address") as! NSString

                    self.showstartbutton = "true"
                    print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
                    if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){

                    }else {
                        print(Vehicaldetails.sharedInstance.FS_MacAddress)
                        Vehicaldetails.sharedInstance.FS_MacAddress = mac_address as String
                    }

                    if(Vehicaldetails.sharedInstance.FirmwareVersion == "\(iot_version)"){
                        Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                    }
                    else if(Vehicaldetails.sharedInstance.FirmwareVersion != "\(iot_version)"){
                        Vehicaldetails.sharedInstance.IsFirmwareUpdate = true
                        Vehicaldetails.sharedInstance.FirmwareVersion = "\(iot_version)"
                    }
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    let text = error.localizedDescription + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                    self.isconect_toFS = "false"
                    if(self.isconect_toFS == "true"){
                        self.showstartbutton = "false"
                    }else
                        if(self.isconect_toFS == "false"){
                            self.showstartbutton = "false"
                    }
                    }}
            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

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
   
                    self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String

                 
                    let text = self.reply
    
                    if((text?.contains("Connect_Softap"))!)
                    {
   

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

                        if(ssid as String == Vehicaldetails.sharedInstance.SSId){
                            Vehicaldetails.sharedInstance.checkSSIDwithLink = "true"
                        self.showstartbutton = "true"

                        }else
                        {
                            Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
                            self.showstartbutton = "false"
                        }

                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        let text = error.localizedDescription + error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString)
                        self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
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
                    let text = (error?.localizedDescription)! + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.sentlog(func_name: "Fueling Page Getinfo Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

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
}
