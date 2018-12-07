//
//  Sync_UnsyncTransaction.swift
//  FuelSecure
//
//  Created by VASP on 8/29/18.
//  Copyright © 2018 VASP. All rights reserved.
//

import Foundation
import UIKit


class Sync_Unsynctransactions : NSObject
{
    var web = Webservices()
    var cf = Commanfunction()


    var ResponceMessageUpload:String = ""
    var string_data = ""
    var reply :String!
    var sysdata:NSDictionary!
    var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
    let defaults = UserDefaults.standard


    func unsyncTransaction() //-> String
    {
        //        if(stopbutton == true){
        //            s1 = string
        //            print(s1)

        if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
        {
            web.sentlogFile()
            let logdata = self.cf.ReadFile(fileName: "Sendlog.txt")
            print(logdata)

            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/test/")
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
                    let Transaction_id = Split[1]
                    let quantity = Split[2]
                    let siteName = Split[3]
                    if(quantity == "0" ){
                        web.UpgradeTransactionStatus(Transaction_id:Transaction_id,Status: "1")
                        self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                    }else if(quantity == "" ){
                        self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                    }

                    let JData: String = cf.ReadReportFile(fileName: filename)
                    if(JData != "")
                    {
                        if(siteName == "SaveTankMonitorReading"){
                            Upload(jsonstring: JData,filename: filename,siteName:"SaveTankMonitorReading")
                        }

                        else {
                            Upload(jsonstring: JData,filename: filename,siteName:"TransactionComplete")
                        }
                        if(ResponceMessageUpload == "success"){
                            self.notify(site: siteName)
                        }
                    }
                }
            }
        }

        else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
        {
            var reportsArray: [AnyObject]!
            let fileManager: FileManager = FileManager()
            let readdata = cf.getDocumentsURL().appendingPathComponent("data/test/")!
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
                    let Transaction_id = Split[1]
                    let quantity = Split[2]
                    let siteName = Split[3]

                    if(quantity == "0" ){
                        web.UpgradeTransactionStatus(Transaction_id:Transaction_id,Status: "1")
                        self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                    }else if(quantity == "" ){
                        self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                    }
                    else {
                        let JData: String = cf.ReadReportFile(fileName: filename)
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
                                self.notify(site: siteName)
                            }
                        }
                    }
                }
            }
        }
        //stopbutton = false
        //  }
    }


    func Upload(jsonstring: String,filename:String,siteName:String)
    {
        FSURL = Vehicaldetails.sharedInstance.URL + "/HandlerTrak.ashx"
        let Email = defaults.string(forKey: "address")
        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL

        string_data = uuid! + ":" + Email! + ":" + "\(siteName)"//TransactionComplete"
        print(string_data,jsonstring)
        let Base64 = cf.convertStringToBase64(string_data)
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        print(jsonstring)
        request.httpBody = jsonstring.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                //"\(self.reply)"
                let data1 = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                print(self.sysdata)

                let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                self.ResponceMessageUpload = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                if(self.ResponceMessageUpload == "fail"){
                    if(ResponceText == "TransactionId not found."){
                        self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                    }
                    // self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                }
                if(self.ResponceMessageUpload == "success"){
                    self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                }
            } else {
                print(error as Any)
                self.reply = "-1"
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }


    func notify(site:String) {



        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "open"
        localNotification.alertBody = NSLocalizedString("Notify", comment:"") + "\(site)."//"Your Transaction is Successfully Completed at \(site)."
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        localNotification.soundName = "button-24.mp3"//UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
}
