////  PreauthFuelquantity.swift
////  FuelSecure
////
////  Created by VASP on 9/21/17.
////  Copyright © 2017 VASP. All rights reserved.
////

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Foundation
import CoreData
import CoreBluetooth
import Network
import AVFoundation
import CallKit


class PreauthFuelquantity: UIViewController,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,StreamDelegate,CLLocationManagerDelegate
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
    
    
    var currentlocation :CLLocation!
    let locationManager = CLLocationManager()
    var sourcelat:Double!
    var sourcelong:Double!
    var Transaction_ID = [NSManagedObject]()
    var results = [NSManagedObject]()
    
    let kBLEService_UUID = "4c425346-0000-1000-8000-00805f9b34fb" //"000000ff-0000-1000-8000-00805f9b34fb"//"6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    //00001101-0000-1000-8000-00805F9B34FB
    let kBLE_Characteristic_uuid_Tx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    //"6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    let kBLE_Characteristic_uuid_Rx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    //"6e400003-b5a3-f393-e0a9-e50e24dcca9e"
    let kBLE_Characteristic_uuid_Tx_upload = "e49227e8-659f-4d7e-8e23-8c6eea5b9174"
    let discoverServices_upload = "725e0bc8-6f00-4d2d-a4af-96138ce599b7"
    
    var txCharacteristic : CBCharacteristic?
    var txCharacteristicupload : CBCharacteristic?
    var rxCharacteristic : CBCharacteristic?
    var blePeripheral : CBPeripheral?
    var characteristicASCIIValue = ""
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    var BLErescount = 0
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var peripheral: CBPeripheral!
    var RSSIs = [NSNumber]()
    var data = NSMutableData()
    var peripherals: [CBPeripheral] = []
