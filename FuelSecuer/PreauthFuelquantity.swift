//  PreauthFuelquantity.swift
//  FuelSecure
//
//  Created by VASP on 9/21/17.
//  Copyright © 2017 VASP. All rights reserved.

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
import CoreData

class PreauthFuelquantity: UIViewController,StreamDelegate,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,CLLocationManagerDelegate
{
    @IBOutlet var Pwait: UILabel!
    @IBOutlet var waitactivity: UIActivityIndicatorView!
    @IBOutlet var lable: UILabel!
    @IBOutlet var tpulse: UILabel!
    @IBOutlet var tquantity: UILabel!
    @IBOutlet var wait: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!

    var cf = Commanfunction()
    let defaults = UserDefaults.standard
    var web = Webservices()
    var getdatafromsetting = false
    var string:String = ""
    var status :String = ""
    var tstring:String = ""
    var sysdata:NSDictionary!
    var sysdata1:NSDictionary!
    var IsStartbuttontapped : Bool = false
    var setrelaysysdata:NSDictionary!
    var stoptimergotostart:Timer = Timer()
    var s1 :String!
    var iswifi :Bool!
    var Fquantity :Double!
    var quantity = [String]()
    var counts:String!
    var timer:Timer = Timer()
    var timerview:Timer = Timer()
    var stoptimer:Timer = Timer()
    var y :CGFloat = CGFloat()
    var results = [NSManagedObject]()
    var Transaction_ID = [NSManagedObject]()
    var beginfuel1 : Bool = false
    var stopbutton :Bool = false
    var fuelquantity:Double!
    var reply :String!
    var reply1 :String!
    var pulsardata:String!
    var startbutton:String = ""
    var currentlocation :CLLocation!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    var buffer = [UInt8](repeating: 0, count:1024)
    var stopdelaytime:Bool = false

    let addr = "192.168.4.1"
    let port = 80

    //Network variables
    var inStream : InputStream?
    var outStream: OutputStream?

    //Mark IBOutlets

    @IBOutlet var cancel: UIButton!
    @IBOutlet var start: UIButton!
    @IBOutlet var Stop: UIButton!
    @IBOutlet var Odometer: UILabel!
    @IBOutlet var vehicleno: UILabel!
    @IBOutlet var displaytime: UILabel!
    @IBOutlet var CQ: UILabel!
    @IBOutlet var FQ: UILabel!
    @IBOutlet var UsageInfoview: UIView!
    @IBOutlet var totalquantityinfo: UILabel!
    @IBOutlet var Quantity1: UILabel!
    @IBOutlet var pulse: UILabel!

   override func viewDidAppear(_ animated: Bool) {
        print(string)
        cf.delay(2){
            self.Activity.hidesWhenStopped = true;
            print(self.cf.getSSID())

            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                let isConect_toFS = self.web.getinfo()
                if(isConect_toFS == "true"){


                }
                else if(isConect_toFS == "false") {


                }
                self.timerview.invalidate()
                self.iswifi = true
                if(self.startbutton == "true")
                {
                    print("startbutton")
                }
                self.displaytime.text = "Please insert the nozzle into the tank \n Then tap start"
            }
            else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
            {
                self.timerview.invalidate()
                self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        wait.isHidden = true
        waitactivity.isHidden = true
        UsageInfoview.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        Vehicaldetails.sharedInstance.gohome = false
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle("Return", for: UIControlState())
        doneButton.addTarget(self, action: #selector(FuelquantityVC.tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor .black

        FQ.isHidden = false
        Stop.isHidden = true
        start.isHidden = false
        cancel.isHidden = false
        getdatafromsetting = true

        if(!timerview.isValid) {}

        Odometer.text = "\(Vehicaldetails.sharedInstance.Odometerno)"
        vehicleno.text = "\(Vehicaldetails.sharedInstance.vehicleno)"
    }

    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.endEditing(true)
    }

    func showFileWithPath(_ path: String) {
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
        {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let fileManager = FileManager()
            let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath + "/filebin")
            if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 1) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationBeginsFromCurrentState(true)
           self.view.frame = CGRect(x: 0,y: -140, width: self.view.frame.size.width, height: self.view.frame.size.height)
            UIView.commitAnimations()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setSamplingtime()->String{

        NetworkEnable()
        Vehicaldetails.sharedInstance.PulserTimingAdjust = "20"
        let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }


    func setralaytcp()->String{

        NetworkEnable()
        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        print(s.count)
        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
         outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        var outputdata :String = string
        if(string == ""){}
        else{
           let Split = outputdata.components(separatedBy: "{")
            _ = Split[0]
            let setrelay = Split[1]
            let setrelaystatus = Split[2]
            outputdata = setrelay + "{" + setrelaystatus
        }
        return outputdata
    }

    func Getralaytcp()->String{

        NetworkEnable()
        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
        print(s.count)
        let datastring = "Get /config?command=relay HTTP/1.1\r\n"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }

    func setpulsartcp()->String{

        NetworkEnable()
        let s:String = "{\"pulsar_request\":{\"counter_set\":1}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":1}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }


    func setralay0tcp()->String{

        NetworkEnable()
        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
        print(s.count)
        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }

