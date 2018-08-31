//
//  Webservices.swift
//  FuelSecuer
//
//  Created by VASP on 5/23/16.
//  Copyright © 2016 VASP. All rights reserved.

import UIKit
import MobileCoreServices
import NetworkExtension

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
    var replySetPulser :String!
    var sysdata:NSDictionary!
    let defaults = UserDefaults.standard
    var cf = Commanfunction()
    var isconect_toFS:String = ""
    var contents:Data!
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
    var LogURL = Vehicaldetails.sharedInstance.URL + "LoginHandler.ashx"


    
    @available(iOS 11.0, *)
    func wifisettings(pagename:String)
    {

        let hotspotConfig = NEHotspotConfiguration(ssid: SSID, passphrase: "123456789", isWEP: false)
        hotspotConfig.joinOnce = true

        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in

            if let error = error {
                // self.showError(error: error)
                print("Error\(error)")
                // self.wifisettings(pagename:"Retry")
            }
            else {
                self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from \(pagename) Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                // self.showSuccess()
                print("Connected")
            }
        }
    }


    func Checkurl()->String {
        let Url:String = URL//APIendpointtrimmedString + url
        //        let Email = ""
        //        let string = uuid + ":" + Email + ":" + "Other" //+ ":" + "es-ES"
        //        let Base64 = convertStringToBase64(string: string)
        //        print(Base64)
        self.sentlog(func_name: "Checkurl command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "GET"
        //request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        let bodyData = ""//"Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        //Vehicaldetails.sharedInstance.TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Checkurl ,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion)", errorfromserverorlink: "",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")

            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Checkurl,Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""//return reply
    }

    func Preauthrization(uuid:String,lat:String,long:String)->String {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Url:String = FSURL//APIendpointtrimmedString + url
        let Email = ""
        let string = uuid + ":" + Email + ":" + "SavePreAuthTransactions"
        // + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "Authenticate:I:" + "\(lat),\(long),versionno.\(Version),Device Type:\(UIDevice().type),iOS:\(UIDevice.current.systemVersion)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 4
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                print(self.reply)
                print(self.reply)
                //"\(self.reply)"
            } else {
                print(error!)
                
                //self.reply = "-1"
                self.reply = "-1" + "#" + "\(error!.localizedDescription)"
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
                self.sentlog(func_name: "Preauthrization Function", errorfromserverorlink: " Response from link $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""//return reply
    }
    
    
    func checkApprove(uuid:String,lat:String!,long:String!)->String {
        if(Vehicaldetails.sharedInstance.Language == ""){
            ///Vehicaldetails.sharedInstance.Language = "en-ES"
        }
        let Url:String = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"//FSURL//APIendpointtrimmedString + url
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        let string = uuid + ":" + Email + ":" + "Other" + ":" + "\(Vehicaldetails.sharedInstance.Language)"//es-ES"
        let Base64 = convertStringToBase64(string: string)
        print(Base64)
        self.sentlog(func_name: "checkApprove command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        Vehicaldetails.sharedInstance.TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
                print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion)", errorfromserverorlink: "",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply //+ "#" + ""//return reply
    }
    
    func Login(_ Username:String,PWD:String,uuid:String)->String {
        let Url:String = LogURL//APIendpointtrimmedString + url
        // let Email = ""
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
                print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "Login Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"

                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
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
                print(self.reply)

            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.reply = "-1" + "#" + "\(error!)"
                self.sentlog(func_name: "Registration Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }
    
    func UpgradeTransactionStatus(Transaction_id:String,Status:String) //-> String
    {   FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"

        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        if(TransactionId == 0){}
        else{

            let Url:String = FSURL//
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let string = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"// + ":" + "\(Vehicaldetails.sharedInstance.Language)"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
            print(string)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            let bodyData = "{\"TransactionId\":\"\(TransactionId)\",\"Status\":\"\(Status)\"}"//
            print(bodyData)
            request.httpBody = bodyData.data(using: String.Encoding.utf8)

            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    print(self.reply)
                    print(response!)
                } else {
                    print(error!)
                    let text = (error?.localizedDescription)! + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    self.reply = "-1"
                    if(self.reply == "-1"){
                        let jsonstring: String = bodyData
                        let unsycnfileName = "#\(TransactionId)#0"
                        if(jsonstring != ""){

                        }
                        let text = (error?.localizedDescription)! + error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString)
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

        let Url:String = FSURL//
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpgradeCurrentVersionWithUgradableVersion"// + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        
        print(string)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"HoseId\":\"\(HoseId)\",\"Version\":\"\(Version)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        // let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply)
                print(response!)
            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
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
        let string = uuid! + ":" + Email! + ":" + "SetHoseNameReplacedFlag" //+ ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        print(string)
        request.httpMethod = "POST"
        
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"SiteId\":\"\(SiteId)\",\"HoseId\":\"\(HoseId)\",\"IsHoseNameReplaced\":\"\(IsHoseNameReplaced)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply)
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
    
    
    func checkhour_odometer(_ vehicle_no:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL//
        let string = uuid! + ":" + Email! + ":" + "CheckVehicleRequireOdometerEntryAndRequireHourEntry" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"
        
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"IMEIUDID\":\"\(uuid!)\",\"VehicleNumber\":\"\(vehicle_no)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply)
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "checkhour_odometer CheckVehicleRequireOdometerEntryAndRequireHourEntry Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

            } else {
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "checkhour_odometer CheckVehicleRequireOdometerEntryAndRequireHourEntry Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")

                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }


    func Sentlogservercll(filePath:String){
        //var filepath:String = ""
        var request:NSURLRequest
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogFile" + ":" + "iPhone" //+ ";" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let dtt1: String = dateFormatter.string(from: NSDate() as Date)
        request = createRequest(authBase64: Base64,path:filePath)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.replysentlog = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.replysentlog)
                let data1:Data = self.replysentlog.data(using: String.Encoding.utf8)!
                do {
                    self.sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                let Message = self.sysdata["ResponceMessage"] as! NSString
                let ResponseText = self.sysdata["ResponceText"] as! NSString

                if(Message == "success"){

                    self.cf.DeleteFileInApp(fileName: "data/unsyncdata/\(dtt1)" + "Sendlog.txt")
                }
            } else {
                print(error!)
                let text = (error?.localizedDescription)! + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "sentlogFile Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.replysentlog = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    func sentlogFile()
    {
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {}
        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
            var filepath:String = ""
            var request:NSURLRequest

            if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
            {}
            else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
                let Email = defaults.string(forKey: "address")
                let uuid = defaults.string(forKey: "uuid")
                let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogFile" + ":" + "iPhone" //+ ";" + "\(Vehicaldetails.sharedInstance.Language)"
                let Base64 = convertStringToBase64(string: string)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMyyyy"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                // if(self.cf.checkPath(fileName: "\(dtt1)" + "Sendlog.txt") == true) {
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
                        Sentlogservercll(filePath:"\(fromPath)/" + "\(filename)")
                    }
                }
                filepath = (readdata!.path)
            }
        }
    }
    
    
    func sentlog(func_name:String,errorfromserverorlink:String,errorfromapp:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "False")
        {}
        else if( Vehicaldetails.sharedInstance.CollectDiagnosticLogs == "True"){
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")

            let Url:String = FSURL//
            let string = uuid! + ":" + Email! + ":" + "SaveDiagnosticLogs" //+ ":" + "\(Vehicaldetails.sharedInstance.Language)"
            let Base64 = convertStringToBase64(string: string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
            request.httpMethod = "POST"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            dateFormatter.dateFormat = "yyyy MM dd"
            let dtt: String = dateFormatter.string(from: NSDate() as Date)
            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
            var transactionID:String = "\(Vehicaldetails.sharedInstance.TransactionId)"
            if(transactionID == "0"){
                transactionID = "NA"
            }

            let bodyData = "\n\n{\"Collectedlogs\":\"\(dtt1), Transaction ID - \(transactionID)" + " \(func_name),\(errorfromserverorlink),\(errorfromapp)*****\",\"LogFrom\":\"iPhone\",\"FileName\":\"\(dtt) DiagnosticLogs_iPhone\"}"//
            print(bodyData)
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            request.timeoutInterval = 20


            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    self.replysentlog = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                    print(self.replysentlog)

                } else {
                    print(error!)
                    self.replysentlog = "-1" + "#" + "\(error!)"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "ddMMyyyy"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    let dtt1: String = dateFormatter.string(from: NSDate() as Date)

                    if(self.cf.checkPath(fileName: "data/unsyncdata/\(dtt1)" + "Sendlog.txt") == true) {
                        if(bodyData != ""){
                            self.cf.SaveLogFile(fileName: "\(dtt1)" + "Sendlog.txt", writeText: bodyData)
                        }
                        let logdata = self.cf.ReadFile(fileName: "\(dtt1)" + "Sendlog.txt")
                        print(logdata)
                    }
                    else if(self.cf.checkPath(fileName: "data/unsyncdata/\(dtt1)" + "Sendlog.txt") == false){
                        self.cf.CreateTextFile(fileName: "data/unsyncdata/\(dtt1)" + "Sendlog.txt", writeText: bodyData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func vehicleAuth(vehicle_no:String,Odometer:Int,isdept:String,isppin:String,isother:String) -> String {

        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"

        let isdept = Vehicaldetails.sharedInstance.deptno
        let isPPin = Vehicaldetails.sharedInstance.Personalpinno
        let isother = Vehicaldetails.sharedInstance.Other
        let Odometer:String = Vehicaldetails.sharedInstance.Odometerno
        let hour = Vehicaldetails.sharedInstance.hours
        
        var TransactionId:String!
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL//
        let string = uuid! + ":" + Email! + ":" + "AuthorizationSequence" + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        ///request.timeoutInterval = 6
        request.httpMethod = "POST"
        
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"IMEIUDID\":\"\(uuid!)\",\"VehicleNumber\":\"\(vehicle_no)\",\"OdoMeter\":\"\(Odometer)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\",\"DepartmentNumber\":\"\(isdept)\",\"PersonnelPIN\":\"\(isPPin)\",\"Other\":\"\(isother)\",\"Hours\":\"\(hour)\",\"CurrentLat\":\"\(Vehicaldetails.sharedInstance.Lat)\",\"CurrentLng\":\"\(Vehicaldetails.sharedInstance.Long)\",\"RequestFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                //print(String(data: data, encoding: String.Encoding.utf8)!)
               // print(String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply!)
                // "\(self.reply)"
                let text = self.reply
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.sentlog(func_name: "AuthorizationSequence Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                print(self.sysdata)
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

    
    func Transactiondetails(bodyData:String) -> String
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + "SavePreAuthTransactions"
        // + ":" + "\(Vehicaldetails.sharedInstance.Language)"
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
                print(self.reply)

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
        let string = uuid! + ":" + Email! + ":" + "TransactionComplete" //+ ":" + "\(Vehicaldetails.sharedInstance.Language)"
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
    
    func tldsendserver(bodyData:String) -> String {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL//APIendpointtrimmedString + url
        let string = uuid! + ":" + Email! + ":" + "SaveTankMonitorReading"// + ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        self.sentlog(func_name: " send service call tldsendserver SaveTankMonitorReading Service Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                print(self.reply)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply)
                let text = self.reply//(error?.localizedDescription)! + error.debugDescription
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                //"\(self.reply)"
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
        let string = uuid! + ":" + Email! + ":" + "UpgradeIsBusyStatus" //+ ":" + "\(Vehicaldetails.sharedInstance.Language)"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"
        
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"SiteId\":\"\(siteid)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 30

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)! as String
                print(self.reply)
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
        request.timeoutInterval = 5   ///15
        
        request.httpMethod = "GET"
        //let session = URLSession.shared
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
        request.timeoutInterval = 5  ///10
        self.sentlog(func_name: "Get tldlevel from the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                // DispatchQueue.main.async{
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
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
                print(error!)
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
        print(reply)
        return reply
    }
    
    
    func GetPulser()->String {
        
        let Url:String = "http://192.168.4.1:80/client?command=pulsar"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 4
        
        // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                // DispatchQueue.main.async{
                self.replygetpulsar = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.replygetpulsar)

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
        self.isconect_toFS = "false";

        let task =  URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String

                print(self.reply)
                // "\(self.reply)"
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let Version = self.sysdata.value(forKey: "Version") as! NSDictionary

                    let iot_version = Version.value(forKey: "iot_version") as! NSString
                    let mac_address = Version.value(forKey: "mac_address") as! NSString

                    self.isconect_toFS = "true"
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
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }

            } else {
                print(error!)
                self.reply = "-1"
            }
        }
        task.resume()
        return isconect_toFS;
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
                print(self.reply)

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
    
    
    func changessidname(wifissid:String) {



        
//        let Url = "http://192.168.4.1:80/config?command=wifi"
//        let password = Vehicaldetails.sharedInstance.password
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
//        print(Url)
//        let bodyData = "{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
//        print(bodyData)
//        self.sentlog(func_name: "changessidname send request Service Function", errorfromserverorlink: " Response from Link $$!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.timeoutInterval = 20
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                print(self.reply)
//
//                self.sentlog(func_name: "changessidname send request Service Function", errorfromserverorlink: " Response from Link $$\(String(describing: response as! HTTPURLResponse?))!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("Status code: (\(httpResponse.statusCode))")
//                    if(httpResponse.statusCode != 200)
//                    {
//                        self.changessidname(wifissid: wifissid)
//                    }
//                }
//
//            } else {
//                let text = (error?.localizedDescription)! + error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.sentlog(func_name: "changessidname Service Function", errorfromserverorlink: " Response from Link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                self.reply = "-1"
//            }
//        }
//        task.resume()
    }
    
    func convertStringToBase64(string: String) -> String
    {
        let utf8str = string.data(using: String.Encoding.utf8)!
        let base64str = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        return base64str
    }
    
    
    func createRequest (authBase64:String,path:String) -> NSURLRequest {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let param = ["Authorization"  : authBase64]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        let url = NSURL(string:FSURL)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(authBase64)", forHTTPHeaderField: "Authorization")
        
        let path1 = path
        print(path1)
        
        request.httpBody = createBodyWithParameters(parameters: param,paths: [path1], boundary: boundary) as Data
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
    
    func createBodyWithParameters(parameters: [String: String]?, paths: [String]?, boundary: String) -> NSData {
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
                
                let filename = "\(url.lastPathComponent)"
                
                do {
                    contents = try Data(contentsOf: url)
                    print(contents)
                } catch {
                    // contents could not be loaded
                }
                
                let mimetype = mimeTypeForPath(path: path)
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; filename=\"\(filename)\"\r\n")
                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                body.append(contents)
                body.appendString(string: "\r\n")
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
