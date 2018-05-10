//
//  FuelquantityVC.swift
//  FuelSecuer
//
//  Created by VASP on 3/31/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation

class FuelquantityVC: UIViewController,StreamDelegate,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,CLLocationManagerDelegate//,UITableViewDelegate, UITableViewDataSource
{

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)

        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath + ("/filebin"))

        if fileManager.fileExists(atPath: destinationURLForFile.path!){
            showFileWithPath(path: destinationURLForFile.path!)
        }
        else{
            do {
                try fileManager.moveItem(at: location as URL, to: destinationURLForFile as URL)
                // show file
                showFileWithPath(path: destinationURLForFile.path!)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }

    @IBOutlet var Pwait: UILabel!
    @IBOutlet var waitactivity: UIActivityIndicatorView!
    @IBOutlet var lable: UILabel!
    @IBOutlet var tpulse: UILabel!
    @IBOutlet var tquantity: UILabel!
    @IBOutlet var wait: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!

    //var downloadTask: URLSessionDownloadTask!
    var reachability = Reachability.self
    var cf = Commanfunction()
    let defaults = UserDefaults.standard
    var web = Webservices()
    var getdatafromsetting = false
    //var readData:String!
    var setrelaydata:String = ""
    //var dataformserver = [String]()
    //var datafromfs = [String]()
    var IsStartbuttontapped : Bool = false
    var string:String = ""
    var status :String = ""
    var tstring:String = ""
    var sysdata:NSDictionary!
    var setrelaysysdata:NSDictionary!
    //var setpulsarsysdata:NSDictionary!
    var sysdata1:NSDictionary!
    var currentSSID:String!
    var s1:String!
    var iswifi :Bool!
    var Fquantity :Double!
     var string_data = ""
    //var startingpoint = [String]()
    var quantity = [String]()
    var counts:String!
    var replySetPulser :String!
    var setpulsardata:String = ""
    var replydata:NSData!
    var bindata:NSData!
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    var timerview:Timer = Timer()
    var stoptimer:Timer = Timer()
    var stoptimergotostart:Timer = Timer()
    var y :CGFloat = CGFloat()
    var beginfuel1 : Bool = false
    var stopbutton :Bool = false
    var record = [String]()
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
    var locationName:NSString!
    var gohome:Bool = false
    var isconect_toFS:String!
    let addr = "192.168.4.1"
    let port = 80
    var showstartbutton:String = ""
    var emptypulsar_count:Int = 0
    var total_count:Int = 0
    var Last_Count:String!
    var ifstartpulsar_status:Int = 0
    var stopdelaytime:Bool = false
    var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()
    var ResponceMessageUpload:String = ""
   
    //Network variables
    var inStream : InputStream?
    var outStream: OutputStream?
    
    //Mark IBOutlets
    //@IBOutlet var fuelquan: UILabel!
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

    var buffer = [UInt8](repeating: 0, count:4096)

    override func viewDidAppear(_ animated: Bool) {
         stoptimergotostart.invalidate()
        self.displaytime.text = "Please wait while your connection is being established With FS link"
        print(string)
        cf.delay(1){
        self.Activity.hidesWhenStopped = true;
        print(self.cf.getSSID())

        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
            let showstart = self.getinfo()
            if(showstart == "true"){

                self.start.isEnabled = true
                self.start.isHidden = false
                self.Pwait.isHidden = true
            }else
                if(showstart == "false"){

                    self.start.isEnabled = false
                    self.start.isHidden = true
                    self.displaytime.text = "Please wait while your connection is being established With FS link"
                      print("return  false  by info command")
                    self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

            }
            if(showstart == "-1")
            {
                print("return  -1  by info command")
                 self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            }
            if(showstart == "")
            {
                print("return \" \"  by info command")
                                 self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            }
                self.timerview.invalidate()
                self.iswifi = true
                if(self.startbutton == "true")
                {
                    print("startbutton")
                }

//            self.stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(Vehicaldetails.sharedInstance.TimeOut)!*60), target: self, selector: #selector(FuelquantityVC.gotostart), userInfo: nil, repeats: false)
//            self.cf.delay(Double(Vehicaldetails.sharedInstance.TimeOut)!*60){
//                if(self.IsStartbuttontapped == false){
//
//                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                    self.web.sentlog(func_name: "Fuiling_sceen_timeout")
//                    appDel.start()
//                    print("hi")
//                }
//                else if(self.IsStartbuttontapped == true)
//                {
//
//
//                }
//            }
        self.displaytime.text = "Please insert the nozzle into the tank \n Then tap start"

        } else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        {
            self.timerview.invalidate()
            self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
        }
      }
    }
    override func viewWillAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        start.isEnabled = false
        start.isHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//UIColor.blueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // self.navigationItem.title = "FluidSecure"
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"

        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func viewDidLoad() {
         stoptimergotostart.invalidate()
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        wait.isHidden = true
        waitactivity.isHidden = true
        UsageInfoview.isHidden = true
        Pwait.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentlocation = locationManager.location
        Vehicaldetails.sharedInstance.gohome = false
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle("Return", for: UIControlState())
        doneButton.addTarget(self, action: #selector(FuelquantityVC.tapAction), for: UIControlEvents.touchUpInside); doneButton.backgroundColor = UIColor .black
        
        FQ.isHidden = false
        Stop.isHidden = true
       // start.isHidden = false
        cancel.isHidden = false
        getdatafromsetting = true
        start.isEnabled = false
        start.isHidden = true
        if(!timerview.isValid) {}
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
//        let strDate = dateFormatter.stringFromDate(NSDate())
        Odometer.text = "\(Vehicaldetails.sharedInstance.Odometerno)"
        vehicleno.text = "\(Vehicaldetails.sharedInstance.vehicleno)"

    }

func gotostart(){
    if(IsStartbuttontapped == false){
        self.cf.delay(0.5){
            _ = self.setralay0tcp()
            self.cf.delay(0.5){
                _ = self.setpulsar0tcp()
            }
    }
                let appDel = UIApplication.shared.delegate! as! AppDelegate
        self.web.sentlog(func_name: "Gotostart")
                        appDel.start()
                        print("hi")
                    }
                    else if(IsStartbuttontapped == true)
                    {


                    }

}

    func tapAction() {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.endEditing(true)
    }


    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
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



    func getinfo() -> String {
        //cf.delay(1){
            let Url:String = "http://192.168.4.1:80/client?command=info"
            let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
            request.httpMethod = "GET"
        request.timeoutInterval = 6
           // self.isconect_toFS = "false";
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
                        self.showstartbutton = "true"
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
                        self.isconect_toFS = "false"
                        if(self.isconect_toFS == "true"){
                            //self.start.isEnabled = true
                            self.showstartbutton = "false"


                        }else
                            if(self.isconect_toFS == "false"){
                                //self.start.isEnabled = false
                                self.showstartbutton = "false"

                        }
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
      //  }

         return showstartbutton//isconect_toFS;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setralaytcp()->String{
        NetworkEnable()

        let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
        print(s.count)
        let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"

        let data = datastring.data(using: String.Encoding.utf8)!
       // outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)

            self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        //Thread.sleep(forTimeInterval: 4)
            var outputdata :String = self.string
        Thread.sleep(forTimeInterval:1)
        print(outputdata)

            if(self.string == ""){}
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
        Thread.sleep(forTimeInterval:1)
        let outputdata = string
        return outputdata
    }

    func setSamplingtime()->String{

        NetworkEnable()
        
        let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(Vehicaldetails.sharedInstance.PulserTimingAdjust)!)}}"
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
//        let data : NSData = datastring.dataUsingEncoding(NSUTF8StringEncoding)!
//        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        let data : Data = datastring.data(using: String.Encoding.utf8)!

            self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)

        let outputdata = string
        return outputdata
    }

    func setpulsar0tcp()->String{
        NetworkEnable()
        let s:String = "{\"final_pulsar_request\":{\"time\":10}}"
        print(s.count)
        let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 36\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_request\":{\"counter_set\":0}}"
//        let data : NSData = datastring.dataUsingEncoding(NSUTF8StringEncoding)!
//        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        return outputdata
    }