    func setpulsar0tcp()->String {
        NetworkEnable()
        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":0}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }

    func Getpulasrtcp() ->String {
        NetworkEnable()
        let datastring = "Get /config?command=Pulsar HTTP/1.1\r\n"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }

    func final_pulsar_request() ->String {
        NetworkEnable()
        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
        print(s.count)
        let datastring = "POST /config?command=pulsarX HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"final_pulsar_request\":{\"time\":10}}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        print(outputdata)
        return outputdata
    }

    func pulsarlastquantity()
    {
        let Url:String = "http://192.168.4.1:80/client?command=record10"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
        request.httpMethod = "GET"
        //let reply1:String!
        //        let session = URLSession.sharedSession()
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.pulsardata)
                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                //self.lableview.text! += "\n" + self.reply1!

                if(self.sysdata1 == nil){}
                else{
                    let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
                    let counts = objUserData.value(forKey: "1:") as! NSNumber
                    // let pulsar_status = objUserData.valueForKey("pulsar_status") as! NSNumber
                    // let pulsar_secure_status = objUserData.valueForKey("pulsar_secure_status") as! NSNumber
                    let t_count = Int(counts) + 1
                    print(t_count)
                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
                    //                    print(counts,Vehicaldetails.sharedInstance.FinalQuantitycount)

                }

                // "\(self.pulsardata)"
            } else {
                print(error as Any)
                self.pulsardata = "-1"
            }
            semaphore.signal()
        }

        task.resume()
    }

    func Getrecordchecktcp()->String {
        NetworkEnable()
        //        let s:String = "record10" //http://192.168.4.1:80/client?command=record10
        //        print(s.count)
        let datastring = "Get /client?command=record10 HTTP/1.1\r\n"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        print(outputdata)
        return outputdata
    }

    func getlastTrans_ID() -> String {

        let Url:String = "http://192.168.4.1:80/client?command=lasttxtnid"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
        request.httpMethod = "GET"

        let semaphore = DispatchSemaphore(value: 0)
       let task =  URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)!as String
                print(self.reply)
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

    func setpulsaroffTime(){
        //        var millisecond: Int {
        //            return Int((self*1000).truncatingRemainder(dividingBy: 1000))
        //        }
        let time:Int = (Int(Vehicaldetails.sharedInstance.PulserStopTime)!+3) * 1000
        print(time)
        NetworkEnable()
        let s:String = "{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"

        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)

        let outputdata = string
        print(outputdata)
        print(datastring)
    }


    func settransaction_IDtoFS(){

        let count:Int = "\(Vehicaldetails.sharedInstance.TransactionId)".count
        var format = "0000000000"
        let range = format.index(format.endIndex, offsetBy: -count)..<format.endIndex
        format.removeSubrange(range)
        print(format)

        let txtnid:String = format + "\(Vehicaldetails.sharedInstance.TransactionId)"
        print(txtnid)

        NetworkEnable()
        let s:String = "{\"txtnid\":\(txtnid)}"
        print(s.count)
        let datastring = "POST /config?command=txtnid HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"txtnid\":\(txtnid)}"
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        print(outputdata)
        print(datastring)
    }

    func savetrans(lastpulsarcount:String,lasttransID:String) {

        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        let fuelquantity = (Double(lastpulsarcount))!/(PulseRatio as NSString).doubleValue
        if(fuelquantity == 0.0 || lasttransID == "-1"){}
        else{
           // let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"TransactionFrom\":\"I\"}"
             let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"Pulses\":\"\(lastpulsarcount)\",\"TransactionFrom\":\"I\"}"
            let jsonstring: String = bodyData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
           let unsycnfileName =  dtt1 + "transaction" + "#" + "lasttransID" + "#" + Vehicaldetails.sharedInstance.siteName
            // let unsycnfileName =  dtt1 + "transaction" + "#" + Vehicaldetails.sharedInstance.siteName

            cf.SaveTextFile(fileName: unsycnfileName, writeText: jsonstring)
        }
    }


    @IBAction func startButtontapped(sender: AnyObject)
        {

            //Start the fueling with buttontapped
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            start.isEnabled = false
            IsStartbuttontapped = true
            //viewDidAppear(true)
            stoptimergotostart.invalidate()

            //cf.delay(0.5){
            self.timerview.invalidate()
            self.cf.delay(0.5){
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                {
                    self.timerview.invalidate()
                    self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                }else {


                    self.reply = self.web.getrelay()
                    let defaultTimeZoneStr = formatter.string(from: Date());
                    //                                print("GetRelay" + defaultTimeZoneStr)// get relay
                    print(self.reply)

                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                    do{
                        self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    }catch let error as NSError {
                        print ("Error: \(error.domain)")
                    }

                    if(self.setrelaysysdata == nil){

                    }
                    else{
                        let objUserData = self.setrelaysysdata.value(forKey: "relay_response") as! NSDictionary

                        let relayStatus = objUserData.value(forKey: "status") as! NSNumber

                        if(relayStatus == 0){




                            self.Pwait.text = "Please wait ... "
                            self.Pwait.isHidden = false
                            self.start.isHidden = true

                            self.setpulsaroffTime()

                            //let defaultTimeZoneStr = formatter.string(from: Date());
                            print("setpulsarofftime" + defaultTimeZoneStr)
                            self.cf.delay(0.5){
                                let st = self.setSamplingtime()
                                let defaultTimeZoneStr1 = formatter.string(from: Date());
                                print("setSamplingtime" + defaultTimeZoneStr1)
                                print(st)





                                self.cf.delay(0.5){
                                    self.start.isHidden = true
                                    self.pulsarlastquantity()
                                    let defaultTimeZoneStr1 = formatter.string(from: Date());
                                    print("pulsarlastquantity" + defaultTimeZoneStr1)

                                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                                  //  _ = self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "1")

                                    self.cf.delay(0.5){
                                        //let lastpulsarcount = Vehicaldetails.sharedInstance.FinalQuantitycount //
                                        let lasttransID = self.getlastTrans_ID()
                                        let defaultTimeZoneStr1 = formatter.string(from: Date());
                                        print("getlastTrans_ID" + defaultTimeZoneStr1)
                                        if(Vehicaldetails.sharedInstance.FinalQuantitycount == ""){}
                                        else{
                                            self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                        }


                                        self.cf.delay(0.5){
                                            //self.web.UpgradeCurrentVersiontoserver() //
                                            self.settransaction_IDtoFS()
                                            let defaultTimeZoneStr1 = formatter.string(from: Date());
                                            print("settransaction_IDtoFS" + defaultTimeZoneStr1)


                                            // else{
                                            //                        let objUserData = self.setrelaysysdata.value(forKey: "relay_response") as! NSDictionary
                                            //                        let status = objUserData.value(forKey: "status") as! NSNumber                         // status = 1
                                            //                                    let defaultTimeZoneStr1 = formatter.string(from: Date());
                                            //                                    print("setrelaysysdata" + defaultTimeZoneStr1)
                                            //                print(setrelayd)
                                            //                if(status == 1) {
                                            self.beginfuel1 = false
                                            self.cancel.isHidden = true
                                            ///hide start button
                                            self.displaytime.text = "Fueling…"
                                            self.Pwait.isHidden = true
                                            self.string = ""
                                            self.iswifi = true
                                            if(self.startbutton == "true")
                                            {
                                                print("startbutton")
                                            }

                                            if(self.iswifi == false){
                                                if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
                                                    self.viewDidAppear(true)
                                                    self.startbutton = "true"
                                                }
                                                else{
                                                    self.showAlertSetting(message: "Please check your wifi connection")
                                                }
                                            }

                                            self.Activity.isHidden = true
                                            self.Activity.stopAnimating()
                                           // self.record = []
                                            self.cf.delay(0.5){
                                                //           // self.reply = self.web.getrelay()
                                                //                let defaultTimeZoneStr = formatter.string(from: Date());
                                                //                print("GetRelay" + defaultTimeZoneStr)// get relay
                                                //            print(self.reply)
                                                //
                                                //            let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                                                //            do{
                                                //                self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                                //            }catch let error as NSError {
                                                //                print ("Error: \(error.domain)")
                                                //            }
                                                //
                                                //            if(self.setrelaysysdata == nil){
                                                //
                                                //            }
                                                //  else{
                                                //                let objUserData = self.setrelaysysdata.value(forKey: "relay_response") as! NSDictionary
                                                //
                                                //                let relayStatus = objUserData.value(forKey: "status") as! NSNumber

                                                //                if(status == 1){

                                                self.string = ""
                                                self.inStream?.close()
                                                self.outStream?.close()
                                                self.cf.delay(0.5){
                                                    var setpulsar = self.setpulsartcp()
                                                    let defaultTimeZoneStr = formatter.string(from: Date());
                                                    print("Pulsar on0" + defaultTimeZoneStr)
                                                    self.cf.delay(0.5){
                                                        if(setpulsar == ""){
                                                            setpulsar = self.setpulsartcp()
                                                            let defaultTimeZoneStr = formatter.string(from: Date());
                                                            print("Pulsar on1" + defaultTimeZoneStr)
                                                            //set pulsar
                                                        }
                                                        if(setpulsar == ""){
                                                            self.cf.delay(0.5){
                                                                _ = self.setralay0tcp()
                                                                _ = self.setpulsar0tcp()
                                                                self.error400(message: "Please check your FS unit, and switch off power and back on.")
                                                            }
                                                        }
                                                        else{

                                                            let Split = setpulsar.components(separatedBy: "{")
                                                            if(Split.count < 3){
                                                                _ = self.setralay0tcp()
                                                                _ = self.setpulsar0tcp()
                                                                self.error400(message: "Please check your FS unit, and switch off power and back on.")
                                                            }    // got invalid respose do nothing
                                                            else{

                                                                let reply = Split[1]
                                                                let setrelay = Split[2]
                                                                let Split1 = setrelay.components(separatedBy: "}")
                                                                let setrelay1 = Split1[0]
                                                                let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
                                                                let data1:Data = outputdata.data(using: String.Encoding.utf8)!
                                                                do{
                                                                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                                                }catch let error as NSError {
                                                                    print ("Error: \(error.domain)")
                                                                }
                                                                print(self.sysdata1)

                                                                let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                                                                self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                                let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber

                                                                //                                if (self.counts != "0"){
                                                                //                                if(pulsar_status == 0)
                                                                //                                {
                                                                //                                    self.stopButtontapped()
                                                                //                                }
                                                                //                            }

                                                                print(setpulsar)

                                                                if(pulsar_status == 1)
                                                                {
                                                                    var setrelayd = self.setralaytcp()
                                                                    let defaultTimeZoneStr = formatter.string(from: Date());
                                                                    print("Relay on0" + defaultTimeZoneStr)
                                                                    print(setrelayd)
                                                                    self.cf.delay(0.5){
                                                                        if(setrelayd == ""){        // if no response sent set relay command again
                                                                            setrelayd = self.setralaytcp()
                                                                            let defaultTimeZoneStr = formatter.string(from: Date());
                                                                            print("Relay on1" + defaultTimeZoneStr)
                                                                        }
                                                                        if(setrelayd == ""){  // after 2 attempt stop relay goto home screen
                                                                            self.cf.delay(0.5){
                                                                                _ = self.setralay0tcp()
                                                                                _ = self.setpulsar0tcp()
                                                                                let defaultTimeZoneStr = formatter.string(from: Date());
                                                                                print(defaultTimeZoneStr)
                                                                                self.error400(message: "Please check your FS unit, and switch off power and back on.")
                                                                            }
                                                                        }
                                                                        else{

                                                                            let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
                                                                            if(Split.count < 2){
                                                                                _ = self.setralay0tcp()
                                                                                _ = self.setpulsar0tcp()
                                                                                self.error400(message: "Please check your FS unit, and switch off power and back on.")
                                                                            }    // got invalid respose do nothing goto home screen
                                                                            else{
                                                                                let reply = Split[0] as! String    // get valid respose proceed
                                                                                let setrelay = Split[1]as! String
                                                                                let Split1:NSArray = setrelay.components(separatedBy: "}") as NSArray
                                                                                let setrelay1 = Split1[0] as! String
                                                                                let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"  /// got valid data from FS unit
                                                                                let defaultTimeZoneStr1 = formatter.string(from: Date());
                                                                                print("getresponse relay on" + defaultTimeZoneStr1)
                                                                                let data1:NSData = outputdata.data(using: String.Encoding.utf8)! as NSData
                                                                                do{
                                                                                    self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                                                                }catch let error as NSError {
                                                                                    print ("Error: \(error.domain)")
                                                                                }
                                                                                print(self.setrelaysysdata)
                                                                                if(self.setrelaysysdata == nil){
                                                                                    self.showAlert(message: "please retry")
                                                                                }
                                                                            }
                                                                            self.start.isHidden = true
                                                                            self.Stop.isHidden = false
                                                                            self.string = ""
                                                                            self.displaytime.text = ""
                                                                            self.btnBeginFueling()
                                                                            let defaultTimeZoneStr = formatter.string(from: Date());
                                                                            print("Get Pulsar" + defaultTimeZoneStr)

                                                                            // self.beginfuel.hidden = true
                                                                        }
                                                                        //                        else
                                                                        //                        {
                                                                        //                                }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        // }
                                                        //                else{
                                                        //                    _ = self.setralay0tcp()
                                                        //                    _ = self.setpulsar0tcp()
                                                        //                        self.error400(message: "Please check your FS unit, and switch off power and back on.")
                                                        //                    }
                                                        // }
                                                    }
                                                    //      }
                                                    //  }
                                                }
                                            }
                                            //  }

                                        }
                                    }
                                    self.string = ""
                                }
                            }
                        }
                        else if(relayStatus == 1)
                        {
                            let alert = UIAlertController(title: "", message: NSLocalizedString("The link is busy, please try after some time.", comment:""), preferredStyle: UIAlertControllerStyle.alert)
                            let backView = alert.view.subviews.last?.subviews.last
                            backView?.layer.cornerRadius = 10.0
                            backView?.backgroundColor = UIColor.white
                            var messageMutableString = NSMutableAttributedString()
                            messageMutableString = NSMutableAttributedString(string: "The link is busy, please try after some time." as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
                            messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:"The link is busy, please try after some time.".count))
                            alert.setValue(messageMutableString, forKey: "attributedMessage")

                            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertActionStyle.default) { action in
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                // Call a method on the CustomController property of the AppDelegate
                                self.cf.delay(1) {     // takes a Double value for the delay in seconds
                                    appDel.start()
                                    self.Activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
                                    self.Activity.startAnimating()
                                }
                            }


                            alert.addAction(okAction)

                            self.present(alert, animated: true, completion: nil)


                        }
                    }
                }

            }
            //   }

        }

//        //Start the fueling with buttontapped
//        start.isEnabled = false
//        timerview.invalidate()
//       cf.delay(1){
//
//            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
//            {
//                self.timerview.invalidate()
//                self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
//
//            }else {
//                self.pulsarlastquantity()
//                self.cf.delay(1){
//
//                    let lasttransID = self.getlastTrans_ID()
//                    self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
//
//                    self.cf.delay(1){
//                        self.settransaction_IDtoFS()
//                        var setrelayd = self.setralaytcp()
//                        print(setrelayd)
//                        self.cf.delay(1.5){
//                            if(setrelayd == ""){        // if no response sent set relay command again
//                                setrelayd = self.setralaytcp()
//                            }
//                            if(setrelayd == ""){  // after 2 attempt stop relay goto home screen
//                                self.cf.delay(1){
//                                    _ = self.setralay0tcp()
//                                    self.error400(message: "Please check your FS unit, and switch off power and back on.")
//                                }
//                            }
//                            else{
//                                let Split = setrelayd.components(separatedBy: "{")
//                                if(Split.count < 2){
//                                    self.error400(message: "Please check your FS unit, and switch off power and back on.")
//                                }    // got invalid respose do nothing goto home screen
//                                else{
//                                    let reply = Split[0]    // get valid respose proceed
//                                    let setrelay = Split[1]
//                                    let Split1 = setrelay.components(separatedBy: "}")
//                                    let setrelay1 = Split1[0]
//
//                                    let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"  /// got valid data from FS unit
//
//                                    let data1:Data = outputdata.data(using: String.Encoding.utf8)!
//                                    do{
//                                         self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                                    }catch let error as NSError {
//                                        print ("Error: \(error.domain)")
//                                    }
//                                    print(self.sysdata)
//                                    let objUserData = self.sysdata.value(forKey: "relay_response") as! NSDictionary
//                                    let status = objUserData.value(forKey: "status") as! NSNumber                         // status = 1
//
//                                    print(setrelayd)
//                                    if(status == 1) {
//                                        self.beginfuel1 = false
//                                        self.cancel.isHidden = true
//                                        self.start.isHidden = true           ///hide start button
//                                        self.displaytime.text = "Fueling…"
//                                        self.string = ""
//                                        self.iswifi = true
//                                        if(self.startbutton == "true")
//                                        {
//                                            print("startbutton")
//                                        }
//
//                                        if(self.iswifi == false){
//                                            if(Vehicaldetails.sharedInstance.reachblevia == "wificonn"){
//                                                self.viewDidAppear(true)
//                                                self.startbutton = "true"
//                                            }
//                                            else{
//                                                self.showAlertSetting(message: "Please check your wifi connection")
//                                            }
//                                        }
//                                        self.Activity.isHidden = true
//                                        self.Activity.stopAnimating()
//                                        self.cf.delay(0.5)
//                                        {
//                                            self.reply = self.web.getrelay()   // get relay
//                                            print(self.reply)
//                                            let data1:Data = self.reply.data(using: String.Encoding.utf8)!
//                                            do{
//                                                 self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                                              }catch let error as NSError {
//                                                print ("Error: \(error.domain)")
//                                            }
//
//                                            if(self.sysdata == nil){}
//                                            else{
//                                                let objUserData = self.sysdata.value(forKey: "relay_response") as! NSDictionary
//
//                                                let relayStatus = objUserData.value(forKey: "status") as! NSNumber
//
//                                                if(relayStatus == 1){
//
//                                                    self.string = ""
//                                                    self.inStream?.close()
//                                                    self.outStream?.close()
//                                                    self.cf.delay(0.5){
//                                                        var setpulsar = self.setpulsartcp()
//                                                        self.cf.delay(0.5){
//                                                            if(setpulsar == ""){
//                                                                setpulsar = self.setpulsartcp()    //set pulsar
//                                                            }
//                                                            if(setpulsar == ""){
//                                                                self.cf.delay(0.5){
//                                                                    _ = self.setralay0tcp()
//                                                                    self.error400(message: "Please check your FS unit, and switch off power and back on.")
//                                                                }
//                                                            }
//                                                            else{
//                                                                let Split = setpulsar.components(separatedBy: "{")
//                                                                if(Split.count < 3){
//                                                                    self.error400(message: "Please check your FS unit, and switch off power and back on.")
//                                                                }    // got invalid respose do nothing
//                                                                else{
//
//                                                                    let reply = Split[1]
//                                                                    let setrelay = Split[2]
//                                                                    let Split1 = setrelay.components(separatedBy: "}")
//                                                                    let setrelay1 = Split1[0]
//                                                                    let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
//                                                                    let data1:Data = outputdata.data(using: String.Encoding.utf8)!
//                                                                    do{
//                                                                        self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                                                                    }catch let error as NSError {
//                                                                        print ("Error: \(error.domain)")
//                                                                    }
//                                                                    print(self.sysdata1)
//
//                                                                    let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
//
//                                                                    self.counts = objUserData.value(forKey: "counts") as! NSString as String
//                                                                    let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
//
//                                                                    if (self.counts != "0"){
//                                                                        if(pulsar_status == 0)
//                                                                        {
//                                                                            self.stopButtontapped()
//                                                                        }
//                                                                    }
//
//                                                                    print(setpulsar)
//
//                                                                    if(pulsar_status == 1)
//                                                                    {
//                                                                        self.string = ""
//                                                                        self.displaytime.text = ""
//                                                                        self.btnBeginFueling()
//                                                                        self.start.isHidden = true
//                                                                        self.Stop.isHidden = false
//                                                                    }
//                                                                    else { }
//                                                                }
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                                else { }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            self.string = ""
//        }
//    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {

        let alert = UIAlertController(title: "Confirm", message: NSLocalizedString("Are you sure to Cancel? Please wait while getting redirected to select hose page.", comment:""), preferredStyle: UIAlertControllerStyle.alert )
        let backView = alert.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: "Are you sure to Cancel? Please wait while getting redirected to select hose page.." as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:"Are you sure to Cancel? Please wait while getting redirected to select hose page.".count))
        alert.setValue(messageMutableString, forKey: "attributedMessage")

        let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.default) { action in
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            // Call a method on the CustomController property of the AppDelegate

            self.cf.delay(1) {     // takes a Double value for the delay in seconds

                // put the delayed action/function here
                self.BusyStatuschange()
                 self.web.sentlog(func_name: "Preauth cancelButtonTapped")
                appDel.start()
                self.Activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
                self.Activity.startAnimating()
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment:""), style: UIAlertActionStyle.cancel) { (submitn) -> Void in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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

    func error400(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertActionStyle.default) { action in //self.//
                self.cf.delay(1){
                Vehicaldetails.sharedInstance.gohome = true
                self.timerview.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                    self.web.sentlog(func_name: "Preauth error400")
                appDel.start()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlert(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        // Action.
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlertSetting(message: String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white

        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
        let action = UIAlertAction(title: NSLocalizedString("Wifi Setitngs", comment:""), style: UIAlertActionStyle.default) { action in //self.
            
                        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
                        let app = UIApplication.shared// .shared
                        app.openURL(url! as URL)
                        Vehicaldetails.sharedInstance.gohome = false
                        self.resumetimer()
        }

        let home = UIAlertAction(title: NSLocalizedString("Back to Home", comment:""), style: UIAlertActionStyle.default) { action in //self.//
                        self.getdatafromsetting = true
                        Vehicaldetails.sharedInstance.gohome = true
                        alertController.view.tintColor = UIColor.green
                        self.timerview.invalidate()
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
            self.web.sentlog(func_name: "Preauth showAlertSetting")
                        appDel.start()
        }

        alertController.addAction(action)
        alertController.addAction(home)
        self.present(alertController, animated: true, completion: nil)
  }

    func resumetimer(){
        self.timerview.invalidate()
        self.timerview = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.viewDidAppear(_:)), userInfo: nil, repeats: true)
    }



    func okaction(sender:UIButton){
        let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared// .shared
        app.openURL(url! as URL)
        Vehicaldetails.sharedInstance.gohome = false
        self.resumetimer()
    }

    func backaction(sender:UIButton){
        Vehicaldetails.sharedInstance.gohome = true
        // alertController.view.tintColor = UIColor.greenColor()
        self.timerview.invalidate()
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        self.web.sentlog(func_name: "Preauth backaction")
        appDel.start()
    }

    func stopButtontapped()
    {
        Stop.isEnabled = false
        Stop.isHidden = true
        wait.isHidden = false
        waitactivity.isHidden = false
        waitactivity.startAnimating()
        self.timer.invalidate()
        string = ""
        cf.delay(0.5){
            self.timer.invalidate()
            var setrelayd = self.setralay0tcp()   //
            self.cf.delay(0.5){
                if(setrelayd == ""){
                    setrelayd = self.setralay0tcp()
                }

                if(setrelayd == ""){
                    self.cf.delay(0.5){
                        _ = self.setralay0tcp()
                        _ = self.setpulsar0tcp()
                        self.error400(message: "Please check your FS unit, and switch off power and back on.")
                        self.stoprelay()
                    }
                }
                else{

                    let Split = setrelayd.components(separatedBy: "{")
                    if(Split.count < 3){
                        _ = self.setralay0tcp()
                        _ = self.setpulsar0tcp()
                        _ = self.stoprelay()
                    }
                    else {
                        let reply = Split[1]
                        let setrelay = Split[2]
                        let Split1 = setrelay.components(separatedBy: "}")
                        let setrelay1 = Split1[0]
                        let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
                        let data1:Data = outputdata.data(using: String.Encoding.utf8)!
                        do{
                           self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        }catch let error as NSError {
                            print ("Error: \(error.domain)")
                        }
                        print(self.sysdata1)
                        let objUserData = self.sysdata1.value(forKey: "relay_response") as! NSDictionary
                        let status = objUserData.value(forKey: "status") as! NSNumber
                        print(setrelayd)

                        if(status == 0) {
                            self.string = ""
                            self.cf.delay(0.5){
                                self.timer.invalidate()
                                self.string = ""
                                var finalpulsar = self.final_pulsar_request()
                                self.cf.delay(0.5){
                                    if(finalpulsar == ""){

                                        finalpulsar = self.final_pulsar_request()
                                    }
                                    print(finalpulsar)
                                    let Split = finalpulsar.components(separatedBy: "{")
                                    print("Splitcout\(Split.count)")
                                    if(Split.count < 3){  _ = self.setralay0tcp()
                                        //self.error400("Please check your FS unit, and switch off power and back on.")
                                     _ = self.setpulsar0tcp()
                                        self.stoprelay()
                                    }
                                    else{
                                        let reply = Split[1]
                                        let setrelay = Split[2]
                                        let Split1 = setrelay.components(separatedBy: "}")
                                        let setrelay1 = Split1[0]
                                        // let setrelaystatus = Split[2]as! String
                                        let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"

                                        let data1:Data = outputdata.data(using: String.Encoding.utf8)!
                                        do{
                                            self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary

                                        }catch let error as NSError {
                                            print ("Error: \(error.domain)")
                                        }

                                        if(self.sysdata1 == nil){}
                                        else{
                                            let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary

                                            self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                            let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                                            if (self.counts != "0"){
                                                if(pulsar_status == 0)
                                                {
                                                    _ = self.setpulsar0tcp()
                                                    self.stoprelay()
                                                }
                                            }
                                            let fuelQuan = self.calculate_fuelquantity(quantitycount: Int(self.counts as String)!)
                                            let y = Double(round(100*fuelQuan)/100)
                                            self.tquantity.text = "\(y) "// + "Gallon"
                                            self.tpulse.text = (self.counts as String) as String
                                        }

                                        print(self.string)
                                        self.Stop.isHidden = true
                                        let SSID:String = self.cf.getSSID()
                                        print(SSID)
                                        print(Vehicaldetails.sharedInstance.SSId)
                                        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                            self.web.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
                                        }
                                        _ = self.setpulsar0tcp()
                                        if( Vehicaldetails.sharedInstance.SSId == SSID  || "FUELSECURE" == SSID)
                                        {
                                            self.cf.delay(0.1) {     // takes a Double value for the delay in seconds
                                                // put the delayed action/function here
                                                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                    _ = self.web.SetHoseNameReplacedFlag()
                                                }
                                                if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == true){
                                                  Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                                                }else{}
                                                self.cf.delay(4){
                                                    if(self.fuelquantity > 0){
                                                        self.wait.isHidden = true
                                                        self.waitactivity.isHidden = true
                                                        self.waitactivity.stopAnimating()
                                                        self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                                        self.pulse.text = "\(self.counts!)"
                                                        self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                                                        self.UsageInfoview.isHidden = false

                                                        self.cf.delay(1){
                                                            self.Transaction(fuelQuantity: self.fuelquantity)
                                                            print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                                            if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                                            else if(Vehicaldetails.sharedInstance.FS_MacAddress != Vehicaldetails.sharedInstance.MacAddress){
                                                                //self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                                            }
                                                        }
                                                        self.cf.delay(10){
                                                            if (self.stopdelaytime == true){}
                                                            else{
                                                            Vehicaldetails.sharedInstance.gohome = true
                                                            self.timerview.invalidate()
                                                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                            self.web.sentlog(func_name: "Preauth stopButtontapped")
                                                            appDel.start()
                                                            }
                                                        }
                                                    }
                                                    else
                                                    {
                                                        self.showAlert(message: "your transaction is not proceed you fuel quantity is 0 please try agian")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            self.cf.delay(1){
                               _ =  self.GetPulser()
                                self.FQ.isHidden = false
                                self.stopbutton = true
                                // self.thankyoubtn.hidden = true
                                self.CQ.isHidden = true
                                self.Stop.isHidden = true
                                self.timer.invalidate()
                                print(self.string)

                                let SSID:String = self.cf.getSSID()
                                print(SSID)
                                print(Vehicaldetails.sharedInstance.SSId)
                                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                    self.web.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
                                }
                                if( Vehicaldetails.sharedInstance.SSId == SSID)
                                {
                                    self.cf.delay(0.1) {
                                        // takes a Double value for the delay in seconds
                                        // put the delayed action/function here
                                        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                            _ = self.web.SetHoseNameReplacedFlag()
                                        }

                                        if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == true){
                                            //self.getuser()
                                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                                        }else{}
                                        self.cf.delay(4){
                                            if(self.fuelquantity > 0){
                                                self.wait.isHidden = true
                                                self.waitactivity.isHidden = true
                                                self.waitactivity.stopAnimating()
                                                self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                                self.pulse.text = "\(self.counts!)"
                                                self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                                                // self.totalquantityinfo.text = "Quantity:\t\t\t\t\(String(format: "%.2f", self.fuelquantity))\n\n Pulse:\t\t\t\t \(self.counts)\n\nThank you for using \nFluidSecure!"
                                                self.UsageInfoview.isHidden = false
                                                // self.error400("Thank you for fueling. Final quantity is \(String(format: "%.2f", self.fuelquantity)). \n \(self.displaytime.text!). Please wait momentarily while the transaction is sent to the Cloud.")
                                                self.cf.delay(1){
                                                    self.Transaction(fuelQuantity: self.fuelquantity)
                                                    print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                                    if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                                    else{
                                                      //  self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                                    }
                                                }
                                                self.cf.delay(10){
                                                    if (self.stopdelaytime == true){}
                                                    else{
                                                    Vehicaldetails.sharedInstance.gohome = true
                                                    self.timerview.invalidate()
                                                    let appDel = UIApplication.shared.delegate! as! AppDelegate

                                                    appDel.start()
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                //self.showAlert("your transaction is not proceed you fuel quantity is 0 please try agian")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    func stoprelay(){

        //Fuelanother.hidden = false
        //    beginfuel.hidden = true
        let SSID:String = cf.getSSID()
        print(SSID)
        print(Vehicaldetails.sharedInstance.SSId)
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
            web.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
        }
        if( Vehicaldetails.sharedInstance.SSId == SSID)
        {

            //"Quantity: \(String(format: "%.2f", self.fuelquantity)) \n\n \(self.displaytime.text!) \n\n\n Thank You!")
            // self.setralay0sleep()//web.sleep()

            cf.delay(0.5) {     // takes a Double value for the delay in seconds

                // put the delayed action/function here
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                    _ = self.web.SetHoseNameReplacedFlag()
                }
                if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == true){
                    //self.getuser()
                    Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                }else{}
                self.cf.delay(4){
                    if(self.fuelquantity == nil){}
                    else{
                        if(self.fuelquantity > 0){
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                            self.pulse.text = "\(self.counts!)"
                            self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                            //self.totalquantityinfo.text = "Quantity:\t\t\t\t\(String(format: "%.2f", self.fuelquantity))\n\n Pulse:\t\t\t\t \(self.counts)\n\nThank you for using \nFluidSecure!"
                            self.UsageInfoview.isHidden = false
                            //self.error400("Thank you for fueling. Final quantity is \(String(format: "%.2f", self.fuelquantity)). with pulse count at \(self.displaytime.text!). \n Please wait momentarily while the transaction closes.")

                            self.cf.delay(1){
                                self.Transaction(fuelQuantity: self.fuelquantity)
                                print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                else{
                                   // self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                }
                            }
                            self.cf.delay(10){
                                if (self.stopdelaytime == true){}
                                else{
                                Vehicaldetails.sharedInstance.gohome = true
                                self.timerview.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate

                                appDel.start()
                                }
                            }
                        }
                        else
                        {
                            self.error400(message: "No Quantity received. Transaction ended.")
                        }
                    }
                }
            }
        }
        else {
            cf.delay(0.5) {     // takes a Double value for the delay in seconds

                // put the delayed action/function here
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                    _ = self.web.SetHoseNameReplacedFlag()
                }
                if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == true){
                   // self.getuser()
                    Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
                }else{}
                self.cf.delay(4){
                    if(self.fuelquantity == nil){}
                    else{
                        if(self.fuelquantity > 0){
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                            self.pulse.text = "\(self.counts!)"
                            self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                            // self.totalquantityinfo.text = "Quantity:\t\t\t\t\(String(format: "%.2f", self.fuelquantity))\n\n Pulse:\t\t\t\t \(self.counts)\n\nThank you for using \nFluidSecure!"
                            self.UsageInfoview.isHidden = false

                            // self.error400("Thank you for fueling. Final quantity is \(String(format: "%.2f", self.fuelquantity)). with pulse count at \(self.displaytime.text!). \n Please wait momentarily while the transaction closes.")

                            self.cf.delay(1){
                                self.Transaction(fuelQuantity: self.fuelquantity)
                                print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                else{
                                    //self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                }
                            }
                            self.cf.delay(10){
                                if (self.stopdelaytime == true){}
                                else{
                                Vehicaldetails.sharedInstance.gohome = true
                                self.timerview.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate

                                appDel.start()
                                }
                            }
                        }
                        else
                        {
                            self.error400(message: "No Quantity received. Transaction ended.")
                        }
                    }
                }
            }
        }
    }

    func BusyStatuschange(){

        let siteid = Vehicaldetails.sharedInstance.siteID

        let bodyData = "{\"SiteId\":\(siteid)\"}" // + /lat:"\(sourcelat)",long:"\(sourcelong)"

        _ = web.ChangeBusyStatus(bodyData: bodyData)

    }

    func Transaction(fuelQuantity:Double)
    {

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        currentlocation = locationManager.location

        if(currentlocation == nil)
        {


        }
        else {
            sourcelat = Vehicaldetails.sharedInstance.Lat//currentlocation.coordinate.latitude
            sourcelong = Vehicaldetails.sharedInstance.Long//currentlocation.coordinate.longitude
            print (sourcelat,sourcelong)
        }
        let siteid = Vehicaldetails.sharedInstance.siteID
      //  let VehicleId = Vehicaldetails.sharedInstance.VehicleId
        let FuelTypeId = Vehicaldetails.sharedInstance.FuelTypeId
       // let PersonId = "0"//Vehicaldetails.sharedInstance.PersonId
       // let PhoneNumber = Vehicaldetails.sharedInstance.PhoneNumber
        let Odomtr = Vehicaldetails.sharedInstance.Odometerno
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
         let pusercount = Vehicaldetails.sharedInstance.pulsarCount
//        let deptno = Vehicaldetails.sharedInstance.deptno
//        let PPinno = Vehicaldetails.sharedInstance.Personalpinno
//        let other = Vehicaldetails.sharedInstance.Other
//        let hour = Vehicaldetails.sharedInstance.hours
        let TransactionId = "\(Vehicaldetails.sharedInstance.TransactionId)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
        let dtt: String = dateFormatter.string(from: NSDate() as Date)

        print(Wifyssid)
        print(Odomtr)
        //let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"TransactionFrom\":\"I\"}"

            let bodyData = "{\"SiteId\":\(siteid),\"CurrentOdometer\":\(Odomtr),\"FuelQuantity\":\((fuelQuantity)),\"TransactionId\":\(TransactionId),\"FuelTypeId\":\(FuelTypeId),\"WifiSSId\":\"\(Wifyssid)\",\"TransactionDate\":\"\(dtt)\",\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"VehicleNumber\":\"\(Vehicaldetails.sharedInstance.vehicleno)\",\"CurrentLat\":\"\(sourcelat!)\",\"CurrentLng\":\"\(sourcelong!)\",\"versionno\":\"1.15.10\"}"
print(bodyData)
        //  SiteId,PersonId,CurrentOdometer,FuelQuantity,FuelTypeId,WifiSSId,TransactionDate,TransactionFrom,CurrentLat,CurrentLng,VehicleNumber,TransactionId

        //"{\"PersonId\":\(PersonId),\"SiteId\":\(siteid),\"VehicleId\":\(VehicleId),\"CurrentOdometer\":\(Odomtr),\"FuelQuantity\":\((fuelQuantity)),\"DepartmentNumber\":\"\(deptno)\",\"Other\":\"\(other)\",\"PersonnelPIN\":\"\(PPinno)\",\"FuelTypeId\":\(FuelTypeId),\"WifiSSId\":\"\(Wifyssid)\",\"PhoneNumber\":\"\(PhoneNumber)\",\"TransactionDate\":\"\(dtt)\",\"TransactionFrom\":\"I\",\"Hours\":\"\(hour)\",\"VehicleNumber\":\"\(Vehicaldetails.sharedInstance.vehicleno)\",\"CurrentLat\":\"\(sourcelat)\",\"CurrentLng\":\"\(sourcelong)\"}"

        let reply = web.Transactiondetails(bodyData: bodyData)
        if (reply == "-1")
        {
            let jsonstring: String = bodyData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            let dtt1: String = dateFormatter.string(from: Date())
           // let unsycnfileName =  dtt1 + "transaction" + "#" + Vehicaldetails.sharedInstance.siteName
              let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.siteName
            cf.preauthSaveTextFile(fileName: unsycnfileName, writeText: jsonstring)
            cf.delay(0.2){
                // self.showAlert("Your Transaction is successfully completed.")
            }
        }

        else{

            let data1:Data = reply.data(using: String.Encoding.utf8)!
            do{
               sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)
            let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            //showAlert(message: "\(ResponceText)")
            self.notify(site: Vehicaldetails.sharedInstance.SSId)
            cf.delay(0.2){
                //self.showAlert("Your Transaction is successfully completed.")
            }
        }
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "TransactionID",in: managedObjectContext)
        let ID = TransactionID(entity: entityDescription!, insertInto: managedObjectContext)
        //results = cf.fetchdata("Certificates", attribute: "account_certificateid", id: account_certificateid)
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TransactionID")
        fetchRequest.returnsObjectsAsFaults = false
        let resultPredicate2 = NSPredicate (format:"(transactionid == %@)",TransactionId)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate2])
        fetchRequest.predicate = compound
        do{
            results = []
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            print(results)
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }
        Transaction_ID = []
        Transaction_ID = results
        print(results)

        if (results == [])
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
            request.returnsObjectsAsFaults = false
            ID.isactive = "false"
            ID.transactionid = TransactionId as String

            do{
                try managedObjectContext.save()
            }catch let error as NSError {
                print ("Error: \(error.domain)")

            }
        }
        else {
//            ID.isactive = "true"
//            ID.transactionid = TransactionId as String

            let count = Transaction_ID.count
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "transactionID")
            request.returnsObjectsAsFaults = false

            for i in 0  ..< count
            {
                let certificate = self.Transaction_ID[i]
                certificate.setValue( "true" as String, forKey: "isactive")
                certificate.setValue( TransactionId as String, forKey: "transactionid")

                do{
                     try managedObjectContext.save()

                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }

                let Transactioniddeatils = Transaction_id(isactive: "true",TransactionID: TransactionId as String)
                Vehicaldetails.sharedInstance.Transaction_id.add(Transactioniddeatils)
            }
        }
    }

    func notify(site:String) {

        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "open"
        localNotification.alertBody = "Your Transaction is Successfully Completed at \(site)."
        localNotification.fireDate = Date(timeIntervalSinceNow: 1)
        localNotification.soundName = "button-24.mp3"//UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }

    @IBAction func Stop(sender: AnyObject) {
        //record = []
        let label1 = UILabel(frame: CGRect(x: 40, y: 80, width: 500, height: 21))
        y = y + 20
        label1.center = CGPoint(x: 80,y: y)
        label1.textAlignment = NSTextAlignment.center
        label1.textColor = UIColor.white
        label1.text = "Output: \(string)"

        stopButtontapped()
    }


    @IBAction func thankyouButtontapped(sender: AnyObject) {

        Vehicaldetails.sharedInstance.buttonset = true

    }

    func unsyncTransaction() -> String
    {
        if(stopbutton == true){
            s1 = string
            print(s1)

            // print("\(Vehicaldetails.sharedInstance.reachblevia)")
            if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
            {
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
//                        let Filename = Split[0] as! String
                        let siteName = Split[1]

                        let JData: String = cf.preauthReadReportFile(fileName: filename)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:siteName,name:"TransactionComplete")
                            return "true"
                        }
                    }
                }
            }

            else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
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

                        let siteName = Split[1]

                        let JData: String = cf.preauthReadReportFile(fileName: filename)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:siteName,name:"TransactionComplete")
                        }
                    }
                }
            }
            stopbutton = false
        }
        return "False"
    }


    func preauthunsyncTransaction() -> String
    {
//        if(stopbutton == true){
//            s1 = string
//            print(s1)

            // print("\(Vehicaldetails.sharedInstance.reachblevia)")
            if (Vehicaldetails.sharedInstance.reachblevia == "cellular")
            {
                var reportsArray: [AnyObject]!
                let fileManager: FileManager = FileManager()
                let readdata = cf.getDocumentsURL().appendingPathComponent("data/preauth/")
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
                        //let Filename = Split[0] as! String
                        let siteName = Split[1]

                        let JData: String = cf.preauthReadReportFile(fileName: filename)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:siteName,name:"SavePreAuthTransactions")
                            return "true"
                        }
                    }
                }
            }

            else if(Vehicaldetails.sharedInstance.reachblevia == "wificonn")
            {
                var reportsArray: [AnyObject]!
                let fileManager: FileManager = FileManager()
                let readdata = cf.getDocumentsURL().appendingPathComponent("data/preauth/")
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

                        let siteName = Split[1]

                        let JData: String = cf.preauthReadReportFile(fileName: filename)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:siteName,name:"SavePreAuthTransactions")
                        }
                    }
                }
            }