//    var kCBAdvDataLocalName = [String]()
    var ifSubscribed = false
    var isdisconnected = false
    var isDisconnect_Peripheral = false
    var FDcheckBLEtimer:Timer = Timer()
    var Count_Fdcheck = 0
    var countwififailConn:Int = 0
    var Last10transaction = ""
    var iflinkison = false
    var sendrename_linkname = false
    
    var sentDataPacket:Data!
    var bindata:Data!
    var totalbindatacount:Int!
    var replydata:NSData!
    var subData = Data()
    var iterationcountforupgrade = 0
    
    //UDP
    //    var connection: NWConnection?
    var hostUDP = "192.168.4.1"
    var portUDP = 80
    var appconnecttoUDP = false
    var AppconnectedtoBLE = false
    var BTMacAddress = false
    
    var cf = Commanfunction()
    var web = Webservices()
    var tcpcon = TCPCommunication()
    
    //var unsync = Sync_Unsynctransactions()
    
    // var getdatafromsetting = false
    var IsStartbuttontapped : Bool = false
    var IsStopbuttontapped:Bool = false
    var IsStopbuttontappedBLE:Bool = true

    var Ispulsarcountsame :Bool = false
    var Cancel_Button_tapped :Bool = false
    var beginfuel1 : Bool = false
    var stopbutton :Bool = false
    var stopdelaytime:Bool = false
    var gohome:Bool = false
    var iswifi :Bool!
    var isgotostartcalled = false
    var sysdata:NSDictionary!
    var setrelaysysdata:NSDictionary!
    var sysdata1:NSDictionary!
    
    var quantity = [String]()
    var quantitysavetime = [String]()
    var kCBAdvData_LocalName = [String]()
    var counts:String!
    var reply_server:String = ""
    var isviewdidDisappear = false
    var localName = ""
    var replysentlog :String!
    var contents:Data!
    var countfromlink = 0
    
    var GetPulsarstartimer:Timer = Timer() //  var timer:Timer = Timer()    // #selector(self.GetPulser) call the Getpulsar function.
    var timerview:Timer = Timer()  // #selector(ViewController.viewDidAppear(_:)) call viewController timerview
    //var stoptimer:Timer = Timer()
    var stoptimergotostart:Timer = Timer() ///#selector(call gotostart function)
    var stoptimer_gotostart:Timer = Timer() ///#selector(gotostart from viewWillapeared)
    var stoptimerIspulsarcountsame:Timer = Timer()  ///call stopIspulsarcountsame for
    // var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()  ///#selector(FuelquantityVC.stoprelay) to stop the app
    var timer_conutnotupdateprevious = Timer()
    
    var y :CGFloat = CGFloat()
    var isokbuttontapped = false
    var fuelquantity:Double!
    var reply :String!
    var reply1 :String!
    var startbutton:String = ""
    var string:String = ""
    
    var emptypulsar_count:Int = 0
    var total_count:Int = 0
    var Last_Count:String!
    var Samecount:String!
    var renameconnectedwifi:Bool = false
    var connectedwifi:String!
    var InterruptedTransactionFlag = true
    var showstart = ""
    var countfailConn:Int = 0
    var countfailBLEConn:Int = 0
    var connectedperipheral = ""
    var appdisconnects_automatically = false
    var onFuelingScreen = false
    var reinstatingtransaction = false
    var reinstatingtransactionattempts:Int = 0
    let callObserver = CXCallObserver()
    //UDP
    //  var connection: NWConnection?
    //    var hostUDP: NWEndpoint.Host = "192.168.4.1"
    //    var portUDP: NWEndpoint.Port = 80
    
    var sendtransactioncausereinstate = true
    var Interrupted_TransactionFlag = "y"
    var sendInterrupted_TransactionFlagN = true
    
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    let defaults = UserDefaults.standard

    var newAsciiText = NSMutableAttributedString()
    var baseTextView: String = ""
    var gotLinkVersion = false
    var connectedservice:String = ""
    private var observationToken: Any?
    var isNotifyenable = false
    
    
    
    //@IBOutlet var Waitp: UILabel!
    @IBOutlet var Pwait: UILabel!
    @IBOutlet var waitactivity: UIActivityIndicatorView!
    @IBOutlet var lable: UILabel!
    @IBOutlet var tpulse: UILabel!
    @IBOutlet var tquantity: UILabel!
    @IBOutlet var wait: UILabel!
    @IBOutlet var Activity: UIActivityIndicatorView!
    //@IBOutlet var viewdata: UIView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var progressviewtext: UILabel!
    @IBOutlet weak var progressview: UIProgressView!
    
    //Mark IBOutlets

    @IBOutlet var Warning: UILabel!
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
    @IBOutlet var OKWait: UILabel!
    @IBOutlet var dataview: UIView!

    override func viewDidAppear(_ animated: Bool) {
        stoptimergotostart.invalidate()
        self.timerview.invalidate()
       
        scrollview.isHidden = false
        OKWait.isHidden = true
       
        //if Transaction ID = 0 app stops the connection and send to fueling screen. Stops all Timer
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            self.timerview.invalidate()
            goto_Start()
            self.web.sentlog(func_name:"Screen timeout starts because transaction id 0, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
           // stoprelay()
        }
        self.timerview.invalidate()
        if(startbutton == "true"){}
        else{
            print(Vehicaldetails.sharedInstance.HubLinkCommunication)
            if(Vehicaldetails.sharedInstance.HubLinkCommunication != "BT")
            {
                self.displaytime.text = NSLocalizedString("MessageFueling1" , comment:"")
            }
            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
            {
                self.cancelScan()
                if(Vehicaldetails.sharedInstance.peripherals.count == 0){
                   // centralManager = CBCentralManager(delegate: self, queue: nil)
//                    cf.delay(0.1){
//                        self.viewDidAppear(true)
//                    }
                }
                else
                {
                    //self.cancelScan()
                }
            }
            
            //else{
            self.start.isEnabled = false
            self.start.isHidden = true
            self.cancel.isHidden = true
            scrollview.isHidden = false
           // Reconnect.isHidden = true
            OKWait.isHidden = true
            
            cf.delay(2){
                self.Activity.hidesWhenStopped = true;
                //                print(Vehicaldetails.sharedInstance.SSId,self.cf.getSSID())
                if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
                    Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
                }
                
                if(self.ifSubscribed == true){
                    if(self.connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9")
                    {
                        self.consoleAsciiText = NSAttributedString(string: "")
                        self.newAsciiText = NSMutableAttributedString()
                        if(self.observationToken == nil){}
                        else{
                            NotificationCenter.default.removeObserver(self.observationToken!)
                        }
                        self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                        self.outgoingData(inputText: "LK_COMM=info")
//                        self.cf.delay(0.1){
                        self.updateIncomingData()
                        NotificationCenter.default.removeObserver(self)
//                        }
                        self.web.sentlog(func_name: " Send info command to link ", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
                        self.AppconnectedtoBLE = true
                        if(self.appdisconnects_automatically == true)
                        {
//                            if(self.AppconnectedtoBLE == true){
//                                self.getlast10transaction()
//                                self.BLErescount = 0
//                                self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
//                                self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
//                                NotificationCenter.default.removeObserver(self)
//                                self.updateIncomingData ()
//
//                                self.cf.delay(0.1){
//                                    self.start.isHidden = true
//                                    self.cancel.isHidden = true
//                                    self.Stop.isHidden = false
//    //                                self.displaytime.text = NSLocalizedString("Fueling", comment:"")
//                                    //self.displaytime.textColor = UIColor.black
//                                    self.FDcheckBLEtimer.invalidate()
//                                    self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
//                                }
//                            }
                        }
                        
                        //                        if(self.gotLinkVersion == true){
                        //                            self.consoleAsciiText = NSAttributedString(string: "")
                        //                            self.newAsciiText = NSMutableAttributedString()
                        //                            if(self.observationToken == nil){}
                        //                            else{
                        //                                NotificationCenter.default.removeObserver(self.observationToken!)
                        //                            }
                        //                            self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                        //                            self.outgoingData(inputText: "LK_COMM=txtnid:D:\(dtt1);V:\(Vehicaldetails.sharedInstance.VehicleId);") //LK_COMM=txtnid:D:2109300606;T:4844316;V:431
                        //
                        //                            NotificationCenter.default.removeObserver(self)
                        //                        self.updateIncomingData()
                        //                        }
                    }
                    
                    else{
                    self.cf.delay(1){
                        self.getBLEinfo()
                        if(Vehicaldetails.sharedInstance.BTMacAddress == "")
                        {
                            if(Vehicaldetails.sharedInstance.MacAddressfromlink == "")
                            {}
                            else{
                        let response = self.web.UpdateMACAddress()
                        let data1:Data = response.data(using: String.Encoding.utf8)!
                        do{
                            //print(self.sysdata)
                            self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            // print(self.sysdata)
                            let ResponceMessage = self.sysdata.value(forKey: "ResponceMessage") as! NSString
                            let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                            print(ResponceMessage,ResponceText)
                            if(ResponceMessage == "fail")
                            {
                                self.showstart = "false"
                                self.error400(message: ResponceText as String)
                            }

                        }
                        catch let error as NSError {
                            print ("Error: \(error.domain)")
                            let text = error.localizedDescription //+ error.debugDescription
                            let test = String((text.filter { !" \n".contains($0) }))
                            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                            print(newString)

                        }
                            }
                    }
                        
                    if(self.appdisconnects_automatically == true)
                    {
//                        if(self.AppconnectedtoBLE == true){
//                            self.getlast10transaction()
//                            self.BLErescount = 0
//                            self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
//                            self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
//                            NotificationCenter.default.removeObserver(self)
//                            self.updateIncomingData ()
//
//                            self.cf.delay(0.1){
//                                self.start.isHidden = true
//                                self.cancel.isHidden = true
//                                self.Stop.isHidden = false
//                                self.displaytime.text = NSLocalizedString("Fueling", comment:"")
//                                //self.displaytime.textColor = UIColor.black
//                                self.FDcheckBLEtimer.invalidate()
//                                self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
//                            }
//                        }
                    }
                    else{
                    //self.start.isEnabled = true
                  //  self.start.isHidden = false
                //    self.cancel.isHidden = false
                    
                    self.Activity.stopAnimating()
                    self.timerview.invalidate()
                    self.stoptimergotostart.invalidate()
                    self.stoptimer_gotostart.invalidate()
                    self.web.sentlog(func_name: "Sent transaction ID to BT link \(Vehicaldetails.sharedInstance.TransactionId)" , errorfromserverorlink: "", errorfromapp: "")
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                        
                        self.outgoingData(inputText: "LK_COMM=txtnid:\(Vehicaldetails.sharedInstance.TransactionId)")//;D:\(dtt1);V:\(Vehicaldetails.sharedInstance.VehicleId);")  //LK_COMM=txtnid:D:2109300606;T:4844316;V:431
                        NotificationCenter.default.removeObserver(self)
                    self.updateIncomingData()
                    self.stoptimergotostart.invalidate()
                    self.stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(PreauthFuelquantity.gotostart), userInfo: nil, repeats: false)
                    
                    self.web.sentlog(func_name: "Starts screen timeout timer.", errorfromserverorlink: "", errorfromapp: "")
                    
                //    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                    }
                }
                    }
            }
                else
                if(self.ifSubscribed == false){
                    self.start.isEnabled = false
                    self.start.isHidden = true
                    self.cancel.isHidden = true
                    self.displaytime.text =  NSLocalizedString("MessageFueling1", comment:"")
                    print("return  false  by info command")
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                    {
                        if(self.connectedperipheral != ""){
                            if(Vehicaldetails.sharedInstance.SSId == self.connectedperipheral){
                                self.connectToDevice()
                            }
                        }
                    }
                    //                        if (self.countfailBLEConn == 2){
                    //                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                    //                            self.web.sentlog(func_name: "App Not able to Connect and Subscribed peripheral Connection.", errorfromserverorlink: "", errorfromapp: "")
                    //                            appDel.start()
                    //                        }
                    
                }
                if(self.AppconnectedtoBLE == true){}
                else if(self.AppconnectedtoBLE == false)
                {
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                    {}
                    else if(Vehicaldetails.sharedInstance.HubLinkCommunication == "UDP")
                    {}
                    else{
                        self.cf.delay(3)
                        {
                            self.Activity.hidesWhenStopped = true;
                            //                print(Vehicaldetails.sharedInstance.SSId,self.cf.getSSID())
                            if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
                                Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
                            }
                            
                            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                            {
                                
            //                    if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
            //
            //                    }
            //                    else{
            //                        if(self.IsStartbuttontapped == true){}
            //                        else{
                                        self.showstart = self.web.getinfo()//self.tcpcon.Getinfo()//self.showstart = self.web.getinfo()
                                        print(self.showstart)
                                        if(self.showstart == "true"){
                                        
                                            if(self.appdisconnects_automatically == true)
                                            {
                                                self.stoptimergotostart.invalidate()
                                                self.stoptimer_gotostart.invalidate()
                                                self.timerview.invalidate()
                                               
                                                
                                                
                                                if(Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines) != self.cf.getSSID().trimmingCharacters(in: .whitespacesAndNewlines)) //check selected wifi and connected wifi is not same
                                                {
                                                    self.timerview.invalidate()

                                                    self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                                                }
                                                else {
                                                    self.Startfueling()
                                                    self.cancel.isHidden = true
                                                }
                                            }
                                            
                                            else{
                                            
                                        self.start.isEnabled = true
                                        self.start.isHidden = false
                                        self.cancel.isHidden = false
                                        self.Pwait.isHidden = true
                                        self.Activity.stopAnimating()
                                        self.timerview.invalidate()
                                        self.stoptimergotostart.invalidate()
                                        
                                        self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                                //self.displaytime.textColor = UIColor.black
                                        //if the information from link get and start button Appeared but user not press the start button the after 60 sec app go to the on HomeScreen.
                                        self.stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(PreauthFuelquantity.gotostart), userInfo: nil, repeats: false)
                                        
                                        self.web.sentlog(func_name:" Starts screen timeout timer.", errorfromserverorlink: "", errorfromapp: "")
                                            }
                                    }
                                    else
                                    if(self.showstart == "false"){
                                        self.start.isEnabled = false
                                        self.start.isHidden = true
                                        self.cancel.isHidden = true
                                        self.displaytime.text =  NSLocalizedString("MessageFueling1" , comment:"")
                                        //self.displaytime.textColor = UIColor.black
                                        print("return  false  by info command")
                                        
                                        //it shows the Join Message from app after call showAlertSetting function
                                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + " \(Vehicaldetails.sharedInstance.SSId) " + NSLocalizedString("Wifi", comment:""))
                                    }
                                        if(self.showstart == "-1")
                                    {
                                        print("return  -1  by info command")
                                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                                    }
                                        if(self.showstart == "")
                                    {
                                        print("return \" \"  by info command")
                                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                                    }
                                    
                                    self.iswifi = true
                                    if(self.startbutton == "true")
                                    {
                                        print("startbutton")
                                    }
                                    //self.timerview.invalidate()
                                    //self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
            //                        }
                                    
            //                    }
                            }
                            else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                            {
                                print(self.cf.getSSID())
                                if(self.cf.getSSID() == "")
                                {
                                    print(Vehicaldetails.sharedInstance.checkSSIDwithLink)
                                    if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "" || Vehicaldetails.sharedInstance.checkSSIDwithLink == "false")
                                    {
                                        if(self.IsStartbuttontapped == true){}
                                        else{
                                            self.showstart = self.web.getinfo_ssid()
                                            if(self.showstart == "true"){
                                             
            //                                    if(self.appdisconnects_automatically == true)
            //                                    {
            //                                        self.stoptimergotostart.invalidate()
            //                                        self.stoptimer_gotostart.invalidate()
            //                                        self.timerview.invalidate()
            //
            //
            //                                        if(Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines) != self.cf.getSSID().trimmingCharacters(in: .whitespacesAndNewlines)) //check selected wifi and connected wifi is not same
            //                                        {
            //                                            self.timerview.invalidate()
            //
            //                                            self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
            //                                        }
            //                                        else {
            //                                            self.Startfueling()
            //                                            self.cancel.isHidden = true
            //                                        }
            //                                    }
            //                                    else{
                                                
                                            self.start.isEnabled = true
                                            self.start.isHidden = false
                                            self.cancel.isHidden = false
                                            self.Pwait.isHidden = true
                                            self.Activity.stopAnimating()
                                            self.timerview.invalidate()
                                            self.stoptimergotostart.invalidate()
                                                
                                            
                                            self.stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(PreauthFuelquantity.gotostart), userInfo: nil, repeats: false)
                                            
                                            self.web.sentlog(func_name:" Starts screen timeout timer.", errorfromserverorlink: "", errorfromapp: "")
                                            
                                            self.displaytime.text = NSLocalizedString("MessageFueling1", comment:"")
                                                   // self.displaytime.textColor = UIColor.black//+ ". Selected Hose \(Vehicaldetails.sharedInstance.SSId) and connected Hose \(self.cf.getSSID()) name is not Matched. Please check again."
            //                                    }
                                        }
                                        else
                                        if(self.showstart == "false"){
                                            self.start.isEnabled = false
                                            self.start.isHidden = true
                                            self.cancel.isHidden = true
                                            self.displaytime.text =  NSLocalizedString("MessageFueling1" , comment:"")
                                            //self.displaytime.textColor = UIColor.black//+ ". Selected Hose \(Vehicaldetails.sharedInstance.SSId) and connected Hose \(self.cf.getSSID()) name is not Matched. Please check again."
                                            print("return  false  by info command")
                                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + " \(Vehicaldetails.sharedInstance.SSId) " + NSLocalizedString("Wifi", comment:""))
                                        }
                                            if(self.showstart == "-1")
                                        {
                                            print("return  -1  by info command")
                                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                                        }
                                            if(self.showstart == "")
                                        {
                                            print("return \" \"  by info command")
                                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                                        }
                                        
                                        self.iswifi = true
                                        if(self.startbutton == "true")
                                        {
                                            print("startbutton")
                                        } else if(self.showstart == "invalid")
                                        {
                                            self.timerview.invalidate()
                                            self.error400(message: "Unable to verify the Connected link." )
                                        }
                                        }}
                                }
                                else
                                {
                                    self.displaytime.text =  NSLocalizedString("MessageFueling1" , comment:"")
                                    //self.displaytime.textColor = UIColor.black//+ ". Selected Hose \(Vehicaldetails.sharedInstance.SSId) and connected Hose \(self.cf.getSSID()) name is not Matched. Please check again."
                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(self.connectedwifi!)" + NSLocalizedString("Wifi", comment:""))
                                    
            //                        self.cf.delay(3){
            //                            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
            //                            let dateFormatter = DateFormatter()
            //                            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
            //                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            //                            let dtt: String = dateFormatter.string(from: NSDate() as Date)
            //
            //                            self.web.sentlog(func_name:" OnAppearing Fueling screen lost Wifi connection with the link, Date\(dtt)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")//errorfromserverorlink: " Connected link: \(self.cf.getSSID())", errorfromapp:" Selected Hose: \(Vehicaldetails.sharedInstance.SSId)")
            //
            //                            //self.timerview.invalidate()
            //                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(self.connectedwifi!)" + NSLocalizedString("Wifi", comment:""))
            //                            }
            //                        }
                                }
                                print(Vehicaldetails.sharedInstance.SSId,self.cf.getSSID())
                                
            //                    self.IsStartbuttontapped = false
                                self.cf.delay(4){
                                    if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID()){
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
                                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                                    let dtt: String = dateFormatter.string(from: NSDate() as Date)

                                    self.web.sentlog(func_name:" OnAppearing Fueling screen lost Wifi connection with the link, Date\(dtt)", errorfromserverorlink:" Hose: \(Vehicaldetails.sharedInstance.SSId)", errorfromapp: " Connected link: \(self.cf.getSSID())")

                                    //self.timerview.invalidate()
                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(self.connectedwifi!)" + NSLocalizedString("Wifi", comment:""))
                                    }
                                }
                            }
                        }

                    }
                }
            }
            }
    }
    
    

    
    @objc func gotostart(){
        isgotostartcalled = true
        self.timerview.invalidate()
        self.stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        self.timerview.invalidate()
        if(Cancel_Button_tapped == true)
        {
            self.web.sentlog(func_name:" Go to start cancel_botton tapped", errorfromserverorlink: "", errorfromapp: "")
        }
        else{
            
            if(IsStartbuttontapped == true){}  /// Is Start button tapped is true then do nothing
            else {
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                {
                    if(self.showstart == "true") {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
                    }
                    else
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                    }
                }
                else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                {
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
                    //potentialfix()
                }
                
                self.web.sentlog(func_name:" Fueling_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
                FDcheckBLEtimer.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
                stoptimer_gotostart.invalidate()
                stoptimergotostart.invalidate()
                self.timerview.invalidate()
            }
        }
    }

    @objc func goto_Start()
    {
        isgotostartcalled = true
        isviewdidDisappear = true
        self.timerview.invalidate()
        self.stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        self.timerview.invalidate()
        self.stoptimerIspulsarcountsame.invalidate()
        self.GetPulsarstartimer.invalidate()
        self.timer_quantityless_thanprevious.invalidate()
        if(Last_Count == nil ){
            Last_Count = "0"
        }
        print(Last_Count!)
        if(Float(Last_Count)! > 0 ){}
        else{
        if(Cancel_Button_tapped == true){}
        else{
            
            if(IsStartbuttontapped == true){}  /// Is Start button tapped is true then do nothing
            else {
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                {
                    if(self.showstart == "true") {
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
                    }
                    else
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                    }
                    
                    
//                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                    _ = self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
                }
                else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                {
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
                    web.potentialfix()
                }
                        
                stoptimer_gotostart.invalidate()
                stoptimergotostart.invalidate()
                
                self.timerview.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
                self.timerview.invalidate()
            }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        disconnectFromDevice()
        self.peripherals = []
//        self.kCBAdvDataLocalName = []
        print(Vehicaldetails.sharedInstance.PulseRatio)
        
        UIApplication.shared.isIdleTimerDisabled = true
        stoptimer_gotostart.invalidate()
        stoptimergotostart.invalidate()
        self.timerview.invalidate()
        //if user goes to the back ground and then come into the foreground and do nothing for 60 sec then it go to home screen
        //stoptimer_gotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(FuelquantityVC.gotostart), userInfo: nil, repeats: false)
        
        start.isEnabled = false
        start.isHidden = true
      //  Reconnect.isHidden = true
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.monospacedSystemFont(ofSize: 20, weight: .black)
            ]
            appearance.largeTitleTextAttributes = attrs
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 31.0/255.0, green: 77.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    self.navigationController?.navigationBar.tintColor = UIColor.white
                    self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    
        
        
        Warning.isHidden = true
        self.timerview.invalidate()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // self.disconnectFromDevice()
        if(Vehicaldetails.sharedInstance.HubLinkCommunication != "BT")
        {
        stoptimer_gotostart.invalidate()
        stoptimergotostart.invalidate()
        super.viewWillDisappear(animated)
        //if Transaction ID = 0 app stops the connection and send to fueling screen. Stops all Timer
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            self.timerview.invalidate()
            goto_Start()
            self.web.sentlog(func_name:" AppStops because transaction id 0, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
        }
        appdisconnects_automatically = false
            
        }
        else if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT"){
        if (isokbuttontapped == true)
        {}
        else{
        if(ifSubscribed == true){
            isviewdidDisappear = true
            self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
            NotificationCenter.default.removeObserver(self)
            self.updateIncomingData()
            self.disconnectFromDevice()
        }
        }
        }
    }
    
    override func viewDidLoad() {
        self.Activity.startAnimating()
        stoptimergotostart.invalidate()
        onFuelingScreen = true
        if((Vehicaldetails.sharedInstance.PulseRatio as NSString).doubleValue == 0)
        {
            gotostart()
        }
        super.viewDidLoad()
        
//        callObserver.setDelegate(self, queue: nil)
//        self.web.sentlog(func_name: " Communication Method Type \(Vehicaldetails.sharedInstance.HubLinkCommunication)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID()) ")
        
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP")
        {
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {}
            else
            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
            {
                self.web.wifisettings_check(pagename:"ViewDidLoad")
            }
            
        }
        else if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT"){
            
            if(ifSubscribed == true){}
            else if(ifSubscribed == false)
            {
                centralManager = CBCentralManager(delegate: self, queue: nil)
            }
            let notificationCenter = NotificationCenter.default
               notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
                
        self.navigationItem.title = "\(Vehicaldetails.sharedInstance.SSId)"
        wait.isHidden = true
        waitactivity.isHidden = true
        UsageInfoview.isHidden = true
        Pwait.isHidden = true
        
        connectedwifi = Vehicaldetails.sharedInstance.SSId
        
        Vehicaldetails.sharedInstance.gohome = false
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44));
        doneButton.setTitle(NSLocalizedString("Return", comment:""), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(PreauthFuelquantity.tapAction), for: UIControl.Event.touchUpInside);
        doneButton.backgroundColor = UIColor.black
        
        FQ.isHidden = false
        Stop.isHidden = true
        cancel.isHidden = false
        //  getdatafromsetting = true
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
                self.web.sentlog(func_name:" Saved Last Transaction to Phone, Date\(dtt1) TransactionId:\(lasttransID),FuelQuantity:\((fuelquantity)),Pulses:\(lastpulsarcount)", errorfromserverorlink: "Selected Hose : \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link : \( self.cf.getSSID())")
            }
        }
    }
    
    func Startfueling()
    {
        
        stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        
        print("before get relay" + cf.dateUpdated)
        let replygetrelay = self.web.getrelay()   ///get relay status to check link is busy or not
        let Split = replygetrelay.components(separatedBy: "#")
        reply = Split[0]
        let error = Split[1]
        //print(self.reply)
        if(self.reply == "-1"){
            
            let text = error//.localizedDescription //+ error.debugDescription
            let test = String((text.filter { !" \n".contains($0) }))
            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
            print(newString)
            self.web.sentlog(func_name:" GetRelay Function ", errorfromserverorlink: "\(newString)", errorfromapp: NSLocalizedString("wificonnection", comment:""))
            self.timerview.invalidate()
            self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
            
        }else{
            let data1:Data = self.reply.data(using: String.Encoding.utf8)!
            do{
                self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
                let text = error.localizedDescription //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.web.sentlog(func_name:" StartButtontapped GetRelay Function ", errorfromserverorlink: "\(newString)", errorfromapp:"\"Error: \(error.domain)")
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
                    
                    if(connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                    {
                        self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link after get relay.", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                        
                        self.timerview.invalidate()
                        self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                        self.IsStartbuttontapped = false
                        
                    } else {
                        
                        print("before setpulsaroffTime" + cf.dateUpdated)
                        
                       // self.tcpcon.setpulsaroffTime()   /// set pulsar off time to FS link
                        
                        print("after setpulsaroffTime" + cf.dateUpdated)
                        
                        if(connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                        {
                            self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link after setpulsaroffTime.",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")//
                            
                            self.timerview.invalidate()
                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                            self.IsStartbuttontapped = false
                        }else {
                            
                            print("before setSamplingtime" + cf.dateUpdated)
                            self.cf.delay(0.5){
                                let st = self.tcpcon.preauthsetSamplingtime()//setSamplingtime()  /// set Sampling time to FS link
                                
                                print("after setSamplingtime" + self.cf.dateUpdated)
                                print(st)
                                
                                print("before pulsarlastquantity" + self.cf.dateUpdated)
                                self.cf.delay(0.5){
                                    self.start.isHidden = true
                                    self.cancel.isHidden = true
                                    self.web.pulsarlastquantity()
                                    self.web.cmtxtnid10()   /// GET last 10 records from FS link
                                    
                                    print("pulsarlastquantity" + self.cf.dateUpdated)
                                    
//                                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")/////
                                    
                                    print("before getlastTrans_ID" + self.cf.dateUpdated)
                                    self.cf.delay(0.5){
                                        
                                        let lasttransID = self.web.getlastTrans_ID()   /// Get the previous Transaction ID from FS link.
                                        
                                        print("getlastTrans_ID" + self.cf.dateUpdated ,Vehicaldetails.sharedInstance.FinalQuantitycount)
                                        if(Vehicaldetails.sharedInstance.FinalQuantitycount == "")
                                        {
                                            //                                             self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                        }
                                        else{
                                            if(Vehicaldetails.sharedInstance.Last_transactionformLast10 == "")
                                            {
                                                self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                            }
                                            else{
                                                if(lasttransID == Vehicaldetails.sharedInstance.Last_transactionformLast10)
                                                {
                                                    self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                                    
                                                    self.web.sentlog(func_name:" Transaction id is matched.", errorfromserverorlink: lasttransID, errorfromapp:"\(Vehicaldetails.sharedInstance.Last_transactionformLast10)")
                                                    
                                                    Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
                                                }
                                                else
                                                {
                                                    self.web.sentlog(func_name:" Transaction is is not matched lasttransID with the Last_transactionformLast10 transaction id  .", errorfromserverorlink: lasttransID, errorfromapp:"\(Vehicaldetails.sharedInstance.Last_transactionformLast10)")
                                                    self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
                                                }
                                            }
                                        }
                                        
                                        if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                        {
                                            self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link after getlastTrans_ID", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                            
                                            self.timerview.invalidate()
                                            self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                                            
                                        } else {
                                            
                                            print("before settransaction_IDtoFS" + self.cf.dateUpdated)
                                            self.cf.delay(0.5){
                                                
                                                self.tcpcon.settransaction_IDtoFS()   ///Set the Current Transaction ID to FS link.
                                                
                                                print("settransaction_IDtoFS" + self.cf.dateUpdated)
                                                
                                                self.beginfuel1 = false
                                                self.displaytime.text = NSLocalizedString("Fueling", comment:"")//"Fueling…"  //3-4sec
                                               // self.displaytime.textColor = UIColor.black
                                                self.Pwait.isHidden = true
                                                
                                               // self.tcpcon.setdefault()
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
                                                        self.timerview.invalidate()
                                                        self.showAlertSetting(message: NSLocalizedString("CheckWifi", comment:""))//"Please check your wifi connection")
                                                    }
                                                }
                                                
                                                self.Activity.isHidden = true
                                                self.Activity.stopAnimating()
                                                
//                                                                                                self.tcpcon.setdefault()
//                                                                                                self.tcpcon.closestreams()
                                                
                                                self.cf.delay(0.5){
                                                    
                                                    print("before setpulsartcp" + self.cf.dateUpdated)
                                                    
                                                    
                                                    print("before Relay on0" + self.cf.dateUpdated)
                                                    var setrelayd = self.tcpcon.setralaytcp()
                                                    
                                                    print("Relay on0" + self.cf.dateUpdated)
                                                    
                                                    self.cf.delay(0.5){ //0.5
                                                        if(setrelayd == ""){        // if no response sent set relay command again
                                                            setrelayd = self.tcpcon.setralaytcp()
                                                            
                                                            print("Relay on1" + self.cf.dateUpdated)
                                                        }
                                                        self.cf.delay(0.5){//0.5
                                                            if(setrelayd == ""){        // if no response sent set relay command again
                                                                setrelayd = self.tcpcon.setralaytcp()
                                                                
                                                                print("Relay on1" + self.cf.dateUpdated)
                                                            }
                                                            if(setrelayd == ""){  // after 2 attempt stop relay goto home screen
                                                                self.cf.delay(0.5){
                                                                    _ = self.tcpcon.setralay0tcp()
                                                                    //     _ = self.tcpcon.setpulsar0tcp()
                                                                    
                                                                    print(self.cf.dateUpdated)
                                                                    self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                                }
                                                            }
//
                                                           else {
                                                               // self.setrelayon(setrelayd: setrelayd)
//                                                                let showstart = self.web.getinfo()
//                                                                print(showstart)
                                                                //setrelayd = "HTTP/1.0 200 OK\r\nContent-Length: 0\r\nServer: lwIP/1.4.0\r\n\n"
//                                                                if(showstart == "true"){
                                                                    let text = setrelayd
                                                                    let test = String((text.filter { !" \r\n".contains($0) }))
                                                                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                                                                    print(newString)
                                                                if(newString.contains("HTTP/1.0200OK"))
                                                                {
                                                                    self.start.isHidden = true
                                                                    self.cancel.isHidden = true
                                                                    self.Stop.isHidden = false  ///show stop button 7-8sec
                                                                    
                                                                   // self.tcpcon.setdefault()
                                                                    
                                                                    self.btnBeginFueling()
                                                                    
                                                                    print("Get Pulsar" + self.cf.dateUpdated)
                                                                    self.displaytime.text = ""
                                                                }
                                                                else
                                                                {
                                                                    self.setrelayon(setrelayd: setrelayd)
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
                    let alert = UIAlertController(title: "", message: NSLocalizedString("The link is busy, please try after some time.", comment:""), preferredStyle: UIAlertController.Style.alert)
                    let backView = alert.view.subviews.last?.subviews.last
                    backView?.layer.cornerRadius = 10.0
                    backView?.backgroundColor = UIColor.white
                    var messageMutableString = NSMutableAttributedString()
                    messageMutableString = NSMutableAttributedString(string: "The link is busy, please try after some time." as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
                    
                    alert.setValue(messageMutableString, forKey: "attributedMessage")
                    
                    let okAction = UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { [self] action in
                        
                        if(self.Last_Count == "0.0" || Last_Count == nil){
                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
                            //self.potentialfix()
                        }
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        // Call a method on the CustomController property of the AppDelegate
                        self.cf.delay(1) {     // takes a Double value for the delay in seconds
                            FDcheckBLEtimer.invalidate()
                            appDel.start()
                            self.Activity.style = UIActivityIndicatorView.Style.gray;
                            self.Activity.startAnimating()
                        }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setrelayon(setrelayd:String)
    {
        let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
        if(Split.count < 2){    /// Split.count<2
            
            let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
            if(Split.count < 2){
            _ = self.tcpcon.setralay0tcp()
            //   _ = self.tcpcon.setpulsar0tcp()
            self.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
            }
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
                self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            // print(self.setrelaysysdata)
            if(self.setrelaysysdata == nil){
                self.showAlert(message: "please retry")
            }
        }
        self.start.isHidden = true
        self.cancel.isHidden = true
        self.Stop.isHidden = false  ///show stop button 7-8sec
        
       // self.tcpcon.setdefault()
        
        self.btnBeginFueling()
        
        print("Get Pulsar" + self.cf.dateUpdated)
        self.displaytime.text = ""
    }

    
    @IBAction func startButtontapped(sender: AnyObject) {
        
        if(Cancel_Button_tapped == true){}
        else{
            
            //Start the fueling with buttontapped
            Vehicaldetails.sharedInstance.ifStartbuttontapped = true
            start.isEnabled = false
            IsStartbuttontapped = true
            stoptimergotostart.invalidate()
            self.stoptimer_gotostart.invalidate()
            self.timerview.invalidate()
            Vehicaldetails.sharedInstance.pulsarCount = ""
            if(AppconnectedtoBLE == true){
                
                getlast10transaction()
                IsStopbuttontappedBLE = false
                BLErescount = 0
                self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                outgoingData(inputText: "LK_COMM=relay:12345=ON")
                NotificationCenter.default.removeObserver(self)
                updateIncomingData ()
                
                self.cf.delay(0.1){
                    self.start.isHidden = true
                    self.cancel.isHidden = true
                    self.Stop.isHidden = false
                    self.displaytime.text = NSLocalizedString("Fueling", comment:"")
                    self.FDcheckBLEtimer.invalidate()
                    self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
                }
            }
            else if(AppconnectedtoBLE == false)
            {
                
                if(self.connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9")
                {
                    settransactionid()
                    self.consoleAsciiText = NSAttributedString(string: "")
                    self.newAsciiText = NSMutableAttributedString()
                    if(self.observationToken == nil){}
                    else{
                        NotificationCenter.default.removeObserver(self.observationToken!)
                    }
                    self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                    outgoingData(inputText: "LK_COMM=relay:12345=ON")
                    self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                    NotificationCenter.default.removeObserver(self)
                    updateIncomingData()
                    
                    if(self.BTMacAddress == true)
                        {
                        self.showAlert(message: "There is a MAC address error. Please contact Support")//"Invalid Link Mac Address. Please try again.")
                        self.cf.delay(6)
                        {
                            self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                            self.updateIncomingData()
                            self.disconnectFromDevice()
                                self.goto_Start()
                        }
    //                        self.showAlert(message: "Macaddress is not matched \(Vehicaldetails.sharedInstance.BTMacAddress)" )
                            
                        }
                    else{
                        IsStopbuttontappedBLE = false
                        BLErescount = 0
                        self.cf.delay(0.1){
                            self.start.isHidden = true
                            self.cancel.isHidden = true
                            self.Stop.isHidden = false
                            self.displaytime.text = NSLocalizedString("Fueling", comment:"")
                            self.FDcheckBLEtimer.invalidate()
                            self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
                        }
                    }
                }
                else{
                if(Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines) != self.cf.getSSID().trimmingCharacters(in: .whitespacesAndNewlines)) //check selected wifi and connected wifi is not same
                {
                    
                    self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())") //errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                    self.timerview.invalidate()
                    
                    self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                }
                else {
                    Startfueling()
                    self.cancel.isHidden = true
                }
            }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.timerview.invalidate()
        Cancel_Button_tapped = true
        if(IsStartbuttontapped == true){}
        else{
            
            let alert = UIAlertController(title: "Confirm", message: NSLocalizedString("Cancelwarning", comment:""), preferredStyle: UIAlertController.Style.alert)
            let backView = alert.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.white
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string: NSLocalizedString("Cancelwarning", comment:"") as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
            // messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:NSLocalizedString("Cancelwarning", comment:"").count))
            alert.setValue(messageMutableString, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: NSLocalizedString("YES", comment:""), style: UIAlertAction.Style.default) { action in
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                // Call a method on the CustomController property of the AppDelegate
                self.cf.delay(0.5) {
                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")//did not press start (start appeared, was never pressed):  User did not Press Start
                    }
                    else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
                    {
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
                        //self.potentialfix()
                    }
                    // put the delayed action/function here
                    let systemVersion = UIDevice.current.systemVersion
                    print("iOS\(systemVersion)")
                    
                    //iPhone or iPad
                    let model = UIDevice.current.model
                    
                    print("device type=\(model)")
                    self.web.sentlog(func_name: " CancelButtonTapped", errorfromserverorlink: "", errorfromapp: "")
                    appDel.start()
                    self.Activity.style = UIActivityIndicatorView.Style.gray;
                    self.Activity.startAnimating()
                    self.timerview.invalidate()
                }
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment:""), style: UIAlertAction.Style.cancel) { (submitn) -> Void in
                self.Cancel_Button_tapped = false
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func error400(message: String)
    {
        self.timerview.invalidate()
        
        //        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        //        {
        if(Last_Count == "0.0" || Last_Count == nil){
            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
            //potentialfix()
        }
        //        }
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            
            self.cf.delay(1){
                self.timerview.invalidate()
                Vehicaldetails.sharedInstance.gohome = true
                self.IsStartbuttontapped = true
                self.stoptimergotostart.invalidate()
                self.stoptimer_gotostart.invalidate()
                self.timerview.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                self.web.sentlog(func_name:" error400 Message ", errorfromserverorlink: "", errorfromapp: message)
                appDel.start()
                self.stopdelaytime = true
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func showAlertSetting(message: String)
    {
        //if #available(iOS 11.0, *){
        
        if(AppconnectedtoBLE == true)
        {
            
        }else
        {
            self.cf.delay(0.3){
                print(Vehicaldetails.sharedInstance.SSId, Vehicaldetails.sharedInstance.fsSSId)
                self.web.wifisettings(pagename:"Retry")
                let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
                hotspotConfig.joinOnce = true
                
                NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
                    
                    if let error = error {
                        // self.showError(error: error)
                        print("Error\(error)")
                        self.web.wifisettings(pagename:"Retry")
                        self.countwififailConn += 1
                        print(self.countwififailConn)
                        if(self.countwififailConn == 3){
                            self.showAlert(message: "Please connect to link \(Vehicaldetails.sharedInstance.SSId)" + "manually using the 'WIFI settings' screen." )
                            
                        }
                        self.web.sentlog(func_name:"try to Connect wifi link \(Vehicaldetails.sharedInstance.SSId)" + " Attempt \(self.countwififailConn)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                    else {
                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                            
                        }
                        self.web.sentlog(func_name:" Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from FuelquantityVC Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                   
                        print("Connected")
                    }
                }
            }
        }
        
        if(Cancel_Button_tapped == true){}
        else if(isgotostartcalled == true){
            self.timerview.invalidate()
        }
        else{
            self.timerview.invalidate()
            Vehicaldetails.sharedInstance.gohome = false
            self.resumetimer()
        }
    }

    func resumetimer(){
        self.timerview.invalidate()
        self.timerview = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(PreauthFuelquantity.viewDidAppear(_:)), userInfo: nil, repeats: true)
    }
   
    func displaymessage(message: String)
    {
        self.timerview.invalidate()
        
  
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        let message  = message
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
        
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        // Action.
        let action =  UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { action in //self.//
            
            self.cf.delay(1){
                self.timerview.invalidate()
                Vehicaldetails.sharedInstance.gohome = true
                self.IsStartbuttontapped = true
                self.stoptimergotostart.invalidate()
                self.stoptimer_gotostart.invalidate()
                self.timerview.invalidate()
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                self.web.sentlog(func_name:" error400 Message ", errorfromserverorlink: "", errorfromapp: message)
                appDel.start()
                self.stopdelaytime = true
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func stopButtontapped()
    {
        
        
        if(AppconnectedtoBLE == true ){
            
            if(self.connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9")
            {
                
//                 if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
//                 {
//                     self.uploadbinfile()
//                     self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                     self.Firmwareupdatedemo()
//                     _ = self.web.UpgradeCurrentiotVersiontoserver()
//                     self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//
//
//                 }
                
                self.IsStopbuttontappedBLE = true
                self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
                self.consoleAsciiText = NSAttributedString(string: "")
                self.newAsciiText = NSMutableAttributedString()
                if(self.observationToken == nil){}
                else{
                    NotificationCenter.default.removeObserver(self.observationToken!)
                }
                self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                outgoingData(inputText: "LK_COMM=relay:12345=OFF")
//                        self.cf.delay(0.1){
                
              
               
                NotificationCenter.default.removeObserver(self)
                updateIncomingData()
                self.Stop.isEnabled = false
                self.Stop.isHidden = true
                self.wait.isHidden = false
                self.waitactivity.isHidden = false
                IsStopbuttontapped = true
                self.FDcheckBLEtimer.invalidate()
            }
            else{
           self.IsStopbuttontappedBLE = true
           self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
           
           
           if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
           {
              
               if(self.AppconnectedtoBLE == true)
               {
                  // let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
                   //    self.renamelink(SSID:trimmedString)
                 //  _ = self.web.SetHoseNameReplacedFlag()
               }
               
           }
           self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
            NotificationCenter.default.removeObserver(self)
           self.updateIncomingData()
         
           self.Stop.isEnabled = false
           self.Stop.isHidden = true
           self.wait.isHidden = false
           self.waitactivity.isHidden = false
           IsStopbuttontapped = true
           self.FDcheckBLEtimer.invalidate()
           self.cf.delay(10){
               do{
                   if(self.isDisconnect_Peripheral == true )
                   {
                       self.web.sentlog(func_name:"Stopbuttontapped but App lost the connection with the BT link ",errorfromserverorlink: "", errorfromapp:"")
                       try self.stoprelay()
                   
                   }
               }

               catch let error as NSError {
                   print ("Error: \(error.domain)")
               }
           }
            }
       }
        else if(AppconnectedtoBLE == false)
        {
            Stop.isEnabled = false
            Stop.isHidden = true
            wait.isHidden = false
            waitactivity.isHidden = false
            waitactivity.startAnimating()
            self.GetPulsarstartimer.invalidate()
            self.timerview.invalidate()
            self.stoptimerIspulsarcountsame.invalidate()
            
            if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
                Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
            }
            print("stopButtontapped" + cf.dateUpdated)
            string = ""
            cf.delay(0.5){
                self.GetPulsarstartimer.invalidate()
                self.timerview.invalidate()
                if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                {
                    self.web.sentlog(func_name:" StopButtontapped lost Wifi connection with the link ",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                    
                    self.timerview.invalidate()
                    do{
                        try self.stoprelay()
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                        self.web.sentlog(func_name:" stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                    }
                }else {
                    
                    print("Before relayoff 0" + self.cf.dateUpdated)
                    var setrelayd = self.tcpcon.setralay0tcp()
                    self.cf.delay(0.5){
                        
                        if(setrelayd == ""){
                            if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.web.sentlog(func_name:" StopButtontapped lost Wifi connection with the link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")//errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
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
                                if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                {
                                    self.web.sentlog(func_name:" StopButtontapped lost Wifi connection with the link ", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")//errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
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
                                    //_ = self.tcpcon.setralay0tcp()
                                    //_ = self.tcpcon.setpulsar0tcp()
                                    self.web.sentlog(func_name: " StopButtontapped set relay off command Response from link is $$ \(setrelayd)!!",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())") //errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
                                    // self.web.UpdateInterruptedTransactionFlag() /// 1168 if relay off is not working then app sends to server Transaction id.
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
                            self.InterruptedTransactionFlag = false
                            print("after set relayoff 0" + self.cf.dateUpdated)
                            let Split = setrelayd.components(separatedBy: "{")
                            if(Split.count < 3){
                                // _ = self.tcpcon.setralay0tcp()
                                // _ = self.tcpcon.setpulsar0tcp()
                                
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
                                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                }
                                catch let error as NSError {
                                    print ("Error: \(error.domain)")
                                    self.web.sentlog(func_name: "stopButtontapped", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                }
                                
                                print(setrelayd)
                                                               
                                self.cf.delay(0.5){
                                    
                                    if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                                    {
                                        self.web.sentlog(func_name:" StopButtontapped lost Wifi connection with the link ",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                        
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
                                        self.GetPulsarstartimer.invalidate()
                                        self.string = ""
                                        //                                    self.tcpcon.setdefault()
                                        //                                    self.tcpcon.closestreams()
                                        self.cf.delay(0.5){
                                            let finalpulsar = self.web.GetPulser()
                                            print(finalpulsar)
                                            let Split = finalpulsar.components(separatedBy: "{")
                                            print("Splitcout\(Split.count)")
                                            if(Split.count < 3){
                                                //_ = self.tcpcon.setralay0tcp()
                                                
                                                //                                                _ = self.tcpcon.setpulsar0tcp()
                                                
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
                                                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                                }catch let error as NSError {
                                                    print ("Error: \(error.domain)")
                                                }
                                                //         print(self.sysdata1,"pulsar_status")
                                                if(self.sysdata1 == nil){}
                                                else{
                                                    let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                                                    // print(self.Last_Count as NSString)
                                                    if(self.Last_Count == nil){
                                                        self.Last_Count = "0.0"
                                                    }
                                                    if((self.Last_Count as NSString).doubleValue < (objUserData.value(forKey: "counts") as! NSString).doubleValue || (self.Last_Count as NSString).doubleValue == (objUserData.value(forKey: "counts") as! NSString).doubleValue) {
                                                        self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                        
                                                    }else{
                                                        self.counts = self.Last_Count
                                                        // print(self.Last_Count)
                                                    }
                                                    print((self.counts as NSString).doubleValue , (objUserData.value(forKey: "counts") as! NSString).doubleValue , (self.counts as NSString).doubleValue , (objUserData.value(forKey: "counts") as! NSString).doubleValue)
                                                    //self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                    
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
                                                
                                                //
                                                self.cf.delay(0.5) {
                                                    
                                                    print("before set setpulsar0tcp" + self.cf.dateUpdated)
                                                    // _ = self.tcpcon.setpulsar0tcp()
                                                    if( self.connectedwifi == SSID  || "FUELSECURE" == SSID)
                                                    {
                                                        print(Vehicaldetails.sharedInstance.SSId)
                                                        print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                                                        self.cf.delay(0.1) {     // takes a Double value for the delay in seconds
                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                                if(self.AppconnectedtoBLE == true)
                                                                {
                                                                    let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
                                                         //           self.renamelink(SSID:trimmedString)
                                                                }
                                                                else{
                                                                let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
                                                                    self.tcpcon.changessidname(wifissid: trimmedString)
                                                                }
                                                                _ = self.web.SetHoseNameReplacedFlag()
//                                                                print(Vehicaldetails.sharedInstance.ReplaceableHoseName)
//                                                                let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
//                                                                self.tcpcon.changessidname(wifissid: trimmedString)
//                                                                // self.tcpcon.changessidname(wifissid: Vehicaldetails.sharedInstance.ReplaceableHoseName)
                                                            }
                                                            
                                                            
                                                            // put the delayed action/function here
                                                            print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
//                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
//                                                                _ = self.web.SetHoseNameReplacedFlag()
//                                                            }
                                                            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                                                                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                                                                //       print(self.counts)
                                                                self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")
                                                                self.cf.delay(0.5){
                                                                    //     print("before set tldlevel" + self.cf.dateUpdated)
                                                                    self.Transaction(fuelQuantity: self.fuelquantity)
                                                                    
                                                                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                                                                    {
                                                                    }
                                                                    else {
                                                                        // let replytld = self.tcpcon.tlddata()
                                                                        //                                                                    self.tcpcon.setdefault()
                                                                        //                                                                    self.tcpcon.closestreams()
                                                                        //                                                                    if(Vehicaldetails.sharedInstance.IsTLDdata == "True")
                                                                        //                                                                    {
                                                                        //                                                                        let replytld = self.web.tldlevel()
                                                                        //                                                                        if(replytld == "" || replytld == "nil"){}
                                                                        //                                                                        else{
                                                                        //                                                                            self.tcpcon.sendtld(replytld: replytld)
                                                                        //                                                                        }
                                                                        //                                                                    }
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
                                                                        _ = self.web.getinfo()//self.tcpcon.Getinfo()//self.web.getinfo()
                                                                        if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                                                            _ = self.web.UpgradeCurrentVersiontoserver()
                                                                        }
                                                                        Vehicaldetails.sharedInstance.IsUpgrade = "N"
                                                                        self.cf.delay(30){
                                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
                                                                            {
                                                                                self.displaymessage(message:"We have renamed your LINK to the given name in the Cloud. Please close App and reopen")
                                                                                Vehicaldetails.sharedInstance.IsHoseNameReplaced = "Y"
                                                                                self.stopdelaytime = true
                                                                            }else{
                                                                            Vehicaldetails.sharedInstance.gohome = true
                                                                            self.timerview.invalidate()
                                                                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                                            self.web.sentlog(func_name: "stopButtontapped 30 delay", errorfromserverorlink: "", errorfromapp: "")
                                                                            appDel.start()
                                                                            }
                                                                        }
                                                                    }
                                                                    if (self.stopdelaytime == true){}
                                                                    else{
                                                                        Vehicaldetails.sharedInstance.gohome = true
                                                                        self.timerview.invalidate()
                                                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                                                        self.web.sentlog(func_name: "stopButtontapped ", errorfromserverorlink: "", errorfromapp: "")
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
                                                                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                                                                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "5")
                                                            }
                                                        }
                                                    }
                                                }
                                                //                                            }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if(self.InterruptedTransactionFlag == true)
                        {
                            self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "y") /// 1168 if relay off is not working then app sends to server Transaction id.
                        }
                    }
                }
                
            }
        }
    }

    
    
    func SenddataTransaction(quantitycount:String,PulseRatio:String)
    {
        cf.delay(0.5) {     // takes a Double value for the delay in seconds
            // put the delayed action/function here
            
            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
                self.web.sentlog(func_name: " StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.tcpcon.getuser()
            }else{}
            self.cf.delay(1){
                self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
                if(self.fuelquantity == nil || self.fuelquantity == 0.0){
                    if(quantitycount == "0" || quantitycount == "0.0"){
                        if(self.IsStartbuttontapped == true){
                            self.error400(message: NSLocalizedString("Pump ON Time Reached", comment: ""))//"NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                        }
                       else if(self.Cancel_Button_tapped == true)
                        {
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        appDel.start()
                        self.timerview.invalidate()
                            self.stoptimergotostart.invalidate()
                            self.stoptimer_gotostart.invalidate()
                            self.timerview.invalidate()
                            self.web.sentlog(func_name:" Go to start cancel_botton tapped", errorfromserverorlink: "", errorfromapp: "")
                       
                        self.stoptimer_gotostart.invalidate()
                        self.stoptimergotostart.invalidate()
                        self.timerview.invalidate()
                        
                    }
                }
            }
//                    self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                
                else{
                    print(self.fuelquantity!)
                    if(self.fuelquantity > 0){
                        
                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                        }
                        else {
                            self.Quantity1.text = "\(String(format: "%.2f", self.fuelquantity))"
                        }
                        
                        self.pulse.text = "\(self.Last_Count!)"
                        // print(self.Last_Count)
                        self.totalquantityinfo.text = NSLocalizedString("ThankyouMSG", comment:"")//"Thank you for using \nFluidSecure!"
                        
                        self.cf.delay(0.5){
                            self.Transaction(fuelQuantity: self.fuelquantity)
                            //self.tcpcon.setdefault()
                            
                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                            {
                            }
                            else {
                                // let replytld = self.tcpcon.tlddata()
                                //                            if(Vehicaldetails.sharedInstance.IsTLDdata == "True")
                                //                            {
                                //                                let replytld = self.web.tldlevel()
                                //                                if(replytld == "" || replytld == "nil"){}
                                //                                else{
                                //                                    self.tcpcon.sendtld(replytld: replytld)
                                //                                }
                                //                            }
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
                                _ = self.web.getinfo()//self.tcpcon.Getinfo()//self.web.getinfo()
                                if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                    _ = self.web.UpgradeCurrentVersiontoserver()
                                }
                                Vehicaldetails.sharedInstance.IsUpgrade = "N"
                                
//                                self.cf.delay(30){
//                                    self.FDcheckBLEtimer.invalidate()
//                                    Vehicaldetails.sharedInstance.gohome = true
//                                    self.timerview.invalidate()
//                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                    //self.web.sentlog(func_name: "stoprelay function 30 delay ", errorfromserverorlink: "", errorfromapp: "")
//                                    appDel.start()
//                                }
                            }
                            if (self.stopdelaytime == true){}
                            else{
                                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
                                {
                                    self.displaymessage(message:"We have renamed your LINK to the given name in the Cloud. Please close App and reopen")
                                    Vehicaldetails.sharedInstance.IsHoseNameReplaced = "Y"
                                    self.stopdelaytime = true
                                }else{
                                Vehicaldetails.sharedInstance.gohome = true
                                self.timerview.invalidate()
                                    self.FDcheckBLEtimer.invalidate()
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                //self.web.sentlog(func_name: "stoprelay function ", errorfromserverorlink: "", errorfromapp: "")
                                appDel.start()
                                }
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
                        //self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                    }
                }
            }
        }
    }

    
    
    func renamelink(SSID:String)
    {
        sendrename_linkname = true
        let MessageuDP = "LK_COMM=name:\(SSID)"
            self.outgoingData(inputText:MessageuDP)
        NotificationCenter.default.removeObserver(self)
            self.updateIncomingData()
        self.web.sentlog(func_name: "Sent LK_COMM=name:\(SSID) command to link", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
        //self.receiveUDP()
        
    }
    
    func stoptransaction()
    {
        let quantitycount = self.Last_Count! //Vehicaldetails.sharedInstance.pulsarCount
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
        
        if( Vehicaldetails.sharedInstance.SSId == SSID)
        {
            SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
        }
    }
    
    @objc func stoprelay() throws  {
        if(Last_Count == nil){
            Last_Count = "0.0"
        }

        FDcheckBLEtimer.invalidate()
        //check here if it is connected to BLE or Link.
        
        if(ifSubscribed == true){}
        else{
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
            {
                // _ = self.tcpcon.setralay0tcp()
                //            _ = self.tcpcon.setpulsar0tcp()
            }
        }
        self.stoptimerIspulsarcountsame.invalidate()
        self.timerview.invalidate()
        self.GetPulsarstartimer.invalidate()
        //Stop.isHidden = true
        //timer_noConnection_withlink.invalidate()
        timer_quantityless_thanprevious.invalidate()
        stoptimergotostart.invalidate()
        stoptimer_gotostart.invalidate()
        
        let SSID:String = cf.getSSID()
        print(SSID)
        print(Vehicaldetails.sharedInstance.SSId)
        print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
        {
            if(AppconnectedtoBLE == true)
            {
                let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
               // renamelink(SSID:trimmedString)
            }
            else{
            let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
            tcpcon.changessidname(wifissid: trimmedString)
            }
//            let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
//            tcpcon.changessidname(wifissid: trimmedString)
        }
        if(self.InterruptedTransactionFlag == true)
        {
            self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "y") /// 1168 if relay off is not working then app sends to server Transaction id.
        }
        
//        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
//            _ = self.web.SetHoseNameReplacedFlag()
//        }
        if(Vehicaldetails.sharedInstance.PulseRatio == "" || Vehicaldetails.sharedInstance.pulsarCount == "" ){
            self.web.sentlog(func_name: " PulsarCount,PulseRatio is null or nil" , errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
            FDcheckBLEtimer.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.stoptimerIspulsarcountsame.invalidate()
            self.timerview.invalidate()
            self.GetPulsarstartimer.invalidate()
            timer_quantityless_thanprevious.invalidate()
            stoptimergotostart.invalidate()
            stoptimer_gotostart.invalidate()
            //self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
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
                sourcelat = 0.0
                sourcelong = 0.0

            }
            else {
                sourcelat = Vehicaldetails.sharedInstance.Lat//currentlocation.coordinate.latitude
                sourcelong = Vehicaldetails.sharedInstance.Long//currentlocation.coordinate.longitude
               // print (sourcelat,sourcelong)
            }
            let siteid = Vehicaldetails.sharedInstance.siteID
            let FuelTypeId = Vehicaldetails.sharedInstance.FuelTypeId
            let pusercount :String
            defaults.set("", forKey: "previouspulsedata")
            if(self.Last_Count == nil){
                pusercount = Vehicaldetails.sharedInstance.pulsarCount
            }else{
                pusercount = self.Last_Count!
            }
            var Odomtr = Vehicaldetails.sharedInstance.Odometerno
            if(Odomtr == ""){
                Odomtr = "0"
            }
            
            var Hours = Vehicaldetails.sharedInstance.hours
            if(Hours == ""){
                Hours = "0"
            }
            
            let Wifyssid = Vehicaldetails.sharedInstance.SSId
            let pulser_count = Vehicaldetails.sharedInstance.pulsarCount
    
            let TransactionId = "\(Vehicaldetails.sharedInstance.TransactionId)"
            if(TransactionId == "0")
            {
    
            }
    //        let v_no = "\(Vehicaldetails.sharedInstance.vehicleno)"
    //        let lat = sourcelat!
    //        let lon = sourcelong!
    //        let version = Version
    //        let deivcetype = UIDevice().type
    //        let UIDevicesystemVersion = UIDevice.current.systemVersion
    
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" //9/25/2017 10:21:41 AM"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt: String = dateFormatter.string(from: NSDate() as Date)
    
            print(Wifyssid)
            print(Odomtr)
            print(Vehicaldetails.sharedInstance.vehicleno,sourcelat!,sourcelong!,Version,UIDevice().type,UIDevice.current.systemVersion)
            
//            "ErrorCode":Errorcode,
//            "FOBNumber":FOBNumber,
//            "Barcode":Barcode,
//            "WifiSSId":wifiSSID,
//            "SiteId":siteid,
//            "DepartmentNumber":isdept,
//            "PersonnelPIN":"\(isPPin)",
//            "Other":"\(isother)",
//            "Hours":"\(hour)",
//            "VehicleExtraOther": VehicleExtraOther,
            
            let bodyData = "{\"SiteId\":\(siteid),\"CurrentOdometer\":\(Odomtr),\"FuelQuantity\":\((fuelQuantity)),\"TransactionId\":\(TransactionId),\"FuelTypeId\":\(FuelTypeId),\"WifiSSId\":\"\(Wifyssid)\",\"TransactionDate\":\"\(dtt)\",\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"VehicleNumber\":\"\(Vehicaldetails.sharedInstance.vehicleno)\",\"ErrorCode\":\"\(Vehicaldetails.sharedInstance.Errorcode)\",\"DepartmentNumber\":\"\(Vehicaldetails.sharedInstance.deptno)\",\"Hours\":\(Hours),\"VehicleExtraOther\":\"\(Vehicaldetails.sharedInstance.ExtraOther)\",\"Other\":\"\(Vehicaldetails.sharedInstance.Other)\",\"PersonnelPIN\":\"\(Vehicaldetails.sharedInstance.Personalpinno)\",\"CurrentLng\":\"\(sourcelong!)\",\"CurrentLat\":\"\(sourcelat!)\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\"}"
            print(bodyData)
    
            let reply = web.Transactiondetails(bodyData: bodyData)
            if (reply == "-1")
            {
                let jsonstring: String = bodyData
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                let dtt1: String = dateFormatter.string(from: Date())
    
                if(TransactionId == "0"){}
                else{
                    let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //Vehicaldetails.sharedInstance.siteName
                    cf.preauthSaveTextFile(fileName: unsycnfileName, writeText: jsonstring)
                    cf.delay(0.2){
                        
                    }
                }
            }
    
            else{
    
                let data1:Data = reply.data(using: String.Encoding.utf8)!
                do{
                    sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                }catch let error as NSError {
                    print ("Error: \(error.domain)")
                }
            //    print(sysdata)
    
                notify(site: Vehicaldetails.sharedInstance.SSId)
                cf.delay(0.2){
    
                }
            }
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let entityDescription = NSEntityDescription.entity(forEntityName: "TransactionID",in: managedObjectContext)
            let ID = TransactionID(entity: entityDescription!, insertInto: managedObjectContext)
    
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
    

    
    

    
    @IBAction func Stop(sender: AnyObject) {
        //        record = []
        let label1 = UILabel(frame: CGRect(x: 40, y: 80, width: 500, height: 21))
        y = y + 20
        label1.center = CGPoint(x: 80,y: y)
        label1.textAlignment = NSTextAlignment.center
        //label1.textColor = UIColor.white
        label1.text = "Output: \(string)"
        self.web.sentlog(func_name:" StopButtontapped",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
        stopButtontapped()
    }
    
    

    func btnBeginFueling() {
        
        print("before GetPulser" + cf.dateUpdated)
        self.cf.delay(0.5){
            //self.GetPulser() ///
            self.quantity = []
            self.countfailConn = 0
        
            self.defaults.set(true, forKey: "InterruptedTransactionFlag")
//            self.defaults.set(Vehicaldetails.sharedInstance.PulseRatio, forKey: "pulsarratio")
            
            print("Get Pulsar1" + self.cf.dateUpdated)
         self.GetPulsarstartimer.invalidate()
            self.web.sentlog(func_name: " Send GetPulsar Request Function", errorfromserverorlink: "", errorfromapp: "")
            self.GetPulsarstartimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
            print("after GetPulser" + self.cf.dateUpdated)
            print(self.GetPulsarstartimer)
        }
    }
    //    func btnBeginFueling()
    //{
//
//        print("before GetPulser" + cf.dateUpdated)
//        self.cf.delay(0.5){
//            //self.GetPulser() ///
//            self.quantity = []
//            self.quantitysavetime = []
//            self.countfailConn = 0
//
//            self.defaults.set(true, forKey: "InterruptedTransactionFlag")
////            self.defaults.set(Vehicaldetails.sharedInstance.PulseRatio, forKey: "pulsarratio")
//
//            print("Get Pulsar1" + self.cf.dateUpdated)
//            self.timer.invalidate()
//            self.web.sentlog(func_name: " Send GetPulsar Request Function", errorfromserverorlink: "", errorfromapp: "")
//            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
//            print("after GetPulser" + self.cf.dateUpdated)
//            print(self.timer)
//        }
//    }

    @objc func GetPulser()
    {
        //if Transaction ID = 0 app stops the connection and send to fueling screen. Stops all Timer
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            self.GetPulsarstartimer.invalidate()
            self.timerview.invalidate()
            gotostart()
            self.GetPulsarstartimer.invalidate()
            self.web.sentlog(func_name:" AppStops because transaction id 0, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
        }
        else
        {
        
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
        //self.Last_Count = "0"
        if(Last_Count == nil){
            Last_Count = "0.0"
        }
        
        let replyGetpulsar1 = web.GetPulser()
        
        print(replyGetpulsar1)
        let Split = replyGetpulsar1.components(separatedBy: "#")
        reply1 = Split[0]
        //let error = Split[1]
        //  print(reply1)
        if(self.reply1 == nil || self.reply1 == "-1")
        {
            //no response from link timeout
            if(Last_Count == nil){
                Last_Count = "0.0"
            }
            let text = reply1//error.localizedDescription + error.debugDescription
            let test = String((text?.filter { !" \n".contains($0) })!)
            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
            print(newString)
            self.web.sentlog(func_name: " Pulser ", errorfromserverorlink: "\(Last_Count!)", errorfromapp: "")
            sendtransactioncausereinstate = true
            //defaults.setValue(Last_Count, forKey: "reinstatingtransaction")
            
            if(sendtransactioncausereinstate == true)
            {
                 let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(Last_Count as String)!)
                 Sendtransaction(fuelQuantity: "\(FuelQuan)")
             Interrupted_TransactionFlag = "y"
                 self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: Interrupted_TransactionFlag)
                appdisconnects_automatically = true
               
             //web.sentlog(func_name: "TXTN ID: \(Vehicaldetails.sharedInstance.TransactionId),Flag: \(Interrupted_TransactionFlag)", errorfromserverorlink: "", errorfromapp: "")
             
                
                 sendtransactioncausereinstate = false
             
            }
            countfailConn += 1
            print(countfailConn)
            if(countfailConn == 2){
                if #available(iOS 11.0, *) {
                    // NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: SSID)
                    if(reinstatingtransactionattempts == 2)
                    {}
                    else{
                    playAlarm()
                    displaytime.text = NSLocalizedString("Reconnect" , comment:"")
                    displaytime.textColor = UIColor.red
                    self.web.wifisettings(pagename:"Getpulsar_fuelquantity")
                    }
                    // countfailConn = 0
                } else {
                    // Fallback on earlier versions
                }
                
            }else if(countfailConn > 2) {
                do{
                    reinstatingtransactionattempts = reinstatingtransactionattempts + 1
                    print(reinstatingtransactionattempts,countfailConn)
                    if(reinstatingtransactionattempts > 3)
                    {
                        displaytime.text = ""
                        self.timerview.invalidate()
                        try! stoprelay()
                        
                        self.web.sentlog(func_name: " reinstating transaction attempts > 3 auto stops transaction.", errorfromserverorlink: "\(Last_Count!)", errorfromapp: "")
                    }
                    else{
//                    playAlarm()
                    displaytime.text = NSLocalizedString("Reconnect" , comment:"")//"Reconnecting to pump, please wait briefly. Do not turn pump off."
                    displaytime.textColor = UIColor.red
                    reinstatingtransaction = true
                    if(Last_Count == nil){
                        Last_Count = "0.0"
                    }
                  
                       
                    defaults.setValue(Last_Count, forKey: "reinstatingtransaction")   // save Last_Count as previous value
                        self.web.sentlog(func_name: "pulse count\(Last_Count!) save to app and link resets. ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                    appdisconnects_automatically = true
                    self.stoptimerIspulsarcountsame.invalidate()
                    self.timerview.invalidate()
                   // self.GetPulsarstartimer.invalidate()
                    //self.GetPulsarstartimer.invalidate()
                    
                    timer_quantityless_thanprevious.invalidate()
                    stoptimergotostart.invalidate()
                    stoptimer_gotostart.invalidate()
                        cf.delay(0.1){
                            self.IsStartbuttontapped = false
                            self.resumetimer() /// reinstate the transaction.
                            self.viewDidAppear(true)
                            self.countwififailConn = 0
                        }
                    }
                }
                catch let error as NSError {
                    print ("Error: \(error.domain)")
                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                }
            }
        }
        else
        {
            //timer_noConnection_withlink.invalidate()
            let data1 = self.reply1.data(using: String.Encoding.utf8)!
            do{
                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                let text = error.localizedDescription //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                self.web.sentlog(func_name: " Pulsar :", errorfromserverorlink: "\(Last_Count!)", errorfromapp: "")
                print ("Error: \(error.domain)")
            }
            
            if(self.sysdata1 == nil){}
            else
            {
                // print(reply1)
                let text = reply1
                let test = String((text?.filter { !" \n".contains($0) })!)
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
                //  print(sysdata1)
                let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                
                var counts = objUserData.value(forKey: "counts") as! NSString
                let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                let pulsar_secure_status = objUserData.value(forKey: "pulsar_secure_status") as! NSNumber
//                if (reinstatingtransaction == true)
//                {
////                    let pulsedata = defaults.string(forKey: "reinstatingtransaction")
////                    print(pulsedata!,counts)
////                    let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
////                    print(pulsedata!,counts,totalpulsecount)
//                    Last_Count = counts as String //+ defaults.string(forKey: "reinstatingtransaction")!
//
//                }
//                else
//                {
                if(Last_Count == nil){
                    Last_Count = "0.0"
                }
                
                if(counts.doubleValue >= (Last_Count as NSString).doubleValue)
                {
                    self.Last_Count = counts as String?
                }
                else
                {
                    if(appdisconnects_automatically == true)
                    {
                       
                    }
                    else{
                        appdisconnects_automatically = true /// added this line because link is reset but not got the confirmation from link to app no timeout happends here if Last count  > count then
                        
                        counts = Last_Count as NSString
                        
                    }
                }
                    
               
//                }
                //transactiondata(Pulsarcount: Last_Count)
                self.defaults.set(self.Last_Count, forKey: "LastCount")//previouspulsedata
                if(appdisconnects_automatically == true){}
                else{
                self.web.sentlog(func_name: " Pulsar :", errorfromserverorlink: " \(Last_Count!)",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                }
                if (counts == ""){
                    self.emptypulsar_count += 1
                    if(self.emptypulsar_count == 3){
                        Vehicaldetails.sharedInstance.gohome = true
                        self.timerview.invalidate()
                        self.stoptimerIspulsarcountsame.invalidate()
                     self.GetPulsarstartimer.invalidate()
                       
                        //timer_noConnection_withlink.invalidate()
                        self.timer_quantityless_thanprevious.invalidate()
                        self.stoptimergotostart.invalidate()
                        self.stoptimer_gotostart.invalidate()

                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        self.web.sentlog(func_name: " Get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                        appDel.start()
                        self.timerview.invalidate()
                        
                    }
                }
                else if (counts == "0")
                {
                    if(Last_Count == nil){
                        Last_Count = "0.0"
                    }
                    let v = self.quantity.count
                    self.quantity.append("0")
                    if(v >= 2){
                        print(self.quantity[v-1],self.quantity[v-2])
                        if(self.quantity[v-1] == self.quantity[v-2]){
                            self.total_count += 1
                            if(self.total_count >= 3){
                                Ispulsarcountsame = true
                                stoptimerIspulsarcountsame.invalidate()
                                Samecount = Last_Count
                                
                                
                                Samecount = Last_Count
                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                
                                self.web.sentlog(func_name:"Get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpon_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                            }}}
                }
                else{
                    
                    self.emptypulsar_count = 0
                    if (counts != "0"){
                        displaytime.text = ""
                        if(appdisconnects_automatically == true){
                            //self.web.sentlog(func_name:"appdisconnects_automatically: \(appdisconnects_automatically) sendInterrupted_TransactionFlagN: \(sendInterrupted_TransactionFlagN)", errorfromserverorlink: "", errorfromapp: "")
                                if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
                                    Ispulsarcountsame = false
                                    stoptimerIspulsarcountsame.invalidate()
                                }
                            var pulsedata = defaults.string(forKey: "reinstatingtransaction")
                            if(Interrupted_TransactionFlag == "y")
                            {
                                self.InterruptedTransactionFlag = false
                                if((pulsedata! as NSString).doubleValue > 0)
                                {
                                    Interrupted_TransactionFlag = "n"
                                    self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "n")
                                   // web.sentlog(func_name: "TXTN ID: \(Vehicaldetails.sharedInstance.TransactionId),Flag: \(Interrupted_TransactionFlag)", errorfromserverorlink: "", errorfromapp: "")

                                    print(Interrupted_TransactionFlag,sendInterrupted_TransactionFlagN)
                                    sendInterrupted_TransactionFlagN = false
                                }
                            }
                                
                            
                            
                            if(sendInterrupted_TransactionFlagN == true){
                            if((pulsedata! as NSString).doubleValue > 0)
                            {
                                Interrupted_TransactionFlag = "n"
                                self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "n")
                               // web.sentlog(func_name: "TXTN ID: \(Vehicaldetails.sharedInstance.TransactionId),Flag: \(Interrupted_TransactionFlag)", errorfromserverorlink: "", errorfromapp: "")
                                
                                print(Interrupted_TransactionFlag,sendInterrupted_TransactionFlagN)
                                sendInterrupted_TransactionFlagN = false
                            }
                                
                            }
                            print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                            let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
//                            print("pulsedata: \( pulsedata!),Counts:\(counts),totalpulsecount: \(totalpulsecount)")
//                            self.tpulse.text = "\(totalpulsecount)"
                            
                            if(totalpulsecount < Int(Last_Count as String)!)
                            {
                                defaults.setValue(Last_Count, forKey: "reinstatingtransaction")
                                self.web.sentlog(func_name: "pulse count\(Last_Count!) save to app and link resets. ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                                pulsedata = Last_Count
//                                print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
//                                //sentlog
//                                GetPulsarstartimer.invalidate()
//                                GetPulsarstartimer.invalidate()
//                                self.web.sentlog(func_name: "Fueling Page getting pulsar count after try to reconnect  Count \(Last_Count!) previous count \(totalpulsecount) ", errorfromserverorlink: " "/*Response from link $$ \(newString1)!!*/,errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                                counts = Last_Count as! NSString
//                                 totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
//                               // self.Last_Count = "\(totalpulsecount)" as String?
//                                stopButtontapped()
//                                GetPulsarstartimer.invalidate()
//                                GetPulsarstartimer.invalidate()
                                
                            }else{
                           // self.quantity.append("\(y) ")
                                timer_quantityless_thanprevious.invalidate()
                                let pulsedata = defaults.string(forKey: "reinstatingtransaction")
                                print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                                var totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
                                print("pulsedata: \( pulsedata!),Counts:\(counts),totalpulsecount: \(totalpulsecount)")
                                self.web.sentlog(func_name: " Pulsar :", errorfromserverorlink: " \(totalpulsecount) = \(pulsedata!) + \(counts)",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
                                self.tpulse.text = "\(totalpulsecount)"
                                self.Last_Count = "\(totalpulsecount)" as String?
                                let v = self.quantity.count
                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(totalpulsecount))
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
                                  
                                    self.Last_Count = "\(totalpulsecount)"
    //                                let v = self.quantity.count
    //                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
    //                                let y = Double(round(100*FuelQuan)/100)
                                    if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                        let y = Double(round(100*FuelQuan)/100)
                                        self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                        print(self.tquantity.text!)
                                    }
                                    else {
                                        let y = Double(round(100*FuelQuan)/100)
                                        self.tquantity.text = "\(y) "
                                    }
                                    self.tpulse.text = "\(totalpulsecount)"
                                    self.quantity.append("\(y) ")
                               
                                
                                print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time,quantity)
                                let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                                print("Inside loop GetPulser" + defaultTimeZoneStr1)
                                if(v >= 2){
                                    print(self.quantity[v-1],self.quantity[v-2])
                                    if(self.quantity[v-1] == self.quantity[v-2]){
                                        self.total_count += 1
                                        if(self.total_count == 3){
                                            Ispulsarcountsame = true
                                            stoptimerIspulsarcountsame.invalidate()
                                            Samecount = Last_Count
                                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                            
                                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                        }
                                    }
                                    else
                                    {
                                        total_count = 0
                                        if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                        else{
                                            
                                            if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
                                                
                                                _ = self.web.SetPulser0()
                                                print(Vehicaldetails.sharedInstance.MinLimit)
                                                if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
                                                    self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
                                                }
                                                //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
                                                self.web.sentlog(func_name:" Auto stops transaction Limit Reached ",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                                self.stopButtontapped()
                                            }
                                        }
                                    }
                                }
                        }
                            }
                        else{
                        self.defaults.set(Vehicaldetails.sharedInstance.TransactionId, forKey: "transactionID")
                        self.defaults.set(Vehicaldetails.sharedInstance.PulseRatio, forKey: "pulsarratio")
                        self.start.isHidden = true
                        self.cancel.isHidden = true
                        // stoptimerIspulsarcountsame.invalidate()
                        //transaction Status send only one time.
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        if(reply_server == "")
                        {
                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
                            reply_server = "Sendtransaction"
                        }
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
                                        Samecount = Last_Count
                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                        
                                        self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off  - after \(Vehicaldetails.sharedInstance.pumpoff_time) Seconds if you get the same count ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
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
                                        self.web.sentlog(func_name:" Auto stops transaction because pulsar_secure_status == 5 ",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                        self.stopButtontapped()
                                    }
                                    
                                    if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                    else{
                                        
                                        if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
                                            
                                            _ = self.web.SetPulser0()
                                            print(Vehicaldetails.sharedInstance.MinLimit)
                                            if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
                                                self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
                                            }//"You are fuel day limit reached.")
                                            self.web.sentlog(func_name:" Auto stops transaction Limit Reached ",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                            self.stopButtontapped()
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            timer_quantityless_thanprevious.invalidate()
                            timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(PreauthFuelquantity.stoprelay), userInfo: nil, repeats: false)
                            self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
                            print("lower qty. than the prior one.")
                        }
                        }
//                        if(pulsar_status == 0)
//                        {
//
//                            do{
//                                playAlarm()
//                                GetPulsarstartimer.invalidate()
//                                    displaytime.text = NSLocalizedString("Reconnect" , comment:"")//"Reconnecting to pump, please wait briefly. Do not turn pump off."
//                                    displaytime.textColor = UIColor.red
//                                    reinstatingtransaction = true
//                                    if(Last_Count == nil){
//                                        Last_Count = "0.0"
//                                    }
//                                    reinstatingtransactionattempts = reinstatingtransactionattempts + 1
//
//                                    if(reinstatingtransactionattempts >= 3)
//                                    {
//                                        GetPulsarstartimer.invalidate()
//                                        displaytime.text = ""
//                                        try! stoprelay()
//                                        self.web.sentlog(func_name: " reinstating transaction attempts > 3 and pulsar_status == 0 auto stops transaction.", errorfromserverorlink: "\(Last_Count!)", errorfromapp: "")
//
//                                    }
//                                    else{
//
//                                    defaults.setValue(Last_Count, forKey: "reinstatingtransaction")
//
//                                        self.web.sentlog(func_name: "pulse count\(Last_Count!) save to app and link resets because pulsar_status == 0. ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                    appdisconnects_automatically = true
//                                    self.stoptimerIspulsarcountsame.invalidate()
//                                    self.timerview.invalidate()
//                                // self.GetPulsarstartimer.invalidate()
//                                    // self.GetPulsarstartimer.invalidate()
//
//                                    timer_quantityless_thanprevious.invalidate()
//                                    stoptimergotostart.invalidate()
//                                    stoptimer_gotostart.invalidate()
//                                        cf.delay(0.1){
//                                            self.IsStartbuttontapped = false
//                                            self.resumetimer() /// reinstate the transaction.
//                                            self.viewDidAppear(true)
//                                            self.countwififailConn = 0
////                                            self.resumetimer()
////                                            self.viewDidAppear(true)
//                                        }
//                                    }
//                                 //try self.stoprelay()
//                            }
//                            catch let error as NSError {
//                                print ("Error: \(error.domain)")
//                                self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
//                            }
//                            // self.stoprelay()
//                        }
                        //                            }
                        }//}
                    else{
                        if(Last_Count == nil){
                            Last_Count = "0.0"
                        }
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
                                    Samecount = Last_Count
                                    stoptimerIspulsarcountsame.invalidate()
                                    
                                    self.web.sentlog(func_name:  "Get pulse count was the same while fueling function, pump off  - after \(Vehicaldetails.sharedInstance.pumpoff_time) Seconds if you get the same count ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                    
                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                }
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
            self.IsStopbuttontappedBLE = true
            if(self.Ispulsarcountsame == true){
                if(Last_Count == nil){
                    Last_Count = "0.0"
                }
                if(Last_Count == "0.0" || Last_Count == "0")
                {
                    
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "4")/////
                    Last_Count = "0.0"
                    Samecount = "0.0"
                }
                print(Last_Count,Samecount)
                if(Samecount == Last_Count){
                    
                    self.GetPulsarstartimer.invalidate()
                    self.web.sentlog(func_name: "Stoprelay stopIspulsarcountsame", errorfromserverorlink: "", errorfromapp:"")
                    if(AppconnectedtoBLE == false ){
                        _ = self.tcpcon.setralay0tcp()
                        do{
                            try self.stoprelay()
                            
                        }
                        catch let error as NSError {
                            print ("Error: \(error.domain)")
                            self.web.sentlog(func_name: "stoprelay stopIspulsarcountsame", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                        }
                    }
                    else
                    {
                        self.IsStopbuttontappedBLE = true
                        self.Stop.isEnabled = false
                        self.Stop.isHidden = true
                        self.wait.isHidden = false
                        self.waitactivity.isHidden = false
                        self.web.sentlog(func_name: " Stop relay pulsarcount is same BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
                        self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                        NotificationCenter.default.removeObserver(self)
                        self.updateIncomingData()
                        self.cf.delay(10){
                            do{
                                if(self.isDisconnect_Peripheral == true ){
                                try self.stoprelay()
                                
                                }
                            }

                            catch let error as NSError {
                                print ("Error: \(error.domain)")
                            }
                            
                        }

                        self.FDcheckBLEtimer.invalidate()
                    }
                  
                    self.displaytime.text = NSLocalizedString("autostop", comment:"")//"app autostop because pulsecount getting is same."
                    self.Stop.isHidden = true
                }
            }
        }
    }
    
    @IBAction func OKbuttontapped(sender: AnyObject)
    {
        isokbuttontapped = true
        UsageInfoview.isHidden = true
        IsStartbuttontapped = true
        scrollview.isHidden = false
        dataview.isHidden = true
        OKWait.isHidden = false
        self.stoptimerIspulsarcountsame.invalidate()
        self.timerview.invalidate()
        self.GetPulsarstartimer.invalidate()
        timer_quantityless_thanprevious.invalidate()
        stoptimergotostart.invalidate()
        stoptimer_gotostart.invalidate()
//        self.tcpcon.setdefault()
//        self.tcpcon.closestreams()
        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: SSID)
     
        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
        {
            displaymessage(message:"We have renamed your LINK to the given name in the Cloud. Please close App and reopen")
            Vehicaldetails.sharedInstance.IsHoseNameReplaced = "Y"
            self.stopdelaytime = true
        }
        else
        {
        self.cf.delay(0.1){
            Vehicaldetails.sharedInstance.gohome = true
            self.FDcheckBLEtimer.invalidate()
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.web.sentlog(func_name: " OK buttontapped", errorfromserverorlink: "", errorfromapp: "")
            self.stopdelaytime = true
        }
        }
    }

    
    @objc func appMovedToBackground() {
        print("app enters background",IsStopbuttontappedBLE)
        if(IsStopbuttontappedBLE != true){
            self.web.sentlog(func_name: " Stop Transaction app enters in background \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
            stopButtontapped()
        }//isdisconnected = true
        
    }
    
    func Sendtransaction(fuelQuantity:String)
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
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        
        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"Transaction\":\"Current_Transaction\"}"
        
        let reply = web.Transaction_details(bodyData: bodyData)
        print(reply)
    }
    // MARK: - BLE Functions
    
    func Stopconnection()
    {
        FDcheckBLEtimer.invalidate()
        //self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
        
        self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
        NotificationCenter.default.removeObserver(self)
        self.updateIncomingData()
        do
        {
            //stoptransaction()
        }
        catch{}
    }
    
    
    @objc func gotostartBLE_resDN()
    {
        if(AppconnectedtoBLE == true ){
            self.web.sentlog(func_name: " BLE res DN", errorfromserverorlink:"Response from link is DN", errorfromapp: "")
            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "7")
           
            self.IsStopbuttontappedBLE = true
            Stop.isEnabled = false
            Stop.isHidden = true
            wait.isHidden = false
            waitactivity.isHidden = false
            FDcheckBLEtimer.invalidate()
        }
        //self.disconnectFromDevice()
        isgotostartcalled = true
        self.timerview.invalidate()
        //stoprealy()  //we should add the stoprelay function if we get some quantity and the get the DN response from link//
        self.FDcheckBLEtimer.invalidate()
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
    }
    
    
    @objc func gotostartBLE()
    {
        self.web.sentlog(func_name: " BLE Auto stops response of FD check is empty", errorfromserverorlink:"", errorfromapp: "")
        if(AppconnectedtoBLE == true ){
            outgoingData(inputText: "LK_COMM=relay:12345=OFF")
            NotificationCenter.default.removeObserver(self)
            updateIncomingData ()
            self.IsStopbuttontappedBLE = true
            Stop.isEnabled = false
            Stop.isHidden = true
            wait.isHidden = false
            waitactivity.isHidden = false
            FDcheckBLEtimer.invalidate()
        }
        self.disconnectFromDevice()
        isgotostartcalled = true
        self.timerview.invalidate()
    }
    
    func calculatetime()
    {
        
    }
    
    @objc func FDcheckBLE()
    {
        var lastcount = ""
        if(Last_Count == nil){
           // self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
            self.outgoingData(inputText: "LK_COMM=FD_check")
            Last_Count = "0"
            self.web.sentlog(func_name: " Last_Count \(Last_Count!)", errorfromserverorlink:"", errorfromapp: "")
        }
        else
        if(Last_Count == "0.0")
        {
            lastcount = Last_Count
            lastcount = "0"
        }else
        {
            lastcount = Last_Count
        }
        
        print(lastcount)
        if(lastcount == "")
        {
            
           // self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
            self.outgoingData(inputText: "LK_COMM=FD_check")
        }else{
        if (Int(lastcount)! >= 0){
        
            //self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
            self.outgoingData(inputText: "LK_COMM=FD_check")
            
//            if(quantity.count > 2)
//            {
//                let v = quantity.count
//                let sec = quantitysavetime.count
//                print(self.quantity[v-1],self.quantity[v-2])
//                if(self.quantity[v-1] == self.quantity[v-2]){
//                   // quantitysavetime[sec-1]
//
////                    self.total_count += 1
////                    if(self.total_count == 3){
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
//                            let current: String = dateFormatter.string(from: NSDate() as Date)
//                        let endDate = dateFormatter.date(from:current)!
//                        let startdate = dateFormatter.date(from:quantitysavetime[v-1])!
//                        let differenceInSeconds = Int(endDate.timeIntervalSince(startdate))
//                        print(differenceInSeconds,current,quantitysavetime[v-1])
//                        if(differenceInSeconds > 10){
//                            FDcheckBLEtimer.invalidate()
//                        Ispulsarcountsame = true
//                        timer_conutnotupdateprevious.invalidate()
//                        Samecount = Last_Count
//                        self.timer_conutnotupdateprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
//                            FDcheckBLEtimer.invalidate()
//                        }
//
////                    }
//                    else
//                    {
//                        timer_conutnotupdateprevious.invalidate()
//                    }
//                }
//            }
            
           
            
        if(self.displaytime.text == "Fueling…...")
            {
                cf.delay(40){
                do
                {
                    if(self.displaytime.text == "Fueling…...")
                    {
                        //                    self.timer_conutnotupdateprevious.invalidate()
                        //                    self.timer_conutnotupdateprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
                        try self.stoprelay()
                        self.web.sentlog(func_name: "auto stops the app when app not connect the link while reconnecting." , errorfromserverorlink: "", errorfromapp: "")
                    }
                }
                catch{}
            }
            //self.AppconnectedtoBLE = true
            }
            else
            {
                self.timer_conutnotupdateprevious.invalidate()
            }
        }
        else
        {
            if(iflinkison == false){
                delay(0.2){
                    self.web.sentlog(func_name: "Sent Relay On Command to BT link again from FD check function because we not receive quantity in first attempt. LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                    self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                    NotificationCenter.default.removeObserver(self)
                    self.updateIncomingData()
                }
            }
        }}
    }
    
    
  func GetPulserBLE(counts:String) {
        //counts = "0"
        
        let dateFormatter = DateFormatter()
        Warning.text = NSLocalizedString("Warningfueling", comment:"")
        Warning.isHidden = false
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let defaultTimeZoneStr = dateFormatter.string(from: Date());
        
        print("before GetPulser" + defaultTimeZoneStr)
   
        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
        print("before send GetPulser" + defaultTimeZoneStr1)
        
        print(characteristicASCIIValue)
    self.defaults.set(Vehicaldetails.sharedInstance.TransactionId, forKey: "transactionID")
    self.defaults.set(Vehicaldetails.sharedInstance.PulseRatio, forKey: "pulsarratio")
   
        if(self.counts == " 0" || self.counts == "0")
        {
            
        }
        else{
           // self.defaults.set(self.Last_Count, forKey: "LastCount")
            if (counts == ""){
                self.emptypulsar_count += 1
                if(self.emptypulsar_count == 3){
                    Vehicaldetails.sharedInstance.gohome = true
                    self.timerview.invalidate()
                    do
                    {
                        try self.stoprelay()
                    }
                    catch{}
                    FDcheckBLEtimer.invalidate()
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    self.web.sentlog(func_name: "get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                    appDel.start()
                    FDcheckBLEtimer.invalidate()
                }
            }
            else if (counts == "0")
            {
                if(Last_Count == nil){
                    Last_Count = "0.0"
                }
                let v = self.quantity.count
                self.quantity.append("0")
                if(v >= 2){
                    print(self.quantity[v-1],self.quantity[v-2],total_count)
                    if(self.quantity[v-1] == self.quantity[v-2]){
                        self.total_count += 1
                        if(self.total_count == 3){
                            Ispulsarcountsame = true
                            stoptimerIspulsarcountsame.invalidate()
                            Samecount = Last_Count
                                                                               
                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                            
                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpon_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                        }
                    }
                }
            }
            else
            {
                self.emptypulsar_count = 0
                if (counts != "0"){
                   // Reconnect.isHidden = true
                    self.start.isHidden = true
                    self.cancel.isHidden = true
                    // stoptimerIspulsarcountsame.invalidate()
                    //transaction Status send only one time.
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    if(reply_server == "")
                    {
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
                        reply_server = "Sendtransaction"
                    }
                    print(self.tpulse.text!, counts)
                    
                    if (self.tpulse.text! == (counts as String) as String){
                        
                    }
                    if(Last_Count == nil){
                        Last_Count = "0.0"
                    }
                    if(appdisconnects_automatically == true){
                        
                            if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
                                Ispulsarcountsame = false
                                stoptimerIspulsarcountsame.invalidate()
                            }
                        print(Last_Count)
                        var pulsedata = defaults.string(forKey: "previouspulsedata")
                        if(pulsedata == ""){}
                        else{
                        let totalpulsecount = Int(Float(pulsedata! as String)!) + Int(counts as String)!
                        print(Last_Count,totalpulsecount,counts,pulsedata)
                        if(totalpulsecount < Int(Float(Last_Count as String)!))
                        {
                            defaults.setValue(Last_Count, forKey: "previouspulsedata")
                            print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                            pulsedata = Last_Count
////
                        }else{
                        

                        
                            
                        let totalpulsecount = Int(Float(pulsedata! as String)!) + Int(counts as String)!
                            if(totalpulsecount < Int(Float(Last_Count as String)!))
                             {
                                defaults.setValue(Last_Count, forKey: "previouspulsedata")
                                 print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                                 pulsedata = Last_Count
                            //
                            }else{
                        self.tpulse.text = "\(totalpulsecount)"
                        //self.quantity.append("\(y) ")
                            timer_quantityless_thanprevious.invalidate()
                       
                            self.Last_Count = "\(totalpulsecount)" as String?
                            let v = self.quantity.count
                            let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(totalpulsecount))
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

                                self.Last_Count = "\(totalpulsecount)"
//                                let v = self.quantity.count
//                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                                let y = Double(round(100*FuelQuan)/100)
                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                    let y = Double(round(100*FuelQuan)/100)
                                    self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                    print(self.tquantity.text!)
                                }
                                else {
                                    let y = Double(round(100*FuelQuan)/100)
                                    self.tquantity.text = "\(y) "
                                }
                                self.tpulse.text = "\(totalpulsecount)"
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                                    let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                                self.quantitysavetime.append("\(dtt1)")
                                self.quantity.append("\(y) ")
                           
                            
                            print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time,quantity)
                            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                            print("Inside loop GetPulser" + defaultTimeZoneStr1)
                            if(v >= 2){
                                print(self.quantity[v-1],self.quantity[v-2])
                                if(self.quantity[v-1] == self.quantity[v-2]){
                                    self.total_count += 1
                                    if(self.total_count == 3){
                                        Ispulsarcountsame = true
                                        stoptimerIspulsarcountsame.invalidate()
                                        Samecount = Last_Count
                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                        
                                        self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                    }
                                }
                                else
                                {
                                    total_count = 0
                                    if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                    else{
                                        print(Vehicaldetails.sharedInstance.MinLimit)
                                        if(Float(Vehicaldetails.sharedInstance.MinLimit)! <= Float(FuelQuan)){
                                            
//                                            _ = self.web.SetPulser0()
                                            print(Vehicaldetails.sharedInstance.MinLimit)
                                            if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
                                            self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
                                            }
                                            self.web.sentlog(func_name: " Stop Transaction fuel limit reached \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                                            //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
                                            self.stopButtontapped()
                                        }
                                    }
                                }
                            }
//                            }
                            
                        }
                        }
                        }
                    }
                    else{
                    
                    if((counts as NSString).doubleValue >= (Last_Count as NSString).doubleValue)
                    {
                        if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
                            Ispulsarcountsame = false
                            stoptimerIspulsarcountsame.invalidate()
                        }
                        timer_quantityless_thanprevious.invalidate()
                        self.Last_Count = counts as String?
                        self.defaults.set(self.Last_Count, forKey: "LastCount")
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
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                        self.quantitysavetime.append("\(dtt1)")
                            self.quantity.append("\(y) ")
                        defaults.set(Last_Count, forKey: "previouspulsedata")
                    
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
                                    Samecount = Last_Count
                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                    
                                    self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                }
                            }
                            else
                            {
                                total_count = 0
                                print(Int(Vehicaldetails.sharedInstance.MinLimit))
                                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0)
                                {}
                                else{
                                    print(Vehicaldetails.sharedInstance.MinLimit)
                                    if((Vehicaldetails.sharedInstance.MinLimit as NSString).doubleValue <= (FuelQuan)){
                                        
                                        _ = self.web.SetPulser0()
                                        print(Vehicaldetails.sharedInstance.MinLimit)
                                        if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
                                        self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
                                        }
                                        self.web.sentlog(func_name: " Stop Transaction fuel limit reached \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                                        
                                        
                                        if(Vehicaldetails.sharedInstance.FuelLimitPerTnx == "FuelLimitPerTnx")
                                        {
                                            self.showAlert(message: NSLocalizedString("Fueltnxlimit", comment:"") )//"You are fuel day limit reached.")
                                            self.stopButtontapped()
                                        }
                                        else if(Vehicaldetails.sharedInstance.FuelLimitPerDay == "FuelLimitPerDay")
                                        {
                                            self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
                                            self.stopButtontapped()
                                        }
                                        else if(Vehicaldetails.sharedInstance.FuelLimitPerMonth == "FuelLimitPerMonth")
                                        {
                                            self.showAlert(message: NSLocalizedString("Fuelmonthlylimit", comment:"") )//"You are fuel day limit reached.")
                                            self.stopButtontapped()
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    else{
                        timer_quantityless_thanprevious.invalidate()
                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
                        print("lower qty. than the prior one.")
                    }
                }
                }
                else{
                    if(Last_Count == nil){
                        Last_Count = "0.0"
                    }
                    let v = self.quantity.count
                    let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                    let y = Double(round(100*FuelQuan)/100)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "ddMMyyyyhhmmss"
                        let dtt1: String = dateFormatter.string(from: NSDate() as Date)
                    self.quantitysavetime.append("\(dtt1)")
                    self.quantity.append("\(y) ")
                    
                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
                    if(v >= 2){
                        if(self.self.quantity[v-1] == self.quantity[v-2]){
                            self.total_count += 1
                            if(self.total_count == 3){
                                Ispulsarcountsame = true
                                Samecount = Last_Count
                                stoptimerIspulsarcountsame.invalidate()
                                
                                self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                
                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(PreauthFuelquantity.stopIspulsarcountsame), userInfo: nil, repeats: false)
                            }
                        }
                    }
                }
            }
        }
    }
    

    func sentTransactionID(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        let dtt1: String = dateFormatter.string(from: NSDate() as Date)
      self.outgoingData(inputText: "LK_COMM=T:\(Vehicaldetails.sharedInstance.TransactionId);D:\(dtt1);V:\(Vehicaldetails.sharedInstance.VehicleId);")//"LK_COMM=T:12345;D:2203211345;V:67890;")
        NotificationCenter.default.removeObserver(self)
        updateIncomingData()
    }
    
    
    func getlastone()
    {
        outgoingData(inputText: "LK_COMM=last1")
        NotificationCenter.default.removeObserver(self)
        updateIncomingData()
//        self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
        
    }
    
    
    
    func parsepulsedata()
    {
        let Split = characteristicASCIIValue.components(separatedBy: "$$")
        
        let jsonText = Split[0];
//       let jsonText =  "{\"version\":{\"version\":\"1.0.0(s)\"},\"mac_address\":{\"bt\":\"10:52:1c:85:72:92\"}}"
        print(jsonText)
        let data1:Data = "\(jsonText)".data(using: String.Encoding.utf8)!
            do{
                //print(self.sysdata)
                self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                 print(self.sysdata)
//                let version = self.sysdata.value(forKey: "version") as! NSDictionary
                let pulse = self.sysdata.value(forKey: "pulse") as! NSNumber
//                let mac_address = self.sysdata.value(forKey: "mac_address") as! NSDictionary
//                let bt = mac_address.value(forKey: "bt") as! NSString
                print(pulse)
                self.web.sentlog(func_name: " BLE Response from link is \(pulse)", errorfromserverorlink:"", errorfromapp: "")
                self.countfromlink = Int(pulse)
                self.GetPulserBLE(counts:"\(pulse)")
                self.displaytime.text = ""
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
                let text = error.localizedDescription //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
            }
        
    }
    
    func lasttransaction()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
          let dtt1: String = dateFormatter.string(from: NSDate() as Date)
          self.consoleAsciiText = NSAttributedString(string: "")
          self.newAsciiText = NSMutableAttributedString()
          if(self.observationToken == nil){}
          else{
                NotificationCenter.default.removeObserver(self.observationToken!)
            }
                                    self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                                    self.outgoingData(inputText: "LK_COMM=last1")
        
                                    NotificationCenter.default.removeObserver(self)
                                self.updateIncomingData()
        delay(2){
            self.parsejsonLast1()
        }
        
    }
    
    func settransactionid()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
          let dtt1: String = dateFormatter.string(from: NSDate() as Date)
          self.consoleAsciiText = NSAttributedString(string: "")
          self.newAsciiText = NSMutableAttributedString()
          if(self.observationToken == nil){}
          else{
           NotificationCenter.default.removeObserver(self.observationToken!)
            }
                                    self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                                    self.outgoingData(inputText: "LK_COMM=txtnid:D:\(dtt1);V:\(Vehicaldetails.sharedInstance.VehicleId);")
        
                                    NotificationCenter.default.removeObserver(self)
                                self.updateIncomingData()
        
        lasttransaction()

    }
    
    func parsejson()
    {
        let Split = self.baseTextView.components(separatedBy: "$$")
        
        let jsonText = Split[0];
//       let jsonText =  "{\"version\":{\"version\":\"1.0.0(s)\"},\"mac_address\":{\"bt\":\"10:52:1c:85:72:92\"}}"
        print(jsonText)
        let data1:Data = jsonText.data(using: String.Encoding.utf8)!
            do{
                //print(self.sysdata)
                if(jsonText.contains("{\"notify\" : \"enabled\"}")){}
                else{
                self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                 print(self.sysdata)
                    self.web.sentlog(func_name: " BLE Response from link is \(jsonText)", errorfromserverorlink:"", errorfromapp: "")
                  
                let version = self.sysdata.value(forKey: "version") as! NSDictionary
                let Linkversion = version.value(forKey: "version") as! NSString
                let mac_address = self.sysdata.value(forKey: "mac_address") as! NSDictionary
                let bt = mac_address.value(forKey: "bt") as! NSString
                print(Linkversion,bt)
                Vehicaldetails.sharedInstance.iotversion = Linkversion as String
                if(Vehicaldetails.sharedInstance.BTMacAddress == "")
                {
                    
                }
                else{
                    print(Vehicaldetails.sharedInstance.BTMacAddress,bt)
                if(Vehicaldetails.sharedInstance.BTMacAddress == bt as String)
                {
                        BTMacAddress = false
                }
                else
                {
                    BTMacAddress = true
                }
                }
                gotLinkVersion = true
                
                    self.consoleAsciiText = NSAttributedString(string: "")
                    self.newAsciiText = NSMutableAttributedString()
                    
//                settransactionid()
                }
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
                let text = error.localizedDescription //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
            }
        
    }
    
    
    
    func parsejsonLast1()
    {
        let Split = self.baseTextView.components(separatedBy: "records")
        if(Split.count >= 2){
            let Split1 = Split[1].components(separatedBy: "$$")
            
            let jsonText = "{" + "\"records" + Split1[0];
            //       let jsonText =  "{\"version\":{\"version\":\"1.0.0(s)\"},\"mac_address\":{\"bt\":\"10:52:1c:85:72:92\"}}"
            print(jsonText)
            let data1:Data = jsonText.data(using: String.Encoding.utf8)!
            do{
                //print(self.sysdata)
                self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print(self.sysdata)
                let record_data = self.sysdata.value(forKey: "records") as! NSArray
                let rowCount = record_data.count
                let index: Int = 0
                for i in 0  ..< rowCount
                {
                    
                    let JsonRow = record_data[i] as! NSDictionary
                    
                    let date = JsonRow.value(forKey: "date") as! NSString
                    let dflag = JsonRow.value(forKey: "dflag") as! Bool
                    let pulse = JsonRow.value(forKey: "pulse") as! NSNumber
                    let txtn = JsonRow.value(forKey: "txtn") as! NSString
                    let vehicle = JsonRow.value(forKey: "vehicle") as! NSString
                    let quantity = self.cf.calculate_fuelquantity(quantitycount: Int(pulse))
                    
                    let transaction_details = Last10Transactions (Transaction_id: txtn as String, Pulses: "\(pulse)", FuelQuantity: "\(quantity)", vehicle: vehicle as String, date: date as String, dflag: "\(dflag)" )
                    self.web.sentlog(func_name: " BLE Response from link is \(jsonText)", errorfromserverorlink:"", errorfromapp: "")
                    Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
                    print(date,dflag,pulse,txtn,vehicle)
                }
                
                
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
                let text = error.localizedDescription //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
            }
            
        }
}

    
    func parsejsonOFF()
    {
        //let Split = self.baseTextView.components(separatedBy: "OFF")
        if(IsStopbuttontappedBLE == true)
        {
            let jsonText = "{\"relay\":\"OFF\"}"
        

        print(jsonText)
        let data1:Data = jsonText.data(using: String.Encoding.utf8)!
            do{
                //print(self.sysdata)
                self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                 print(self.sysdata)
                let relay = self.sysdata.value(forKey: "relay") as! NSString
//                let pulse = self.sysdata.value(forKey: "pulse") as! NSDictionary
                if(relay == "OFF")
                {
                    self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
                    IsStopbuttontapped = true
                    self.disconnectFromDevice()
                }
                    
                print(relay)
               
                
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
                let text = error.localizedDescription //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                print(newString)
                
            }
        }
        else{
        let jsonText = baseTextView//Split[0];//"{\"relay\":\"OFF\"}"
        }
      
    }
    
    
    
    func getlast10transaction()
    {
        if(Last10transaction != "")
        {
            if(Last10transaction.contains("--"))
            {}else{
                let Splitdata = Last10transaction.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",\nBTMAC:")
                let Splitdata1 = Splitdata[0];
                let Mac = Splitdata[1];
                let MacAddressdata = Mac.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\nversion")
                let MacAddress = MacAddressdata[0]
                print(MacAddress,Splitdata)
               
                if(Vehicaldetails.sharedInstance.BTMacAddress == MacAddress)
                {
                        BTMacAddress = true
                }
                else
                {
                    BTMacAddress = false
                }
                
                let Splitdata2 = Splitdata1.components(separatedBy: ":")
                let dataafterL10 = Splitdata2[1]
                let Splitdata3 = dataafterL10.trimmingCharacters(in: .whitespacesAndNewlines) .components(separatedBy: ",")
                for i in 0  ..< Splitdata3.count
                {
                    let Split = Splitdata3[i].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "-")
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
        }
    }
    
    
    func playAlarm() {
        // need to declare local path as url
        guard let url = Bundle.main.url(forResource: "Ding", withExtension: "mp3") else {
                   print("error to get the mp3 file")
                   return
               }

               do {
                audio = try AVPlayer(url: url)
               } catch {
                   print("audio file error")
               }
        audio?.play()

    }
    
    func notify(site:String) {
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "FluidSecure"
            notificationContent.body = NSLocalizedString("Notify", comment:"") + "\(site)."
        notificationContent.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                            repeats: false)
            let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)

            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
    }
}
    // MARK: - Central Manager delegate
   
    extension PreauthFuelquantity: CBCentralManagerDelegate {

        func disconnectFromDevice()
        {
            if blePeripheral != nil {
                //self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic!),\(blePeripheral!)", errorfromserverorlink: "", errorfromapp:"")
                // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
                // Therefore, we will just disconnect from the peripheral
                // print(rxCharacteristic!)
                print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
                {
                    self.displaytime.text = ""//NSLocalizedString("MessageFueling", comment:"")
                        if(self.AppconnectedtoBLE == true)
                    {
                        let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
                            self.renamelink(SSID:trimmedString)
                            _ = self.web.SetHoseNameReplacedFlag()
                    }
                    self.isdisconnected = true
                }
                self.cf.delay(0.2){
                    if(self.rxCharacteristic == nil){}
                else{
                    self.blePeripheral!.setNotifyValue(false, for: self.rxCharacteristic!)

                }

                    self.centralManager.cancelPeripheralConnection(self.blePeripheral!)
                    self.centralManager.cancelPeripheralConnection(self.blePeripheral!)
                    self.isdisconnected = true
                }

                self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic),\(blePeripheral)", errorfromserverorlink: "", errorfromapp:"")
                print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
                {
                    self.isdisconnected = true
                    cf.delay(1)
                    {
                        self.centralManager = CBCentralManager(delegate: self, queue: nil)
                       // self.cancelScan()
                    //centralManager?.connect(blePeripheral!, options: nil)
                    self.start.isEnabled = false
                    self.start.isHidden = true
                    self.cancel.isHidden = true
                    //self.Pwait.isHidden = false
                        self.UsageInfoview.isHidden = true
                    }


                        cf.delay(5){
                     if self.blePeripheral != nil {
                            // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
                            // Therefore, we will just disconnect from the peripheral
                            self.blePeripheral!.setNotifyValue(false, for: self.rxCharacteristic!)
                            self.centralManager?.cancelPeripheralConnection(self.blePeripheral!)
                        self.cf.delay(10){
                            do{
                                self.isdisconnected = true
                                self.UsageInfoview.isHidden = false
                                try self.stoprelay()


                            }

                            catch let error as NSError {
                                print ("Error: \(error.domain)")
                            }

                        }
                        self.isdisconnected = true
                        print("disconnected")
                        }

    //
                        }
    //
    //
    //
                }
                else
                {
                    do{

                        try self.stoprelay()
                        isdisconnected = true
                    }
                    catch let error as NSError {
                        print ("Error: \(error.domain)")
                    }
                }
            }
        }

        //Peripheral Connections: Connecting, Connected, Disconnected

        //-Connection
        func connectToDevice() {

            if(blePeripheral == nil)
            {}
            else{
                centralManager?.connect(blePeripheral!, options: nil)
                self.web.sentlog(func_name: "connect To BT link Device \(blePeripheral!)", errorfromserverorlink:"", errorfromapp: "")
                AppconnectedtoBLE = true
                self.getBLEinfo()
            }
        }

        func ConnecttoBLE()
        {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }

        
        //     MARK: - Upgrade helper Methods
        func sendData() {
            
            progressview.isHidden = false
            progressviewtext.isHidden = false
            if let discoveredPeripheral = blePeripheral{
                if let txCharacteristic = txCharacteristicupload
                {
                    sentDataPacket = Firmwareupdatedemo()
                    if sentDataPacket != nil {
                        discoveredPeripheral.writeValue(sentDataPacket!, for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
                    }
                    else{
                        
                        // discoveredPeripheral.writeValue("EOM".data(using: String.Encoding.utf8)!, for: txCharacteristic, type: .withoutResponse)
                    }
                }
            }
        }
        
        
        func Firmwareupdatedemo() -> Data? {
            //let subData:Data
            guard let discoveredPeripheral = blePeripheral,
                  let txCharacteristic = txCharacteristicupload
            else { return nil}
            let mtu = discoveredPeripheral.maximumWriteValueLength(for: CBCharacteristicWriteType.withoutResponse)
            
            if(bindata == nil){
                uploadbinfile()
            }
            else {
                guard bindata!.count > 0 else {
                    
                    
                    // set label for progress value
                    
                    self.progressviewtext.text = "Done Upgrade \(Int(self.progressview.progress * 100))%"
                    _ = self.web.UpgradeCurrentiotVersiontoserver()
                    self.disconnectFromDevice()
                    // invalidate timer if progress reach to 1
                    
                    //                if(progressview.progress >= 1)
                    
                    return nil
                }
                progressview.isHidden = false
                progressviewtext.isHidden = false
                let iteration:Float = Float(totalbindatacount / mtu)
                let onepercentoffile:Float = 1/iteration
                print(iteration,Float(Double(onepercentoffile)))
                iterationcountforupgrade = iterationcountforupgrade + 1
                self.progressview.progress += Float(Double(onepercentoffile))
                self.progressviewtext.text = "Please wait Upgrading in progress \(Int(self.progressview.progress * 100))%"
                
                var range:Range<Data.Index>
                // Create a range based on the length of data to return
                if (bindata!.count) >= mtu{
                    range = (0..<mtu)
                }
                else{
                    
                    range = (0..<(bindata!.count))
                }
                // Get a new copy of data
                subData = bindata!.subdata(in: range)
                // Mutate data
                bindata!.removeSubrange(range)
                print(range,subData,bindata!)
                // Return the new copy of data
                
            }
            
            return subData
        }
        
        //BTUpgrade
        
        func uploadbinfile(){
            //Download new link from Server using getbinfile and upload/Flash the file to FS link.
            //            DispatchQueue.main.async(execute: {
            //                self.web.beginBackgroundUpdateTask()
            //                if(self.bindata == nil){
            self.bindata = self.getbinfile() as Data
            //                }
            //                else{
            self.totalbindatacount = self.bindata!.count
            print(self.bindata!.count)
            self.outgoingData(inputText: "LK_COMM=upgrade \(self.bindata!.count)")
            NotificationCenter.default.removeObserver(self)
            self.updateIncomingData()
            //                }
            
            // End the background task.
            
            //                self.web.endBackgroundUpdateTask()
            //            })
        }
        
        func getbinfile() -> Data
        {
            let urlPath:String = Vehicaldetails.sharedInstance.FilePath
            
            let objectUrl = URL(string:urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:objectUrl! as URL)
            request.httpMethod = "GET"
            
            let session = Foundation.URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task =  session.dataTask(with: request as URLRequest) { data, response, error in
                if let data = data {
                   
                    self.replydata = data as NSData
                } else {
                    print(error!)
                }
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            return replydata as Data
        }
        
        // MARK: - write the data
        // Write functions

        func outgoingData (inputText:String) {
            let appendString = "\n"

           // let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
            //let myAttributes1 = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.blue]
            self.web.sentlog(func_name: " BLE sent request to link is \(inputText)", errorfromserverorlink:"", errorfromapp: "")
            writeValue(data: inputText)

            let attribString = NSAttributedString(string: "[Outgoing]: " + inputText + appendString)//, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributes1))
            let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
            newAsciiText.append(attribString)
            consoleAsciiText = newAsciiText
        }


        func updateIncomingData() {
            observationToken = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){ [self]
                notification in
//                let appendString = "\n"

                //let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
                //  let myAttributes2 = [self.convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, self.convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red]
//                let attribString = NSAttributedString(string: "[Incoming]: " + (self.characteristicASCIIValue as String))// + appendString)//, attributes: self.convertToOptionalNSAttributedStringKeyDictionary(myAttributes2))
//                let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)

//                newAsciiText.append(attribString)
                if(connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9"){
                self.newAsciiText.append(NSAttributedString(string:(characteristicASCIIValue as String)))
                    if("\(self.newAsciiText)".contains("$$"))
                    {
                        let jsondata = newAsciiText
                        self.baseTextView = "\(jsondata)"
                    }
    //                NotificationCenter.default.removeObserver(self.observationToken!)
                    //integrtedresponse = newAsciiText as String
                    print(baseTextView,newAsciiText)

                   
                    print("\(self.newAsciiText)")
                    if("\(self.newAsciiText)".contains("bt"))
                    {
                        self.parsejson()
                    }

                    if("\(characteristicASCIIValue)".contains("{\"pulse\":"))
                    {
                        self.parsepulsedata()
                    }
                    if("\(self.newAsciiText)".contains("dflag"))
                    {
                        self.baseTextView = ""
                        let json_data = newAsciiText
                        self.baseTextView = "\(json_data)"

                        self.parsejsonLast1()
                    }

                    if("\(self.newAsciiText)".contains("OFF"))
                    {
                        if (isdisconnected == true)
                        {}
                        else{
                        let jsondata = newAsciiText
                        self.baseTextView = "\(jsondata)"
                        print(newAsciiText)
                      
                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                        {
                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                            {
                                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                if(self.bindata == nil){
                                    self.uploadbinfile()
                                }
                                // self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                //self.Firmwareupdate()//Firmwareupdatedemo()
                                sendData()
                                  _ = self.web.UpgradeCurrentiotVersiontoserver()

                            }
                        }
                            else
                            {
                                self.parsejsonOFF()
                                
                            }
                        }
                       
                    }
                    }


                if(self.characteristicASCIIValue == "ON")
                {
                    iflinkison = true
                }
                if(characteristicASCIIValue == "HO")
                {
                    self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
                    Count_Fdcheck = 0
                }
                else if(characteristicASCIIValue == "DN")
                {
                    self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
                    gotostartBLE_resDN()
                }
                else if(characteristicASCIIValue == "")
                {
                    ///  self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
                    delay(1){
                        Count_Fdcheck = Count_Fdcheck + 1
                    }
//                    if(Count_Fdcheck == 3)
//                    {
//                        gotostartBLE()
//
//                    }
                }

                if(self.characteristicASCIIValue == "OFF")
                {
                    if (isdisconnected == true)
                    {
                        //                        do{
                        //
                        //                            try self.stoprelay()
                        //
                        //                        }
                        //
                        //                        catch let error as NSError {
                        //                            print ("Error: \(error.domain)")
                        //                        }
                    }
                    else{
                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                        {
                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                            {
                                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                if(self.bindata == nil){
                                    self.uploadbinfile()
                                }
                                // self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                //self.Firmwareupdate()//Firmwareupdatedemo()
                                sendData()
                                //  _ = self.web.UpgradeCurrentiotVersiontoserver()

                            }
                        }
                        else{
                            self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
                            IsStopbuttontapped = true
                            self.disconnectFromDevice()
                        }
                    }
                }
            }
            NotificationCenter.default.removeObserver(self)
        }

        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
            return input.rawValue
        }

        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
            guard let input = input else { return nil }
            return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
        }

        
        func getBLEinfo()
        {
            consoleAsciiText = NSAttributedString(string: "")
            newAsciiText = NSMutableAttributedString()
//            if(observationToken == nil){}
//            else{
                NotificationCenter.default.removeObserver(self)//.observationToken!)
//            }
            newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, newAsciiText.length))
            outgoingData(inputText: "LK_COMM=info")
            
            updateIncomingData()
            NotificationCenter.default.removeObserver(self)
            self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
            AppconnectedtoBLE = true
        }
        


        func startScan() {
            print(countfromlink)
//            if(countfromlink > 0)
//            {}
//            else{
            self.web.sentlog(func_name: "Start BT Scan...for \(kBLEService_UUID)", errorfromserverorlink:"", errorfromapp: "\(peripherals)")
            self.peripherals = []
//            self.kCBAdvDataLocalName = []
            let BLEService_UUID = CBUUID(string: kBLEService_UUID)
            print("Now Scanning...")
            self.GetPulsarstartimer.invalidate()
            centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])

            Timer.scheduledTimer(withTimeInterval: 10, repeats: false) {_ in
                self.web.sentlog(func_name: "Scan Stopped...", errorfromserverorlink:"", errorfromapp: "\(self.peripherals)")
                if(self.peripherals.count == 0)
                {
                    if(self.onFuelingScreen == true){
                        if(self.appconnecttoUDP == true){}
                        else{
                    self.cancelScan()
                        }
                    }
                }
                Vehicaldetails.sharedInstance.peripherals = self.peripherals
               // self.cancelScan()
                if(self.onFuelingScreen == true){
                    if(self.appconnecttoUDP == true){}
                    else{
                        if(self.countfromlink > 0)
                            {
                            if(self.sendrename_linkname == true)
                            {
                                self.cancelScan()
                            }
                        }
                            else{
                self.cancelScan()
                    }
                    }

                }

            }
           // }
        }

        /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
        func cancelScan() {
//            if(countfromlink > 0)
//            {}
//            else{

            self.centralManager?.stopScan()

            self.web.sentlog(func_name: "Scan Stopped", errorfromserverorlink: "Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(peripherals)")
            Vehicaldetails.sharedInstance.peripherals = self.peripherals
            if (peripherals.count == 0){
                if(IsStartbuttontapped == true){}
                else{
                    self.countfailBLEConn = self.countfailBLEConn + 1
                    if (self.countfailBLEConn > 3){

                        self.web.sentlog(func_name: "App Not able to Connect and Subscribed peripheral Connection. Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
                        Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
                        Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                        self.performSegue(withIdentifier: "GoUDP", sender: self)
                        appconnecttoUDP = true

                    }
                    else{
                        if(ifSubscribed == true){}
                        else{
                            self.web.sentlog(func_name: " Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
                            self.startScan()
                            if(onFuelingScreen == true){
                                if(peripherals.count == 0)
                                {

                                }
                                else
                                {
                                    viewDidAppear(true)
                                }
                        }
                        }
                    }
//                    displaytime.text = "BT link not found. please try again later."
                    Vehicaldetails.sharedInstance.peripherals = self.peripherals
                    // AppconnectedtoBLE = false
                    cancel.isHidden = false
                }
            }
            else
            {
                if(peripherals.count == 0)
                {
                    print(peripherals,peripherals.count)
                }
                else{
                    print(peripherals,peripherals.count)
                    for i in 0  ..< peripherals.count
                    {
                        print(peripherals,peripherals.count)
                        if(peripherals.count == 0)
                        {
                            print(peripherals,peripherals.count)
                        }
                        else{
                            let peripheral = self.peripherals[i]
                           // let localName = self.kCBAdvDataLocalName[i]
                            if(peripheral.name! == "nil" || peripheral.name! == "(null)")
                            {}
                            else{
                            if( Vehicaldetails.sharedInstance.SSId.uppercased() == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                            {
                                blePeripheral = self.peripherals[i]
                                connectedperipheral = (blePeripheral?.name)!
                                connectToDevice()

                                break
                            }
                            else
                            if(Vehicaldetails.sharedInstance.SSId.uppercased() == localName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                            {
                                blePeripheral = self.peripherals[i]
                                if(blePeripheral?.name == localName){
                                
                                connectedperipheral = (blePeripheral?.name)!
                                
                                connectToDevice()
                                break
                                }
                            }
                            
                            else if(Vehicaldetails.sharedInstance.OriginalNamesOfLink.count > 0)
                                {
                                self.web.sentlog(func_name: "OriginalNamesOfLink name \(Vehicaldetails.sharedInstance.OriginalNamesOfLink).", errorfromserverorlink:"", errorfromapp: "")
                                for ln in 0  ..< Vehicaldetails.sharedInstance.OriginalNamesOfLink.count
                                {
                                    if(peripheral.name! == "nil" || peripheral.name! == "(null)")
                                    {}
                                    else{
                                        
                                    if( "\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])".trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                    {
                                        print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]), \(peripheral.name!)")
                                        blePeripheral = self.peripherals[i]
                                        connectedperipheral = (blePeripheral?.name)!
                                        defaults.set(blePeripheral?.name!, forKey: "LasttransactionSSID")
                                        //                                defaults.set("\(blePeripheral!.identifier)", forKey: "Lasttransactionidentifier")
                                        connectToDevice()
                                        break
                                        
                                    }
                                    else if("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])".trimmingCharacters(in: .whitespacesAndNewlines).uppercased().components(separatedBy: .whitespacesAndNewlines).joined() == localName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                    {
                                        print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]), \(localName)")
                                        //blePeripheral = self.peripherals[i]
                                        //                            if(peripheral.name! == BLEPeripheralforlocalname){
                                        blePeripheral = self.peripherals[i]
                                        connectedperipheral = (blePeripheral?.name)!
                                        
                                        connectToDevice()
                                        break
                                        
                                    }
                                }
                            }
                                }
                                
                            }
                        }
                        
                    }
                    if(self.connectedperipheral == "")
                    {
                        if(IsStartbuttontapped == true){}
                        else{
                            self.countfailBLEConn = self.countfailBLEConn + 1

                            self.web.sentlog(func_name: "Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")

                            if (self.countfailBLEConn == 5){

                                self.web.sentlog(func_name: "App Not able to Connect BT Link and Subscribed peripheral Connection. Attempt  \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")

                                self.web.sentlog(func_name: "App Switches BT to UDP...", errorfromserverorlink: "", errorfromapp: "")
                                Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
                                Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
                                self.performSegue(withIdentifier: "GoUDP", sender: self)
                                appconnecttoUDP = true

                            }
                            else{
                                if(ifSubscribed == true){}
                                else{
                                    self.web.sentlog(func_name: " Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
                                    self.startScan()
                                }
                            }
                        }
                    }
                    //self.viewDidAppear(true)
                }
            }
           // }
        }


        func centralManagerDidUpdateState(_ central: CBCentralManager) {

            if central.state == CBManagerState.poweredOn {
                print("BLE powered on")
                if(countfromlink > 0)
                {
                    if(sendrename_linkname == true)
                    {
                        startScan()
                    }
                }
                else{
                // Turned on
                startScan()
                //central.scanForPeripherals(withServices: [CBUUID(string: "000000ff-0000-1000-8000-00805f9b34fb")], options: nil)
                }
            }
            else {
                print("Something wrong with BLE")
                // Not on, but can have different issues
            }
        }


        /*
         Called when the central manager discovers a peripheral while scanning. Also, once peripheral is connected, cancel scanning.
         */
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
            if(onFuelingScreen == true){
                if(peripheral.name == "nil" || peripheral.name == "(null)")
                {
                    self.web.sentlog(func_name: "onFuelingScreen peripheral \(peripheral)", errorfromserverorlink: "Peripheral name: \(String(describing: peripheral.name))", errorfromapp:"")
//                    self.web.sentlog(func_name: "Advertisement data \(advertisementData["kCBAdvDataLocalName"] as! String)", errorfromserverorlink: "Peripheral name: \(String(describing: peripheral.name))", errorfromapp:"")
                    //showAlert(message: "Peripheral Not Found \(Vehicaldetails.sharedInstance.BTMacAddress)" )
                }
                
                else{
                    blePeripheral = peripheral
                    self.peripherals.append(peripheral)
                    self.RSSIs.append(RSSI)
                   
                    peripheral.delegate = self
//                    localName = advertisementData["kCBAdvDataLocalName"] as! String
//                    print(localName)
//                    self.kCBAdvData_LocalName.append(localName)
                    //        BLEPeripheralforlocalname = peripheral.name!
                    
//                    self.web.sentlog(func_name: "Advertisement data \(advertisementData["kCBAdvDataLocalName"] as! String)", errorfromserverorlink: "Peripheral name: \(String(describing: peripheral.name))", errorfromapp:"")
                }
            }
            if blePeripheral == nil {
                print("Found new pheripheral devices with services")
                print("Peripheral name: \(String(describing: peripheral.name))")
                print("**********************************")
                print ("Advertisement Data : \(advertisementData)")
            }

        }

        func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
            if error != nil {
                print("Failed to connect to peripheral")
                return
            }
        }

        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            //let BLEService_UUID = CBUUID(string: kBLEService_UUID)
            print("*****************************")
            print("Connection complete")
            print("Peripheral info: \(String(describing: blePeripheral))")

            //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
            centralManager?.stopScan()
            print("Scan Stopped")

            //Erase data that we might have
            data.length = 0

            //Discovery callback
            peripheral.delegate = self
            //Only look for services that matches transmit uuid
            peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b7")])
            peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b9")])
            peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")])

            //Once connected, move to new view controller to manager incoming and outgoing data
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)

            //           let uartViewController = storyboard.instantiateViewController(withIdentifier: "UartModuleViewController") as! FuelquantityVC
            //
            //           uartViewController.peripheral = peripheral
            //
            //           navigationController?.pushViewController(uartViewController, animated: true)
        }


        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            if (isviewdidDisappear == true)
            {
                disconnectFromDevice()
            }
            else{
                self.isDisconnect_Peripheral = true
            if(self.IsStopbuttontappedBLE == false){
                self.web.sentlog(func_name: " Reconnect to Link \(IsStopbuttontappedBLE)", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                FDcheckBLEtimer.invalidate()

                    if(self.IsStopbuttontappedBLE == true)
                    {
                        self.web.sentlog(func_name: " Reconnect to Link \(self.IsStopbuttontappedBLE)", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                    }
                    else{
                     //   self.Reconnect.isHidden = false
                      //  self.Reconnect.text = "Reconnecting to pump."//NSLocalizedString("Reconnect" , comment:"")
                //displaytime.textColor = UIColor.red
                        self.appdisconnects_automatically = true
                self.connectToDevice()
                        self.delay(0.2){
                    self.viewDidAppear(true)

                        }

                    }


            }
            else if(self.IsStopbuttontappedBLE == true)
            {
                FDcheckBLEtimer.invalidate()
            print("Disconnected")
                isDisconnect_Peripheral = true
            self.web.sentlog(func_name: "Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp:"\(error)")
            if(Last_Count == nil){
                Last_Count = "0"
                self.web.sentlog(func_name: " Last_Count \(Last_Count!) Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                self.viewDidAppear(true)
            }

            if(Last_Count! == "0"){
                self.connectToDevice()
            }
            else{
                if (IsStopbuttontapped == true)
                {
                    if(Last_Count! == "0.0"){
                        do{
                            try self.stoprelay()
                            isdisconnected = true
                        }
                        catch let error as NSError {
                            print ("Error: \(error.domain)")
                        }
                        isdisconnected = true
                       // disconnectFromDevice()
                    }
                    else{

                        if (isdisconnected == true)
                        {}
                        else
                        {
                            disconnectFromDevice()
                        }
                    }
                }
                }
            }}
        }
    }

//Mark:CallObserver

extension PreauthFuelquantity: CXCallObserverDelegate
{
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

       if call.hasEnded == true {
           print("CXCallState: Disconnected")
       }

       if call.isOutgoing == true && call.hasConnected == false {
           print("CXCallState: Dialing")
       }

       if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
           print("CXCallState: Incoming")
       }

       if call.hasConnected == true && call.hasEnded == false {
           print("CXCallState: Connected")
        self.web.sentlog(func_name: " User Connected the call.", errorfromserverorlink:"", errorfromapp: "")
            stopButtontapped()
       }
    }
}


    // MARK: - Peripheral Delegate


    extension PreauthFuelquantity: CBPeripheralDelegate {

        func writeValue(data: String){
            let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
            //change the "data" to valueString
            if let blePeripheral = blePeripheral{
                if let txCharacteristic = txCharacteristic
                {
                    blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
                }
            }
        }

        func writeCharacteristic(val: Int8){
            var val = val
            let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
            blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withResponse)
        }

        /*
         Invoked when you discover the peripheral’s available services.
         This method is invoked when your app calls the discoverServices(_:) method. If the services of the peripheral are successfully discovered, you can access them through the peripheral’s services property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
         */
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            print("*******************************************************")

            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }

            guard let services = peripheral.services else {
                return
            }
            //We need to discover the all characteristic
            print(services)
            for service in services {

                peripheral.discoverCharacteristics(nil, for: service)
                
                if service.uuid.isEqual(CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b9")){
                
                    connectedservice = "725e0bc8-6f00-4d2d-a4af-96138ce599b9"
                }
                else if service.uuid.isEqual(CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b7")){
                    connectedservice = "725e0bc8-6f00-4d2d-a4af-96138ce599b7"
                } else if service.uuid.isEqual(CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")){
                    connectedservice = "725e0bc8-6f00-4d2d-a4af-96138ce599b6"
                }
                // bleService = service
                print(service)
            }
            print("Discovered Services: \(services)")
        }

        /*
         Invoked when you discover the characteristics of a specified service.
         This method is invoked when your app calls the discoverCharacteristics(_:for:) method. If the characteristics of the specified service are successfully discovered, you can access them through the service's characteristics property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
         */

        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

            print("*******************************************************")

            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }

            guard let characteristics = service.characteristics else {
                return
            }

            print("Found \(characteristics.count) characteristics!")

            for characteristic in characteristics {
                //looks for the right characteristic

                if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Rx))  {
                    rxCharacteristic = characteristic

                    //Once found, subscribe to the this particular characteristic...
                    peripheral.setNotifyValue(true, for: rxCharacteristic!)

                    // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
                    // didUpdateNotificationStateForCharacteristic method will be called automatically
                    peripheral.readValue(for: characteristic)
                    print("Rx Characteristic: \(characteristic.uuid)")
                }
                if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Tx)){
                    txCharacteristic = characteristic
                    print("Tx Characteristic: \(characteristic.uuid)")
                }
                peripheral.discoverDescriptors(for: characteristic)
            }
        }


        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            guard characteristic == rxCharacteristic,
                  let characteristicValue = characteristic.value,
                  let ASCIIstring = NSString(data: characteristicValue,
                                             encoding: String.Encoding.utf8.rawValue)
            else { return }
            
            characteristicASCIIValue = ASCIIstring as String
            if((characteristicASCIIValue as String).contains("L10:"))
            {
                Last10transaction = (characteristicASCIIValue as String)
                self.web.sentlog(func_name: " Get response from info command to link \(characteristicASCIIValue)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
            }
            
            if(characteristicASCIIValue == "Notify enabled..." || characteristicASCIIValue == "LinkBlue notify enabled..." || characteristicASCIIValue == "{\"notify\" : \"enabled\"}")
            {
                isNotifyenable = true
            }
            if("\(characteristicASCIIValue)".contains("{\"pulse\":"))
            {
                self.parsepulsedata()
            }
            
            if((characteristicASCIIValue as String).contains("pulse:"))
            {
            let Split = self.characteristicASCIIValue.components(separatedBy: ":")
            if(Split.count == 2){
                let reply1 = Split[0]
                let count = Split[1]
                let dc = count.trimmingCharacters(in: .whitespaces)
                let datacount =  Int(dc as String)!
                
                if(reply1 == "pulse" ){
                    print("\(self.characteristicASCIIValue)")
                    //                        if(appdisconnects_automatically == true)
                    //                        {
                    //
                    //                        }
                    //                        else{
                    self.web.sentlog(func_name: " BLE Response from link is \(self.characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
                    //                        }
                    //                        if(datacount > 100)
                    //                        {
                    //                            self.GetPulserBLE(counts:"\(100)")
                    //                        }
                    //                        else{
                    self.countfromlink = datacount
                    self.GetPulserBLE(counts:"\(datacount)")
                    //                        }
                    self.displaytime.text = ""
                    
                }
                
                else if(self.characteristicASCIIValue == "pulse: 0")
                {
                }
            }
            }
            
            
            print("Value Recieved: \((characteristicASCIIValue as String))")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
            
            
            guard let characteristicData = characteristic.value,
                  let stringFromData = String(data: characteristicData, encoding: .utf8) else { return }
            
            
            
            guard characteristic == txCharacteristicupload,
                  let characteristicValue = characteristic.value,
                  let stringFromData = String(data: characteristicData, encoding: .utf8)
            else{return}
            // Have we received the end-of-message token?
            if stringFromData == "EOM" {
                // End-of-message case: show the data.
                // Dispatch the text view update to the main queue for updating the UI, because
                // we don't know which thread this method will be called back on.
                DispatchQueue.main.async() {
                    //self.textView.text = String(data: self.data, encoding: .utf8)
                }
                
                // Write test data
                
            } else {
                // Otherwise, just append the data to what we have previously received.
                sendData()//bin_data.append(characteristicData)
            }
        }


        func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
            print("*******************************************************")

            if error != nil {
                print("\(error.debugDescription)")
                return
            }
            guard let descriptors = characteristic.descriptors else { return }

            descriptors.forEach { descript in
                print("function name: DidDiscoverDescriptorForChar \(String(describing: descript.description))")
                print("Rx Value \(String(describing: rxCharacteristic?.value))")
                print("Tx Value \(String(describing: txCharacteristic?.value))")
                //if it is subscribed the Notification has begun for: E49227E8-659F-4D7E-8E23-8C6EEA5B9173
            }
        }

    //    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
    //        <#code#>
    //    }

        func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
            print("*******************************************************")

            if (error != nil) {
                print("Error changing notification state:\(String(describing: error?.localizedDescription))")
                ifSubscribed = false

            } else {
                print("Characteristic's value subscribed")
            }

            if (characteristic.isNotifying) {
                ifSubscribed = true
                web.sentlog(func_name: "Connected to BT link, Subscribed. Set Notify enabled... to true in BLE transaction for ID:", errorfromserverorlink: "\(characteristic.uuid)", errorfromapp: ""); print("Subscribed. Notification has begun for: \(characteristic.uuid)")
                if(IsStartbuttontapped == false)
                {
                getlast10transaction()
                    delay(1){
//                        if(self.BTMacAddress == true)
//                        {
                        self.start.isEnabled = true
                        self.start.isHidden = false
                        self.cancel.isHidden = false
                        self.Pwait.isHidden = true
                        self.Activity.stopAnimating()
                        self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
//                        }
//                        else
//                        {
//                            self.showAlert(message: "Macaddress is not matched \(Vehicaldetails.sharedInstance.BTMacAddress)" )
//                        }
                    }
                }
                if(self.appdisconnects_automatically == true)
                {
                    if(self.AppconnectedtoBLE == true){
                        self.getlast10transaction()
                        self.BLErescount = 0
                        self.baseTextView = ""
                        self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                        self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                        NotificationCenter.default.removeObserver(self)
                        self.updateIncomingData ()
                        
                        self.cf.delay(0.1){
                            self.start.isHidden = true
                            self.cancel.isHidden = true
                            self.Stop.isHidden = false
                            //                                self.displaytime.text = NSLocalizedString("Fueling", comment:"")
                            //self.displaytime.textColor = UIColor.black
                            self.FDcheckBLEtimer.invalidate()
                            self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
                        }
                    }
                }
            }
            else
            {
                ifSubscribed = false
            }
        }

        func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
            guard error == nil else {
                print("Error discovering services: error \(error)")
                return
            }
            print("Message sent")
        }

        func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
            guard error == nil else {
                print("Error discovering services: error")
                return
            }
            print("Succeeded!")
        }


      // Stub to stop run-time warning
      func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {}
        
       
        /*
         *  This is called when peripheral is ready to accept more data when using write without response
         */
        func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral)
        {
            self.sendData()
        }

    }

    

   