//    func Getpulasrtcp() ->String{
//        NetworkEnable()
//        let datastring = "Get /config?command=Pulsar HTTP/1.1\r\n"
////        let data : NSData = datastring.dataUsingEncoding(NSUTF8StringEncoding)!
////        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata = string
//        return outputdata
//    }

//    func Getrecordchecktcp()->String {
//        NetworkEnable()
//        //        let s:String = "record10" //http://192.168.4.1:80/client?command=record10
//        //        print(s.count)
//        let datastring = "Get /client?command=record10" //HTTP/1.0\r\n"
//        let data : Data = datastring.data(using: String.Encoding.utf8)!
//        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        let outputdata = string
//        print(outputdata)
//        return outputdata
//    }
//

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

    func pulsarlastquantity(){
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
        //dispatch_semaphore_wait(semaphore, dispatch_time_t(DispatchTime.now()))
    }

    func getlastTrans_ID() -> String{
        let Url:String = "http://192.168.4.1:80/client?command=lasttxtnid"//"http://192.168.4.1:80/client?command=pulsar"//
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
        request.httpMethod = "GET"

       // let session = URLSession.sharedSession()
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
                print("Response: \(String(describing: response))")
            } else {
                    self.reply = "-1"
            }
            semaphore.signal()
        }

        task.resume()