//            stopbutton = false
//        }
        return "False"
    }

    @IBAction func Fuelhistory(sender: AnyObject) {


    }


    func Upload(jsonstring: String,filename:String,siteName:String,name:String)
    {

        let Email = defaults.string(forKey: "address")

        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL
        let string = uuid! + ":" + Email! + ":" + name
        let Base64 = cf.convertStringToBase64(string)
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
               // "\(self.reply)"
                let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                do{
                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                print(self.sysdata1)

                let ResponceMessage = self.sysdata1.value(forKey: "ResponceMessage") as! NSString
                //self.notify(siteName)
              //  let TransactionId = Vehicaldetails.sharedInstance.TransactionId
               // self.web.UpgradeTransactionStatus(Status: "2")
                if(ResponceMessage == "success"){
                self.cf.preauthDeleteReportTextFile(fileName: filename, writeText: "")
                }
            } else {
                print(error!)
                self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
         _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }


    @IBAction func beginFueling(sender: AnyObject) {


    }

    func btnBeginFueling() {

        status = ""
        print(status)
        if(status == ""){
            _ = GetPulser()
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GetPulser), userInfo: nil, repeats: true)
            print(timer)
        }

        else{}
    }


    func GetPulser()->String {
        let Url:String = "http://192.168.4.1:80/client?command=pulsar"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
        request.httpMethod = "GET"
        //let reply:String!
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply1 = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply1)

                //"\(self.reply1)"
            } else {
                print(error!)
                self.reply1 = "-1"
            }
            semaphore.signal()
        }

        task.resume()
           _ = semaphore.wait(timeout: DispatchTime.now())
        if(reply1 == nil){}
        else{
            let data1:Data = reply1.data(using: String.Encoding.utf8)!
            do{
                sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            //self.lableview.text! += "\n" + self.reply1!

            if(sysdata1 == nil){}
            else{
                let objUserData = sysdata1.value(forKey: "pulsar_status") as! NSDictionary

                let counts = objUserData.value(forKey: "counts") as! NSString
                let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                let pulsar_secure_status = objUserData.value(forKey: "pulsar_secure_status") as! NSNumber
                if (counts != "0"){

                    let v = quantity.count
                    if(v == 3){
                        if(quantity[v-1] == "0.0" ){

                            print(quantity[v-1])
                        }
                        else{
                            print(quantity[v-1])
                            if(quantity[v-1] == quantity[v-2] && quantity[v-1] == quantity[v-3])
                            {
                                _ = self.setralay0tcp()
                                _ = self.setpulsar0tcp()
                                stoprelay()//stopButtontapped()

                            }
                        }
                    }

                    if(pulsar_status == 0)
                    {
                        timer.invalidate()
                        _ = self.setralay0tcp()
                        _ = self.setpulsar0tcp()
                        _ = calculate_fuelquantity(quantitycount: Int(counts as String)!)
                        stoprelay()
                        //stopButtontapped()
                    }
                }

                let fuelQuan = calculate_fuelquantity(quantitycount: Int(counts as String)!)
                let y = Double(round(100*fuelQuan)/100)

                if(self.tquantity.text == "\(y)"){// + "Gallon"){

                    cf.delay(( Vehicaldetails.sharedInstance.PulserStopTime as NSString).doubleValue){
                        self.timer.invalidate()
                        _ = self.setralay0tcp()
                        _ = self.setpulsar0tcp()
                        self.stoprelay()

                    }
                }

                quantity.append("\(y) ")

                self.tquantity.text = "\(y) "// + "Gallon"

                tpulse.text = (counts as String) as String
                if(pulsar_secure_status == 0){

                }
                else if(pulsar_secure_status == 1)
                {
                    displaytime.text = "5"
                }

                else if(pulsar_secure_status == 2)
                {
                    displaytime.text = "4"
                }

                else if(pulsar_secure_status == 3)
                {
                    displaytime.text = "3"
                }

                else if(pulsar_secure_status == 4)
                {
                    displaytime.text = "2"
                }

                else if(pulsar_secure_status == 5)
                {
                    displaytime.text = "1 \n \n Pulsar disconnected"
                    stopButtontapped()
                }
                
                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                else{
                    
                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(fuelQuan)) {
                        
                        _ = web.SetPulser0()
                        print(Vehicaldetails.sharedInstance.MinLimit)
                        showAlert(message: "You are fuel day limit reached.")
                        //web.recordcheck()
                        stopButtontapped()
                        //stoprelay()
                    }
                }
                // }
            }
            return reply1
        }
        return ""
    }
    
    func resetdata()  {
        
        
        
        NetworkEnable()
        //let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        //  print(s.characters.count)
        let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata :String = string
        if(string == ""){lable.text = "Upgrade Completed."}
        else{
            //            let Split:NSArray = outputdata.componentsSeparatedByString("{")
            //            let reply = Split[0] as! String
            //            let setrelay = Split[1]as! String
            //            let setrelaystatus = Split[2]as! String
            //            outputdata = setrelay + "{" + setrelaystatus
        }
        print( outputdata)
        
        
      }
    
    @IBAction func OKbuttontapped(sender: AnyObject) {
        UsageInfoview.isHidden = true
        self.cf.delay(1){
            Vehicaldetails.sharedInstance.gohome = true
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            
            appDel.start()
            self.stopdelaytime = true
        }
    }
    
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 3 // your number of cell here
    //    }
    //
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        // your cell coding
    //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    //            cell.textLabel!.text = "Quantity: \t\t\t\(String(format: "%.2f", self.fuelquantity))"
    //
    //        return UITableViewCell()
    //    }
    
    func stop(y:Double)
    {
        //var stoptimer:NSTimer
        if(self.tquantity.text == "\(y)"){// + "Gallon"){
            stoptimer = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.PulserStopTime as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopButtontapped), userInfo: nil, repeats: false)
        }
        else
        {
            stoptimer.invalidate()
        }
    }
    
    func btnQuitPressed() {
     _ = web.SetPulser0()
     _ = web.setrelay0()
    }
    
