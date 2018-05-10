//
//  Webservices.swift
//  FuelSecuer
//
//  Created by VASP on 5/23/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit

class Webservices:NSObject {
    var reply :String!
    var replySetPulser :String!
    var sysdata:NSDictionary!
    let defaults = UserDefaults.standard
    var cf = Commanfunction()
    var isconect_toFS:String = ""
    //


    func Preauthrization(uuid:String,lat:String,long:String)->String {
        let Url:String = FSURL//APIendpointtrimmedString + url
        let Email = ""
        let string = uuid + ":" + Email + ":" + "SavePreAuthTransactions"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "Authenticate:I:" + "\(lat),\(long),versionno.1.15.13"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 4

        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)!as String
                print(self.reply)
                print(self.reply)
                //"\(self.reply)"
            } else {
                print(error!)
                //self.reply = "-1"
                self.reply = "-1" + "#" + "\(error!.localizedDescription)"
            }
            semaphore.signal()
        }

        task.resume()
       semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""//return reply
    }


    func checkApprove(uuid:String,lat:String!,long:String!)->String {
        let Url:String = FSURL//APIendpointtrimmedString + url
        let Email = ""
        let string = uuid + ":" + Email + ":" + "Other"
        let Base64 = convertStringToBase64(string: string)
        print(Base64)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!),versionno.1.15.13"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 4

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)!as String
                print(self.reply)
               // "\(self.reply)"
            } else {
                print(error!)
                //self.reply = "-1"
                self.reply = "-1" //+ "#" + "\(error!.localizedDescription)"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
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
        let bodyData = ""
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        //request.timeoutInterval = 4

       // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                //"\(self.reply)"
            } else {
                print(error!)
               // self.reply = "-1"
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""//return reply
    }


       func getbinfile() -> String
    {

        let Url:String = "http://103.8.126.241:7854/user1.bin"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        request.httpMethod = "GET"


       // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                //"\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
   // }

    }

    func registration(Name:String,Email:String,Base64:String,mobile:String,uuid:String,company:String) -> String
    {
        //let APIendpointtrimmedString = APIendpoint.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let Url:String = FSURL//APIendpointtrimmedString + url
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I#:#\(company)"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
       // request.timeoutInterval = 10

        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
               // "\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1" + "#" + "\(error!)"
                //self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""//return reply
    }

    func UpgradeTransactionStatus(Transaction_id:String,Status:String) //-> String
    {
        //let Status = //Vehicaldetails.sharedInstance.FirmwareVersion
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        if(TransactionId == 0){}
        else{
        //let IsHoseNameReplaced = Vehicaldetails.sharedInstance.IsHoseNameReplaced//"Y"
        let Url:String = FSURL//
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let string = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        print(string)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"TransactionId\":\"\(TransactionId)\",\"Status\":\"\(Status)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                print(response!)
            } else {
                print(error!)
                self.reply = "-1"
                if(self.reply == "-1"){
                    let jsonstring: String = bodyData
                    let unsycnfileName = "#\(TransactionId)#0"
                     if(jsonstring != ""){
                   // self.cf.SaveTransaction_status(fileName: unsycnfileName, writeText: jsonstring,Path:"data/test/")
                }//+ "#" + "\(error!)"
               }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        //return reply //+ "#" + ""//return reply
     //   }
    }

    func UpgradeCurrentVersiontoserver() -> String {
        let Version = Vehicaldetails.sharedInstance.FirmwareVersion
        let HoseId = Vehicaldetails.sharedInstance.HoseID
        //let IsHoseNameReplaced = Vehicaldetails.sharedInstance.IsHoseNameReplaced//"Y"
        let Url:String = FSURL//
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

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                print(response!)
                 } else {
                print(error!)
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""//return reply
    }

    func SetHoseNameReplacedFlag() -> String{ //-- service

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
        let bodyData = "{\"SiteId\":\"\(SiteId)\",\"HoseId\":\"\(HoseId)\",\"IsHoseNameReplaced\":\"\(IsHoseNameReplaced)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                print(response!)

                //"\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1" + "#" + "\(error!)"
                //self.reply = "-1"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""//return reply

    }


    func checkhour_odometer(_ vehicle_no:String) -> String
    {
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL//
        let string = uuid! + ":" + Email! + ":" + "CheckVehicleRequireOdometerEntryAndRequireHourEntry"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        // request.timeoutInterval = 6
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"IMEIUDID\":\"\(uuid!)\",\"VehicleNumber\":\"\(vehicle_no)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 10

       // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
               // "\(self.reply)"
            } else {
                //print(error?._domain)
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
    }

    func sentlog(func_name:String)
    {
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        //  let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL//
        let string = uuid! + ":" + Email! + ":" + "logSummary"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        // request.timeoutInterval = 6
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "Data = iOS \(uuid!), \(func_name)"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 10

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                // "\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)


    }

    func vehicleAuth(vehicle_no:String,Odometer:Int,isdept:String,isppin:String,isother:String) -> String {

//       let IsOdoMeterRequire  = Vehicaldetails.sharedInstance.odometerreq
//        let IsHoursRequire = Vehicaldetails.sharedInstance.IsHoursrequirs
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
        let string = uuid! + ":" + Email! + ":" + "AuthorizationSequence"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        ///request.timeoutInterval = 6
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"IMEIUDID\":\"\(uuid!)\",\"VehicleNumber\":\"\(vehicle_no)\",\"OdoMeter\":\"\(Odometer)\",\"WifiSSId\":\"\(wifiSSID)\",\"SiteId\":\"\(siteid)\",\"DepartmentNumber\":\"\(isdept)\",\"PersonnelPIN\":\"\(isPPin)\",\"Other\":\"\(isother)\",\"Hours\":\"\(hour)\",\"CurrentLat\":\"\(Vehicaldetails.sharedInstance.Lat)\",\"CurrentLng\":\"\(Vehicaldetails.sharedInstance.Long)\",\"RequestFrom\":\"I\",\"versionno\":\"1.15.13\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        //CurrentOdometer,RequestFrom,CurrentLat,CurrentLng,DepartmentNumber,PersonnelPIN,Other,Hours

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
       let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply!)
               // "\(self.reply)"
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                print(self.sysdata)
//                let ResponceMessage = self.sysdata.valueForKey("ResponceMessage") as! NSString
//                let ResponceText = self.sysdata.valueForKey("ResponceText") as! NSString
//                let ValidationFailFor = self.sysdata.valueForKey("ValidationFailFor") as! NSString
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

                
            } else {
                //print(error?.domain)
                self.reply = "-1" + "#" + "\(error!)"
            }
            semaphore.signal()
        }

        task.resume()
          semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply + "#" + ""
        }

    func ChangeBusyStatus(bodyData:String) -> String{

        let Email = defaults.string(forKey: "address")

        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL//APIendpointtrimmedString + url
        let string = uuid! + ":" + Email! + ":" + "TransactionComplete"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 10

       // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                //"\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1" //+ "#" + "\(error!)"
                //self.reply = "-1"

            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply

    }

    func Transactiondetails(bodyData:String) -> String
    {

       let Email = defaults.string(forKey: "address")

        let uuid = defaults.string(forKey: "uuid")
              let Url:String = FSURL//APIendpointtrimmedString + url
        let string = uuid! + ":" + Email! + ":" + "TransactionComplete"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)

        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        ///request.timeoutInterval = 3

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                //"\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1" //+ "#" + "\(error!)"
                //self.reply = "-1"

            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply

    }
    func Transaction_details(bodyData:String) -> String
    {

        let Email = defaults.string(forKey: "address")

        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL//APIendpointtrimmedString + url
        let string = uuid! + ":" + Email! + ":" + "TransactionComplete"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")

        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        ///request.timeoutInterval = 3

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
               // "\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1" //+ "#" + "\(error!)"
                //self.reply = "-1"

            }
            semaphore.signal()
        }

        task.resume()
       semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply

    }

    func sendSiteID() -> String {
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        //  let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
        let siteid = Vehicaldetails.sharedInstance.siteID
        print("\(Vehicaldetails.sharedInstance.siteID)")
        let Url:String = FSURL//
        let string = uuid! + ":" + Email! + ":" + "UpgradeIsBusyStatus"
        let Base64 = convertStringToBase64(string: string)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        // request.timeoutInterval = 6
        request.httpMethod = "POST"

        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        let bodyData = "{\"SiteId\":\"\(siteid)\"}"//
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.timeoutInterval = 10

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                // "\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1"// + "#" + "\(error!)"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }

    func updateMacAddress(macadd:String){

//        let Email = defaults.string(forKey: "address")
//        let uuid = defaults.string(forKey: "uuid")
//          //  let wifiSSID:String = Vehicaldetails.sharedInstance.SSId
//            let siteid = Vehicaldetails.sharedInstance.siteID
//            print("\(Vehicaldetails.sharedInstance.siteID)")
//            let Url:String = FSURL//
//            let string = uuid! + ":" + Email! + ":" + "UpdateMACAddress"
//        let Base64 = convertStringToBase64(string: string)
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//            // request.timeoutInterval = 6
//        request.httpMethod = "POST"
//
//            request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//            let bodyData = "{\"SiteId\":\"\(siteid)\",\"MACAddress\":\"\(macadd)\"}"//
//            print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//            //request.timeoutInterval = 10
//
//        //let session = URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//           let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//                if let data = data {
//                    print(String(data: data, encoding: String.Encoding.utf8)!)
//                    self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                    print(self.reply)
//                   // "\(self.reply)"
//                } else {
//                    print(error!)
//                    self.reply = "-1" + "#" + "\(error!)"
//                }
//                semaphore.signal()
//            }//)
//            
//            task.resume()
//            semaphore.wait(timeout: DispatchTime.distantFuture)
//           // return reply + "#" + ""
        }


    func status() {
        let Url:String = "http://192.168.4.1:80/upgrade?command=reset"
        let request:NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "POST"
        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)

               // "\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)

        //self.binfiledata.text = self.reply

    }

     func getrelay() -> String {
        let Url:String = "http://192.168.4.1:80/config?command=relay"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        request.timeoutInterval = 15

        request.httpMethod = "GET"
        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)

               // "\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)

        return reply
    }


 func setrelay() {
        let Url:String = "http://192.168.4.1:80/config?command=relay";
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyData = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.httpBodyStream = InputStream(data:bodyData.data(using: String.Encoding.utf8)!)

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
               // "\(self.reply)"
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if(httpResponse.statusCode != 200)
                    {
                         self.cf.delay(0.3){
                        self.setrelay()
                        }

                    }else if(httpResponse.statusCode == 200)
                    {
                        ///self.getrelay()
                    }
                }

            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)


    }


