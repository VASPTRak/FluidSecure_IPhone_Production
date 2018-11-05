//
//  FuelquantityVC.swift
//  FuelSecuer
//
//  Created by VASP on 3/31/16.
//  Copyright © 2016 VASP. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation

public enum Model : String {
    case simulator     = "simulator/sandbox",
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPad5              = "iPad 5",
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPadMini1          = "iPad Mini 1",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadAir1           = "iPad Air 1",
    iPadAir2           = "iPad Air 2",
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro9_7_cell    = "iPad Pro 9.7\" cellular",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro12_9_cell   = "iPad Pro 12.9\" cellular",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro2_12_9_cell = "iPad Pro 2 12.9\" cellular",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    unrecognized       = "?unrecognized?"
}

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,2"   : .iPadAir1,
            "iPad5,4"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPad5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9_cell,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,6" : .iPhoneX
        ]

        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}

class FuelquantityVC: UIViewController,StreamDelegate,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate
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
    
    @IBOutlet var Warning: UILabel!
    @IBOutlet var Pwait: UILabel!
    @IBOutlet var waitactivity: UIActivityIndicatorView!
    @IBOutlet var lable: UILabel!
    @IBOutlet var tpulse: UILabel!
    @IBOutlet var tquantity: UILabel!
    @IBOutlet var wait: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!
    @IBOutlet var OKWait: UILabel!
    @IBOutlet var dataview: UIView!

    //var downloadTask: URLSessionDownloadTask!
    
    var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
    var stringdata:String = ""
    var reachability = Reachability.self
    var cf = Commanfunction()
    let defaults = UserDefaults.standard
    var web = Webservices()
    var tcpcon = TCPCommunication()
    var unsync = Sync_Unsynctransactions()
    var getdatafromsetting = false

    var IsStartbuttontapped : Bool = false
    var IsStopbuttontapped:Bool = false
    var Ispulsarcountsame :Bool = false
    var Cancel_Button_tapped :Bool = false
    var string:String = ""

    var tstring:String = ""
    var sysdata:NSDictionary!
    var setrelaysysdata:NSDictionary!

    var sysdata1:NSDictionary!
    var currentSSID:String!
    var s1:String!
    var iswifi :Bool!
    var Fquantity :Double!
    var quantity = [String]()
    var counts:String!
    var replySetPulser :String!
    var setpulsardata:String = ""
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    var timerview:Timer = Timer()
    var stoptimer:Timer = Timer()
    var stoptimergotostart:Timer = Timer()
    var stoptimerIspulsarcountsame:Timer = Timer()
    var y :CGFloat = CGFloat()
    var beginfuel1 : Bool = false
    var stopbutton :Bool = false
    var record = [String]()
    var fuelquantity:Double!
    var reply :String!
    var reply1 :String!
    var pulsardata:String!
    var startbutton:String = ""
    var gohome:Bool = false
    var isconect_toFS:String!
    var showstartbutton:String = ""
    var emptypulsar_count:Int = 0
    var total_count:Int = 0
    var Last_Count:String!
    var tlddatafromlink:String!
    var stopdelaytime:Bool = false
    var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()
    var countfailConn:Int = 0
    var fcount:Int = 0
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    
    //Mark IBOutlets
    //@IBOutlet var fuelquan: UILabel!
    @IBOutlet var scrollview: UIScrollView!
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
        stoptimergotostart.invalidate()
        scrollview.isHidden = false
        OKWait.isHidden = true
        self.timerview.invalidate()
        if(startbutton == "true"){}
        else{
            self.displaytime.text = NSLocalizedString("MessageFueling1", comment:"")

            cf.delay(4){
                self.Activity.hidesWhenStopped = true;
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                    let showstart = self.web.getinfo()
                    if(showstart == "true"){
                        self.start.isEnabled = true
                        self.start.isHidden = false
                        self.Pwait.isHidden = true
                        self.Activity.stopAnimating()

                    }else
                        if(showstart == "false"){
                            self.start.isEnabled = false
                            self.start.isHidden = true
                            self.displaytime.text =  NSLocalizedString("MessageFueling1", comment:"")
                            print("return  false  by info command")
                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + " \(Vehicaldetails.sharedInstance.SSId) " + NSLocalizedString("Wifi", comment:""))
                    }
                    if(showstart == "-1")
                    {
                        print("return  -1  by info command")
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                    }
                    if(showstart == "")
                    {
                        print("return \" \"  by info command")
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                    }
                    self.timerview.invalidate()
                    self.iswifi = true
                    if(self.startbutton == "true")
                    {
                        print("startbutton")
                    }

                    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")

                } else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                {
                    self.IsStartbuttontapped = false
                    self.cf.delay(4){
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                        let dtt: String = dateFormatter.string(from: NSDate() as Date)

                        self.web.sentlog(func_name: "OnAppearing Fueling screen lost Wifi connection with the link, Date\(dtt)", errorfromserverorlink: " Connected link: \(self.cf.getSSID())", errorfromapp:" Selected Hose: \(Vehicaldetails.sharedInstance.SSId)")

                        self.timerview.invalidate()
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
      
        UIApplication.shared.isIdleTimerDisabled = true
        stoptimergotostart.invalidate()
        start.isEnabled = false
        start.isHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)//
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        Warning.isHidden = true
        
    }
    
    override func viewDidLoad() {
        self.Activity.startAnimating()
        stoptimergotostart.invalidate()
        super.viewDidLoad()
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        wait.isHidden = true
        waitactivity.isHidden = true
        UsageInfoview.isHidden = true
        Pwait.isHidden = true

        Vehicaldetails.sharedInstance.gohome = false
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControlState())
        doneButton.addTarget(self, action: #selector(FuelquantityVC.tapAction), for: UIControlEvents.touchUpInside);
        doneButton.backgroundColor = UIColor.black
        
        FQ.isHidden = false
        Stop.isHidden = true
        cancel.isHidden = false
        getdatafromsetting = true
        start.isEnabled = false
        start.isHidden = true
        if(!timerview.isValid) {}

        Odometer.text = "\(Vehicaldetails.sharedInstance.Odometerno)"
        vehicleno.text = "\(Vehicaldetails.sharedInstance.vehicleno)"
    }

    @objc func tapAction() {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savetrans(lastpulsarcount:String,lasttransID:String){
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        let fuelquantity = (Double(lastpulsarcount))!/(PulseRatio as NSString).doubleValue
        if(fuelquantity == 0.0 || lasttransID == "-1"){}
        else{
            let bodyData = "{\"TransactionId\":\(lasttransID),\"FuelQuantity\":\((fuelquantity)),\"Pulses\":\"\(lastpulsarcount)\",\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"Transaction\":\"LastTransaction\"}"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            let unsycnfileName =  dtt1 + "#" + "transaction" + "#" + "lasttransID" + "#" + Vehicaldetails.sharedInstance.SSId
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
            }
        }
    }
    
    
    @IBAction func startButtontapped(sender: AnyObject) {

        if(Cancel_Button_tapped == true){}
        else{
            //Start the fueling with buttontapped

            start.isEnabled = false
            IsStartbuttontapped = true
            stoptimergotostart.invalidate()
            self.timerview.invalidate()
            self.cancel.isHidden = true

            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.web.sentlog(func_name: "startButtontapped lost Wifi connection with the link", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                self.timerview.invalidate()

                self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
            }
            else {
                print("before get relay" + cf.dateUpdated)
                let replygetrelay = self.web.getrelay()   ///get realy status to check link is busy or not
                let Split = replygetrelay.components(separatedBy: "#")
                reply = Split[0]
                let error = Split[1]
                print(self.reply)
                if(self.reply == "-1"){
                    
                    let text = error//.localizedDescription + error.debugDescription
                    let test = String((text.filter { !" \n".contains($0) }))
                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                    print(newString)
                    self.web.sentlog(func_name: "StartButtontapped GetRelay Function ", errorfromserverorlink: "\(newString)", errorfromapp: NSLocalizedString("wificonnection", comment:""))
                    self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                }else{
                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
                    do{
                        self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    }catch let error as NSError {
                        print ("Error: \(error.domain)")
                        let text = error.localizedDescription + error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        print(newString)
                        self.web.sentlog(func_name: "startButtontapped GetRelay Function ", errorfromserverorlink: "\(newString)", errorfromapp:"\"Error: \(error.domain)")
                    }

                    if(self.setrelaysysdata == nil){
                        print("HI set relay sysdata is nil")
                    }
                    else{

                        let objUserData = self.setrelaysysdata.value(forKey: "relay_response") as! NSDictionary

                        let relayStatus = objUserData.value(forKey: "status") as! NSNumber

                        print("after get relay" + cf.dateUpdated)
                        if(relayStatus == 0){

                            self.Pwait.text =  NSLocalizedString("Pleasewait", comment:"")//"Please wait ... "   //1-2sec
                            self.Pwait.isHidden = false
                            self.start.isHidden = true
                            self.cancel.isHidden = true   /// hide the cancel Button.

                            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.web.sentlog(func_name: "startButtontapped lost Wifi connection with the link after get relay.", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")

                                self.timerview.invalidate()
                                self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                            }else {

                                print("before setpulsaroffTime" + cf.dateUpdated)

                                self.tcpcon.setpulsaroffTime()   /// set pulsar off time to FS link

                                print("after setpulsaroffTime" + cf.dateUpdated)

                                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                {
                                    self.web.sentlog(func_name: "startButtontapped lost Wifi connection with the link after setpulsaroffTime.", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")

                                    self.timerview.invalidate()
                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                                }else {

                                    print("before setSamplingtime" + cf.dateUpdated)
                                    self.cf.delay(0.5){
                                        let st = self.tcpcon.setSamplingtime()  /// set Sampling time to FS link

                                        print("after setSamplingtime" + self.cf.dateUpdated)
                                        print(st)

                                        print("before pulsarlastquantity" + self.cf.dateUpdated)
                                        self.cf.delay(0.5){
                                            self.start.isHidden = true

                                            self.web.pulsarlastquantity()   /// GET last 10 records from FS link

                                            print("pulsarlastquantity" + self.cf.dateUpdated)

                                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                                            _ = self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "1")/////

                                            print("before getlastTrans_ID" + self.cf.dateUpdated)
                                            self.cf.delay(0.5){

                                                let lasttransID = self.web.getlastTrans_ID()   /// Get the previous Transaction ID from FS link.

                                                print("getlastTrans_ID" + self.cf.dateUpdated ,Vehicaldetails.sharedInstance.FinalQuantitycount)
                                                if(Vehicaldetails.sharedInstance.FinalQuantitycount == ""){}
                                                else{
                                                    self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                                }

                                                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                                {
                                                    self.web.sentlog(func_name: "startButtontapped lost Wifi connection with the link after getlastTrans_ID", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                                                    self.timerview.invalidate()
                                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")

                                                } else {

                                                    print("before settransaction_IDtoFS" + self.cf.dateUpdated)
                                                    self.cf.delay(0.5){

                                                        self.tcpcon.settransaction_IDtoFS()   ///Set the Current Transaction ID to FS link.

                                                        print("settransaction_IDtoFS" + self.cf.dateUpdated)

                                                        self.beginfuel1 = false
                                                        self.displaytime.text = NSLocalizedString("Fueling", comment:"")//"Fueling…"  //3-4sec
                                                        self.Pwait.isHidden = true

                                                        self.tcpcon.setdefault()
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
                                                                self.showAlertSetting(message: NSLocalizedString("CheckWifi", comment:""))//"Please check your wifi connection")
                                                            }
                                                        }

                                                        self.Activity.isHidden = true
                                                        self.Activity.stopAnimating()

                                                        self.tcpcon.setdefault()
                                                        self.tcpcon.closestreams()

                                                        self.cf.delay(0.5){

                                                            print("before setpulsartcp" + self.cf.dateUpdated)
                                                            var setpulsar = self.tcpcon.setpulsartcp()
                                                            
                                                            print(setpulsar)
                                                            print("Pulsar on0" + self.cf.dateUpdated)
                                                            self.cf.delay(0.5){
                                                                if(setpulsar == ""){
                                                                    setpulsar = self.tcpcon.setpulsartcp()

                                                                    print("Pulsar on1" + self.cf.dateUpdated)
                                                                    //set pulsar
                                                                }
                                                                if(setpulsar == ""){
                                                                    self.cf.delay(0.5){
                                                                        _ = self.tcpcon.setralay0tcp()
                                                                        _ = self.tcpcon.setpulsar0tcp()

                                                                    }
                                                                }
                                                                else{

                                                                    let Split = setpulsar.components(separatedBy: "{")
                                                                    if(Split.count < 3){
                                                                        _ = self.tcpcon.setralay0tcp()
                                                                        _ = self.tcpcon.setpulsar0tcp()
                                                                        self.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
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


                                                                        print(setpulsar)

                                                                        if(pulsar_status == 1)
                                                                        {

                                                                            print("before Relay on0" + self.cf.dateUpdated)
                                                                            var setrelayd = self.tcpcon.setralaytcp()

                                                                            print("Relay on0" + self.cf.dateUpdated)

                                                                            self.cf.delay(0.5){
                                                                                if(setrelayd == ""){        // if no response sent set relay command again
                                                                                    setrelayd = self.tcpcon.setralaytcp()

                                                                                    print("Relay on1" + self.cf.dateUpdated)
                                                                                }
                                                                                if(setrelayd == ""){  // after 2 attempt stop relay goto home screen
                                                                                    self.cf.delay(0.5){
                                                                                        _ = self.tcpcon.setralay0tcp()
                                                                                        _ = self.tcpcon.setpulsar0tcp()

                                                                                        print(self.cf.dateUpdated)
                                                                                        self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                                                    }
                                                                                }
                                                                                else{

                                                                                    let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
                                                                                    if(Split.count < 2){
                                                                                        _ = self.tcpcon.setralay0tcp()
                                                                                        _ = self.tcpcon.setpulsar0tcp()
                                                                                        self.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
                                                                                    }    // got invalid respose do nothing goto home screen
                                                                                    else{
                                                                                        let reply = Split[0] as! String    // get valid respose proceed
                                                                                        let setrelay = Split[1]as! String
                                                                                        let Split1:NSArray = setrelay.components(separatedBy: "}") as NSArray
                                                                                        let setrelay1 = Split1[0] as! String
                                                                                        let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"  /// got valid data from FS unit

                                                                                        print("getresponse relay on" + self.cf.dateUpdated)
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

                                                                                    self.tcpcon.setdefault()

                                                                                    self.btnBeginFueling()

                                                                                    print("Get Pulsar" + self.cf.dateUpdated)
                                                                                    self.displaytime.text = ""
                                                                                }
                                                                            }
                                                                        }
                                                                        else{
                                                                            print("not started Pulsar")
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
                            }
                        }
                        else if(relayStatus == 1)
                        {
                            let alert = UIAlertController(title: "", message: NSLocalizedString("The link is busy, please try after some time.", comment:""), preferredStyle: UIAlertControllerStyle.alert)
                            let backView = alert.view.subviews.last?.subviews.last
                            backView?.layer.cornerRadius = 10.0
                            backView?.backgroundColor = UIColor.white
                            var messageMutableString = NSMutableAttributedString()
                            messageMutableString = NSMutableAttributedString(string: "The link is busy, please try after some time." as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
                            messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:"The link is busy, please try after some time.".count))
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
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {

        Cancel_Button_tapped = true
        if(IsStartbuttontapped == true){}
        else{
            let alert = UIAlertController(title: "Confirm", message: NSLocalizedString("Cancelwarning", comment:""), preferredStyle: UIAlertControllerStyle.alert)
            let backView = alert.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.white
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string: NSLocalizedString("Cancelwarning", comment:"") as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
            messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:NSLocalizedString("Cancelwarning", comment:"").count))
            alert.setValue(messageMutableString, forKey: "attributedMessage")

            let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertActionStyle.default) { action in
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                // Call a method on the CustomController property of the AppDelegate
                self.cf.delay(0.5) {
                    // put the delayed action/function here
                    let systemVersion = UIDevice.current.systemVersion
                    print("iOS\(systemVersion)")

                    //iPhone or iPad
                    let model = UIDevice.current.model

                    print("device type=\(model)")
                    self.web.sentlog(func_name: "cancelButtonTapped", errorfromserverorlink: "", errorfromapp: "")
                    appDel.start()
                    self.Activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
                    self.Activity.startAnimating()
                }
            }

            let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment:""), style: UIAlertActionStyle.cancel) { (submitn) -> Void in
                self.Cancel_Button_tapped = false
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertActionStyle.default) { action in //self.//
            
            self.cf.delay(1){
                Vehicaldetails.sharedInstance.gohome = true
                self.IsStartbuttontapped = true
                self.stoptimergotostart.invalidate()
                self.timerview.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                self.web.sentlog(func_name: "error400 Message ", errorfromserverorlink: "", errorfromapp: message)
                appDel.start()
                self.stopdelaytime = true
            }
        }
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
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 25.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action = UIAlertAction(title: NSLocalizedString("ConnectWifi", comment:""), style: UIAlertActionStyle.default) { action in //self.

            if #available(iOS 11.0, *) {
                // self.web.wifisettings(pagename: "FuelQuantityVC")
                self.cf.delay(1){
                    let hotspotConfig = NEHotspotConfiguration(ssid: self.SSID, passphrase: "123456789", isWEP: false)
                    hotspotConfig.joinOnce = true

                    NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in

                        if let error = error {
                            // self.showError(error: error)
                            print("Error\(error)")
                            self.web.wifisettings(pagename:"Retry")
                        }
                        else {
                            self.web.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from FuelquantityVC Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                            // self.showSuccess()
                            print("Connected")
                        }
                    }
                }
            } else {
                // Fallback on earlier versions

                let alertController = UIAlertController(title: NSLocalizedString("Title", comment:""), message: NSLocalizedString("Message", comment:"") + "\(Vehicaldetails.sharedInstance.SSId).", preferredStyle: UIAlertControllerStyle.alert)
                let backView = alertController.view.subviews.last?.subviews.last
                backView?.layer.cornerRadius = 10.0
                backView?.backgroundColor = UIColor.white

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.left

                let paragraphStyle1 = NSMutableParagraphStyle()
                paragraphStyle1.alignment = NSTextAlignment.left

                let attributedString = NSAttributedString(string:NSLocalizedString("Subtitle", comment:""), attributes: [
                    NSAttributedStringKey.paragraphStyle:paragraphStyle1,
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20), //your font here
                    NSAttributedStringKey.foregroundColor : UIColor.black
                    ])

                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal(NSLocalizedString("Step1", comment:""))
                    .bold("\(Vehicaldetails.sharedInstance.SSId)")
                    .normal(NSLocalizedString("Step2", comment:""))
                    .bold("\(Vehicaldetails.sharedInstance.SSId)")
                    .normal(NSLocalizedString("Step3", comment:""))

                alertController.setValue(formattedString, forKey: "attributedMessage")
                alertController.setValue(attributedString, forKey: "attributedTitle")
                let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default){
                    action in

                }
                alertController.addAction(action)

                self.present(alertController, animated: true, completion: nil)
            }

            Vehicaldetails.sharedInstance.gohome = false
            self.resumetimer()
        }
        let home = UIAlertAction(title: NSLocalizedString("BacktoHome", comment:""), style: UIAlertActionStyle.default) { action in //
            
            Vehicaldetails.sharedInstance.gohome = true
            self.IsStartbuttontapped = true
            self.stoptimergotostart.invalidate()
            alertController.view.tintColor = UIColor.green
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            
            appDel.start()
            self.timerview.invalidate()
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

        Vehicaldetails.sharedInstance.gohome = false
        self.resumetimer()
    }
    
    func backaction(sender:UIButton){
        IsStartbuttontapped = true
        stoptimergotostart.invalidate()
        Vehicaldetails.sharedInstance.gohome = true
        self.timerview.invalidate()
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        self.web.sentlog(func_name: "backaction", errorfromserverorlink: "", errorfromapp: "")
        appDel.start()
    }

    @objc func stopButtontapped()
    {
        Stop.isEnabled = false
        Stop.isHidden = true
        wait.isHidden = false
        waitactivity.isHidden = false
        waitactivity.startAnimating()
        self.timer.invalidate()

        print("stopButtontapped" + cf.dateUpdated)
        string = ""
        cf.delay(0.5){
            self.timer.invalidate()
            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.web.sentlog(func_name: "stopButtontapped lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                self.timerview.invalidate()
                do{
                    try self.stoprelay()
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                }
            }else {

                print("Before relayoff 0" + self.cf.dateUpdated)
                var setrelayd = self.tcpcon.setralay0tcp()
                self.cf.delay(0.5){
                    
                    if(setrelayd == ""){
                        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                        {self.web.sentlog(func_name: "stopButtontapped lost Wifi connection with the link", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                            self.timerview.invalidate()
                            //  self.stoprelay()
                            do{
                                try self.stoprelay()
                            }
                            catch let error as NSError {
                                print ("Error: \(error.domain)")
                                self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                            }
                        }else {
                            setrelayd = self.tcpcon.setralay0tcp()
                            self.cf.delay(0.5){}
                        }
                    }

                    print("Before relayoff 0" + self.cf.dateUpdated)
                    if(setrelayd == ""){
                        self.cf.delay(0.5){
                            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.web.sentlog(func_name: "stopButtontapped lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                                self.timerview.invalidate()
                                // self.stoprelay()
                                do{
                                    try self.stoprelay()
                                }
                                catch let error as NSError {
                                    print ("Error: \(error.domain)")
                                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                }

                            }else {
                                _ = self.tcpcon.setralay0tcp()
                                _ = self.tcpcon.setpulsar0tcp()
                                self.web.sentlog(func_name: "stopButtontapped set relay off command Response from link is $$ \(setrelayd)!!", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )

                                do{
                                    try self.stoprelay()
                                }
                                catch let error as NSError {
                                    print ("Error: \(error.domain)")
                                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                }
                            }
                        }
                    }
                    else{

                        print("after set relayoff 0" + self.cf.dateUpdated)
                        let Split = setrelayd.components(separatedBy: "{")
                        if(Split.count < 3){
                            _ = self.tcpcon.setralay0tcp()
                            _ = self.tcpcon.setpulsar0tcp()

                            do{
                                try self.stoprelay()
                            }
                            catch let error as NSError {
                                print ("Error: \(error.domain)")
                                self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                            }
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
                                self.web.sentlog(func_name: "stopButtontapped", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                            }
                            print(self.sysdata1,"relay_response")


                            print(setrelayd)
                            

                            self.cf.delay(0.5){

                                if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                {
                                    self.web.sentlog(func_name: "stopButtontapped lost Wifi connection with the link ", errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                                    self.timerview.invalidate()
                                    do{
                                        try self.stoprelay()
                                    }
                                    catch let error as NSError {
                                        print ("Error: \(error.domain)")
                                        self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                    }
                                }else {

                                    print("before get final_pulsar_request" + self.cf.dateUpdated)
                                    self.timer.invalidate()
                                    self.string = ""
                                    self.tcpcon.setdefault()
                                    self.tcpcon.closestreams()
                                    self.cf.delay(0.5){
                                        var finalpulsar = self.tcpcon.final_pulsar_request()
                                        self.cf.delay(1){
                                            if(finalpulsar == ""){
                                                finalpulsar = self.tcpcon.final_pulsar_request()
                                            }
                                            print(finalpulsar)
                                            let Split = finalpulsar.components(separatedBy: "{")
                                            print("Splitcout\(Split.count)")
                                            if(Split.count < 3){  _ = self.tcpcon.setralay0tcp()

                                                _ = self.tcpcon.setpulsar0tcp()

                                                do{
                                                    try self.stoprelay()
                                                }
                                                catch let error as NSError {
                                                    print ("Error: \(error.domain)")
                                                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                                }
                                            }
                                            else{
                                                print("after get final_pulsar_request" + self.cf.dateUpdated)
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

                                                    if (self.counts != "0"){

                                                    }
                                                    self.fuelquantity = self.cf.calculate_fuelquantity(quantitycount: Int(self.counts as String)!)
                                                    if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                                        let y = Double(round(100*self.fuelquantity)/100)
                                                        self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                                        print(self.tquantity.text!)
                                                    }
                                                    else {
                                                        let y = Double(round(100*self.fuelquantity)/100)
                                                        self.tquantity.text = "\(y) "

                                                    }
                                                    self.tpulse.text = (self.counts as String) as String
                                                    self.Last_Count = (self.counts as String) as String
                                                }

                                                print(self.string)
                                                self.Stop.isHidden = true

                                                let SSID:String = self.cf.getSSID()
                                                print(SSID)
                                                print(Vehicaldetails.sharedInstance.SSId)
                                                print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                                                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                    self.tcpcon.changessidname(wifissid: Vehicaldetails.sharedInstance.ReplaceableHoseName)
                                                }
                                                self.cf.delay(0.5) {

                                                    print("before set setpulsar0tcp" + self.cf.dateUpdated)
                                                    _ = self.tcpcon.setpulsar0tcp()
                                                    if( Vehicaldetails.sharedInstance.SSId == SSID  || "FUELSECURE" == SSID)
                                                    {

                                                        self.cf.delay(0.5) {     // takes a Double value for the delay in seconds

                                                            // put the delayed action/function here
                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                                _ = self.web.SetHoseNameReplacedFlag()
                                                            }
                                                            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                                                                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                                                self.tcpcon.getuser()
                                                                //                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
                                                            }else{}

                                                            if(self.fuelquantity > 0){

                                                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                                                    self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                                                }
                                                                else {
                                                                    self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                                                                }

                                                                self.pulse.text = "\(self.counts!)"
                                                                print(self.counts)
                                                                self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")
                                                                self.cf.delay(0.5){
                                                                    //     print("before set tldlevel" + self.cf.dateUpdated)
                                                                    self.Transaction(fuelQuantity: self.fuelquantity)

//                                                                       let replytld = self.tcpcon.tlddata()
                                                                    self.tcpcon.setdefault()
                                                                    self.tcpcon.closestreams()
                                                                    if(Vehicaldetails.sharedInstance.IsTLDdata == "True")
                                                                    {
                                                                        let replytld = self.web.tldlevel()
                                                                        if(replytld == "" || replytld == "nil"){}
                                                                        else{
                                                                            self.tcpcon.sendtld(replytld: replytld)
                                                                        }
                                                                    }
                                                                    self.wait.isHidden = true
                                                                    self.waitactivity.isHidden = true
                                                                    self.waitactivity.stopAnimating()
                                                                    self.UsageInfoview.isHidden = false
                                                                    self.Warning.isHidden = true
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
                                                                            self.web.sentlog(func_name: "stopButtontapped 30 delay", errorfromserverorlink: "", errorfromapp: "")
                                                                            appDel.start()
                                                                        }
                                                                    }
                                                                    if (self.stopdelaytime == true){}
                                                                    else{
                                                                        Vehicaldetails.sharedInstance.gohome = true
                                                                        self.timerview.invalidate()
                                                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                                        self.web.sentlog(func_name: "stopButtontapped ", errorfromserverorlink: "", errorfromapp: "")
                                                                        appDel.start()
                                                                    }
                                                                    self.wait.isHidden = true
                                                                    self.waitactivity.isHidden = true
                                                                    self.waitactivity.stopAnimating()
                                                                    self.UsageInfoview.isHidden = false
                                                                    self.Warning.isHidden = true
                                                                }

                                                            }
                                                            else
                                                            {
                                                                self.error400(message: NSLocalizedString("ZeroQuantity", comment:""))//"Quantity is zero. Transaction is stopped")
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
                }
            }
        }
    }


    func SenddataTransaction(quantitycount:String,PulseRatio:String){
        cf.delay(0.5) {     // takes a Double value for the delay in seconds
            // put the delayed action/function here
            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                _ = self.web.SetHoseNameReplacedFlag()
            }
            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.tcpcon.getuser()
            }else{}
            self.cf.delay(1){
                self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
                if(self.fuelquantity == nil){

                    self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                }
                else{
                    if(self.fuelquantity > 0){

                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                        }
                        else {
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                        }

                        self.pulse.text = "\(self.Last_Count!)"
                        print(self.Last_Count)
                        self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"

                        self.cf.delay(0.5){
                            self.Transaction(fuelQuantity: self.fuelquantity)
                            self.tcpcon.setdefault()
                            let replytld = self.tcpcon.tlddata()

                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.UsageInfoview.isHidden = false
                            self.Warning.isHidden = true
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
                                    self.web.sentlog(func_name: "stoprelay function 30 delay ", errorfromserverorlink: "", errorfromapp: "")
                                    appDel.start()
                                }
                            }
                            if (self.stopdelaytime == true){}
                            else{
                                Vehicaldetails.sharedInstance.gohome = true
                                self.timerview.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                self.web.sentlog(func_name: "stoprelay function ", errorfromserverorlink: "", errorfromapp: "")
                                appDel.start()
                            }
                            self.wait.isHidden = true
                            self.waitactivity.isHidden = true
                            self.waitactivity.stopAnimating()
                            self.UsageInfoview.isHidden = false
                            self.Warning.isHidden = true
                        }
                    }
                    else
                    {
                        self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                    }
                }
            }
        }
    }
    
    @objc func stoprelay() throws -> String {
        if(Last_Count == nil){
            Last_Count = "0.0"
        }
        self.timer.invalidate()
        Stop.isHidden = true
        timer_noConnection_withlink.invalidate()
        timer_quantityless_thanprevious.invalidate()
        let SSID:String = cf.getSSID()
        print(SSID)
        print(Vehicaldetails.sharedInstance.SSId)
        print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
        {
            tcpcon.changessidname(wifissid: Vehicaldetails.sharedInstance.ReplaceableHoseName)
        }
        if(Vehicaldetails.sharedInstance.PulseRatio == "" || Vehicaldetails.sharedInstance.pulsarCount == "" ){
            self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
        } else{
            let quantitycount = self.Last_Count! //Vehicaldetails.sharedInstance.pulsarCount
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue

            if( Vehicaldetails.sharedInstance.SSId == SSID)
            {
                SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
            }
            else {
                SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
            }
        }
        return ""
    }


    func Transaction(fuelQuantity:Double)
    {
        let Odomtr = Vehicaldetails.sharedInstance.Odometerno
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount :String
        if(self.Last_Count == nil){
            pusercount = Vehicaldetails.sharedInstance.pulsarCount
        }else{
            pusercount = self.Last_Count!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        
        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"Transaction\":\"Current_Transaction\"}"

        let reply = "-1"//web.Transaction_details(bodyData: bodyData)
        if (reply == "-1")
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)

            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
            }
        }
        else{
            Warning.isHidden = true
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            print(sysdata)
            self.unsync.notify(site: Vehicaldetails.sharedInstance.SSId)
        }
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

    func btnBeginFueling() {

        print("before GetPulser" + cf.dateUpdated)
        self.cf.delay(0.5){
            self.GetPulser() ///
            self.quantity = []
            self.countfailConn = 0
            print("Get Pulsar1" + self.cf.dateUpdated)
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)

            print("after GetPulser" + self.cf.dateUpdated)
            print(self.timer)
        }
    }

    @objc func GetPulser() {

        let dateFormatter = DateFormatter()
        Warning.text = NSLocalizedString("Warningfueling", comment:"")
        Warning.isHidden = false
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let defaultTimeZoneStr = dateFormatter.string(from: Date());

        print("before GetPulser" + defaultTimeZoneStr)
        //cf.delay(0.5) {
        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
        print("before send GetPulser" + defaultTimeZoneStr1)
        self.web.sentlog(func_name: "StartButtontapped Send GetPulsar Request Function", errorfromserverorlink: "", errorfromapp: "")

        let replyGetpulsar1 = web.GetPulser()

        print(replyGetpulsar1)
        let Split = replyGetpulsar1.components(separatedBy: "#")
        reply1 = Split[0]
        let error = Split[1]
        print(reply1)
        if(self.reply1 == nil || self.reply1 == "-1")
        {
            let text = reply1//error.localizedDescription + error.debugDescription
            let test = String((text?.filter { !" \n".contains($0) })!)
            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
            print(newString)
            self.web.sentlog(func_name: "StartButtontapped GetPulsar Function", errorfromserverorlink: "\(newString)", errorfromapp: "")
            timer_noConnection_withlink = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
            countfailConn += 1
            print(countfailConn)
            if(countfailConn < 3){
                if #available(iOS 11.0, *) {
                    // NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: SSID)
                    self.web.wifisettings(pagename:"Getpulsar_fuelquantity")
                    countfailConn = 0
                } else {
                    // Fallback on earlier versions
                }

            }else if(countfailConn > 3) {
                do{
                    try self.stoprelay()
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                }
            }
        }
        else{
            timer_noConnection_withlink.invalidate()
            let data1 = self.reply1.data(using: String.Encoding.utf8)!
            do{
                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            }catch let error as NSError {
                let text = error.localizedDescription + error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.web.sentlog(func_name: "StartButtontapped GetPulsar Function ", errorfromserverorlink: "\(newString)", errorfromapp: "")
                print ("Error: \(error.domain)")
            }

            if(self.sysdata1 == nil){}
            else
            {
                print(reply1)
                let text = reply1
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.web.sentlog(func_name: "StartButtontapped GetPulsar Function ", errorfromserverorlink: "Response from link $$ \(newString)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                print(sysdata1)
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
                        self.web.sentlog(func_name: "get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
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
                            if(counts.doubleValue > (Last_Count as NSString).doubleValue){
                                Ispulsarcountsame = false
                                stoptimerIspulsarcountsame.invalidate()
                            }
                            timer_quantityless_thanprevious.invalidate()
                            self.Last_Count = counts as String?
                            let v = self.quantity.count
                            let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                            let y = Double(round(100*FuelQuan)/100)
                            if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                let y = Double(round(100*FuelQuan)/100)
                                self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                print(self.tquantity.text!)
                            }
                            else {
                                let y = Double(round(100*FuelQuan)/100)
                                self.tquantity.text = "\(y) "
                            }

                            self.tpulse.text = (counts as String) as String
                            self.quantity.append("\(y) ")

                            print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                            print("Inside loop GetPulser" + defaultTimeZoneStr1)
                            if(v >= 2){
                                print(self.quantity[v-1],self.quantity[v-2])
                                if(self.quantity[v-1] == self.quantity[v-2]){
                                    self.total_count += 1
                                    if(self.total_count == 3){
                                        Ispulsarcountsame = true
                                        stoptimerIspulsarcountsame.invalidate()
                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)

                                        self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
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
                                        self.displaytime.text = "1 \n \n " + NSLocalizedString("Pulsardisconnected", comment: "")
                                        self.stopButtontapped()
                                    }

                                    if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                    else{

                                        if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){

                                            _ = self.web.SetPulser0()
                                            print(Vehicaldetails.sharedInstance.MinLimit)
                                            self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:""))//"You are fuel day limit reached.")
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

                        if(pulsar_status == 0)
                        {
                            _ = self.tcpcon.setpulsar0tcp()
                            do{
                                try self.stoprelay()
                            }
                            catch let error as NSError {
                                print ("Error: \(error.domain)")
                                self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                            }
                            // self.stoprelay()
                        }
                        //                            }
                    }
                    else{
                        let v = self.quantity.count
                        let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                        let y = Double(round(100*FuelQuan)/100)

                        self.quantity.append("\(y) ")

                        print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                        print("Inside loop GetPulser" + defaultTimeZoneStr1)
                        if(v >= 2){
                            if(self.self.quantity[v-1] == self.quantity[v-2]){
                                self.total_count += 1
                                if(self.total_count == 3){
                                    Ispulsarcountsame = true
                                    stoptimerIspulsarcountsame.invalidate()

                                    self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")

                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @objc func stopIspulsarcountsame(){
        if(self.IsStopbuttontapped == true){

        }
        else {
            if(self.Ispulsarcountsame == true){


                self.timer.invalidate()
                 self.web.sentlog(func_name: "stoprelay stopIspulsarcountsame", errorfromserverorlink: "", errorfromapp:"")
                _ = self.tcpcon.setralay0tcp()
                _ = self.tcpcon.setpulsar0tcp()
                self.displaytime.text = NSLocalizedString("autostop", comment:"")//"app autostop because pulsecount getting is same."
                self.Stop.isHidden = true
                do{
                    try self.stoprelay()
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.web.sentlog(func_name: "stoprelay stopIspulsarcountsame", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                }
            }
        }
    }

    @IBAction func OKbuttontapped(sender: AnyObject) {
        UsageInfoview.isHidden = true
        IsStartbuttontapped = true
        scrollview.isHidden = false
        dataview.isHidden = true
        OKWait.isHidden = false
        timer.invalidate()
        stoptimergotostart.invalidate()
        self.cf.delay(0.1){
            Vehicaldetails.sharedInstance.gohome = true
            self.timerview.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.web.sentlog(func_name: "OKbuttontapped", errorfromserverorlink: "", errorfromapp: "")
            self.stopdelaytime = true
        }
    }
}