//    func Reset() {
//        NetworkEnable()
//        //let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
//        //  print(s.characters.count)
//        let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//         outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata :String = string
//        if(string == ""){}
//        else{
//            //            let Split:NSArray = outputdata.componentsSeparatedByString("{")
//            //            let reply = Split[0] as! String
//            //            let setrelay = Split[1]as! String
//            //            let setrelaystatus = Split[2]as! String
//            //            outputdata = setrelay + "{" + setrelaystatus
//        }
//        print( outputdata)
//
//    }

//    func upgrade() {
//
//        NetworkEnable()
//        let datastring = "POST /upgrade?command=start HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//         outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata :String = string
//        if(string == ""){}
//        else{
//            print( string)
//        }
//        print(outputdata)
//        //cf.delay(){
//
//        self.uploadbinfile()
//        self.cf.delay(2){
//            self.resetdata()
//
//        }
//
//        // }
//    }

//    func getbinfile() -> NSData
//    {
//
//        let Url:String = Vehicaldetails.sharedInstance.FilePath//"http://103.8.126.241:7854/user1.2048.new.5.bin"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//
//        request.httpMethod = "GET"
//        //request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//        //let bodyData = "\(Name)#:#\(mobile)#:#\(Email)#:#\(uuid)#:#I"
//        //request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
//        request.timeoutInterval = 150
//
//         let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8))
//                print(data)
//                self.replydata = data as NSData//NSString(data: data, encoding:NSUTF8StringEncoding)as! String
//                // print(self.reply)
//                //self.displaytime.text = "Download user1.bin file successfully."
//                //  "\(self.reply)"
//                // print(self.reply.characters.count)
//                self.lable.text = "Download Completed .bin File"
//            } else {
//                print(error)
//                //self.replydata = "-1"
//                //self.displaytime.text = "error to download."
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//      semaphore.wait(timeout: DispatchTime.distantFuture)
//        //print(replydata)
//        return replydata
//        // }
//    }