//    func sleep() {
//        let Url:String = "http://192.168.4.1/config?command=diswifi"
//        let request: NSMutableURLRequest = NSMutableURLRequest(URL:NSURL(string:Url)!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPMethod = "POST"
//        let bodyData = "{\"wifi_request\":{\"time\":15}}"
//        request.HTTPBody = bodyData.data(using: String.Encoding.utf8)
//        //request.HTTPBodyStream = NSInputStream(data: bodyData.dataUsingEncoding(NSUTF8StringEncoding)!)
//
//
//        let session = NSURLSession.sharedSession()
//        let semaphore = dispatch_semaphore_create(0)
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: NSUTF8StringEncoding))
//                self.reply = NSString(data: data, encoding:NSASCIIStringEncoding)as! String
//                print(self.reply)
//                print(response)
//                if let httpResponse = response as? NSHTTPURLResponse {
//                    print("Status code: (\(httpResponse.statusCode))")
//                    if(httpResponse.statusCode != 200)
//                    {
//                        self.cf.delay(0.1){
//                        self.sleep()
//                        }
//                    }
//                }
//
//
//                "\(self.reply)"
//            } else {
//                print(error)
//                self.reply = "-1"
//            }
//            dispatch_semaphore_signal(semaphore)
//        }
//
//        task.resume()
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)
//
//    }

    // curl -X POST http://ip/config?command=sleep
 func recordcheck() -> String {
        let Url:String = "http://192.168.4.1:80/client?command=record10";
    let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
    request.httpMethod = "GET"

    let session = URLSession.shared

    let semaphore = DispatchSemaphore(value: 0)
    let task = session.dataTask(with: request as URLRequest as URLRequest) { data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8))
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply!)
                "\(self.reply!)"
            } else {
                print(error!)
                self.reply = "-1"

            }
        semaphore.signal()
        }

        task.resume()
    return (reply)!
    semaphore.wait(timeout: DispatchTime.now())

    }

    func setrelay0() {

        let Url:String = "http://192.168.4.1:80/config?command=relay";

        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)

        let bodyData = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"

        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

              // request.HTTPBodyStream = NSInputStream(data: bodyData.dataUsingEncoding(NSUTF8StringEncoding)!)

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)


        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(data)
                print(self.reply)
                //"\(self.reply)"
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if(httpResponse.statusCode != 200)
                    {
                        self.cf.delay(0.3){
                        self.setrelay0()
                    }
                 }
                }

            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)
        task.resume()
        semaphore.wait(timeout: DispatchTime.now())
       // Vehicaldetails.sharedInstance.setrelay0
        
    //}
    }

    func GetPulser()->String {
       let Url:String = "http://192.168.4.1:80/client?command=pulsar"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)

                //"\(self.reply)"
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }
    
     func getinfo() -> String {
        cf.delay(1){
        let Url:String = "http://192.168.4.1:80/client?command=info"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
            request.httpMethod = "GET"
            self.isconect_toFS = "false";
            //let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
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
                   // let sdk_version = Version.valueForKey("sdk_version") as! NSString
                    let iot_version = Version.value(forKey: "iot_version") as! NSString
                    let mac_address = Version.value(forKey: "mac_address") as! NSString
                   // Vehicaldetails.sharedInstance.FirmwareVersion = "\(iot_version)"
                    self.isconect_toFS = "true"
                    print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
                    if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){

                    }else {
                        print(Vehicaldetails.sharedInstance.FS_MacAddress)
                        Vehicaldetails.sharedInstance.FS_MacAddress = mac_address as String
                        // self.updateMacAddress(mac_address as String)
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

               // print(self.sysdata)

                // return reply
            } else {
                print(error!)
                self.reply = "-1"
            }
                semaphore.signal()
        }

            task.resume()
            semaphore.wait(timeout: DispatchTime.distantFuture)
        //self.binfiledata.text = self.reply
        }

        return isconect_toFS;
    }

     func SetPulser()  {

     let Url:String = "http://192.168.4.1:80/config?command=pulsar"

        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyData = "{\"pulsar_request\":{\"counter_set\":1}}"

        request.httpBody = bodyData.data(using: String.Encoding.utf8)

        // request.HTTPBodyStream = NSInputStream(data: bodyData.dataUsingEncoding(NSUTF8StringEncoding)!)

       // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.replySetPulser = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.replySetPulser)
                "\(self.replySetPulser)"
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if(httpResponse.statusCode != 200)
                    {
                        self.cf.delay(0.4){
                        self.SetPulser()
                        }
                    }
                    else if(httpResponse.statusCode == 200){

                       //self.GetPulser()
                    }
                }

            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)
         cf.delay(5){}
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)


    }

    func SetPulser0() -> String {
        let Url:String = "http://192.168.4.1:80/config?command=pulsar"

        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)

        let bodyData = "{\"pulsar_request\":{\"counter_set\":0}}"

        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")



        //request.HTTPBodyStream = NSInputStream(data: bodyData.dataUsingEncoding(NSUTF8StringEncoding)!)

        //let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
               //"\(self.reply)"
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if(httpResponse.statusCode != 200)
                    {
                        //self.SetPulser0()
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
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }


    func changessidname(wifissid:String) {

        let Url = "http://192.168.4.1:80/config?command=wifi"

        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
        print(Url)
        let bodyData = "{\"Request\":{\"SoftAP\":{\"Connect_SoftAP\":{\"authmode\":\"OPEN\",\"channel\":2,\"ssid\":\"\(wifissid)\",\"password\":\"\"}}}}"
        print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        //request.HTTPBodyStream = NSInputStream(data: bodyData.dataUsingEncoding(NSUTF8StringEncoding)!)
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

       // let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                //"\(self.reply)"
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: (\(httpResponse.statusCode))")
                    if(httpResponse.statusCode != 200)
                    {
                        self.changessidname(wifissid: wifissid)
                    }
                }

            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }//)

        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
    }



    func convertStringToBase64(string: String) -> String
    {
        let utf8str = string.data(using: String.Encoding.utf8)!
        let base64str = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        return base64str
    }
    
}