//        dispatch_semaphore_wait(semaphore, dispatch_time_t(DispatchTime.distantFuture))
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
        print(Vehicaldetails.sharedInstance.PulserStopTime)
    }


    func settransaction_IDtoFS(){
        let count:Int = "\(Vehicaldetails.sharedInstance.TransactionId)".count
        var format = "0000000000"
        //let range = format.endIndex.advancedBy(-count)..<format.endIndex
         let range = format.index(format.endIndex, offsetBy: -count)..<format.endIndex
        format.removeSubrange(range)
        //format.removeRange(range)
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

    func savetrans(lastpulsarcount:String,lasttransID:String){
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        let fuelquantity = (Double(lastpulsarcount))!/(PulseRatio as NSString).doubleValue
        if(fuelquantity == 0.0 || lasttransID == "-1"){}
        else{
            let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"Pulses\":\"\(lastpulsarcount)\",\"TransactionFrom\":\"I\",\"versionno\":\"1.15.13\"}"
        //let jsonstring: String = bodyData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
        let unsycnfileName =  dtt1 + "transaction" + "#" + "lasttransID" + "#" + Vehicaldetails.sharedInstance.siteName
            if(bodyData != ""){
            cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
            }
        }
    }


    @IBAction func startButtontapped(sender: AnyObject) {

        //Start the fueling with buttontapped
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        start.isEnabled = false
        IsStartbuttontapped = true
        stoptimergotostart.invalidate()
        self.timerview.invalidate()

        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.timerview.invalidate()
                self.showAlertSetting(message: "Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            }
            else {
                let defaultTimeZoneStr1 = formatter.string(from: Date());
                print("before get relay" + defaultTimeZoneStr1)
                           self.reply = self.web.getrelay()   ///get realy status to check link is busy or not

                            print(self.reply)
                    if(self.reply == "-1"){
                         self.showAlertSetting(message: "Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                    }else{
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
                                let defaultTimeZoneStr1 = formatter.string(from: Date());
                                print("after get relay" + defaultTimeZoneStr1)
                                if(relayStatus == 0){


                self.Pwait.text = "Please wait ... "   //1-2sec
                self.Pwait.isHidden = false
                self.start.isHidden = true
                self.cancel.isHidden = true   /// hide the cancel Button.

        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
        {
            self.timerview.invalidate()
            self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

        }else {
            let defaultTimeZoneStr = formatter.string(from: Date());
            print("before setpulsaroffTime" + defaultTimeZoneStr)
      // self.cf.delay(0.5){

            self.setpulsaroffTime()   /// set pulsar off time to FS link

        let defaultTimeZoneStr1 = formatter.string(from: Date());
        print("after setpulsaroffTime" + defaultTimeZoneStr1)

            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.timerview.invalidate()
                self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

            }else {
                let defaultTimeZoneStr1 = formatter.string(from: Date());
                print("before setSamplingtime" + defaultTimeZoneStr1)
                 self.cf.delay(0.5){
               let st = self.setSamplingtime()  /// set Sampling time to FS link

                    let defaultTimeZoneStr1 = formatter.string(from: Date());
                    print("after setSamplingtime" + defaultTimeZoneStr1)
                    print(st)

            let defaultTimeZoneStr = formatter.string(from: Date());
            print("before pulsarlastquantity" + defaultTimeZoneStr)
            self.cf.delay(0.5){
                self.start.isHidden = true

            self.pulsarlastquantity()   /// GET last 10 records from FS link
                let defaultTimeZoneStr1 = formatter.string(from: Date());
                print("pulsarlastquantity" + defaultTimeZoneStr1)

                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                _ = self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "1")/////
                let defaultTimeZoneStr = formatter.string(from: Date());
                print("before getlastTrans_ID" + defaultTimeZoneStr)
                self.cf.delay(0.5){

                let lasttransID = self.getlastTrans_ID()   /// Get the previous Transaction ID from FS link.
                let defaultTimeZoneStr1 = formatter.string(from: Date());
                print("getlastTrans_ID" + defaultTimeZoneStr1 ,Vehicaldetails.sharedInstance.FinalQuantitycount)
                if(Vehicaldetails.sharedInstance.FinalQuantitycount == ""){}
                else{
                    self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                }

                    if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                    {
                        self.timerview.invalidate()
                        self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                    } else {
                        let defaultTimeZoneStr = formatter.string(from: Date());
                        print("before settransaction_IDtoFS" + defaultTimeZoneStr)
                        self.cf.delay(0.5){

                    self.settransaction_IDtoFS()   ///Set the Current Transaction ID to FS link.
                    let defaultTimeZoneStr1 = formatter.string(from: Date());
                    print("settransaction_IDtoFS" + defaultTimeZoneStr1)

                    self.beginfuel1 = false
                    self.displaytime.text = "Fueling…"  //3-4sec
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
                else
                {
                    self.showAlertSetting(message: "Please check your wifi connection")
                }
            }

            self.Activity.isHidden = true
            self.Activity.stopAnimating()


                    self.string = ""
                    self.inStream?.close()
                    self.outStream?.close()
                    self.cf.delay(0.5){
                        let defaultTimeZoneStr2 = formatter.string(from: Date());
                        print("before setpulsartcp" + defaultTimeZoneStr2)
                    var setpulsar = self.setpulsartcp()
                        let defaultTimeZoneStr3 = formatter.string(from: Date());
                        print("Pulsar on0" + defaultTimeZoneStr3)
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
                                self.ifstartpulsar_status = Int(pulsar_status)
//                                if (self.counts != "0"){
//                                if(pulsar_status == 0)
//                                {
//                                    self.stopButtontapped()
//                                }
//                            }

                        print(setpulsar)

                     if(pulsar_status == 1)
                        {
                            let defaultTimeZoneStr1 = formatter.string(from: Date());
                            print("before Relay on0" + defaultTimeZoneStr1)
                            var setrelayd = self.setralaytcp()
                            let defaultTimeZoneStr = formatter.string(from: Date());
                            print("Relay on0" + defaultTimeZoneStr)
//                            print(setrelayd)
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
                            self.Stop.isHidden = false  ///show stop button 7-8sec
                            self.string = ""

                            self.btnBeginFueling()
                            let defaultTimeZoneStr = formatter.string(from: Date());
                            print("Get Pulsar" + defaultTimeZoneStr)
                                    self.displaytime.text = ""
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
                    //    }
                  //  }

                }}
            }
       //*** //self.string = ""
            }
                                        }}
            }}//}
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
                    }}//}

      //  }
     //   }

    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {

        let alert = UIAlertController(title: "Confirm", message: NSLocalizedString("Are you sure you want to Cancel? Please wait while getting redirected to select hose page.", comment:""), preferredStyle: UIAlertControllerStyle.alert)
        let backView = alert.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: "Are you sure you want to Cancel? Please wait while getting redirected to select hose page." as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:"Are you sure you want to Cancel? Please wait while getting redirected to select hose page.".count))
        alert.setValue(messageMutableString, forKey: "attributedMessage")

        let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.default) { action in
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            // Call a method on the CustomController property of the AppDelegate
              self.cf.delay(1.5) {     // takes a Double value for the delay in seconds




                if(self.ifstartpulsar_status == 1)
                    {
                        _ = self.setralay0tcp()
                        _ = self.setpulsar0tcp()
                        // put the delayed action/function here
                        self.BusyStatuschange()
                        self.web.sentlog(func_name: "cancelButtonTapped")
                        appDel.start()}
                else if(self.ifstartpulsar_status == 0)
                { _ = self.setralay0tcp()
                    _ = self.setpulsar0tcp()}

                // put the delayed action/function here
                self.BusyStatuschange()
                self.web.sentlog(func_name: "cancelButtonTapped")
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
             self.IsStartbuttontapped = true
            self.stoptimergotostart.invalidate()
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            self.web.sentlog(func_name: "error400 Message")
            appDel.start()
            self.stopdelaytime = true
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
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
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
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")

        // Action.
            let action = UIAlertAction(title: NSLocalizedString("Wifi Settings", comment:""), style: UIAlertActionStyle.default) { action in //self.

            let url = NSURL(string: "App-Prefs:root=WIFI") //for WIFI setting app
            let app = UIApplication.shared// .shared
                app.openURL(url! as URL)
            Vehicaldetails.sharedInstance.gohome = false
            self.resumetimer()
        }
        let home = UIAlertAction(title: NSLocalizedString("Back to Home", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            //self.getdatafromsetting = true

            Vehicaldetails.sharedInstance.gohome = true
            self.IsStartbuttontapped = true
            self.stoptimergotostart.invalidate()
            alertController.view.tintColor = UIColor.green
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate

            appDel.start()
        }

//        let btnsetting = UIImage(named: "Button-Green")!
//        let imageButtonws : UIButton = UIButton(frame: CGRect(x: 140, y: 90, width: 120, height: 40))
//        imageButtonws.setBackgroundImage(btnsetting, for: UIControlState())
//        imageButtonws.setTitle("OK", for: UIControlState.normal)
//        imageButtonws.setTitleColor(UIColor.white, for: UIControlState.normal)
//        imageButtonws.addTarget(self, action: #selector(FuelquantityVC.okaction(sender:)), for:.touchUpInside)
//
//        let btnset = UIImage(named: "Button-White")!
//        let back : UIButton = UIButton(frame: CGRect(x: 10, y: 90, width: 120, height: 40))
//        back.setBackgroundImage(btnset, for: UIControlState())
//        back.setTitle("Back", for: UIControlState.normal)
//        back.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
//        back.addTarget(self, action: #selector(FuelquantityVC.backaction(sender:)), for:.touchUpInside)

        alertController.addAction(action)
        alertController.addAction(home)
        self.present(alertController, animated: true, completion: nil)
    }

    func resumetimer(){
        //viewDidAppear(true)
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
        IsStartbuttontapped = true
        stoptimergotostart.invalidate()
        Vehicaldetails.sharedInstance.gohome = true
       // alertController.view.tintColor = UIColor.greenColor()
        self.timerview.invalidate()
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        self.web.sentlog(func_name: "backaction")
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
            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.timerview.invalidate()
                self.stoprelay()

            }else {
            var setrelayd = self.setralay0tcp()
            self.cf.delay(0.5){

            if(setrelayd == ""){
                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                {
                    self.timerview.invalidate()
                    self.stoprelay()

                }else {
                setrelayd = self.setralay0tcp()
                }
            }

            if(setrelayd == ""){
                self.cf.delay(0.5){
                    if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                    {
                        self.timerview.invalidate()
                        self.stoprelay()

                    }else {
                    _ = self.setralay0tcp()

                    _ = self.setpulsar0tcp()

                    self.error400(message: "Please check your FS unit, and switch off power and back on.")
                    self.stoprelay()
                    }
                    }
            }
            else{

            let Split = setrelayd.components(separatedBy: "{")
                if(Split.count < 3){
                        _ = self.setralay0tcp()
                            _ = self.setpulsar0tcp()
                            self.stoprelay()

                    }
            else {

                    let reply = Split[1]
                    let setrelay = Split[2]
                    let Split1 = setrelay.components(separatedBy: "}")
                    let setrelay1 = Split1[0]
                    let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
                    let data1 = outputdata.data(using: String.Encoding.utf8)!
                    do{
                        self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                      }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                    }
                    print(self.sysdata1,"relay_response")
                    let objUserData = self.sysdata1.value(forKey: "relay_response") as! NSDictionary
                    let status = objUserData.value(forKey: "status") as! NSNumber
                    print(setrelayd)

//                if(status == 0) {
                        self.string = ""
                        self.cf.delay(0.5){
                            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.timerview.invalidate()
                                self.stoprelay()
                              //  self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                            }else {
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

                             _ = self.setpulsar0tcp()
                            self.stoprelay()
                        }
                        else{
                            let reply = Split[1]
                            let setrelay = Split[2]
            let Split1 = setrelay.components(separatedBy: "}")
            let setrelay1 = Split1[0]
            let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
            let data1 = outputdata.data(using: String.Encoding.utf8)!
            do{
                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(self.sysdata1,"pulsar_status")
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
               // self.beginfuel.hidden = true
                let SSID:String = self.cf.getSSID()
                print(SSID)
                print(Vehicaldetails.sharedInstance.SSId)
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                    self.web.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
                }
                _ = self.setpulsar0tcp()
                if( Vehicaldetails.sharedInstance.SSId == SSID  || "FUELSECURE" == SSID)
                {

                    self.cf.delay(0.5) {     // takes a Double value for the delay in seconds

                        // put the delayed action/function here
                        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                            _ = self.web.SetHoseNameReplacedFlag()
                        }
                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){

                            self.getuser()
//                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
                        }else{}
                        self.cf.delay(1){
                        if(self.fuelquantity > 0){
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                            self.pulse.text = "\(self.counts!)"
                            print(self.counts)
                            self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
//                            self.quantityT.text = String(format: "%.2f", self.fuelquantity)
//                            self.pulseT.text = "\(self.counts)"
                            self.UsageInfoview.isHidden = false
                            // self.error400("Thank you for fueling. Final quantity is \(String(format: "%.2f", self.fuelquantity)). \n \(self.displaytime.text!). Please wait momentarily while the transaction is sent to the Cloud.")
                            self.cf.delay(1){
                                self.Transaction(fuelQuantity: self.fuelquantity)
                                print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                            if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                else if(Vehicaldetails.sharedInstance.FS_MacAddress != Vehicaldetails.sharedInstance.MacAddress){
                               // self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                }
                            }
                            self.cf.delay(10){
                                if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                                {
                                    _ = self.web.getinfo()
                                    if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                    _ = self.web.UpgradeCurrentVersiontoserver()
                                   }
                                    Vehicaldetails.sharedInstance.IsUpgrade = "N"
                                    self.cf.delay(30){
                                        Vehicaldetails.sharedInstance.gohome = true
                                        self.timerview.invalidate()
                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                        self.web.sentlog(func_name: "stopButtontapped 30 delay")
                                        appDel.start()
                                    }
                                }
                                if (self.stopdelaytime == true){}
                                else{
                                Vehicaldetails.sharedInstance.gohome = true
                                self.timerview.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                self.web.sentlog(func_name: "stopButtontapped")
                                appDel.start()
                                }
                            }
                        }
                        else
                        {
                            self.showAlert(message: "Quantity is zero. Transaction is stopped")
                        }
                        }
                    }
                }
                        }
                    }
                    }}
        //    }
//            else
//            {
//                self.cf.delay(1){
//                self.GetPulser()
//                self.FQ.isHidden = false
//                self.stopbutton = true
//               // self.thankyoubtn.hidden = true
//                self.CQ.isHidden = true
//                self.Stop.isHidden = true
//                self.timer.invalidate()
//
//                print(self.string)
//                //self.Fuelanother.hidden = false
//              //  self.beginfuel.hidden = true
//                let SSID:String = self.cf.getSSID()
//                print(SSID)
//                print(Vehicaldetails.sharedInstance.SSId)
//                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
//                    self.web.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
//                }
//                if( Vehicaldetails.sharedInstance.SSId == SSID)
//                {
//                    self.cf.delay(0.1) {
//                        // takes a Double value for the delay in seconds
//                        // put the delayed action/function here
//                        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
//                            _ = self.web.SetHoseNameReplacedFlag()
//                        }
//
//                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
//                            self.getuser()
////                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
//                        }else{}
//                         self.cf.delay(4){
//                        if(self.fuelquantity > 0){
//                            self.wait.isHidden = true
//                            self.waitactivity.isHidden = true
//                            self.waitactivity.stopAnimating()
//                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
//                            self.pulse.text = "\(self.counts!)"
//                              print(self.counts)
//                            self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
//                           // self.totalquantityinfo.text = "Quantity:\t\t\t\t\(String(format: "%.2f", self.fuelquantity))\n\n Pulse:\t\t\t\t \(self.counts)\n\nThank you for using \nFluidSecure!"
//                            self.UsageInfoview.isHidden = false
//                            // self.error400("Thank you for fueling. Final quantity is \(String(format: "%.2f", self.fuelquantity)). \n \(self.displaytime.text!). Please wait momentarily while the transaction is sent to the Cloud.")
//                            self.cf.delay(1){
//                                self.Transaction(fuelQuantity: self.fuelquantity)
//                                 print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
//                                if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
//                                else{
//                                   // self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
//                                }
//                            }
//                            self.cf.delay(10){
//                                if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
//                                {
//                                    _ = self.web.getinfo()
//                                    if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
//                                        _ = self.web.UpgradeCurrentVersiontoserver()
//                                    }
//
//                                    Vehicaldetails.sharedInstance.IsUpgrade = "N"
//
//                                    self.cf.delay(30){
//                                        Vehicaldetails.sharedInstance.gohome = true
//                                        self.timerview.invalidate()
//                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                        self.web.sentlog(func_name: "stopButtontapped 30 delay")
//                                        appDel.start()
//                                    }
//                                }
//                                Vehicaldetails.sharedInstance.gohome = true
//                                self.timerview.invalidate()
//                                let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                self.web.sentlog(func_name: "stopButtontapped")
//                                appDel.start()
//                            }
//                        }
//                        else
//                        {
//                            //self.showAlert("Quantity is zero. Transaction is eliminated")
//                        }
//                        }
//                    }
//                }
//                        }
//
//                       }
                    }
                }
            }
            }}
    }

    
    func stoprelay(){

        //Fuelanother.hidden = false
                                //    beginfuel.hidden = true
        self.timer.invalidate()
        timer_noConnection_withlink.invalidate()
        timer_quantityless_thanprevious.invalidate()
                    let SSID:String = cf.getSSID()
                    print(SSID)
                    print(Vehicaldetails.sharedInstance.SSId)
                    if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                        web.changessidname(wifissid: Vehicaldetails.sharedInstance.SSId)
                    }
                    if( Vehicaldetails.sharedInstance.SSId == SSID)
                    {

                        cf.delay(0.5) {     // takes a Double value for the delay in seconds
        
                            // put the delayed action/function here
                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                _ = self.web.SetHoseNameReplacedFlag()
                            }
                            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                                self.getuser()
                             }else{}
                            self.cf.delay(4){
                            if(self.fuelquantity == nil){
//                                self.cf.delay(10){
//                                    Vehicaldetails.sharedInstance.gohome = true
//                                    self.timerview.invalidate()
//                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                    self.web.sentlog(func_name: "stoprelay function")
//                                    appDel.start()
//                                }
                                self.error400(message: "No Quantity received. Transaction ended.")
                            }
                            else{
                            if(self.fuelquantity > 0){
                                self.wait.isHidden = true
                                self.waitactivity.isHidden = true
                                self.waitactivity.stopAnimating()
                                self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                self.pulse.text = "\(self.counts!)"
                                  print(self.counts)
                                self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                                //self.totalquantityinfo.text = "Quantity:\t\t\t\t\(String(format: "%.2f", self.fuelquantity))\n\n Pulse:\t\t\t\t \(self.counts)\n\nThank you for using \nFluidSecure!"
                                self.UsageInfoview.isHidden = false
                                //self.error400("Thank you for fueling. Final quantity is \(String(format: "%.2f", self.fuelquantity)). with pulse count at \(self.displaytime.text!). \n Please wait momentarily while the transaction closes.")

                                self.cf.delay(1){
                                    self.Transaction(fuelQuantity: self.fuelquantity)
                                     print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                    if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                    else{
                                      //  self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                    }
                                }
                                    self.cf.delay(10){
                                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                                        {
                                            _ = self.web.getinfo()
                                            if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                                _ = self.web.UpgradeCurrentVersiontoserver()
                                            }
                                            Vehicaldetails.sharedInstance.IsUpgrade = "N"

                                            self.cf.delay(30){
                                                Vehicaldetails.sharedInstance.gohome = true
                                                self.timerview.invalidate()
                                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                self.web.sentlog(func_name: "stoprelay function 30 delay")
                                                appDel.start()
                                            }
                                        }
                                        if (self.stopdelaytime == true){}
                                        else{
                                    Vehicaldetails.sharedInstance.gohome = true
                                    self.timerview.invalidate()
                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                                         self.web.sentlog(func_name: "stoprelay function")
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
                            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                                self.getuser()
                            }else{}
                            self.cf.delay(4){
                            if(self.fuelquantity == nil){
//                                self.cf.delay(10){
//                                    Vehicaldetails.sharedInstance.gohome = true
//                                    self.timerview.invalidate()
//                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                    self.web.sentlog(func_name: "stoprelay function")
//                                    appDel.start()
//                                }
                                self.error400(message: "No Quantity received. Transaction ended.")
                            }
                            else{
                                if(self.fuelquantity > 0){
                                        self.wait.isHidden = true
                                        self.waitactivity.isHidden = true
                                        self.waitactivity.stopAnimating()
                                        self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                        self.pulse.text = "\(self.Last_Count!)"
                                        print(self.Last_Count)
                                        self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                                        self.UsageInfoview.isHidden = false
                                        self.cf.delay(1){
                                        self.Transaction(fuelQuantity: self.fuelquantity)
                                         print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                        if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                        else{
                                          //  self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                        }
                                    }
                                    self.cf.delay(10){
                                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                                        {
                                            _ = self.web.getinfo()
                                            if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                                _ = self.web.UpgradeCurrentVersiontoserver()
                                            }
                                            Vehicaldetails.sharedInstance.IsUpgrade = "N"

                                            self.cf.delay(30){
                                                Vehicaldetails.sharedInstance.gohome = true
                                                self.timerview.invalidate()
                                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                self.web.sentlog(func_name: "stoprelay function")
                                                appDel.start()
                                            }
                                        }

                                        if (self.stopdelaytime == true){}
                                        else{
                                        Vehicaldetails.sharedInstance.gohome = true
                                        self.timerview.invalidate()
                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                        self.web.sentlog(func_name: "stoprelay function")
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
        {}
        else {
                sourcelat = Vehicaldetails.sharedInstance.Lat//currentlocation.coordinate.latitude
                sourcelong = Vehicaldetails.sharedInstance.Long//currentlocation.coordinate.longitude
                print (sourcelat,sourcelong)
             }

        let Odomtr = Vehicaldetails.sharedInstance.Odometerno
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount = Vehicaldetails.sharedInstance.pulsarCount

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        //let dtt: String = Vehicaldetails.sharedInstance.date//dateFormatter.stringFromDate(NSDate())

        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"1.15.13\"}"

        //"{\"PersonId\":\(PersonId),\"SiteId\":\(siteid),\"VehicleId\":\(VehicleId),\"CurrentOdometer\":\(Odomtr),\"FuelQuantity\":\((fuelQuantity)),\"DepartmentNumber\":\"\(deptno)\",\"Other\":\"\(other)\",\"PersonnelPIN\":\"\(PPinno)\",\"FuelTypeId\":\(FuelTypeId),\"WifiSSId\":\"\(Wifyssid)\",\"PhoneNumber\":\"\(PhoneNumber)\",\"TransactionDate\":\"\(dtt)\",\"TransactionFrom\":\"I\",\"Hours\":\"\(hour)\",\"VehicleNumber\":\"\(Vehicaldetails.sharedInstance.vehicleno)\",\"CurrentLat\":\"\(sourcelat)\",\"CurrentLng\":\"\(sourcelong)\"}"

        let reply = web.Transaction_details(bodyData: bodyData)
        if (reply == "-1")
        {
            let jsonstring: String = bodyData
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            //let unsycnfileName =  dtt1 + "transaction" + "#" + Vehicaldetails.sharedInstance.siteName
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.siteName
             if(bodyData != ""){
            cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
            }
            cf.delay(0.2){
           // self.showAlert("Your Transaction is successfully completed.")
            }
        }

        else{

            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)
           // let ResponceText = sysdata.value(forKey: "ResponceText") as! NSString
            //showAlert(message: "\(ResponceText)")
            // self.web.UpgradeTransactionStatus(Status: "2")
            self.notify(site: Vehicaldetails.sharedInstance.SSId)
            cf.delay(0.2){
            //self.showAlert("Your Transaction is successfully completed.")
        }
        }
    }

    func notify(site:String) {

        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "open"
        localNotification.alertBody = "Your Transaction is Successfully Completed at \(site)."
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        localNotification.soundName = "button-24.mp3"//UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }

    @IBAction func Stop(sender: AnyObject) {
        record = []
        let label1 = UILabel(frame: CGRect(x: 40, y: 80, width: 500, height: 21))
        y = y + 20
        label1.center = CGPoint(x: 80,y: y)
        label1.textAlignment = NSTextAlignment.center
        label1.textColor = UIColor.white
        label1.text = "Output: \(string)"

        stopButtontapped()
    }

    func unsyncTransaction() -> String
    {
        if(stopbutton == true){
            s1 = string
            print(s1)

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
                        let siteName = Split[1]
                        let quantity = Split[2]
                        if(quantity == "0" ){
                            web.UpgradeTransactionStatus(Transaction_id:siteName,Status: "1")
                            self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                        }else if(quantity == "" ){
                          //  self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                        }

                        let JData: String = cf.ReadReportFile(fileName: filename)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:siteName)
                            if(ResponceMessageUpload == "success"){
                                self.notify(site: siteName)
                            }

                            return "true"
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
                        let siteName = Split[1]
                        let quantity = Split[2]
                        if(quantity == "0" ){
                            web.UpgradeTransactionStatus(Transaction_id:siteName,Status: "1")
                            self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                        }else if(quantity == "" ){
                             self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                        }
                        else {
                        let JData: String = cf.ReadReportFile(fileName: filename)
                        print(JData)
                        if(JData != "")
                        {
                            Upload(jsonstring: JData,filename: filename,siteName:siteName)
                            if(ResponceMessageUpload == "success"){
                                self.notify(site: siteName)

                            }
                        }
                        }
                        
                    }
                }
            }
            stopbutton = false
        }
        return "False"
    }


    func Upload(jsonstring: String,filename:String,siteName:String)
    {

        let Email = defaults.string(forKey: "address")

        let uuid = defaults.string(forKey: "uuid")
        let Url:String = FSURL

//        if(siteName == "transactionStatus")
//        {
//            string_data = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"
//        }else if(siteName == ""){
            string_data = uuid! + ":" + Email! + ":" + "TransactionComplete"
//        }
        print(string_data)
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
                     self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
                print(self.sysdata)

                _ = self.sysdata.value(forKey: "ResponceText") as! NSString


                //self.web.UpgradeTransactionStatus(Status: "2")
                self.ResponceMessageUpload = (self.sysdata.value(forKey: "ResponceMessage") as! NSString) as String

                if(self.ResponceMessageUpload == "success"){
                   self.cf.DeleteReportTextFile(fileName: filename, writeText: "")
                }


            } else {
                print(error as Any)
                self.reply = "-1"
               //  self.web.UpgradeTransactionStatus(Status: "1")
            }
            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
   }


    func btnBeginFueling() {

//        status = ""
//        print(status)
//        if(status == ""){
         let formatter = DateFormatter();
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        let defaultTimeZoneStr2 = formatter.string(from: Date());
        print("before GetPulser" + defaultTimeZoneStr2)
        self.cf.delay(0.2){
//
            self.GetPulser()
            self.quantity = []



        let defaultTimeZoneStr = formatter.string(from: Date());
        print("Get Pulsar1" + defaultTimeZoneStr)
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
        let defaultTimeZoneStr1 = formatter.string(from: Date());
        print("after GetPulser" + defaultTimeZoneStr1)
            print(self.timer)
             }
//        }
//
//        else{}
    }

    func GetPulser() {
        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
        {
            self.timer.invalidate()
            Stop.isHidden = true
            displaytime.text = "\(Vehicaldetails.sharedInstance.SSId) WiFi Connection lost with mobile."
            cf.delay(0.5) {     // takes a Double value for the delay in seconds
                self.timer.invalidate()
                // put the delayed action/function here
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                    _ = self.web.SetHoseNameReplacedFlag()
                }
//                if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
//                    self.getuser()
//                }else{}
                self.cf.delay(4){
                    if(self.fuelquantity == nil){
//                        self.cf.delay(10){
//                            Vehicaldetails.sharedInstance.gohome = true
//                            self.timerview.invalidate()
//                            let appDel = UIApplication.shared.delegate! as! AppDelegate
//                            self.web.sentlog(func_name: "stoprelay function")
//                            appDel.start()
//                        }
                        self.error400(message: "No Quantity received. Transaction ended.")

                    }
                    else{
                        if(self.fuelquantity > 0){
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                            self.pulse.text = "\(self.Last_Count!)"
                            print(self.counts)
                            self.totalquantityinfo.text = "Thank you for using \nFluidSecure!"
                            self.UsageInfoview.isHidden = false
                            self.cf.delay(1){
                                self.Transaction(fuelQuantity: self.fuelquantity)
                                print(Vehicaldetails.sharedInstance.MacAddress,Vehicaldetails.sharedInstance.FS_MacAddress)
                                if(Vehicaldetails.sharedInstance.FS_MacAddress == Vehicaldetails.sharedInstance.MacAddress){}
                                else{
                                    //  self.web.updateMacAddress(macadd: Vehicaldetails.sharedInstance.FS_MacAddress as String)
                                }
                            }
                            self.cf.delay(10){
                                if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                                {
                                    _ = self.web.getinfo()
                                    if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                        _ = self.web.UpgradeCurrentVersiontoserver()
                                    }
                                    Vehicaldetails.sharedInstance.IsUpgrade = "N"

                                    self.cf.delay(30){
                                        Vehicaldetails.sharedInstance.gohome = true
                                        self.timerview.invalidate()
                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                        self.web.sentlog(func_name: "stoprelay function")
                                        appDel.start()
                                    }
                                }
                                if (self.stopdelaytime == true){}
                                else{
                                Vehicaldetails.sharedInstance.gohome = true
                                self.timerview.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                self.web.sentlog(func_name: "stoprelay function")
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
            self.timerview.invalidate()
//            self.showAlertSetting(message: "Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

        }
        else {
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let defaultTimeZoneStr = dateFormatter.string(from: Date());

            print("before GetPulser" + defaultTimeZoneStr)
            //cf.delay(0.5) {

                let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                print("before send  GetPulser" + defaultTimeZoneStr1)
           reply1 = web.GetPulser()
            print(reply1)
//        let Url:String = "http://192.168.4.1:80/client?command=pulsar"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
//        request.httpMethod = "GET"
//        //let reply:String!
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest){ data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply1 = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                print(self.reply1)
//           } else {
//                print(error!)
//                self.reply1 = "-1"
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//         _ = semaphore.wait(timeout: DispatchTime.now())
        if(self.reply1 == nil || self.reply1 == "-1")
        {
            timer_noConnection_withlink = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
        }
        else{
            timer_noConnection_withlink.invalidate()
                    let data1 = self.reply1.data(using: String.Encoding.utf8)!
            do{
                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }

            if(self.sysdata1 == nil){}
            else{
                        let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                
                let counts = objUserData.value(forKey: "counts") as! NSString
                let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                let pulsar_secure_status = objUserData.value(forKey: "pulsar_secure_status") as! NSNumber

                if (counts == ""){
                    self.emptypulsar_count += 1
                    if(self.emptypulsar_count == 3){
                        Vehicaldetails.sharedInstance.gohome = true
                        self.timerview.invalidate()
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        self.web.sentlog(func_name: "get emptypulsar_count function")
                        appDel.start()
                    }

                } else {
                    self.emptypulsar_count = 0
                if (counts != "0"){
                    print(self.tpulse.text!, counts)
                    if (self.tpulse.text! == (counts as String) as String){

                   }
                    if(Last_Count == nil){
                        Last_Count = "0.0"

                    }
                    if(counts.doubleValue >= (Last_Count as NSString).doubleValue)
                    {
                    timer_quantityless_thanprevious.invalidate()
                    self.Last_Count = counts as String?
                    let v = self.quantity.count
                    let fuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                    let y = Double(round(100*fuelQuan)/100)
                     self.tquantity.text = "\(y)"// + "Gallon"

                    self.tpulse.text = (counts as String) as String
                    self.quantity.append("\(y) ")

                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.PulserStopTime)
                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
                     if(v >= 2){
                        if(self.self.quantity[v-1] == self.quantity[v-2]){// + "Gallon"){
                            self.total_count += 1
                            if(self.total_count == 3){

                                self.cf.delay((Vehicaldetails.sharedInstance.PulserStopTime as NSString).doubleValue){
                            self.timer.invalidate()
                            _ = self.setralay0tcp()
                            _ = self.setpulsar0tcp()
                            self.displaytime.text = "app autostop because pulsecount getting is same."
                            self.Stop.isHidden = true
                            self.stoprelay()
                        }
                    }
                }
                else {
                            self.total_count = 0



                

                if(pulsar_secure_status == 0){
                    
                }
                 else if(pulsar_secure_status == 1)
                {
                    self.displaytime.text = "5"
                }
                    
                else if(pulsar_secure_status == 2)
                {
                    self.displaytime.text = "4"
                }
                    
                else if(pulsar_secure_status == 3)
                {
                    self.displaytime.text = "3"
                }
                    
                else if(pulsar_secure_status == 4)
                {
                    self.displaytime.text = "2"
                }
                    
                else if(pulsar_secure_status == 5)
                {
                    self.displaytime.text = "1 \n \n Pulsar disconnected"
                    self.stopButtontapped()
                }

                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                else{
                    
                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(fuelQuan)){
                        
                        _ = self.web.SetPulser0()
                        print(Vehicaldetails.sharedInstance.MinLimit)
                        self.showAlert(message: "You are fuel day limit reached.")
                        self.stopButtontapped()
                    }
                }
                        }

                        }
                    }
                    else{
                        timer_quantityless_thanprevious.invalidate()
                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
                            print("lower qty. than the prior one.")
                        }
                }
                else{

                    let v = self.quantity.count
                    let fuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                    let y = Double(round(100*fuelQuan)/100)
                    self.tquantity.text = "\(y)"// + "Gallon"

                    self.tpulse.text = (counts as String) as String
                    self.quantity.append("\(y) ")

                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.PulserStopTime)
                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
                    if(v >= 2){
                        if(self.self.quantity[v-1] == self.quantity[v-2]){// + "Gallon"){
                            self.total_count += 1
                            if(self.total_count == 3){
                                self.timer.invalidate()
                                self.cf.delay((Vehicaldetails.sharedInstance.PulserStopTime as NSString).doubleValue){

                                    _ = self.setralay0tcp()
                                    _ = self.setpulsar0tcp()
                                    self.displaytime.text = "app autostop because pulsecount getting is same."
                                    self.Stop.isHidden = true
                                    self.stoprelay()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
            }//}

    }

    func resetdata()  {

        NetworkEnable()
        let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata :String = string
        if(string == ""){lable.text = "Upgrade Completed."}
        else{
        }
        print( outputdata)
    }

    @IBAction func OKbuttontapped(sender: AnyObject) {
        UsageInfoview.isHidden = true
         IsStartbuttontapped = true
        stoptimergotostart.invalidate()
        self.cf.delay(1){
            Vehicaldetails.sharedInstance.gohome = true
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            self.web.sentlog(func_name: "OKbuttontapped")
            appDel.start()
             self.stopdelaytime = true
        }
    }

    func stop(y:Double)
    {
        //var stoptimer:NSTimer
        if(self.tquantity.text == "\(y) "){// + "Gallon"){
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

    func Reset() {
        NetworkEnable()
        let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata :String = string
        if(string == ""){}
        else{

        }
        print( outputdata)
    }

    func upgrade() {

        NetworkEnable()
        let datastring = "POST /upgrade?command=start HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
        let data : Data = datastring.data(using: String.Encoding.utf8)!
        outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata :String = string
        if(string == ""){}
        else{
                print( string)
            }
        print(outputdata)
        self.uploadbinfile()
        self.cf.delay(2){
            self.resetdata()
        }
    }

    func getbinfile() -> NSData
    {

        let Url:String = Vehicaldetails.sharedInstance.FilePath//"http://103.8.126.241:7854/user1.2048.new.5.bin"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)

        request.httpMethod = "GET"
        request.timeoutInterval = 150

        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task =  session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                //print(String(data: data, encoding: String.Encoding.utf8)!)
                print(data)
                self.replydata = data as NSData//NSString(data: data, encoding:NSUTF8StringEncoding)as! String
               // self.lable.text = "Download Completed .bin File"
            } else {
                print(error!)
                //self.replydata = "-1"
                //self.displaytime.text = "error to download."
            }
            semaphore.signal()
        }

        task.resume()
         _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return replydata
    }

    func getuser(){
        if(Vehicaldetails.sharedInstance.reachblevia == "cellular"){
        NetworkEnable()
        let datastring = "GET /upgrade?command=getuser HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
            let data : Data = datastring.data(using: String.Encoding.utf8)!
            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
        let outputdata = string
        print( outputdata)
        //lable.text = "Start Downloading.bin File"
             self.upgrade()
        }
    }

    func uploadbinfile(){
        self.bindata = self.getbinfile()
        let Url:String = "http://192.168.4.1:80"
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
       // let data:NSData = self.bindata
        print(bindata)//NSData(contentsOfFile: data1)!
        request.setValue("\(self.bindata.length)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"

        request.httpBody = (self.bindata! as Data)//.dataUsingEncoding(NSUTF8StringEncoding)

        self.lable.text = "Start Upgrade...."
        let session = Foundation.URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8)!)
                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
                print(self.reply)
           }  else {
                        print(error!)
                        self.reply = "-1"
                    }
                semaphore.signal()
        }
            task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

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
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)

        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
            inStream?.close()
            inStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            outStream?.close()
            outStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)

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

        default:
            print("Unknown")
        }
    }
}