//    func getuser(){
//        if(Vehicaldetails.sharedInstance.reachblevia == "cellular"){
//            NetworkEnable()
//            //        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
//            //        print(s.characters.count)
//            let datastring = "GET /upgrade?command=getuser HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            let outputdata = string
//            print( outputdata)
//
//            // cf.delay(0.5){
//            // self.bindata = self.getbinfile()
//            lable.text = "Start Downloading .bin File"
//            self.upgrade()
//        }
//    }
    
//    func uploadbinfile(){
//        self.bindata = self.getbinfile()
//        let Url:String = "http://192.168.4.1:80"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//        //let data:NSData = self.bindata
//        print(bindata)//NSData(contentsOfFile: data1)!
//        request.setValue("\(self.bindata.length)", forHTTPHeaderField: "Content-Length")
//        request.httpMethod = "POST"
//        //let bindata = self.getbinfile()
//        request.httpBody = self.bindata as! Data//.dataUsingEncoding(NSUTF8StringEncoding)
//        //
//        ////            self.delay(2){
//        self.lable.text = "Start Upgrade...."
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8))
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)as! String
//                print(self.reply)
//                "\(self.reply)"
//
//            } else {
//                print(error)
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//
//    }

    //Network functions
    func NetworkEnable() {
        
        print("NetworkEnable")
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)

        inStream?.delegate = self
        outStream?.delegate = self

        inStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)

        inStream?.open()
        outStream?.open()

        buffer = [UInt8](repeating: 0, count: 4096)
    }
    
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
        case Stream.Event.endEncountered:
            print("EndEncountered")
            //labelConnection.text = "Connection stopped by server"
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            // start.alpha = 1
        // start.enabled = true
        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
            
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            // labelConnection.text = "Failed to connect to server"
            //start.alpha = 1
            // start.enabled = true
        //displaytime.text = ""
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            status = "HasBytesAvailable"
            if aStream == inStream {
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                
                string += bufferStr! as String
                
                print(bufferStr!)
            }
            break
            
        case Stream.Event.hasSpaceAvailable:
            print("HasSpaceAvailable")
        case Stream.Event():
            print("None")
        case Stream.Event.openCompleted:
            print("OpenCompleted")
        //labelConnection.text = "Connected to server"
        default:
            print("Unknown")
        }
    }


    //    func getinfo() {
    //        cf.delay(1){
    //            let Url:String = "http://192.168.4.1:80/client?command=info"
    //            let request: NSMutableURLRequest = NSMutableURLRequest(URL:NSURL(string: Url)!)
    //            request.HTTPMethod = "GET"
    //
    //            let session = NSURLSession.sharedSession()
    //            let semaphore = dispatch_semaphore_create(0)
    //            let task = session.dataTaskWithRequest(request) { data, response, error in
    //                if let data = data {
    //                    print(String(data: data, encoding: NSUTF8StringEncoding))
    //                    self.reply = NSString(data: data, encoding:NSASCIIStringEncoding)as! String
    //
    //                    print(self.reply)
    //                    "\(self.reply)"
    //                    let data1:NSData = self.reply.dataUsingEncoding(NSUTF8StringEncoding)!
    //                    do{
    //                        self.sysdata = try NSJSONSerialization.JSONObjectWithData(data1, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
    //                        let Version = self.sysdata.valueForKey("Version") as! NSDictionary
    //                        let sdk_version = Version.valueForKey("sdk_version") as! NSString
    //                        let iot_version = Version.valueForKey("iot_version") as! NSString
    //                        let mac_address = Version.valueForKey("mac_address") as! NSString
    //                        print(Vehicaldetails.sharedInstance.FirmwareVersion,iot_version)
    //                        if(Vehicaldetails.sharedInstance.MacAddress == "\(mac_address)"){
    //
    //                        }else {
    //                            //self.web.updateMacAddress(mac_address as String)
    //                        }
    //                        if(Vehicaldetails.sharedInstance.FirmwareVersion == "\(iot_version)"){
    //
    //                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = false
    //                        }
    //                        else if(Vehicaldetails.sharedInstance.FirmwareVersion != "\(iot_version)"){
    //                            Vehicaldetails.sharedInstance.IsFirmwareUpdate = true
    //                        }
    //                    }catch let error as NSError {
    //                        print ("Error: \(error.domain)")
    //                    }
    //
    //                    // print(self.sysdata)
    //
    //                    //return reply
    //                } else {
    //                    print(error)
    //                    self.reply = "-1"
    //                }
    //                dispatch_semaphore_signal(semaphore)
    //            }
    //
    //            task.resume()
    //            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)
    //            //self.binfiledata.text = self.reply
    //        }
    //    }

}

