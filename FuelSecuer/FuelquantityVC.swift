
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
import CoreLocation
import CoreBluetooth
import Network
import AVFoundation
//import CallKit

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
         iPadmini4WiFi      = "iPad mini 4 WiFi",
         iPadminiWC         = "iPad mini WiFi Cellular",
         iPadAir2WiFi       = "iPad Air 2 WiFi",
         iPadAir2Cellular   = "iPad Air 2 Cellular",
         iPadAir1           = "iPad Air 1",
         iPadAir2           = "iPad Air 2",
         iPadPro9_7         = "iPad Pro 9.7\"",
         iPadPro9_7_cell    = "iPad Pro 9.7\" cellular",
         iPadPro12_9        = "iPad Pro 12.9\"",
         iPadPro12_9_cell   = "iPad Pro 12.9\" cellular",
         iPadPro2_12_9      = "iPad Pro 2 12.9\"",
         iPadPro2_12_9_cell = "iPad Pro 2 12.9\" cellular",
         iPadPro10inch2ndGen =  "iPad Pro 10.5-inch 2nd Gen",
         
         iPad6thGenWiFi = "iPad 6th Gen (WiFi)",
         iPad6thGenWiFiCellular = "iPad 6th Gen (WiFi+Cellular)",
         iPad7thGenWiFi = "iPad 7th Gen 10.2-inch (WiFi)",
         iPad7thGenWiFiCellular = "iPad 7th Gen 10.2-inch (WiFi+Cellular)",
         iPadPro113rdGenWiFi = "iPad Pro 11 inch 3rd Gen (WiFi)",
         iPadPro113rdGen1TBWiFi = "iPad Pro 11 inch 3rd Gen (1TB, WiFi)",
         iPadPro113rdGenWiFiCellular = "iPad Pro 11 inch 3rd Gen (WiFi+Cellular)",
         iPadPro3G1TBWiFiCellular = "iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)",
         iPadPro12inch3GenW = "iPad Pro 12.9 inch 3rd Gen (WiFi)",
         iPadPro12inch3Gen1TBW = "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)",
         iPadPro12inch3GenWC = " iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)",
         iPadPro12inch3Gen1TBWC = "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)",
         iPadPro11inch4GenW =  "iPad Pro 11 inch 4th Gen (WiFi)",
         iPadPro11inch4GenWC =  "iPad Pro 11 inch 4th Gen (WiFi+Cellular)",
         iPadPro12inch4GenW = "iPad Pro 12.9 inch 4th Gen (WiFi)",
         iPadPro12inch4GenWC = "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)",
         iPadmini5GenW =  "iPad mini 5th Gen (WiFi)",
         iPadmini5Gen =  "iPad mini 5th Gen",
         iPadAir3GenW =  "iPad Air 3rd Gen (WiFi)",
         iPadAir3Gen = "iPad Air 3rd Gen",
         iPad8GenW = "iPad 8th Gen (WiFi)",
         iPad8GenWC =  "iPad 8th Gen (WiFi+Cellular)",
         iPad9GenW = "iPad 9th Gen (WiFi)",
         iPad9GenWC = "iPad 9th Gen (WiFi+Cellular)",
         iPad6miniGenW = "iPad mini 6th Gen (WiFi)",
         iPadmini6GenWC = "iPad mini 6th Gen (WiFi+Cellular)",
         iPadAir4GenW = "iPad Air 4th Gen (WiFi)",
         iPadAir4GenWC = "iPad Air 4th Gen (WiFi+Cellular)",
         iPadPro115Gen = "iPad Pro 11 inch 5th Gen",
         iPadPro125Gen = "iPad Pro 12.9 inch 5th Gen",
         iPadAir5thGenW = "iPad Air 5th Gen (WiFi)",
         iPadAir5thGenWC = "iPad Air 5th Gen (WiFi+Cellular)",
         iPad10thGen = "iPad 10th Gen",
         
         iPadPro11inch4thGen = "iPad Pro 11 inch 4th Gen",
         
         iPadPro129inch6thGen = "iPad Pro 12.9 inch 6th Gen",
         
         iPadPro13inch = "iPad Pro (13-inch) (M4)",
         
         
         
         iPhone6            = "iPhone 6",
         iPhone6plus        = "iPhone 6 Plus",
         iPhone6S           = "iPhone 6S",
         iPhone6Splus       = "iPhone 6S Plus",
         iPhoneSE           = "iPhone SE",
         iPhone7            = "iPhone 7",
         iPhone7plus        = "iPhone 7 Plus",
         iPhone8            = "iPhone 8",
         iPhone8plus        = "iPhone 8 Plus",
         iPhoneXGlobal      = "iPhone X Global",
         iPhoneXGSM         = "iPhone X GSM",
         iPhoneX            = "iPhone X",
         iPhoneXR           = "iPhone XR",
         iPhoneXS           = "iPhone XS",
         iPhoneXSMax        = "iPhone XS Max",
         iPhone11           = "iPhone 11",
         iPhone11Pro        = "iPhone11 Pro",
         iPhone11ProMax     = "iPhone11 Pro Max",
         iPhoneXSMaxGlobal  = "iPhone XS Max Global",
         iPhoneSE2ndGen     = "iPhone SE 2nd Gen",
         iPhone12Mini       =  "iPhone 12 Mini",
         iPhone12           = "iPhone 12",
         iPhone12Pro        = "iPhone 12 Pro",
         iPhone12ProMax     = "iPhone 12 Pro Max",
         iPhone13Pro        = "iPhone 13 Pro",
         iPhone13ProMax     = "iPhone 13 Pro Max",
         iPhone13Mini       = "iPhone 13 Mini",
         iPhone13           = "iPhone 13",
         iPhoneSE3rdGen     = "iPhone SE 3rd Gen",
         iPhone14           = "iPhone 14",
         iPhone14Plus       = "iPhone 14 Plus",
         iPhone14Pro        = "iPhone 14 Pro",
         iPhone14ProMax     = "iPhone 14 Pro Max",
         
         iPhone15           = "iPhone 15",
         iPhone15Plus       = "iPhone 15 Plus",
         iPhone15Pro        = "iPhone 15 Pro",
         iPhone15ProMax     = "iPhone 15 Pro Max",
         
         
         unrecognized       = "?unrecognized?"
    
}

public extension UIDevice {
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        let modelMap : [ String : Model ] = [
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
            
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            
            "iPad4,2"   : .iPadAir1,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            
            "iPad5,1"   : .iPadmini4WiFi,
            "iPad5,2"   : .iPadminiWC,
            "iPad5,3"   : .iPadAir2WiFi,
            "iPad5,4"   : .iPadAir2Cellular,
            
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPad5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9_cell,
            
            "iPad7,3" : .iPadPro10inch2ndGen,// iPad Pro 10.5-inch 2nd Gen
            "iPad7,4" : .iPadPro10inch2ndGen, //iPad Pro 10.5-inch 2nd Gen
            "iPad7,5": .iPad6thGenWiFi,//iPad 6th Gen (WiFi)
            "iPad7,6" : .iPad6thGenWiFiCellular, //iPad 6th Gen (WiFi+Cellular)
            "iPad7,11" : .iPad7thGenWiFi, //iPad 7th Gen 10.2-inch (WiFi)
            "iPad7,12" : .iPad7thGenWiFiCellular,//iPad 7th Gen 10.2-inch (WiFi+Cellular)
            "iPad8,1" : .iPadPro113rdGenWiFi,//iPad Pro 11 inch 3rd Gen (WiFi)
            "iPad8,2" : .iPadPro113rdGen1TBWiFi,//iPad Pro 11 inch 3rd Gen (1TB, WiFi)
            "iPad8,3" : .iPadPro113rdGenWiFiCellular, //iPad Pro 11 inch 3rd Gen (WiFi+Cellular)
            "iPad8,4" : .iPadPro113rdGen1TBWiFi,//iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)
            "iPad8,5" : .iPadPro12inch3GenW,//iPad Pro 12.9 inch 3rd Gen (WiFi)
            "iPad8,6" : .iPadPro12inch3Gen1TBW,//iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)
            "iPad8,7" : .iPadPro12inch3GenWC,//iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)
            "iPad8,8" : .iPadPro12inch3Gen1TBWC,//iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)
            "iPad8,9" : .iPadPro11inch4GenW,//iPad Pro 11 inch 4th Gen (WiFi)
            "iPad8,10" : .iPadPro11inch4GenWC,//iPad Pro 11 inch 4th Gen (WiFi+Cellular)
            "iPad8,11" : .iPadPro12inch4GenWC,//iPad Pro 12.9 inch 4th Gen (WiFi)
            "iPad8,12" : .iPadPro12inch4GenWC,//iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)
            "iPad11,1" : .iPadmini5GenW,//iPad mini 5th Gen (WiFi)
            "iPad11,2" : .iPadmini5Gen,//iPad mini 5th Gen
            "iPad11,3" : .iPadAir3GenW,//iPad Air 3rd Gen (WiFi)
            "iPad11,4" : .iPadAir3Gen,//iPad Air 3rd Gen
            "iPad11,6" : .iPad8GenW,//iPad 8th Gen (WiFi)
            "iPad11,7" : .iPad8GenWC,//iPad 8th Gen (WiFi+Cellular)
            "iPad12,1" : .iPad9GenW,//iPad 9th Gen (WiFi)
            "iPad12,2" : .iPad9GenWC,//iPad 9th Gen (WiFi+Cellular)
            "iPad14,1" : .iPad6miniGenW,//iPad mini 6th Gen (WiFi)
            "iPad14,2" : .iPadmini6GenWC,//iPad mini 6th Gen (WiFi+Cellular)
            "iPad13,1" : .iPadAir4GenW,//iPad Air 4th Gen (WiFi)
            "iPad13,2" : .iPadAir4GenWC,//iPad Air 4th Gen (WiFi+Cellular)
            "iPad13,4" : .iPadPro115Gen,//iPad Pro 11 inch 5th Gen
            "iPad13,5" : .iPadPro115Gen,//iPad Pro 11 inch 5th Gen
            "iPad13,6" : .iPadPro115Gen,//iPad Pro 11 inch 5th Gen
            "iPad13,7" : .iPadPro115Gen,//iPad Pro 11 inch 5th Gen
            "iPad13,8" : .iPadPro125Gen,//iPad Pro 12.9 inch 5th Gen
            "iPad13,9" : .iPadPro125Gen,//
            "iPad13,10" : .iPadPro125Gen,//
            "iPad13,11" : .iPadPro125Gen,//iPad Pro 12.9 inch 5th Gen
            "iPad13,16" : .iPadAir5thGenW,//iPad Air 5th Gen (WiFi)
            "iPad13,17" : .iPadAir5thGenWC,//iPad Air 5th Gen (WiFi+Cellular)
            "iPad13,18" : .iPad10thGen,//iPad 10th Gen
            "iPad13,19" : .iPad10thGen,//iPad 10th Gen
            "iPad14,3" : .iPadPro11inch4thGen,//iPad Pro 11 inch 4th Gen
            "iPad14,4" : .iPadPro11inch4thGen,//iPad Pro 11 inch 4th Gen
            "iPad14,5" : .iPadPro129inch6thGen,//iPad Pro 12.9 inch 6th Gen
            "iPad14,6" : .iPadPro129inch6thGen,//iPad Pro 12.9 inch 6th Gen
        
            "iPad16,5" : .iPadPro13inch,//"iPad Pro (13-inch) (M4)"
            "iPad16,6" : .iPadPro13inch, //"iPad Pro (13-inch) (M4)"
            
            
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            
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
            "iPhone10,3" : .iPhoneXGlobal,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,6" : .iPhoneXGSM,
            
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMaxGlobal,
            "iPhone11,8" : .iPhoneXR,
            
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2ndGen,
            
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            
            "iPhone14,2" : .iPhone13Pro,
            "iPhone14,3" : .iPhone13ProMax,
            "iPhone14,4" : .iPhone13Mini,
            "iPhone14,5" : .iPhone13,
            "iPhone14,6" : .iPhoneSE3rdGen,
            "iPhone14,7" : .iPhone14,
            "iPhone14,8" : .iPhone14Plus,
            
            "iPhone15,2" : .iPhone14Pro,
            "iPhone15,3" : .iPhone14ProMax,
           
            "iPhone15,4" : .iPhone15,
            "iPhone15,5" : .iPhone15Plus,
            "iPhone16,1" : .iPhone15Pro,
            "iPhone16,2" : .iPhone15ProMax
            
            
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {//} .init(validatingUTF8: modelCode!)!] {
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

var inStream : InputStream?
var outStream: OutputStream?
let addr = "192.168.4.1"
let port = 80
var buffer = [UInt8](repeating: 0, count:4096)
var stringbuffer:String = ""
var status :String = ""
var sysdata1:NSDictionary!
var replydata:NSData!
var tlddatafromlink:String!
var reply :String!
let defaults = UserDefaults.standard
var audio:AVPlayer!

class FuelquantityVC: UIViewController,UITextFieldDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate, UITextViewDelegate//,CBCentralManagerDelegate, CBPeripheralDelegate
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
    
    var readRSSITimer: Timer!
    var RSSIholder: NSNumber = 0
    
    let kBLEService_UUID = "4c425346-0000-1000-8000-00805f9b34fb"
    let kBLE_Characteristic_uuid_Tx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    let kBLE_Characteristic_uuid_Tx_upload = "e49227e8-659f-4d7e-8e23-8c6eea5b9174"
    let discoverServices_upload = "725e0bc8-6f00-4d2d-a4af-96138ce599b7"
    let kBLE_Characteristic_uuid_Rx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    
    var iskBLE_Characteristic_uuid_Tx_upload_setnotifytrue = false
    var iskBLE_Characteristic_uuid_Tx_setnotifytrue = false
    var txCharacteristic : CBCharacteristic?
    var txCharacteristicupload : CBCharacteristic?
    var rxCharacteristic : CBCharacteristic?
    var blePeripheral : CBPeripheral?
    var characteristicASCIIValue = ""
    var discoveredPeripheral: CBPeripheral?
    var connectedservice:String = ""
    var isupgradeBLE = false
    var isrelayon = false
    
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    var BLErescount = 0
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var peripheral: CBPeripheral!
    var RSSIs = [NSNumber]()
    var data = NSMutableData()
    var peripherals: [CBPeripheral] = []
    
    var ifSubscribed = false
    var isdisconnected = false
    var isDisconnect_Peripheral = false
    var FDcheckBLEtimer:Timer = Timer()
    var Count_Fdcheck = 0
    var countwififailConn:Int = 0
    var Last10transaction = ""
    //var isrelayon = false
    var sendrename_linkname = false
    var isUpdateMACAddress = false
    var isBTlinkDisconnect = false
    
    var isssidconnected = "false"
    
    var lasttransactioncount = ""
    var sentDataPacket:Data!
    var bindata:Data!
    var totalbindatacount:Int!
    var replydata:NSData!
    var subData = Data()
    var lasttransID = ""
    
    var hostUDP = "192.168.4.1"
    var portUDP = 80
    var appconnecttoUDP = false
    var AppconnectedtoBLE = false
    var BTMacAddress = false
    
    var cf = Commanfunction()
    var web = Webservices()
    var tcpcon = TCPCommunication()
    var unsync = Sync_Unsynctransactions()
    
    var IsStartbuttontapped : Bool = false
    var IsStopbuttontapped:Bool = false
    var IsStopbuttontappedBLE:Bool = false
    var at_fdcheckble :Bool = false
    var Ispulsarcountsame :Bool = false
    var PulseCountSamefunctionCall :Bool = false
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
    var counts:String!
    var reply_server:String = ""
    var isviewdidDisappear = false
    var iterationcountforupgrade = 0
    var replysentlog :String!
    var contents:Data!
    var countfromlink = 0
    var isNotifyenable = false
    var GetPulsarstartimer:Timer = Timer() //  var timer:Timer = Timer()    // #selector(self.GetPulser) call the Getpulsar function.
    var timerview:Timer = Timer()  // #selector(ViewController.viewDidAppear(_:)) call viewController timerview
    //var stoptimer:Timer = Timer()
    var stoptimergotostart:Timer = Timer() ///#selector(call gotostart function)
    var stoptimer_gotostart:Timer = Timer() ///#selector(gotostart from viewWillapeared)
    var stoptimerIspulsarcountsame:Timer = Timer()  ///call stopIspulsarcountsame for
    // var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()  ///#selector(FuelquantityVC.stoprelay) to stop the app
    var timer_conutnotupdateprevious = Timer()
    var stoptimerIspulsarcountsamefor10sec:Timer = Timer()
    
    var y :CGFloat = CGFloat()
    var isokbuttontapped = false
    var fuelquantity:Double!
    var reply :String!
    var reply1 :String!
    var startbutton:String = ""
    var string:String = ""
    var isupload_file = false
    var emptypulsar_count:Int = 0
    var total_count:Int = 0
    var Last_Count:String!
    var Samecount:String!
    var renameconnectedwifi:Bool = false
    var iscountwififailConnfalse:Bool = false
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
    //    var localName = ""
    var BLEPeripheralforlocalname = ""
    
    var sendtransactioncausereinstate = true
    var Interrupted_TransactionFlag = "y"
    var sendInterrupted_TransactionFlagN = true
    var newAsciiText = NSMutableAttributedString()
    var baseTextView: String = ""
    var gotLinkVersion = false
    var IsUpgrade = false
    private var observationToken: Any?
    
    
    private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
    let defaults = UserDefaults.standard
    //Mark IBOutlets
    
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
    
    @IBOutlet weak var Reconnect: UILabel!
    //@IBOutlet weak var progressviewtext: UILabel!
    //    @IBOutlet weak var progressview: UIProgressView!
    
    
    ///view did Appear every time we visit this page and we see this page below fuction is called.
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
        }
        self.timerview.invalidate()
        if(startbutton == "true"){}
        else{
            if(Vehicaldetails.sharedInstance.HubLinkCommunication != "BT")
            {
                self.displaytime.text = NSLocalizedString("MessageFueling1" , comment:"")
            }
            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
            {
                self.cancelScan()
                if(Vehicaldetails.sharedInstance.peripherals.count == 0){
                    //remove this #1791 call multiple
                    //                    if(self.appdisconnects_automatically == true){
                    centralManager = CBCentralManager(delegate: self, queue: nil)
                    //                    }
                    
                }
                else
                {
                    self.cancelScan()
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
                
                if(Vehicaldetails.sharedInstance.checkSSIDwithLink == "true"){
                    Vehicaldetails.sharedInstance.checkSSIDwithLink = "false"
                }
                
                if(self.ifSubscribed == true){
                    
                    //                    if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                    //                    {
                    //                        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                    //                        {
                    //                            self.uploadbinfile()
                    //                            //                                                                    self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    ////                            _ = self.firmwareUpdateDemo()
                    ////                            self.sendData()
                    //                            _ = self.web.UpgradeCurrentiotVersiontoserver()
                    //                            self.web.sentlog(func_name: "Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    //
                    //                        }
                    //                        else
                    //                        {
                    //                            self.web.sentlog(func_name: " Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    //                            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                    //                            {
                    //                                self.tcpcon.getuser()
                    //                            }
                    //                        }
                    //                        //                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
                    //                    }
                    
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
                        self.cf.delay(0.5){
                            self.updateIncomingData()
                            //                        NotificationCenter.default.removeObserver(self)
                        }
                        self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
                        self.AppconnectedtoBLE = true
                        if(self.appdisconnects_automatically == true)
                        {
                            
                        }
                    }
                    else{
                        
                        if(Vehicaldetails.sharedInstance.BTMacAddress == "")
                        {
                            self.getlast10transaction()
                        }
                        
                        if(self.appdisconnects_automatically == true)
                        {
                            
                        }
                        else{
                            
                            self.Activity.stopAnimating()
                            self.timerview.invalidate()
                            self.stoptimergotostart.invalidate()
                            self.stoptimer_gotostart.invalidate()
                            self.web.sentlog(func_name: "Sent transaction ID to BT link \(Vehicaldetails.sharedInstance.TransactionId)" , errorfromserverorlink: "", errorfromapp: "")
                            
                            
                            self.outgoingData(inputText: "LK_COMM=txtnid:\(Vehicaldetails.sharedInstance.TransactionId)")
                            
                            NotificationCenter.default.removeObserver(self)
                            self.updateIncomingData()
                            //                        }
                            self.stoptimergotostart.invalidate()
                            self.stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(FuelquantityVC.gotoStart), userInfo: nil, repeats: false)
                            
                            self.web.sentlog(func_name: "Starts screen timeout timer.", errorfromserverorlink: "", errorfromapp: "")
                            
                            //    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                        }
                        //                        }
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
                                
                                self.showstart = self.web.getinfo()
                                
                                if(Vehicaldetails.sharedInstance.MacAddress == "" && self.cf.getSSID() != "" )
                                {
                                    if (self.isUpdateMACAddress == false){
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
                                                if(ResponceMessage != "fail")
                                                {
                                                    self.isUpdateMACAddress = true
                                                    self.showstart = "true"
                                                }
                                                else if(ResponceMessage == "fail")
                                                {
                                                    //                                                    self.showstart = "false"
                                                    //self.error400(message: ResponceText as String)
                                                }
                                            }
                                            //}
                                            catch let error as NSError {
                                                print ("Error: \(error.domain)")
                                                let text = error.localizedDescription //+ error.debugDescription
                                                let test = String((text.filter { !" \n".contains($0) }))
                                                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                                                print(newString)
                                                
                                            }
                                        } }
                                }
                                
                                
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
                                            self.startFueling()
                                            self.cancel.isHidden = true
                                        }
                                    }
                                    
                                    else{
                                        
                                        if(self.defaults.string(forKey: "Companyname") == "Company2")
                                        {
                                            //#2437
                                            if(Vehicaldetails.sharedInstance.selectedCompanybyGA.contains("Demo-") || Vehicaldetails.sharedInstance.GACompany.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == Vehicaldetails.sharedInstance.selectedCompanybyGA.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                            {
                                                self.start.isEnabled = true
                                                self.start.isHidden = false
                                                self.cancel.isHidden = false
                                                self.Pwait.isHidden = true
                                                self.Activity.stopAnimating()
                                                self.timerview.invalidate()
                                                self.stoptimergotostart.invalidate()
                                                
                                                self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                            }
                                            else{
                                                self.startFueling()
                                                self.cancel.isHidden = true
                                                self.Pwait.isHidden = true
                                                self.Activity.stopAnimating()
                                                self.timerview.invalidate()
                                                self.stoptimergotostart.invalidate()
                                                
                                                self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                            }
                                        }
                                        //                                        {
                                        //                                            self.startFueling()
                                        //                                            self.cancel.isHidden = true
                                        //                                            self.Pwait.isHidden = true
                                        //                                            self.Activity.stopAnimating()
                                        //                                            self.timerview.invalidate()
                                        //                                            self.stoptimergotostart.invalidate()
                                        //
                                        //                                            self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                        //                                        }
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
                                            self.stoptimergotostart = Timer.scheduledTimer(timeInterval: (Double(1)*120), target: self, selector: #selector(FuelquantityVC.gotoStart), userInfo: nil, repeats: false)
                                            
                                            self.web.sentlog(func_name:" Starts screen timeout timer.", errorfromserverorlink: "", errorfromapp: "")
                                        }
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
                                
                                if(self.showstart == "MACNotSame")
                                {
                                    self.displaytime.text = "There is a MAC address error. Please contact Support"
                                    self.showAlert(message: "There is a MAC address error. Please contact Support.")//"Invalid Link Mac Address. Please try again.")
                                    self.cf.delay(10)
                                    {
                                        self.gotoStart()
                                        self.web.sentlog(func_name:"There is a MAC address error app autostops.", errorfromserverorlink: "", errorfromapp: "")
                                    }
                                    self.timerview.invalidate()
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
                                            self.cf.delay(0.5){
                                                //self.showstart = self.web.getinfo()//_ssid()
                                            }
                                            if(self.showstart == "true"){
                                                
                                                if(self.defaults.string(forKey: "Companyname") == "Company2")
                                                {
                                                    //#2437
                                                    if(Vehicaldetails.sharedInstance.selectedCompanybyGA.contains("Demo-") || Vehicaldetails.sharedInstance.GACompany.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == Vehicaldetails.sharedInstance.selectedCompanybyGA.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                                    {
                                                        self.start.isEnabled = true
                                                        self.start.isHidden = false
                                                        self.cancel.isHidden = false
                                                        self.Pwait.isHidden = true
                                                        self.Activity.stopAnimating()
                                                        self.timerview.invalidate()
                                                        self.stoptimergotostart.invalidate()
                                                        
                                                        self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                                    }
                                                    else{
                                                        self.startFueling()
                                                        self.cancel.isHidden = true
                                                        self.Pwait.isHidden = true
                                                        self.Activity.stopAnimating()
                                                        self.timerview.invalidate()
                                                        self.stoptimergotostart.invalidate()
                                                        
                                                        self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                                    }
                                                }
                                                //                                                {
                                                //                                                    self.startFueling()
                                                //                                                    self.cancel.isHidden = true
                                                //                                                    self.Pwait.isHidden = true
                                                //                                                    self.Activity.stopAnimating()
                                                //                                                    self.timerview.invalidate()
                                                //                                                    self.stoptimergotostart.invalidate()
                                                //
                                                //                                                    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                                                //                                                }
                                                else{
                                                    
                                                    
                                                    self.start.isEnabled = true
                                                    self.start.isHidden = false
                                                    self.cancel.isHidden = false
                                                    self.Pwait.isHidden = true
                                                    self.Activity.stopAnimating()
                                                    self.timerview.invalidate()
                                                    self.stoptimergotostart.invalidate()
                                                }
                                                
                                            }
                                            else
                                            if(self.showstart == "false"){
                                                self.start.isEnabled = false
                                                self.start.isHidden = true
                                                self.cancel.isHidden = true
                                                self.displaytime.text =  NSLocalizedString("MessageFueling1" , comment:"")
                                                
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
                                                self.error400(message: "Unable to verify the Connected link.")
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (self.countwififailConn >= 5)
                                    {
                                        self.displaytime.text = "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'Wi-Fi Settings' screen."
                                        self.displaytime.textColor = UIColor.red
                                    }
                                    else{
                                        self.displaytime.text = NSLocalizedString("MessageFueling1" , comment:"")
                                        self.displaytime.textColor = UIColor.black
                                    }
                                    // self.displaytime.text =  NSLocalizedString("MessageFueling1" , comment:"")
                                    self.displaytime.textColor = UIColor.black//+ ". Selected Hose \(Vehicaldetails.sharedInstance.SSId) and connected Hose \(self.cf.getSSID()) name is not Matched. Please check again."
                                    self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(self.connectedwifi!)" + NSLocalizedString("Wifi", comment:""))
                                    
                                    
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
    
    
    
    
    @objc func gotoStart(){
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
            
            if(IsStartbuttontapped == true)
            {
                
            }  /// Is Start button tapped is true then do nothing
            else {
                
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                {
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    if(self.ifSubscribed == true){
                        //print(self.Last_Count)
                        if(self.Last_Count == "0" || self.Last_Count == nil)
                        {
                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "5")
                        }
                        //                    cleanup()
                        self.isviewdidDisappear = true
                        if(isrelayon == true){
                            self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                            self.updateIncomingData()
                        }
                        
                        self.disconnectFromDevice()
                        appDel.start()
                        self.Activity.style = UIActivityIndicatorView.Style.gray;
                        self.Activity.startAnimating()
                        self.timerview.invalidate()
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "5")
                       
                        
                    }
                }
                else if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP"){
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
                    
                    self.web.sentlog(func_name:" Fueling_screen_timeout, back to home screen", errorfromserverorlink: "", errorfromapp: "")
                    FDcheckBLEtimer.invalidate()
                    self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
                    let appDel = UIApplication.shared.delegate! as! AppDelegate
                    appDel.start()
                    stoptimer_gotostart.invalidate()
                    stoptimergotostart.invalidate()
                    self.timerview.invalidate()
                }
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
        //        if(Last_Count == nil ){
        //            Last_Count = "0"
        //        }
        //        if(Int(Last_Count)! > 0 ){}
        //        else{
        if(Cancel_Button_tapped == true){}
        else{
            
            if(IsStartbuttontapped == true){
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
                self.timerview.invalidate()
            }  /// Is Start button tapped is true then do nothing
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
                self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
                self.timerview.invalidate()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        disconnectFromDevice()
        self.peripherals = []
        //        self.kCBAdvData_LocalName = []
        print(Vehicaldetails.sharedInstance.PulseRatio)
        
        UIApplication.shared.isIdleTimerDisabled = true
        stoptimer_gotostart.invalidate()
        stoptimergotostart.invalidate()
        self.timerview.invalidate()
        //if user goes to the back ground and then come into the foreground and do nothing for 60 sec then it go to home screen
        //stoptimer_gotostart = Timer.scheduledTimer(timeInterval: (Double(1)*60), target: self, selector: #selector(FuelquantityVC.gotostart), userInfo: nil, repeats: false)
        //if Transaction ID = 0 app stops the connection and send to fueling screen. Stops all Timer
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            self.timerview.invalidate()
            self.goto_Start()
            self.web.sentlog(func_name:" AppStops because transaction id 0, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
        }
        else{
            //if user goes to the back ground and then come into the foreground and do nothing for 60 sec then it go to home screen
            stoptimer_gotostart = Timer.scheduledTimer(timeInterval: (Double(1)*120), target: self, selector: #selector(FuelquantityVC.gotoStart), userInfo: nil, repeats: false)
        }
        
        start.isEnabled = false
        start.isHidden = true
        Reconnect.isHidden = true
        
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
        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
        {
            
            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP")
                
            {
                if(Vehicaldetails.sharedInstance.isUpgradeComplete == "True")
                {
                    _ = self.web.UpgradeCurrentVersiontoserver()
                }
            }
        }
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
            
            if(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce == "1")
            {
//                print(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce,defaults.string(forKey: "UpdateSwitchTimeBounceForLink"))
                if(defaults.string(forKey: "UpdateSwitchTimeBounceForLink") != nil)
                {
                    //                    if(defaults.string(forKey: "UpdateSwitchTimeBounceForLink") == "true")
                    //                    {
                    _ = web.UpdateSwitchTimeBounceForLink()
                    //                    }
                }
            }
            else
            {
                if(defaults.string(forKey: "UpdateSwitchTimeBounceForLink") != nil) {
                   
                        _ = web.UpdateSwitch_TimeBounceForLink()
                }
            }
            
            if (isokbuttontapped == true)
            {
                //                cleanup()
            }
            else{
                if(ifSubscribed == true){
                    //                    cleanup()
                    //            isviewdidDisappear = true
                    //            self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                    //            self.updateIncomingData()
                    //            self.disconnectFromDevice()
                }
                
            }
             if(IsStopbuttontapped == true)
            {
                self.disconnectFromDevice()
            }
        }
        onFuelingScreen = false
//        self.unsync.unsyncTransaction()
//        unsync.unsyncP_typestatus()
    }
    
    override func viewDidLoad() {
        
        self.Activity.startAnimating()
        stoptimergotostart.invalidate()
        onFuelingScreen = true
        Ispulsarcountsame = false
        //        if defaults.value(forKey: "Lasttransactionidentifier") != nil {
        //          //Key exists
        //            print(defaults.value(forKey: "Lasttransactionidentifier"))
        //        }
        //        else
        //        {
        //            defaults.set("", forKey: "Lasttransactionidentifier")
        //        }
        //        self.baseTextView.delegate = self
        //        integrtedresponse?.text = ""
        if(Vehicaldetails.sharedInstance.IsFirstTimeUse == "True")
        {
            showAlert(message: "This is the first time you are using the system. Please be sure the quantity shown on the display matches the final quantity on the dispenser. If not, please be sure to call in to Support" )
        }
        if((Vehicaldetails.sharedInstance.PulseRatio as NSString).doubleValue == 0)
        {
            self.web.sentlog(func_name:" Pulsar Ratio = \(Vehicaldetails.sharedInstance.PulseRatio).", errorfromserverorlink: "", errorfromapp: "")
            gotoStart()
        }
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        //callObserver.setDelegate(self, queue: nil)
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
                // centralManager = CBCentralManager(delegate: self, queue: nil)
            }
            //            let notificationCenter = NotificationCenter.default
            //               notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
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
        doneButton.addTarget(self, action: #selector(FuelquantityVC.tapAction), for: UIControl.Event.touchUpInside);
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
    
    func saveTrans(lastpulsarcount:String,lasttransID:String){
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
    
    func startFueling()
    {
        
        stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        
        print("before get relay" + cf.dateUpdated)
        //        let replygetrelay = self.web.getrelay()   ///get relay status to check link is busy or not
        //        let Split = replygetrelay.components(separatedBy: "#")
        //        reply = Split[0]
        //        let error = Split[1]
        //        //print(self.reply)
        //        if(self.reply == "-1"){
        //
        //            let text = error//.localizedDescription //+ error.debugDescription
        //            let test = String((text.filter { !" \n".contains($0) }))
        //            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
        //            print(newString)
        //            self.web.sentlog(func_name:" GetRelay Function ", errorfromserverorlink: "\(newString)", errorfromapp: NSLocalizedString("wificonnection", comment:""))
        //            self.timerview.invalidate()
        //            self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Your Connection with \(Vehicaldetails.sharedInstance.SSId) is lost. Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
        //
        //        }else{
        //            let data1:Data = self.reply.data(using: String.Encoding.utf8)!
        //            do{
        //                self.setrelaysysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        //            }catch let error as NSError {
        //                print ("Error: \(error.domain)")
        //                let text = error.localizedDescription //+ error.debugDescription
        //                let test = String((text.filter { !" \n".contains($0) }))
        //                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
        //                print(newString)
        //                self.web.sentlog(func_name:" StartButtontapped GetRelay Function ", errorfromserverorlink: "\(newString)", errorfromapp:"\"Error: \(error.domain)")
        //            }
        //
        //            if(self.setrelaysysdata == nil){
        //                print("HI set relay sysdata is nil")
        //            }
        //            else{
        
        //                let objUserData = self.setrelaysysdata.value(forKey: "relay_response") as! NSDictionary
        //
        //                let relayStatus = objUserData.value(forKey: "status") as! NSNumber
        //
        //                print("after get relay" + cf.dateUpdated)
        //                if(relayStatus == 0){
        
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
            
            
            
            print("after setpulsaroffTime" + cf.dateUpdated)
            
            if(connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
            {
                self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link after setpulsaroffTime.",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")//
                
                self.timerview.invalidate()
                self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                self.IsStartbuttontapped = false
            }else {
                
//                print("before setSamplingtime" + cf.dateUpdated)
//                self.cf.delay(0.5){
//                    var st = ""
//                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
//                    {
//                        if(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce == "1")
//                        {
//                            st = self.tcpcon.setSamplingtime()  /// set Sampling time to FS link
//                            if(st.contains("200")){
//                                _ = self.web.UpdateSwitchTimeBounceForLink()
//                            }
//                        }
//                    }
//                    print("after setSamplingtime" + self.cf.dateUpdated)
//                    print(st)
                    
//                    print("before pulsarlastquantity" + self.cf.dateUpdated)
//                    self.cf.delay(0.5){
//                        self.start.isHidden = true
//                        self.cancel.isHidden = true
//                        if(Vehicaldetails.sharedInstance.iotversion == "f7.5.7.7.6.18t4(l)"){}
//                        else{
//                            self.web.cmtxtnid10()   /// GET last 10 records from FS link
//                        }
//                        print("pulsarlastquantity" + self.cf.dateUpdated)
//                        
//                        //                                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                        //                                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")/////
//                        
//                        print("before getlastTrans_ID" + self.cf.dateUpdated)
//                        self.cf.delay(0.5){
//                            if(Vehicaldetails.sharedInstance.iotversion == "f7.5.7.7.6.18t4(l)"){
//                                self.web.pulsarlastquantity()
//                                lasttransID = self.web.getlastTrans_ID()   /// Get the previous Transaction ID from FS link.
//                                
//                                print("getlastTrans_ID" + self.cf.dateUpdated ,Vehicaldetails.sharedInstance.FinalQuantitycount)
//                                if(Vehicaldetails.sharedInstance.FinalQuantitycount == "")
//                                {
//                                    //                                             self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
//                                }
//                                else{
//                                    if(Vehicaldetails.sharedInstance.Last_transactionformLast10 == "")
//                                    {
//                                        self.saveTrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
//                                    }
//                                    else{
//                                        if(lasttransID == Vehicaldetails.sharedInstance.Last_transactionformLast10)
//                                        {
//                                            self.saveTrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
//                                            
//                                            self.web.sentlog(func_name:" Transaction id is matched.", errorfromserverorlink: lasttransID, errorfromapp:"\(Vehicaldetails.sharedInstance.Last_transactionformLast10)")
//                                            
//                                            Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
//                                        }
//                                        else
//                                        {
//                                            self.web.sentlog(func_name:" Transaction is is not matched lasttransID with the Last_transactionformLast10 transaction id  .", errorfromserverorlink: lasttransID, errorfromapp:"\(Vehicaldetails.sharedInstance.Last_transactionformLast10)")
//                                            self.saveTrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
//                                        }
//                                    }
//                                }
//                        }
//                            
                            if(self.connectedwifi != self.cf.getSSID()) //check selected wifi and connected wifi is not same
                            {
                                self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link after getlastTrans_ID", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                                
                                self.timerview.invalidate()
                                self.showAlertSetting(message: NSLocalizedString("WarningselectWifi", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))//"Please select \(Vehicaldetails.sharedInstance.SSId) Wi-Fi.")
                                
                            } else {
                                
                                print("before settransaction_IDtoFS" + self.cf.dateUpdated)
                                self.cf.delay(0.5){
                                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                    {
                                        self.tcpcon.settransaction_IDtoFS()   ///Set the Current Transaction ID to FS link.
                                    }
                                    print("settransaction_IDtoFS" + self.cf.dateUpdated)
                                    
                                    self.beginfuel1 = false
                                    self.displaytime.text = NSLocalizedString("Fueling", comment:"")//"Fueling…"  //3-4sec
                                    // self.displaytime.textColor = UIColor.black
                                    self.Pwait.isHidden = true
                                    
                                    
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
                                    
                                    
                                    
                                    self.cf.delay(0.5){
                                        
                                        print("before setpulsartcp" + self.cf.dateUpdated)
                                        
                                        
                                        print("before Relay on0" + self.cf.dateUpdated)
                                        var setrelayd = ""
                                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                        {
                                            setrelayd = self.tcpcon.setralaytcp()
                                            
                                            print("Relay on0" + self.cf.dateUpdated)
                                        }
                                        self.cf.delay(0.5){ //0.5
                                            if(setrelayd == ""){        // if no response sent set relay command again
                                                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                                {
                                                    setrelayd = self.tcpcon.setralaytcp()
                                                    
                                                    print("Relay on1" + self.cf.dateUpdated)
                                                }
                                            }
                                            self.cf.delay(0.5){//0.5
                                                if(setrelayd == ""){        // if no response sent set relay command again
                                                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                                    {
                                                        setrelayd = self.tcpcon.setralaytcp()
                                                        
                                                        print("Relay on1" + self.cf.dateUpdated)
                                                    }
                                                }
                                                if(setrelayd == ""){  // after 2 attempt stop relay goto home screen
                                                    self.cf.delay(0.5){
                                                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                                        {
                                                            _ = self.tcpcon.setralay0tcp()
                                                        }
                                                        
                                                        
                                                        print(self.cf.dateUpdated)
                                                        self.error400(message: NSLocalizedString("CheckFSunit", comment:""))//"Please check your FS unit, and switch off power and back on.")
                                                    }
                                                }
                                                //
                                                else {
                                                    
                                                    let text = setrelayd
                                                    let test = String((text.filter { !" \r\n".contains($0) }))
                                                    let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                                                    print(newString)
                                                    if(newString.contains("HTTP/1.0200OK"))
                                                    {
                                                        self.start.isHidden = true
                                                        self.cancel.isHidden = true
                                                        self.Stop.isHidden = false  ///show stop button 7-8sec
                                                        
                                                        
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
//            }
//        }
//    }
    //                else if(relayStatus == 1)
    //                {
    //                    if(self.appdisconnects_automatically == true){}
    //                    else{
    //
    //
    //                    let alert = UIAlertController(title: "", message: NSLocalizedString("The link is busy, please try after some time.", comment:""), preferredStyle: UIAlertController.Style.alert)
    //                    let backView = alert.view.subviews.last?.subviews.last
    //                    backView?.layer.cornerRadius = 10.0
    //                    backView?.backgroundColor = UIColor.white
    //                    var messageMutableString = NSMutableAttributedString()
    //                    messageMutableString = NSMutableAttributedString(string: "The link is busy, please try after some time." as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
    //
    //                    alert.setValue(messageMutableString, forKey: "attributedMessage")
    //                    self.showAlert(message: "relayStatus == 1 The link is busy, please try after some time.")
    //                    let okAction = UIAlertAction(title: NSLocalizedString("ok", comment:""), style: UIAlertAction.Style.default) { [self] action in
    //
    //                        if(self.Last_Count == "0.0" || Last_Count == nil){
    //                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
    //                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
    //                            //self.potentialfix()
    //                        }
    //                        let appDel = UIApplication.shared.delegate! as! AppDelegate
    //                        // Call a method on the CustomController property of the AppDelegate
    //                        self.cf.delay(1) {     // takes a Double value for the delay in seconds
    //                            self.FDcheckBLEtimer.invalidate()
    //                            appDel.start()
    //                            self.Activity.style = UIActivityIndicatorView.Style.gray;
    //                            self.Activity.startAnimating()
    //                        }
    //                    }
    //                    alert.addAction(okAction)
    //                    self.present(alert, animated: true, completion: nil)
    //                }
    //                }
    //            }
    //        }
    //    }
    
    func setrelayon(setrelayd:String)
    {
        let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
        if(Split.count < 2){    /// Split.count<2
            
            let Split:NSArray = setrelayd.components(separatedBy: "{") as NSArray
            if(Split.count < 2){
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                {
                    _ = self.tcpcon.setralay0tcp()
                }
                
                self.error400(message:NSLocalizedString("CheckFSunit", comment:""))// "Please check your FS unit, and switch off power and back on.")
            }
        }    // got invalid respose do nothing goto home screen
        else{
            let reply = Split[0] as! String    // get valid respose proceed
            let setrelay = Split[1] as! String
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
                self.showAlert(message: "please retry" )
            }
        }
        self.start.isHidden = true
        self.cancel.isHidden = true
        self.Stop.isHidden = false  ///show stop button 7-8sec
        
        
        self.btnBeginFueling()
        
        print("Get Pulsar" + self.cf.dateUpdated)
        self.displaytime.text = ""
    }
    
    
    @IBAction func startButtontapped(sender: AnyObject) {
        
        if(Cancel_Button_tapped == true){}
        else{
            self.start.isHidden = true
            self.cancel.isHidden = true
            self.Stop.isHidden = false
            self.Stop.isEnabled = false
            self.displaytime.text = NSLocalizedString("Fueling", comment:"")
            
            delay(1){
                //Start the fueling with buttontapped
                self.web.sentlog(func_name: "Start Button Tapped" , errorfromserverorlink: "", errorfromapp: "")
                self.defaults.set(0, forKey: "reinstatingtransaction")
                Vehicaldetails.sharedInstance.ifStartbuttontapped = true
                self.start.isEnabled = false
                self.IsStartbuttontapped = true
                self.stoptimergotostart.invalidate()
                self.stoptimer_gotostart.invalidate()
                self.timerview.invalidate()
                Vehicaldetails.sharedInstance.pulsarCount = ""
                if(self.AppconnectedtoBLE == true){
                    
                    if(self.connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9")
                    {
                        self.settransactionid()  //set transaction id
                        self.cf.delay(4){
                            self.consoleAsciiText = NSAttributedString(string: "")
                            self.newAsciiText = NSMutableAttributedString()
                            if(self.observationToken == nil){}
                            else{
                                NotificationCenter.default.removeObserver(self.observationToken!)
                            }
                            
                            
                            //                        if(self.BTMacAddress == true)
                            //                        {
                            //                            self.showAlert(message: "There is a MAC address error. Please contact Support")//"Invalid Link Mac Address. Please try again.")
                            //                            self.cf.delay(6)
                            //                            {
                            //                            self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                            //                            self.updateIncomingData()
                            //                                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                            //                                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                            //                                self.disconnectFromDevice()
                            //                                self.goto_Start()
                            //                            }
                            //                            //                        self.showAlert(message: "Macaddress is not matched \(Vehicaldetails.sharedInstance.BTMacAddress)" )
                            //
                            //                        }
                            //                        else{
                            self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                            self.cf.delay(2){
                                self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                                //                        self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                                NotificationCenter.default.removeObserver(self)
                                self.updateIncomingData()
                                self.IsStopbuttontappedBLE = false
                                self.BLErescount = 0
                                
                                self.start.isHidden = true
                                self.cancel.isHidden = true
                                self.Stop.isHidden = false
                                self.displaytime.text = NSLocalizedString("Fueling", comment:"")
                                self.FDcheckBLEtimer.invalidate()
                                self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.fdCheckBLE), userInfo: nil, repeats: true)
                            }
                            //                        }
                        }
                    }
                    else{
                        self.getBLEInfo()
                        self.delay(1){
                            self.getlast10transaction()
                            //                    if(self.BTMacAddress == true)
                            //                    {
                            //                        self.showAlert(message: "There is a MAC address error. Please contact Support")//"Invalid Link Mac Address. Please try again.")
                            //                        self.cf.delay(6)
                            //                        {
                            //                        self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                            //                        self.updateIncomingData()
                            //                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                            //                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                            //                            self.disconnectFromDevice()
                            //                            self.goto_Start()
                            //                        }
                            //                        //                        self.showAlert(message: "Macaddress is not matched \(Vehicaldetails.sharedInstance.BTMacAddress)" )
                            //
                            //                    }
                            //                    else
                            //                    {
                            self.IsStopbuttontappedBLE = false
                            self.BLErescount = 0
                            //                        self.web.sentlog(func_name: "Sent Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                            self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                            NotificationCenter.default.removeObserver(self)
                            self.updateIncomingData ()
                            
                            self.cf.delay(0.1){
                                self.start.isHidden = true
                                self.cancel.isHidden = true
                                self.Stop.isHidden = false
                                self.displaytime.text = NSLocalizedString("Fueling", comment:"")
                                self.FDcheckBLEtimer.invalidate()
                                self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.fdCheckBLE), userInfo: nil, repeats: true)
                            }
                            //                    }
                        }
                    }
                }
                else if(self.AppconnectedtoBLE == false)
                {
                    if(Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines) != self.cf.getSSID().trimmingCharacters(in: .whitespacesAndNewlines)) //check selected wifi and connected wifi is not same
                    {
                        
                        self.web.sentlog(func_name:" StartButtontapped lost Wifi connection with the link",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())") //errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)")
                        self.timerview.invalidate()
                        
                        self.showAlertSetting(message: NSLocalizedString("wificonnection", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" +  NSLocalizedString("wificonnection1", comment:"") + "\(Vehicaldetails.sharedInstance.SSId)" + NSLocalizedString("Wifi", comment:""))
                    }
                    else {
                        self.startFueling()
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
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP"){
                    //self.cf.delay(0.5) {
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
                else
                if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT"){
                    self.web.sentlog(func_name: " CancelButtonTapped", errorfromserverorlink: "", errorfromapp: "")
                    if (self.isokbuttontapped == true)
                    {
                        //                cleanup()
                    }
                    else{
                        if(self.ifSubscribed == true){
//                            print(self.Last_Count)
                            if(self.Last_Count == "0" || self.Last_Count == nil)
                            {
                                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "5")
                            }
                            //                    cleanup()
                            self.isviewdidDisappear = true
                            if(self.isrelayon == true){
                                self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                                self.updateIncomingData()
                            }
                            self.disconnectFromDevice()
                            appDel.start()
                            self.Activity.style = UIActivityIndicatorView.Style.gray;
                            self.Activity.startAnimating()
                            self.timerview.invalidate()
                        }
                        else
                        {
                            self.onFuelingScreen = false
                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                            appDel.start()
                            self.Activity.style = UIActivityIndicatorView.Style.gray;
                            self.Activity.startAnimating()
                            self.timerview.invalidate()
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment:""), style: UIAlertAction.Style.cancel) { (submitn) -> Void in
                self.Cancel_Button_tapped = false
            }
            onFuelingScreen = false
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func error400(message: String)
    {
        self.timerview.invalidate()
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT") //#2351
        {}
        else if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP"){
            if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
            {
                if(Last_Count == "0.0" || Last_Count == nil){
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
                    //potentialfix()
                }
            }
        }
        
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
        
        print(countwififailConn)
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            
        }
        else
        {
            if (countwififailConn > 5)
            {
                self.displaytime.text = "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'Wi-Fi Settings' screen."
                displaytime.textColor = UIColor.red
                print(countwififailConn)
                if(iscountwififailConnfalse == false)
                {
                    iscountwififailConnfalse = true
                    self.showAlert(message: "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'Wi-Fi Settings' screen.")
                    displaytime.textColor = UIColor.red
                    
                }
            }
            else{
                if #available(iOS 11.0, *) {
                    displaytime.textColor = UIColor.black
                    self.cf.delay(1){
                        print(Vehicaldetails.sharedInstance.SSId, Vehicaldetails.sharedInstance.fsSSId)
                        //self.web.wifisettings(pagename:"Retry")
                        if(self.reinstatingtransactionattempts > 3){}
                        else{
                            let hotspotConfig = NEHotspotConfiguration(ssid: Vehicaldetails.sharedInstance.SSId, passphrase: "123456789", isWEP: false)
                            hotspotConfig.joinOnce = false
                            
                            NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
                                
                                if error?.localizedDescription == "already associated."
                                {
                                    print("Connected")
                                    self.isssidconnected = "true"
                                }
                                if(self.isssidconnected == "true"){}
                                else{
                                    if let error = error {
                                        self.countwififailConn += 1
                                        // self.showError(error: error)
                                        print("Error\(error)")
                                        self.web.sentlog(func_name: "error: \(error)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                                        
                                        //self.web.wifisettings(pagename:"Retry")
                                        //self.countwififailConn += 1
                                        print(self.countwififailConn)
                                        if(self.countwififailConn == 5){
                                            
                                            // self.showAlert(message: "Please connect to link \(Vehicaldetails.sharedInstance.SSId)" + "manually using the 'WIFI settings' screen.")
                                            self.displaytime.text = "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'Wi-Fi Settings' screen."
                                            self.displaytime.textColor = UIColor.red
                                            //sleep(5)
                                        }
                                        else if(self.countwififailConn > 5){
                                            self.cf.delay(2){
                                                
                                                self.displaytime.text = "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'Wi-Fi Settings' screen."
                                                self.displaytime.textColor = UIColor.red
                                            }
                                        }
                                        if(self.countwififailConn == 20)
                                        {
                                            self.timerview.invalidate()
                                            self.timerview.invalidate()
                                            self.timerview.invalidate()
                                            self.GetPulsarstartimer.invalidate()
                                            
                                            self.gotoStart()
                                            do{
                                                try self.stoprelay()
                                            }
                                            catch let error as NSError {
                                                print ("Error: \(error.domain)")
                                                self.web.sentlog(func_name:" stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                            }
                                            self.web.sentlog(func_name:"try to Connect wifi link \(Vehicaldetails.sharedInstance.SSId) Stop Transaction gotostart starts because Attempt \(self.countwififailConn) > 20, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                            
                                        }
                                        else{
                                            self.web.sentlog(func_name:"try to Connect wifi link \(Vehicaldetails.sharedInstance.SSId)" + " Attempt \(self.countwififailConn)", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: "  Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                                        }
                                    }
                                    
                                    else {
                                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID()){
                                            self.viewDidAppear(true)
                                            self.web.sentlog(func_name:" Connecting to \(Vehicaldetails.sharedInstance.SSId) ", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: "  Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                                            
                                            // self.showSuccess()
                                            print("Connected")
                                        }
                                        else
                                        {
                                            //                            if(self.countwififailConn > 1){
                                            //                                self.displaytime.text = "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'WIFI settings' screen."
                                            //                                self.showAlert(message: "Please connect to link \(Vehicaldetails.sharedInstance.SSId) " + "manually using the 'WIFI settings' screen.")
                                            //                                self.web.sentlog(func_name:"App Shows Message to User Joins \(Vehicaldetails.sharedInstance.SSId) wifi Manually on fueling Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link: \(self.cf.getSSID())")
                                            //                            }
                                        }
                                    }
                                }
                            }
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
    }
    
    
    func resumetimer(){
        self.timerview.invalidate()
        self.timerview = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(FuelquantityVC.viewDidAppear(_:)), userInfo: nil, repeats: true)
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
    
    func finalPulsar()
    {
        
        let final_pulsar = self.web.GetPulser()
        print(final_pulsar)
        var parsingerror = false
        let Split = final_pulsar.components(separatedBy: "{")
        print("Splitcout\(Split.count)")
        if(Split.count < 3){
            
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
                self.web.sentlog(func_name: "Got Error while parsing \(error.domain) ,\(outputdata)", errorfromserverorlink: "", errorfromapp:"")
                parsingerror = true
            }
            //                         print(self.sysdata1,"pulsar_status")
            if(parsingerror == true){
                
            }
            else{
                let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                print(self.Last_Count as NSString)
                self.web.sentlog(func_name: "Pulsar : \(objUserData.value(forKey: "counts") as! NSString)", errorfromserverorlink: "", errorfromapp:"")
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
            
            
        }
        
    }
    
    @objc func stopButtontapped()
    {
        print(Last_Count)
        if(self.Last_Count == "0.0" || Last_Count == "0")
        {
            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "5")
            
        }
        else
        {
            if(isBTlinkDisconnect == true)
            {
                //2347
                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "10")
                self.web.sentlog(func_name: " BT Comm Interruption ", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                if(AppconnectedtoBLE == true ){
                    disconnectFromDevice()
                }
            }
        }
        if(AppconnectedtoBLE == true ){
            print(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce)
                            if(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce == "1")
                            {
            
                                self.sendpulsar_type()
                            }
            if(Vehicaldetails.sharedInstance.GetPulserTypeFromLINK == "True"){
                outgoingData(inputText: "LK_COMM=p_type?")
                updateIncomingData()
            }
            //self.settransactionid()  //set transaction id
            if(self.connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9")
            {
                self.FDcheckBLEtimer.invalidate()
                self.IsStopbuttontappedBLE = true
                //self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
                self.consoleAsciiText = NSAttributedString(string: "")
                self.newAsciiText = NSMutableAttributedString()
                if(self.observationToken == nil){}
                else{
                    NotificationCenter.default.removeObserver(self.observationToken!)
                }
                self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                
                self.cf.delay(1){
                    self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                    //                        self.cf.delay(0.1){
                    
                    
                    
                    NotificationCenter.default.removeObserver(self)
                    self.updateIncomingData()
                    self.Stop.isEnabled = false
                    self.Stop.isHidden = true
                    self.wait.isHidden = false
                    self.waitactivity.isHidden = false
                    self.IsStopbuttontapped = true
                    self.FDcheckBLEtimer.invalidate()
                }
            }
            else{
                self.IsStopbuttontappedBLE = true
                //self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
                
                
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
                            self.web.sentlog(func_name:"Disconnected Device from link \(Vehicaldetails.sharedInstance.SSId).",errorfromserverorlink: "", errorfromapp:"")
                            try self.stoprelay()
                            
                        }
                        else
                        {
                            self.web.sentlog(func_name:"Disconnected Device from link \(Vehicaldetails.sharedInstance.SSId).",errorfromserverorlink: "", errorfromapp:"")
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
                    var setrelayd = ""
                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                    {
                        setrelayd = self.tcpcon.setralay0tcp()
                    }
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
                                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                {
                                    setrelayd = self.tcpcon.setralay0tcp()
                                }
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
                                    self.web.sentlog(func_name: "Error: \(error.domain)", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
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
                                        self.cf.delay(0.5){
                                            var st = ""
                                            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                            {
                                                if(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce == "1")
                                                {
                                                    st = self.tcpcon.setSamplingtime()  /// set Sampling time to FS link
                                                    if(st.contains("200")){
                                                        _ = self.web.UpdateSwitchTimeBounceForLink()
                                                    }
                                                }
                                            }
                                            
                                            print("after setSamplingtime" + self.cf.dateUpdated)
                                            print(st)
                                        }
                                        print("before pulsarlastquantity" + self.cf.dateUpdated)
                                        self.cf.delay(0.5){
                                            self.start.isHidden = true
                                            self.cancel.isHidden = true
                                            if(Vehicaldetails.sharedInstance.iotversion == "f7.5.7.7.6.18t4(l)"){
                                                self.web.pulsarlastquantity()
                                            }
                                            else{
                                                self.web.cmtxtnid10()   /// GET last 10 records from FS link
                                            }
                                            print("pulsarlastquantity" + self.cf.dateUpdated)
                                            
                                            //                                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                                            //                                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")/////
                                            
                                            print("before getlastTrans_ID" + self.cf.dateUpdated)
//                                            self.cf.delay(0.5){
//                                                if(Vehicaldetails.sharedInstance.iotversion == "f7.5.7.7.6.18t4(l)"){
//                                                    self.web.pulsarlastquantity()
////                                                    let lasttransID = self.web.getlastTrans_ID()   /// Get the previous Transaction ID from FS link.
//                                                    
//                                                    print("getlastTrans_ID" + self.cf.dateUpdated ,Vehicaldetails.sharedInstance.FinalQuantitycount)
//                                                    if(Vehicaldetails.sharedInstance.FinalQuantitycount == "")
//                                                    {
//                                                        //                                             self.savetrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: lasttransID)
//                                                    }
//                                                    else{
//                                                        if(Vehicaldetails.sharedInstance.Last_transactionformLast10 == "")
//                                                        {
//                                                            self.saveTrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: self.lasttransID)
//                                                        }
//                                                        else{
//                                                            if(self.lasttransID == Vehicaldetails.sharedInstance.Last_transactionformLast10)
//                                                            {
//                                                                self.saveTrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: self.lasttransID)
//                                                                
//                                                                self.web.sentlog(func_name:" Transaction id is matched.", errorfromserverorlink: self.lasttransID, errorfromapp:"\(Vehicaldetails.sharedInstance.Last_transactionformLast10)")
//                                                                
//                                                                Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
//                                                            }
//                                                            else
//                                                            {
//                                                                self.web.sentlog(func_name:" Transaction is is not matched lasttransID with the Last_transactionformLast10 transaction id  .", errorfromserverorlink: self.lasttransID, errorfromapp:"\(Vehicaldetails.sharedInstance.Last_transactionformLast10)")
//                                                                self.saveTrans(lastpulsarcount: Vehicaldetails.sharedInstance.FinalQuantitycount,lasttransID: self.lasttransID)
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
                                            }
                                        
                                        
                                        print("before get final_pulsar_request" + self.cf.dateUpdated)
                                        self.GetPulsarstartimer.invalidate()
                                        self.string = ""
                                        
                                        self.cf.delay(0.5){
                                            self.finalPulsar()
                                            
                                            self.cf.delay(1){
                                                self.finalPulsar()
                                                
                                                //                                            let finalpulsar = self.web.GetPulser()
                                                //                                            print(finalpulsar)
                                                //                                            let Split = finalpulsar.components(separatedBy: "{")
                                                //                                            print("Splitcout\(Split.count)")
                                                //                                            if(Split.count < 3){
                                                //
                                                //                                                do{
                                                //                                                    try self.stoprelay()
                                                //                                                }
                                                //                                                catch let error as NSError {
                                                //                                                    print ("Error: \(error.domain)")
                                                //                                                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                                //                                                }
                                                //                                            }
                                                //                                            else{
                                                //                                                print("after get final_pulsar_request" + self.cf.dateUpdated)
                                                //                                                let reply = Split[1]
                                                //                                                let setrelay = Split[2]
                                                //                                                let Split1 = setrelay.components(separatedBy: "}")
                                                //                                                let setrelay1 = Split1[0]
                                                //                                                let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
                                                //                                                let data1 = outputdata.data(using: String.Encoding.utf8)!
                                                //                                                do{
                                                //                                                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                                //                                                }catch let error as NSError {
                                                //                                                    print ("Error: \(error.domain)")
                                                //                                                }
                                                //                                                //         print(self.sysdata1,"pulsar_status")
                                                //                                                if(self.sysdata1 == nil){}
                                                //                                                else{
                                                //                                                    let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
                                                //                                                    // print(self.Last_Count as NSString)
                                                //                                                    if(self.Last_Count == nil){
                                                //                                                        self.Last_Count = "0.0"
                                                //                                                    }
                                                //                                                    if((self.Last_Count as NSString).doubleValue < (objUserData.value(forKey: "counts") as! NSString).doubleValue || (self.Last_Count as NSString).doubleValue == (objUserData.value(forKey: "counts") as! NSString).doubleValue) {
                                                //                                                        self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                //
                                                //                                                    }else{
                                                //                                                        self.counts = self.Last_Count
                                                //                                                        // print(self.Last_Count)
                                                //                                                    }
                                                //                                                    print((self.counts as NSString).doubleValue , (objUserData.value(forKey: "counts") as! NSString).doubleValue , (self.counts as NSString).doubleValue , (objUserData.value(forKey: "counts") as! NSString).doubleValue)
                                                //                                                    //self.counts = objUserData.value(forKey: "counts") as! NSString as String
                                                //
                                                //                                                    if (self.counts != "0"){
                                                //
                                                //                                                    }
                                                //                                                    self.fuelquantity = self.cf.calculate_fuelquantity(quantitycount: Int(self.counts as String)!)
                                                //                                                    if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                                                //                                                        let y = Double(round(100*self.fuelquantity)/100)
                                                //                                                        self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                                                //                                                        print(self.tquantity.text!)
                                                //                                                    }
                                                //                                                    else {
                                                //                                                        let y = Double(round(100*self.fuelquantity)/100)
                                                //                                                        self.tquantity.text = "\(y) "
                                                //                                                    }
                                                //                                                    self.tpulse.text = (self.counts as String) as String
                                                //                                                    self.Last_Count = (self.counts as String) as String
                                                //                                                }
                                                
                                                print(self.string)
                                                self.Stop.isHidden = true
                                                
                                                let SSID:String = self.cf.getSSID()
                                                print(SSID)
                                                print(Vehicaldetails.sharedInstance.SSId)
                                                print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                                                
                                                //
                                                self.cf.delay(0.5) {
                                                    
                                                    print("before set setpulsar0tcp" + self.cf.dateUpdated)
                                                    
                                                    if( self.connectedwifi == SSID  || "FUELSECURE" == SSID)
                                                    {
                                                        print(Vehicaldetails.sharedInstance.SSId)
                                                        print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                                                        self.cf.delay(0.1) { [self] in     // takes a Double value for the delay in seconds
                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                                if(self.AppconnectedtoBLE == true)
                                                                {
                                                                    let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
                                                                    //           self.renamelink(SSID:trimmedString)
                                                                }
                                                                else{
                                                                    let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
                                                                    if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                                                    {
                                                                        self.tcpcon.changessidname(wifissid: trimmedString)
                                                                    }
                                                                }
                                                                self.web.SetHoseNameReplacedFlag()
                                                                //                                                                print(Vehicaldetails.sharedInstance.ReplaceableHoseName)
                                                                //
                                                            }
                                                            
                                                            
                                                            // put the delayed action/function here
                                                            print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
                                                            //                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
                                                            //                                                                _ = self.web.SetHoseNameReplacedFlag()
                                                            //                                                            }
                                                                                                                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                                                                                                                        {
                                                                                                                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP")
//                                                                                                                            {
//                                                                                                                                self.uploadbinfile()
//                                                                                                                                //                                                                    self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                                                                                                                                _ = self.firmwareUpdateDemo()
//                                                                                                                                _ = self.web.UpgradeCurrentiotVersiontoserver()
//                                                                                                                                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                                                            
//                                                            
//                                                                                                                            }
//                                                                                                                            else
                                                                                                                            {
                                                                                                                                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                                                                                                                                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                                                                                                                {
                                                                                                                                    Reconnect.isHidden = false;                                                                                   self.Reconnect.text = "Software update in progress.\nPlease wait several seconds.";                                                                                        self.tcpcon.getuser()
                                                                                                                                }
                                                                                                                            }
                                                                                                                            //                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
                                                                                                                        }
                                                                                                                        else{}
                                                            
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
                                                                        
                                                                    }
                                                                    self.unsync.unsyncTransaction()
                                                                    self.wait.isHidden = true
                                                                    self.waitactivity.isHidden = true
                                                                    self.waitactivity.stopAnimating()
                                                                    self.UsageInfoview.isHidden = false
                                                                    self.Warning.isHidden = true
                                                                }
                                                                self.cf.delay(10){
                                                                    //                                                                    if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                                                                    //                                                                    {
                                                                    //                                                                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                                                                    //                                                                        {
                                                                    //                                                                            _ = self.web.getinfo()//self.tcpcon.Getinfo()//self.web.getinfo()
                                                                    //                                                                        }
                                                                    //                                                                        if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                                                                    //                                                                            _ = self.web.UpgradeCurrentVersiontoserver()
                                                                    //                                                                        }
                                                                    //                                                                        Vehicaldetails.sharedInstance.IsUpgrade = "N"
                                                                    //                                                                        self.cf.delay(30){
                                                                    //                                                                            if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
                                                                    //                                                                            {
                                                                    //                                                                                self.displaymessage(message:"We have renamed your LINK to the given name in the Cloud. Please close App and reopen")
                                                                    //                                                                                Vehicaldetails.sharedInstance.IsHoseNameReplaced = "Y"
                                                                    //                                                                                self.stopdelaytime = true
                                                                    //                                                                            }else{
                                                                    //                                                                                Vehicaldetails.sharedInstance.gohome = true
                                                                    //                                                                                self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
                                                                    //                                                                                self.timerview.invalidate()
                                                                    //
                                                                    //                                                                                self.timerview.invalidate()
                                                                    //                                                                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                                    //                                                                                self.web.sentlog(func_name: "stopButtontapped 30 delay", errorfromserverorlink: "", errorfromapp: "")
                                                                    //                                                                                appDel.start()
                                                                    //                                                                            }
                                                                    //                                                                        }
                                                                    //                                                                    }
                                                                    if (self.stopdelaytime == true){}
                                                                    else{
                                                                        Vehicaldetails.sharedInstance.gohome = true
                                                                        self.timerview.invalidate()
                                                                        self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
                                                                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                                                                        //                                                                        self.web.sentlog(func_name: "stopButtontapped ", errorfromserverorlink: "", errorfromapp: "")
                                                                        appDel.start()
                                                                    }
                                                                    self.unsync.unsyncTransaction()
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
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                //                        if(self.InterruptedTransactionFlag == true)
                //                        {
                //                            self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "y") /// 1168 if relay off is not working then app sends to server Transaction id.
                //                        }
            }
        }
        //            }
        //        }
    }
    
    //    //     MARK: - Helper Methods
    //    func sendData() {
    //
    //        progressview.isHidden = false
    //        progressviewtext.isHidden = false
    //        if let discoveredPeripheral = blePeripheral{
    //            if let txCharacteristic = txCharacteristicupload
    //            {
    //                sentDataPacket = firmwareUpdateDemo()
    //                if sentDataPacket != nil {
    //                    discoveredPeripheral.writeValue(sentDataPacket!, for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
    //                }
    //                else{
    //
    //                    // discoveredPeripheral.writeValue("EOM".data(using: String.Encoding.utf8)!, for: txCharacteristic, type: .withoutResponse)
    //                }
    //            }
    //        }
    //    }
    //#2177
    func sendpulsar_type()
    {
        if(AppconnectedtoBLE == true ){
            
            if(Vehicaldetails.sharedInstance.PulserTimingAdjust == "1")
            {
                outgoingData(inputText: "LK_COMM=p_type:" + "\(Vehicaldetails.sharedInstance.PulserTimingAdjust)")
                updateIncomingData()
                
            }
            else  if(Vehicaldetails.sharedInstance.PulserTimingAdjust == "2")
            {
                outgoingData(inputText: "LK_COMM=p_type:" + "\(Vehicaldetails.sharedInstance.PulserTimingAdjust)")
                updateIncomingData()
                
            }
            else  if(Vehicaldetails.sharedInstance.PulserTimingAdjust == "3")
            {
                outgoingData(inputText: "LK_COMM=p_type:" + "\(Vehicaldetails.sharedInstance.PulserTimingAdjust)")
                updateIncomingData()
                
            }
            else  if(Vehicaldetails.sharedInstance.PulserTimingAdjust == "4")
            {
                outgoingData(inputText: "LK_COMM=p_type:" + "\(Vehicaldetails.sharedInstance.PulserTimingAdjust)")
                updateIncomingData()
                
            }
        }
    }
    //
    //    func firmwareUpdateDemo() -> Data? {
    //        //let subData:Data
    //        guard let discoveredPeripheral = blePeripheral,
    //              let txCharacteristic = txCharacteristicupload
    //        else { return nil}
    //        let mtu = discoveredPeripheral.maximumWriteValueLength(for: CBCharacteristicWriteType.withoutResponse)
    //
    //        if(bindata == nil){
    //            uploadbinfile()
    //        }
    //        else {
    //            guard bindata!.count > 0 else {
    //
    //
    //                // set label for progress value
    //
    //                self.progressviewtext.text = "Done Upgrade \(Int(self.progressview.progress * 100))%"
    //                _ = self.web.UpgradeCurrentiotVersiontoserver()
    //                self.web.sentlog(func_name: " Finished Upgrade Process", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
    //                print(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce)
    //                                    if(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce == "1")
    //                                    {
    //
    //                                        self.sendpulsar_type()
    //                                    }
    //                outgoingData(inputText: "LK_COMM=p_type?")
    //                updateIncomingData()
    //                getlast10transaction()
    //                delay(1){
    //                    //                        if(self.BTMacAddress == true)
    //                    //                        {
    //
    //                    self.start.isEnabled = true
    //                    self.start.isHidden = false
    //                    self.cancel.isHidden = false
    //                    self.Pwait.isHidden = true
    //                    self.Activity.stopAnimating()
    //                    self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
    ////                    self.IsUpgrade = true
    //                    //                self.disconnectFromDevice()
    //                    //                self.cleanup()
    //                    // invalidate timer if progress reach to 1
    //
    //                    //                if(progressview.progress >= 1)
    //                }
    //                return nil
    //            }
    //            progressview.isHidden = false
    //            progressviewtext.isHidden = false
    //            let iteration:Float = Float(totalbindatacount / mtu)
    //            let onepercentoffile:Float = 1/iteration
    //            print(iteration,Float(Double(onepercentoffile)))
    //            iterationcountforupgrade = iterationcountforupgrade + 1
    //            self.progressview.progress += Float(Double(onepercentoffile))
    //            self.progressviewtext.text = "Please wait Upgrading in progress \(Int(self.progressview.progress * 100))%"
    //
    //            var range:Range<Data.Index>
    //            // Create a range based on the length of data to return
    //            if (bindata!.count) >= mtu{
    //                range = (0..<mtu)
    //            }
    //            else{
    //
    //                range = (0..<(bindata!.count))
    //            }
    //            // Get a new copy of data
    //            subData = bindata!.subdata(in: range)
    //            // Mutate data
    //            bindata!.removeSubrange(range)
    //            print(range,subData,bindata!)
    //            // Return the new copy of data
    //
    //        }
    //
    //        return subData
    //    }
    //
    //    //BTUpgrade
    //
    //    func uploadbinfile(){
    //        //Download new link from Server using getbinfile and upload/Flash the file to FS link.
    //        //            DispatchQueue.main.async(execute: {
    //        //                self.web.beginBackgroundUpdateTask()
    //        //                if(self.bindata == nil){
    //        isupload_file = true
    //        self.bindata = self.getbinfile() as Data
    //        //                }
    //        //                else{
    //        self.totalbindatacount = self.bindata!.count
    //        print(self.bindata!.count)
    //        self.outgoingData(inputText: "LK_COMM=upgrade \(self.bindata!.count)")
    //        NotificationCenter.default.removeObserver(self)
    //        self.updateIncomingData()
    //        //                }
    //
    //        // End the background task.
    //
    //        //                self.web.endBackgroundUpdateTask()
    //        //            })
    //    }
    //
    //    func getbinfile() -> Data
    //    {
    //        let urlPath:String = Vehicaldetails.sharedInstance.FilePath
    //
    //        let objectUrl = URL(string:urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    //        let request: NSMutableURLRequest = NSMutableURLRequest(url:objectUrl! as URL)
    //        request.httpMethod = "GET"
    //
    //        let session = Foundation.URLSession.shared
    //        let semaphore = DispatchSemaphore(value: 0)
    //        let task =  session.dataTask(with: request as URLRequest) { data, response, error in
    //            if let data = data {
    //
    //                self.replydata = data as NSData
    //            } else {
    //                print(error!)
    //            }
    //            semaphore.signal()
    //        }
    //        task.resume()
    //        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    //        return replydata as Data
    //    }
    
    
    func senddataTransaction(quantitycount:String,PulseRatio:String)
    {
        //        cf.delay(0.5) {     // takes a Double value for the delay in seconds
        // put the delayed action/function here
        
                if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                {
                    
                    
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "HTTP")
//                    {
//                        //                self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//        
//                        self.uploadbinfile()
//                        self.web.sentlog(func_name: "stoprelay Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                        // self.firmwareUpdateDemo()
//                        _ = self.web.UpgradeCurrentiotVersiontoserver()
//                    }
//                    else
                    {
                        
                       
                        self.web.sentlog(func_name: " stoprelay Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                        {
                            Reconnect.isHidden = false
                            self.Reconnect.text = "Software update in progress.\nPlease wait several seconds.";
                            
                            
                            self.tcpcon.getuser()
                           
        //                    _ = self.web.UpgradeCurrentiotVersiontoserver()
                        }
                    }
                }
        
                else{
                    _ = self.web.UpgradeCurrentiotVersiontoserver()
        
                }
        self.cf.delay(1){
            self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
            if(self.fuelquantity == nil || self.fuelquantity == 0.0){
                if(quantitycount == "0" || quantitycount == "0.0"){
                    if(self.IsStartbuttontapped == true){
                        if(self.PulseCountSamefunctionCall == true){
                            self.error400(message: NSLocalizedString("Pump ON Time Reached", comment: ""))//"NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                        }
                        else
                        {
                            let appDel = UIApplication.shared.delegate! as! AppDelegate
                            appDel.start()
                        }
                    }
                    else
                    if(self.Cancel_Button_tapped == true)
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
                        if(self.lasttransactioncount == self.Last_Count){}
                        else{
                            self.Transaction(fuelQuantity: self.fuelquantity)
                        }
                        
                        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                        {
                            if(Vehicaldetails.sharedInstance.BTMacAddress == "")
                            {
                                if(Vehicaldetails.sharedInstance.MacAddressfromlink == "")
                                {}
                                else{
                                    
                                    if(self.isUpdateMACAddress == false){
                                        let response = self.web.UpdateMACAddress()
                                        let data1:Data = response.data(using: String.Encoding.utf8)!
                                        do{
                                            //print(self.sysdata)
                                            self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                            // print(self.sysdata)
                                            let ResponceMessage = self.sysdata.value(forKey: "ResponceMessage") as! NSString
                                            let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                            print(ResponceMessage,ResponceText)
                                            if(ResponceMessage == "success")
                                            {
                                                self.isUpdateMACAddress = true
                                                self.showstart = "true"
                                            }
                                            else
                                            if(ResponceMessage == "fail")
                                            {
                                                //                                                self.showstart = "false"
                                                
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
                            }
                        }
                        else {
                            
                        }
                        self.unsync.unsyncTransaction()
                        self.unsync.unsyncP_typestatus()
                        self.wait.isHidden = true
                        self.waitactivity.isHidden = true
                        self.waitactivity.stopAnimating()
                        self.UsageInfoview.isHidden = false
                        self.Warning.isHidden = true
                    }
                    self.cf.delay(10){
                        if(self.onFuelingScreen == true){
                        //                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                        //                        {
                        //                            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                        //                            {
                        //                                _ = self.web.getinfo()//self.tcpcon.Getinfo()//self.web.getinfo()
                        //                            }
                        //                            if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
                        //                                _ = self.web.UpgradeCurrentVersiontoserver()
                        //                            }
                        //                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
                        //
                        ////                            self.cf.delay(30){
                        ////                                self.FDcheckBLEtimer.invalidate()
                        ////                                Vehicaldetails.sharedInstance.gohome = true
                        ////                                self.timerview.invalidate()
                        ////                                self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
                        ////                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                        ////                                self.web.sentlog(func_name: "stoprelay function 30 delay ", errorfromserverorlink: "", errorfromapp: "")
                        ////                                appDel.start()
                        ////                                self.web.sentlog(func_name: " OK buttontapped TXTN \(Vehicaldetails.sharedInstance.TransactionId) finished, back to home screen.", errorfromserverorlink: "", errorfromapp: "")
                        ////                            }
                        //                        }
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
                                self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
                                let appDel = UIApplication.shared.delegate! as! AppDelegate
                                //                                self.web.sentlog(func_name: "stoprelay function ", errorfromserverorlink: "", errorfromapp: "")
                                appDel.start()
                            }
                        }
                        self.unsync.unsyncTransaction()
                        self.unsync.unsyncP_typestatus()
                        self.wait.isHidden = true
                        self.waitactivity.isHidden = true
                        self.waitactivity.stopAnimating()
                        self.UsageInfoview.isHidden = false
                        self.Warning.isHidden = true
                    }
                    }
                }
                else
                {
                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                    {
                        Vehicaldetails.sharedInstance.gohome = true
                        self.timerview.invalidate()
                        self.FDcheckBLEtimer.invalidate()
                        self.IsStartbuttontapped = true
                        self.stoptimergotostart.invalidate()
                        self.stoptimer_gotostart.invalidate()
                        self.timerview.invalidate()
                        let appDel = UIApplication.shared.delegate! as! AppDelegate
                        
                        appDel.start()
                        self.stopdelaytime = true
                    }
                    else{
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
            senddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
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
                if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                {
                    tcpcon.changessidname(wifissid: trimmedString)
                    
                }
                self.web.SetHoseNameReplacedFlag()
            }
        }
        if(AppconnectedtoBLE == true)
        {}
        else{
            if(self.InterruptedTransactionFlag == true)
            {
                self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "y") /// 1168 if relay off is not working then app sends to server Transaction id.
            }
        }
        print(Vehicaldetails.sharedInstance.PulseRatio ,Vehicaldetails.sharedInstance.pulsarCount)
        if(Vehicaldetails.sharedInstance.PulseRatio == ""){
            self.web.sentlog(func_name: "PulseRatio is null or nil" , errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
            FDcheckBLEtimer.invalidate()
            self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
            self.web.sentlog(func_name: " OK buttontapped TXTN \(Vehicaldetails.sharedInstance.TransactionId) finished, back to home screen.", errorfromserverorlink: "", errorfromapp: "")
            self.stoptimerIspulsarcountsame.invalidate()
            self.timerview.invalidate()
            self.GetPulsarstartimer.invalidate()
            timer_quantityless_thanprevious.invalidate()
            stoptimergotostart.invalidate()
            stoptimer_gotostart.invalidate()
            //            self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
        } else{
            let quantitycount = self.Last_Count! //Vehicaldetails.sharedInstance.pulsarCount
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
            
            if( Vehicaldetails.sharedInstance.SSId == SSID)
            {
                senddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
            }
            else {
                senddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
            }
        }
    }
    
    
    @objc func sendTransaction_ifgetsamecount()
    {
        
        print(Samecount == Last_Count)
        self.web.sentlog(func_name:"count \(Samecount) \(Last_Count)", errorfromserverorlink: "", errorfromapp: "")
        //        if(Samecount == Last_Count){
        
        let Odomtr = Vehicaldetails.sharedInstance.Odometerno
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount :String
        //            defaults.set("", forKey: "previouspulsedata")
        if(self.Last_Count == nil){
            pusercount = Vehicaldetails.sharedInstance.pulsarCount
        }else{
            pusercount = self.Last_Count!
        }
        
        
        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
        let fuelQuantity = (Double(pusercount))!/(PulseRatio as NSString).doubleValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        
        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"IsFuelingStop\":2,\"Transaction\":\"Current_Transaction\"}"
        
        let reply = web.Transaction_details(bodyData: bodyData)
        if (reply == "-1")
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
                self.characteristicASCIIValue = ""
                if(TransactionId == 0){}
                else{
                    self.web.sentlog(func_name: " Saved Current Transaction to Phone, Date\(dtt1) TransactionId:\(TransactionId),FuelQuantity:\((fuelQuantity)),Pulses:\(pusercount)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                }
            }
        }
        else{
            Warning.isHidden = true
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            //  print(sysdata)
            //            self.notify(site: Vehicaldetails.sharedInstance.SSId)
        }
        //        }
    }
    
    func Transaction(fuelQuantity:Double)
    {
        let Odomtr = Vehicaldetails.sharedInstance.Odometerno
        let Wifyssid = Vehicaldetails.sharedInstance.SSId
        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        let pusercount :String
        defaults.set("", forKey: "previouspulsedata")
        if(self.Last_Count == nil){
            pusercount = Vehicaldetails.sharedInstance.pulsarCount
        }else{
            pusercount = self.Last_Count!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        
        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"IsFuelingStop\":0,\"Transaction\":\"Current_Transaction\"}"
        
        let reply = web.Transaction_details(bodyData: bodyData)
        if (reply == "-1")
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //
            if(bodyData != ""){
                cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
                self.characteristicASCIIValue = ""
                if(TransactionId == 0){}
                else{
                    self.web.sentlog(func_name: " Saved Current Transaction to Phone, Date\(dtt1) TransactionId:\(TransactionId),FuelQuantity:\((fuelQuantity)),Pulses:\(pusercount)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
                }
            }
        }
        else{
            Warning.isHidden = true
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            //  print(sysdata)
            //            self.notify(site: Vehicaldetails.sharedInstance.SSId)
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
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
        {
            self.web.sentlog(func_name:" StopButtontapped",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
        }
        else
        {
            self.web.sentlog(func_name:" StopButtontapped",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
        }
        
        stopButtontapped()
    }
    
    func reconnectToLink()
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
            if(Last_Count == "0" || Last_Count == "0.0")
            {}
            else{
                isBTlinkDisconnect = true
                let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
                let FuelQuan = (Double(truncating: Int(Last_Count as String)! as NSNumber))/(PulseRatio as NSString).doubleValue
                //let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(Last_Count as String)!)
                Sendtransaction(fuelQuantity: "\(FuelQuan)")
                Interrupted_TransactionFlag = "y"
                self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: Interrupted_TransactionFlag)
                appdisconnects_automatically = true
                
                sendtransactioncausereinstate = false
            }
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
                    self.GetPulsarstartimer.invalidate()
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
    
    
    @objc func GetPulser()
    {
        
        //if Transaction ID = 0 app stops the connection and send to select hose screen. Stops all Timer
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            FDcheckBLEtimer.invalidate()
            self.timerview.invalidate()
            self.gotoStart()
            self.FDcheckBLEtimer.invalidate()
            self.web.sentlog(func_name:" AppStops because transaction id 0, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
        }
        else
        {
            let dateFormatter = DateFormatter()
            Warning.text = NSLocalizedString("Warningfueling", comment:"")
            Warning.isHidden = false
            self.Stop.isEnabled = true
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
            if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())  /// Check if it is connected to selected  hose
            {
                let replyGetpulsar1 = web.GetPulser()
                
                print(replyGetpulsar1)
                let Split = replyGetpulsar1.components(separatedBy: "#")
                reply1 = Split[0]
                //let error = Split[1]
                //  print(reply1)
                if(self.reply1 == nil || self.reply1 == "-1")
                {
                    reconnectToLink()
                    
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
                        self.web.sentlog(func_name: " Pulsar :\(Last_Count)", errorfromserverorlink: " \(newString)", errorfromapp: "")
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
                        //let pulsar_status = objUserData.value(forKey: "pulsar_status") as! NSNumber
                        let pulsar_secure_status = objUserData.value(forKey: "pulsar_secure_status") as! NSNumber
                        
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
                        
                        self.defaults.set(self.Last_Count, forKey: "LastCount")//previouspulsedata
                        if(appdisconnects_automatically == true){}
                        else{
                            self.web.sentlog(func_name: " ", errorfromserverorlink: " Pulsar : \(Last_Count!)",errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
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
                                self.web.sentlog(func_name: "data send to server Final Quantity = \(self.Quantity1.text) ,Final Pulse Count = \(self.pulse.text)", errorfromserverorlink: "", errorfromapp: "")
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
                                    if(self.total_count == 3){
                                        Ispulsarcountsame = true
                                        stoptimerIspulsarcountsame.invalidate()
                                        Samecount = Last_Count
                                        
                                        
                                        Samecount = Last_Count
                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                        
                                        self.stoptimerIspulsarcountsamefor10sec.invalidate()
                                        self.stoptimerIspulsarcountsamefor10sec = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(FuelquantityVC.sendTransaction_ifgetsamecount), userInfo: nil, repeats: false)
                                        
                                        self.web.sentlog(func_name:"Get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpon_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                    }
                                }
                            }
                        }
                        else{
                            
                            self.emptypulsar_count = 0
                            if (counts != "0"){
                                displaytime.text = ""
                                if(appdisconnects_automatically == true){
                                    
                                    if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
                                        Ispulsarcountsame = false
                                        stoptimerIspulsarcountsame.invalidate()
                                    }
                                    var pulsedata = defaults.string(forKey: "reinstatingtransaction")
                                    print(pulsedata)
                                    if(pulsedata == nil){
                                        pulsedata = "0"
                                    }
                                    //                            else{
                                    if(Interrupted_TransactionFlag == "y")
                                    {
                                        self.InterruptedTransactionFlag = false
                                        if((pulsedata! as NSString).doubleValue > 0)///test again pulsedata getting nil
                                        {
                                            Interrupted_TransactionFlag = "n"
                                            self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "n")
                                            
                                            
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
                                   // print("LastCount: \( Last_Count),pulsedata:\( pulsedata!),Counts: \(counts)")
                                    let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
                                    
                                    
                                    if(totalpulsecount < Int(Last_Count as String)!)
                                    {
                                        defaults.setValue(Last_Count, forKey: "reinstatingtransaction")
                                        self.web.sentlog(func_name: "pulse count\(Last_Count!) save to app and link resets. ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                        //print("Counts: \(counts),pulsedata:\( pulsedata!),LastCount: \( Last_Count)")
                                        pulsedata = Last_Count
                                        
                                        
                                        
                                    }else{
                                        
                                        timer_quantityless_thanprevious.invalidate()
                                        var pulsedata = defaults.string(forKey: "reinstatingtransaction")
                                        if(pulsedata == nil){
                                            pulsedata = "0"
                                        }
                                        //                                else{
                                        Interrupted_TransactionFlag = "n"
                                        self.web.UpdateInterruptedTransactionFlag(TransactionId: "\(Vehicaldetails.sharedInstance.TransactionId)",Flag: "n")
                                        print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                                        var totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
                                        print("pulsedata: \( pulsedata!),Counts:\(counts),totalpulsecount: \(totalpulsecount)")
                                        self.web.sentlog(func_name: "", errorfromserverorlink: " Pulsar : \(totalpulsecount) = \(pulsedata!) + \(counts)" ,errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
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
                                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                                    
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
                                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                                    
                                                    self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off  - after \(Vehicaldetails.sharedInstance.pumpoff_time) Seconds if you get the same count ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                                    self.stoptimerIspulsarcountsamefor10sec.invalidate()
                                                    self.stoptimerIspulsarcountsamefor10sec = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(FuelquantityVC.sendTransaction_ifgetsamecount), userInfo: nil, repeats: false)
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
                                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
                                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
                                        print("lower qty. than the prior one.")
                                    }
                                }
                                //                            if(pulsar_status == 0)
                                //                            {
                                //
                                //                                do{
                                //                                    playAlarm()
                                //                                    GetPulsarstartimer.invalidate()
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
                                //                                        defaults.setValue(Last_Count, forKey: "reinstatingtransaction")
                                //
                                //                                        self.web.sentlog(func_name: "pulse count\(Last_Count!) save to app and link resets because pulsar_status == 0. ,Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                //                                        appdisconnects_automatically = true
                                //                                        self.stoptimerIspulsarcountsame.invalidate()
                                //                                        self.timerview.invalidate()
                                //
                                //
                                //                                        timer_quantityless_thanprevious.invalidate()
                                //                                        stoptimergotostart.invalidate()
                                //                                        stoptimer_gotostart.invalidate()
                                //                                        cf.delay(0.1){
                                //                                            self.IsStartbuttontapped = false
                                //                                            self.resumetimer() /// reinstate the transaction.
                                //                                            self.viewDidAppear(true)
                                //                                            self.countwififailConn = 0
                                //
                                //                                        }
                                //                                    }
                                //                                    //try self.stoprelay()
                                //                                }
                                //                                catch let error as NSError {
                                //                                    print ("Error: \(error.domain)")
                                //                                    self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
                                //                                }
                                //
                                //                            }
                                
                            }
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
                                            
                                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                            self.stoptimerIspulsarcountsamefor10sec.invalidate()
                                            self.stoptimerIspulsarcountsamefor10sec = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(FuelquantityVC.sendTransaction_ifgetsamecount), userInfo: nil, repeats: false)
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
                reconnectToLink()
            }
        }
        
    }
    
    
    
    @objc func stopIspulsarcountsame(){
        if(self.IsStopbuttontapped == true){
            
        }
        else {
            self.IsStopbuttontappedBLE = true
            self.PulseCountSamefunctionCall = true
            if(self.Ispulsarcountsame == true){
                if(Last_Count == nil){
                    Last_Count = "0.0"
                }
                if(Last_Count == "0.0" || Last_Count == "0")
                {
                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "4")/////
                    
                }
                //print(Last_Count,Samecount)
                if(Samecount == Last_Count){
                    
                    self.GetPulsarstartimer.invalidate()
                    self.web.sentlog(func_name: "Stoprelay stopIspulsarcountsame", errorfromserverorlink: "", errorfromapp:"")
                    if(AppconnectedtoBLE == false ){
                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                        {
                            _ = self.tcpcon.setralay0tcp()
                        }
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
        UsageInfoview.isHidden = true
        IsStartbuttontapped = true
        scrollview.isHidden = false
        dataview.isHidden = true
        OKWait.isHidden = false
        GetPulsarstartimer.invalidate()
        stoptimergotostart.invalidate()
        self.stoptimer_gotostart.invalidate()
        _ = self.web.UpgradeCurrentiotVersiontoserver()
        
        self.web.sentlog(func_name: "data send to server Final Quantity = \(Quantity1.text!) ,Final Pulse Count = \(pulse.text!)", errorfromserverorlink: "", errorfromapp: "")
        self.cf.delay(1){
            Vehicaldetails.sharedInstance.gohome = true
            self.timerview.invalidate()
            self.stoptimerIspulsarcountsame.invalidate()
            self.GetPulsarstartimer.invalidate()
            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: self.SSID)
            //timer_noConnection_withlink.invalidate()
            self.timer_quantityless_thanprevious.invalidate()
            self.stoptimergotostart.invalidate()
            self.stoptimer_gotostart.invalidate()
            //self.web.wifi_settings()
            self.unsync.unsyncTransaction()   ///check
            self.unsync.unsyncP_typestatus()
            self.unsync.Send10trans()
            self.timerview.invalidate()
            //UIApplication.shared.delegate = nil
            self.web.sentlog(func_name: " OK buttontapped TXTN \(Vehicaldetails.sharedInstance.TransactionId) finished, back to home screen.", errorfromserverorlink: "", errorfromapp: "")
            self.stopdelaytime = true
            let appDel = UIApplication.shared.delegate! as! AppDelegate
            appDel.start()
    
        }
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmss"
        
        print(Wifyssid)
        print(Odomtr)
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"\(Version)\",\"Device Type\":\"\(UIDevice().type)\",\"iOS\": \"\(UIDevice.current.systemVersion)\",\"IsFuelingStop\":2,\"Transaction\":\"Current_Transaction\"}"
        
        let reply = web.Transaction_details(bodyData: bodyData)
        print(reply)
    }
    // MARK: - BLE Functions
    
    //    func Stopconnection()
    //    {
    //        FDcheckBLEtimer.invalidate()
    //        //self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
    //        disconnectFromDevice()
    //        //        self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
    //        //        self.updateIncomingData()
    //        do
    //        {
    //            //stoptransaction()
    //        }
    //        catch{}
    //    }
    
    
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
        //        stoprealy()  //we should add the stoprelay function if we get some quantity and the get the DN response from link//
        self.FDcheckBLEtimer.invalidate()
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.start()
    }
    
    
    @objc func gotostartBLE()
    {
        self.web.sentlog(func_name: " BLE Auto stops response of FD check is empty", errorfromserverorlink:"", errorfromapp: "")
        if(AppconnectedtoBLE == true ){
            if(isrelayon == true){
                outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                
                updateIncomingData ()
            }
            self.IsStopbuttontappedBLE = true
            Stop.isEnabled = false
            Stop.isHidden = true
            wait.isHidden = false
            waitactivity.isHidden = false
            FDcheckBLEtimer.invalidate()
        }
        self.web.sentlog(func_name: " TXTN \(Vehicaldetails.sharedInstance.TransactionId) finished, back to home screen.", errorfromserverorlink: "", errorfromapp: "")
        self.disconnectFromDevice()
        isgotostartcalled = true
        self.timerview.invalidate()
    }
    
    //    func calculatetime()
    //    {
    //
    //    }
    
    @objc func fdCheckBLE()
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
                
                if(self.displaytime.text == "Fueling…...")
                {
                    cf.delay(40){
                        do
                        {
                            if(self.displaytime.text == "Fueling…...")
                            {
                                self.FDcheckBLEtimer.invalidate()
                                if(self.isrelayon == true){
                                    self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                                    self.updateIncomingData()
                                    self.at_fdcheckble = true
                                }
//                                self.disconnectFromDevice()
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
                if(isrelayon == false){
                    delay(0.2){
                        self.web.sentlog(func_name: "Sent Relay On Command to BT link again from FD check function because we not receive quantity in first attempt. LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                        self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                        NotificationCenter.default.removeObserver(self)
                        self.updateIncomingData()
                    }
                }
            }
        }
    }
    
    
    func getPulserBLE(counts:String) {
        //counts = "0"
        readRSSI()
        //        self.web.sentlog(func_name: " RSSI \(RSSIholder)", errorfromserverorlink: "", errorfromapp:"")
        
        if("\(Vehicaldetails.sharedInstance.TransactionId)" == "0")
        {
            self.GetPulsarstartimer.invalidate()
            self.timerview.invalidate()
            goto_Start()
            self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
            outgoingData(inputText: "LK_COMM=relay:12345=OFF")
            //                        self.cf.delay(0.1){
            
            
            
            NotificationCenter.default.removeObserver(self)
            //updateIncomingData()
            disconnectFromDevice()
            self.GetPulsarstartimer.invalidate()
            self.web.sentlog(func_name:" AppStops because transaction id 0, Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
        }
        else
        {
            
            let dateFormatter = DateFormatter()
            Warning.text = NSLocalizedString("Warningfueling", comment:"")
            Warning.isHidden = false
            self.Stop.isEnabled = true
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
                                
                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                
                                self.web.sentlog(func_name: "get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpon_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                self.stoptimerIspulsarcountsamefor10sec.invalidate()
                                self.stoptimerIspulsarcountsamefor10sec = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(FuelquantityVC.sendTransaction_ifgetsamecount), userInfo: nil, repeats: false)
                            }
                        }
                    }
                }
                else
                {
                    self.emptypulsar_count = 0
                    if (counts != "0"){
                        Reconnect.isHidden = true
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
                            isBTlinkDisconnect = false
                            if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
                                Ispulsarcountsame = false
                                stoptimerIspulsarcountsame.invalidate()
                            }
                            print(Last_Count)
                            var pulsedata = defaults.string(forKey: "previouspulsedata")
                            if(pulsedata == "")
                            {
                                defaults.setValue("0", forKey: "previouspulsedata")
                            }
                            else{
                                let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
                                print(Last_Count,totalpulsecount,counts,pulsedata)
                                if(totalpulsecount < Int(Float(Last_Count as String)!))
                                {
                                    defaults.setValue(Last_Count, forKey: "previouspulsedata")
                                    print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
                                    pulsedata = Last_Count
                                    ////
                                }else{
                                    
                                    let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
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
                                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                                    
                                                    self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                                    self.stoptimerIspulsarcountsamefor10sec.invalidate()
                                                    self.stoptimerIspulsarcountsamefor10sec = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(FuelquantityVC.sendTransaction_ifgetsamecount), userInfo: nil, repeats: false)
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
                                                            self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)")
                                                        }
                                                        self.web.sentlog(func_name: " Stop Transaction fuel limit reached \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                                                        //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
                                                        self.stopButtontapped()
                                                    }
                                                }
                                            }
                                        }
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
                                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                            
                                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
                                            self.stoptimerIspulsarcountsamefor10sec.invalidate()
                                            self.stoptimerIspulsarcountsamefor10sec = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(FuelquantityVC.sendTransaction_ifgetsamecount), userInfo: nil, repeats: false)
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
                                                self.web.sentlog(func_name: " Stop Transaction fuel limit reached \(Vehicaldetails.sharedInstance.MinLimit).", errorfromserverorlink:"", errorfromapp: "")
                                                
                                                //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
                                                self.stopButtontapped()
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
                                    
                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //    func sentTransactionID(){
    //
    //        self.outgoingData(inputText: "LK_COMM=T:12345;D:2203211345;V:67890;")
    //        NotificationCenter.default.removeObserver(self)
    //        updateIncomingData()
    //    }
    
    
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
        if(jsonText.contains("{\"relay\":\"OFF\"}")){}
        else{
            print(jsonText)
            let data1:Data = "\(jsonText)".data(using: String.Encoding.utf8)!
            do{
                //print(self.sysdata)
                self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                let pulse = self.sysdata.value(forKey: "pulse") as! NSNumber
                
                print(pulse)
                //            self.delay(1){
               
                
                self.countfromlink = Int(truncating: pulse)
                print(lasttransactioncount)
//                if(countfromlink > 0 && countfromlink == Int(lasttransactioncount))
//                {
//                
//                }
//                else
//                {
                if(isrelayon == true) {
                    self.web.sentlog(func_name: " BLE Response from link is \(pulse)", errorfromserverorlink:"", errorfromapp: "")
                    self.getPulserBLE(counts:"\(pulse)")
                }
//                }
                self.displaytime.text = ""
                //            }
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
    
    
    //Get Last transaction from link
    func lasttransaction()
    {
        self.consoleAsciiText = NSAttributedString(string: "")
        self.newAsciiText = NSMutableAttributedString()
        if(self.observationToken == nil){}
        else{
            NotificationCenter.default.removeObserver(self.observationToken!)
        }
        self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
        
        //        delay(1){
        
        self.outgoingData(inputText: "LK_COMM=last1")
        NotificationCenter.default.removeObserver(self)
        self.updateIncomingData()
        if("\(self.newAsciiText)".contains("records"))
        {
            self.parsejsonLast1()
        }
        //        }
    }
    
    //Set transaction id to Link.
    func settransactionid()
    {
        lasttransaction()
        delay(2){
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
            self.outgoingData(inputText:"LK_COMM=T:\(Vehicaldetails.sharedInstance.TransactionId);D:\(dtt1);V:\(Vehicaldetails.sharedInstance.VehicleId);") //TDV change the vehicle id to vehicle no
            
            NotificationCenter.default.removeObserver(self)
            self.updateIncomingData()
        }
    }
    
    func parsejson()
    {
        let Split = self.baseTextView.components(separatedBy: "$$")
        
        let jsonText = Split[1];
        //       let jsonText =  "{\"version\":{\"version\":\"1.0.0(s)\"},\"mac_address\":{\"bt\":\"10:52:1c:85:72:92\"}}"
        print(jsonText)
        if(jsonText.contains("{\"notify\" : \"enabled\"}")){}
        else{
            if(jsonText.contains("version")){
                let data1:Data = jsonText.data(using: String.Encoding.utf8)!
                do{
                    //print(self.sysdata)
                    self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    if(self.sysdata == nil){
                        
                    }
                    else{
                        self.web.sentlog(func_name: " BLE Response from link is \(jsonText)", errorfromserverorlink:"", errorfromapp: "")
                        print(self.sysdata)
                        
                        let version = self.sysdata.value(forKey: "version") as! NSDictionary
                        let Linkversion = version.value(forKey: "version") as! NSString
                        let mac_address = self.sysdata.value(forKey: "mac_address") as! NSDictionary
                        let bt = mac_address.value(forKey: "bt") as! NSString
                        print(Linkversion,bt)
                        Vehicaldetails.sharedInstance.MacAddressfromlink = bt as String
                        Vehicaldetails.sharedInstance.iotversion = Linkversion as String
                        if(Vehicaldetails.sharedInstance.BTMacAddress == "")
                        {
                            if(Vehicaldetails.sharedInstance.MacAddressfromlink == "")
                            {}
                            else{
                                
                                if(self.isUpdateMACAddress == false){
                                    let response = self.web.UpdateMACAddress()
                                    let data1:Data = response.data(using: String.Encoding.utf8)!
                                    do{
                                        //print(self.sysdata)
                                        self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                                        // print(self.sysdata)
                                        let ResponceMessage = self.sysdata.value(forKey: "ResponceMessage") as! NSString
                                        let ResponceText = self.sysdata.value(forKey: "ResponceText") as! NSString
                                        print(ResponceMessage,ResponceText)
                                        if(ResponceMessage == "success")
                                        {
                                            self.isUpdateMACAddress = true
                                            self.showstart = "true"
                                        }
                                        else
                                        if(ResponceMessage == "fail")
                                        {
                                            self.showstart = "false"
                                            gotLinkVersion = true
                                            self.gotostartBLE()
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
                        }
                        else{
                            print(Vehicaldetails.sharedInstance.BTMacAddress,bt)
                            if(Vehicaldetails.sharedInstance.BTMacAddress == bt as String)
                            {
                                self.web.sentlog(func_name: " BLE Mac Address from server \(Vehicaldetails.sharedInstance.BTMacAddress), MacAddressfromlink \(bt) ", errorfromserverorlink:"", errorfromapp: "")
                                BTMacAddress = false
                            }
                            else
                            {
                                self.web.sentlog(func_name: "There is a MAC address error BLE Mac Address from server \(Vehicaldetails.sharedInstance.BTMacAddress), MacAddressfromlink \(Vehicaldetails.sharedInstance.MacAddressfromlink) ", errorfromserverorlink:"", errorfromapp: "")
                                BTMacAddress = true
                            }
                            
                            gotLinkVersion = true
                            
                            //                settransactionid()
                        }
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
                self.web.sentlog(func_name: " BLE Response from link is \(jsonText)", errorfromserverorlink:"", errorfromapp: "")
                // let index: Int = 0
                if(rowCount >= 1){
                    
                    for i in 0  ..< rowCount
                    {
                        
                        let JsonRow = record_data[i] as! NSDictionary
                        if(JsonRow.count >= 5){
                            let date = JsonRow.value(forKey: "date") as! NSString
                            let dflag = JsonRow.value(forKey: "dflag") as! Bool
                            let pulse = JsonRow.value(forKey: "pulse") as! NSNumber
                            let txtn = JsonRow.value(forKey: "txtn") as! NSString
                            let vehicle = JsonRow.value(forKey: "vehicle") as! NSString
                            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
                            let quantity = (Double(truncating: pulse))/(PulseRatio as NSString).doubleValue
                            //self.cf.calculate_fuelquantity(quantitycount: Int(truncating: pulse))
                            lasttransactioncount = "\(pulse)"
                            self.saveTrans(lastpulsarcount: "\(pulse)",lasttransID: txtn as String)
//                            let transaction_details = Last10Transactions (Transaction_id: txtn as String, Pulses: "\(pulse)", FuelQuantity: "\(quantity)", vehicle: vehicle as String, date: date as String, dflag: "\(dflag)" )
                            
//                            Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
                            print(date,dflag,pulse,txtn,vehicle)
                        }
                    }
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
        else
        {
            self.web.sentlog(func_name: "Data : \(Split)", errorfromserverorlink: "", errorfromapp:"")
        }
        
    }
    
    
    func parsejsonOFF()
    {
        let Split = self.baseTextView.components(separatedBy: "$$")
        if(IsStopbuttontappedBLE == true)
        {
            let jsonText = "{\"relay\":\"OFF\"}" //Split[0]//
            
            //       let jsonText =  "{\"version\":{\"version\":\"1.0.0(s)\"},\"mac_address\":{\"bt\":\"10:52:1c:85:72:92\"}}"
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
                    self.isdisconnected = true
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
                Vehicaldetails.sharedInstance.MacAddressfromlink = MacAddress
                var version = MacAddressdata[1].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
                print(MacAddress,Splitdata,version)
                Vehicaldetails.sharedInstance.iotversion = version[0]
                Vehicaldetails.sharedInstance.iotversion.removeFirst()
                print(Vehicaldetails.sharedInstance.iotversion.removeFirst())
                print(Vehicaldetails.sharedInstance.BTMacAddress,MacAddress)
                if(Vehicaldetails.sharedInstance.BTMacAddress == ""){}
                else{
                    if(Vehicaldetails.sharedInstance.BTMacAddress.trimmingCharacters(in: .whitespacesAndNewlines) == MacAddress.trimmingCharacters(in: .whitespacesAndNewlines))
                    {
                        self.web.sentlog(func_name: " BLE Mac Address from server \(Vehicaldetails.sharedInstance.BTMacAddress), MacAddressfromlink \(Vehicaldetails.sharedInstance.MacAddressfromlink) ", errorfromserverorlink:"", errorfromapp: "")
                        BTMacAddress = false
                    }
                    else
                    {
                        
                        self.web.sentlog(func_name: "There is a MAC address error BLE Mac Address from server \(Vehicaldetails.sharedInstance.BTMacAddress), MacAddressfromlink \(Vehicaldetails.sharedInstance.MacAddressfromlink) ", errorfromserverorlink:"", errorfromapp: "")
                        BTMacAddress = true
                    }
                    
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
                        let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
                        let quantity = (Double(truncating: Int(pulses as String)! as NSNumber))/(PulseRatio as NSString).doubleValue
                        //let quantity = self.cf.calculate_fuelquantity(quantitycount: Int(pulses as String)!)
                        let transaction_details = Last10Transactions(Transaction_id: transid, Pulses: pulses, FuelQuantity: "\(quantity)", vehicle: "", date: "", dflag: "")
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
    
    func GotoSettingpage(message: String)
    {
        
        
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
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}



// MARK: - Central Manager delegate

extension FuelquantityVC: CBCentralManagerDelegate {
    // MARK: - write the data
    // Write functions
    
    
    func outgoingData (inputText:String) {
        
        self.web.sentlog(func_name: " BLE sent request to link is \(inputText)", errorfromserverorlink:"", errorfromapp: "")
        writeValue(data: inputText)
        
        let attribString = NSAttributedString(string: inputText)//, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributes1))
        let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
        newAsciiText.append(attribString)
        consoleAsciiText = newAsciiText
    }
    
    
    func updateIncomingData()
    {
        observationToken = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){ [self]
            notification in
            print(connectedservice)
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
                    if(gotLinkVersion == true)
                    {
                        
                    }
                    else{
                        self.parsejson()
                    }
                }
                
                if("\(characteristicASCIIValue)".contains("{\"pulse\":"))
                {
                    if(IsStopbuttontappedBLE == true){}
                    else{
                        //                        cf.delay(1){
                        //sleep(1)
                        //2405
                        //                        self.parsepulsedata()
                        //                        }
                    }
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
                        
                        //                        if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                        //                        {
                        //                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                        //                            {
                        //                                self.web.sentlog(func_name: "Got OFF response from link Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                        //                                if(self.bindata == nil){
                        //                                    self.uploadbinfile()
                        //                                }
                        //
                        //                                sendData()
                        //                                _ = self.web.UpgradeCurrentiotVersiontoserver()
                        //
                        //                            }
                        //                        }
                        //                        else
                        //                        {
                        
                        self.parsejsonOFF()
                        
                        //                        }
                    }
                    
                }
            }
            
            
            if(self.characteristicASCIIValue == "ON")
            {
                print(characteristicASCIIValue)
                isrelayon = true
                
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
                    self.Count_Fdcheck = self.Count_Fdcheck + 1
                }
                //                    if(Count_Fdcheck == 3)
                //                    {
                //                        gotostartBLE()
                //
                //                    }
            }
                     
            
            if(self.characteristicASCIIValue.contains("{\"upgrade\":'true'}"))
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
                            stoptimer_gotostart.invalidate()
                            stoptimergotostart.invalidate()
                            //                            self.web.sentlog(func_name: " Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                            //                            if(self.bindata == nil){
                            //                                self.uploadbinfile()
                            //                            }
                            // self.web.sentlog(func_name: "StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                            //self.Firmwareupdate()
                            //                            firmwareUpdateDemo()
                            //                            sendData()
                            //                              _ = self.web.UpgradeCurrentiotVersiontoserver()
                            
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
    
    func getBLEInfo()
    {
        consoleAsciiText = NSAttributedString(string: "")
        newAsciiText = NSMutableAttributedString()
        //            if(observationToken == nil){}
        //            else{
        NotificationCenter.default.removeObserver(self)//.observationToken!)
        //            }
        newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, newAsciiText.length))
        outgoingData(inputText: "LK_COMM=info")
        //        self.cf.delay(0.5){
        //            self.updateIncomingData()
        //            NotificationCenter.default.removeObserver(self)
        //        }
        //        updateIncomingData()
        //        NotificationCenter.default.removeObserver(self)
        self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
        AppconnectedtoBLE = true
    }
    
    
    func startScan() {
        if(ifSubscribed == true)
        {
            
        }
        else{
            print(countfromlink)
            
            self.web.sentlog(func_name: "Start BT Scan...to search the service id \(kBLEService_UUID)", errorfromserverorlink:"", errorfromapp: "\(peripherals)")
            self.peripherals = []
            //        self.kCBAdvData_LocalName = []
            let BLEService_UUID = CBUUID(string: kBLEService_UUID)
            print("Now Scanning...")
            self.GetPulsarstartimer.invalidate()
            centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
            
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false) {_ in
                //            self.web.sentlog(func_name: "Scan Stopped...", errorfromserverorlink:"", errorfromapp: "\(self.peripherals)")
                if(self.peripherals.count == 0)
                {
                    if(self.onFuelingScreen == true){
                        if(self.appconnecttoUDP == true){}
                        else{
                            //self.cancelScan()
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
        }
    }
    
    /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
    func cancelScan() {
        if(ifSubscribed == true){}
        else{
            self.centralManager?.stopScan()
            
            self.web.sentlog(func_name: "Scan Stopped", errorfromserverorlink: "Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(peripherals)")
            Vehicaldetails.sharedInstance.peripherals = self.peripherals
            if (peripherals.count == 0){
                if(IsStartbuttontapped == true){}
                else{
                    self.countfailBLEConn = self.countfailBLEConn + 1
                    self.web.sentlog(func_name: "Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
                    
                    if (self.countfailBLEConn == 5){
                        
                        self.web.sentlog(func_name: "App Not able to Connect BT Link and Subscribed peripheral Connection. Attempt  \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
                        
                        
                        
                        let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                        
                        if("1.4.12".compare(Vehicaldetails.sharedInstance.CurrentFirmwareVersion, options: .numeric) == .orderedSame ||  "1.4.12".compare(Vehicaldetails.sharedInstance.CurrentFirmwareVersion, options: .numeric) == .orderedAscending)
                        {
                            Alert(message: "We are unable to establish connection, please call into Support.")
                        }
                        else
                        {
                            
                            self.web.sentlog(func_name: "App Switches BT to UDP...", errorfromserverorlink: "", errorfromapp: "")
                            Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
                            DispatchQueue.main.async() {
                                
                                self.performSegue(withIdentifier: "GoUDP", sender: self)
                            }
                            appconnecttoUDP = true
                            
                        }
                    }
                    
                    else{
                        if(ifSubscribed == true){}
                        else{
                            self.web.sentlog(func_name: " Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
                            //self.startScan()
                            if(onFuelingScreen == true){
                                if(peripherals.count == 0)
                                {
                                    delay(3){
                                        self.startScan()
                                    }
                                }
                                else
                                {
                                    viewDidAppear(true)
                                }
                            }
                        }
                    }
                    
                    Vehicaldetails.sharedInstance.peripherals = self.peripherals
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
                            peripheral = self.peripherals[i]
                            
                            
                            if(peripheral.name! == "nil" || peripheral.name! == "(null)")
                            {}
                            else{
                                if( Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                {
                                    
                                    blePeripheral = self.peripherals[i]
                                    connectedperipheral = (blePeripheral?.name)!
                                    defaults.set(blePeripheral?.name!, forKey: "LasttransactionSSID")
                                    //                            defaults.set("\(blePeripheral!.identifier)", forKey: "Lasttransactionidentifier")
                                    connectToDevice()
                                    break
                                }
                                //                        else if(Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().components(separatedBy: .whitespacesAndNewlines).joined() == localName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                //                        {
                                //                            //blePeripheral = self.peripherals[i]
                                //                            //                            if(peripheral.name! == BLEPeripheralforlocalname){
                                //                            blePeripheral = self.peripherals[i]
                                //                            connectedperipheral = (blePeripheral?.name)!
                                //
                                //                            connectToDevice()
                                //                            break
                                //                            //                            }
                                //                        }
                                
                                
                                else if(Vehicaldetails.sharedInstance.OriginalNamesOfLink.count > 0)
                                {
                                    self.web.sentlog(func_name: "OriginalNamesOfLink name \(Vehicaldetails.sharedInstance.OriginalNamesOfLink).", errorfromserverorlink:"", errorfromapp: "")
                                    for ln in 0  ..< Vehicaldetails.sharedInstance.OriginalNamesOfLink.count
                                    {
                                        if(peripheral.name! == "nil" || peripheral.name! == "(null)")
                                        {}
                                        else{
                                            //2441
                                            for p in 0  ..< peripherals.count
                                            {
                                                print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])".trimmingCharacters(in: .whitespacesAndNewlines).uppercased(), peripherals[p].name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                                print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])", peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),self.peripherals[i],self.peripherals[p])
                                                if( "\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])".trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == peripherals[p].name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                                {
                                                    self.web.sentlog(func_name: "\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]),\(self.peripherals[p])", errorfromserverorlink:"", errorfromapp: "")
                                                    print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]), \(peripheral.name!)")
                                                    blePeripheral = self.peripherals[p]
                                                    //print(blePeripheral)
                                                    connectedperipheral = (blePeripheral?.name)!
                                                    defaults.set(blePeripheral?.name!, forKey: "LasttransactionSSID")
                                                    //                                defaults.set("\(blePeripheral!.identifier)", forKey: "Lasttransactionidentifier")
                                                    connectToDevice()
                                                    break
                                                    
                                                }
                                            }
                                            //                                else if("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])".trimmingCharacters(in: .whitespacesAndNewlines).uppercased().components(separatedBy: .whitespacesAndNewlines).joined() == localName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                            //                                {
                                            //                                    print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]), \(localName)")
                                            //                                    //blePeripheral = self.peripherals[i]
                                            //                                    //                            if(peripheral.name! == BLEPeripheralforlocalname){
                                            //                                    blePeripheral = self.peripherals[i]
                                            //                                    connectedperipheral = (blePeripheral?.name)!
                                            //
                                            //                                    connectToDevice()
                                            //                                    break
                                            //
                                            //                                    //                            }
                                            //                                }
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        if(self.AppconnectedtoBLE == true){
                            
                            break
                        }
                    }
                    if(self.connectedperipheral == "")
                    {
                        for i in 0  ..< peripherals.count
                        {
                            print(peripherals,peripherals.count)
                            if(peripherals.count == 0)
                            {
                                print(peripherals,peripherals.count)
                            }
                            else{
                                peripheral = self.peripherals[i]
                                
                                if(peripheral.name! == "nil" || peripheral.name! == "(null)")
                                {}
                                else{
                                    if( Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                    {
                                        
                                        blePeripheral = self.peripherals[i]
                                        connectedperipheral = (blePeripheral?.name)!
                                        defaults.set(blePeripheral?.name!, forKey: "LasttransactionSSID")
                                        //                            defaults.set("\(blePeripheral!.identifier)", forKey: "Lasttransactionidentifier")
                                        connectToDevice()
                                        break
                                    }
                                    //                            else if(Vehicaldetails.sharedInstance.SSId.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().components(separatedBy: .whitespacesAndNewlines).joined() == localName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                    //                            {
                                    //                                //blePeripheral = self.peripherals[i]
                                    //                                //                            if(peripheral.name! == BLEPeripheralforlocalname){
                                    //                                blePeripheral = self.peripherals[i]
                                    //                                connectedperipheral = (blePeripheral?.name)!
                                    //
                                    //                                connectToDevice()
                                    //                                break
                                    //                                //                            }
                                    //                            }
                                    
                                    
                                    else if(Vehicaldetails.sharedInstance.OriginalNamesOfLink.count > 0)
                                    {
                                        self.web.sentlog(func_name: "OriginalNamesOfLink name \(Vehicaldetails.sharedInstance.OriginalNamesOfLink).", errorfromserverorlink:"", errorfromapp: "")
                                        for ln in 0  ..< Vehicaldetails.sharedInstance.OriginalNamesOfLink.count
                                        {
                                            if(peripheral.name! == "nil" || peripheral.name! == "(null)")
                                            {}
                                            else{
                                                //2441
                                                for p in 0  ..< peripherals.count
                                                {
                                                    self.web.sentlog(func_name: "\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]),\(self.peripherals[p])", errorfromserverorlink:"", errorfromapp: "")
                                                    
                                                    print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])", peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),self.peripherals[i],self.peripherals[p])
                                                    if( "\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln])".trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == peripherals[p].name!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                                                    {
                                                        print("\(Vehicaldetails.sharedInstance.OriginalNamesOfLink[ln]), \(peripheral.name!)")
                                                        blePeripheral = self.peripherals[p]
                                                        //print(blePeripheral)
                                                        connectedperipheral = (blePeripheral?.name)!
                                                        defaults.set(blePeripheral?.name!, forKey: "LasttransactionSSID")
                                                        //                                defaults.set("\(blePeripheral!.identifier)", forKey: "Lasttransactionidentifier")
                                                        connectToDevice()
                                                        break
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                    //                    if( defaults.value(forKey: "Lasttransactionidentifier")! as! String == "\(peripheral.identifier)"){
                                    //                                                self.web.sentlog(func_name: "\(blePeripheral!.identifier),\(defaults.value(forKey: "Lasttransactionidentifier"))! as! String,\(peripheral.identifier)", errorfromserverorlink: "", errorfromapp: "")
                                    //                                                print("\(blePeripheral!.identifier)",defaults.value(forKey: "Lasttransactionidentifier")! as! String,"\(peripheral.identifier)")
                                    //                                                                            blePeripheral = self.peripherals[i]
                                    //                                                                            connectedperipheral = (blePeripheral?.name)!
                                    //                                                                            defaults.set(blePeripheral?.name!, forKey: "LasttransactionSSID")
                                    //                                                                            connectToDevice()
                                    //                                                                            break
                                    //                                                                            }
                                }
                            }
                            if(self.AppconnectedtoBLE == true){
                                
                                break
                            }
                        }
                        if(IsStartbuttontapped == true){}
                        else{
                            self.countfailBLEConn = self.countfailBLEConn + 1
                            
                            self.web.sentlog(func_name: "Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
                            
                            if (self.countfailBLEConn == 5){
                                
                                
                                self.web.sentlog(func_name: "App Not able to Connect BT Link and Subscribed peripheral Connection. Attempt  \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
                                
                                
                                
                                let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                                self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                                
                                if("1.4.12".compare(Vehicaldetails.sharedInstance.CurrentFirmwareVersion, options: .numeric) == .orderedSame ||  "1.4.12".compare(Vehicaldetails.sharedInstance.CurrentFirmwareVersion, options: .numeric) == .orderedAscending)
                                {
                                    Alert(message: "We are unable to establish connection, please call into Support.")
                                }
                                else
                                {
                                    
                                    self.web.sentlog(func_name: "App Switches BT to UDP...", errorfromserverorlink: "", errorfromapp: "")
                                    Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
                                    DispatchQueue.main.async() {
                                        
                                        self.performSegue(withIdentifier: "GoUDP", sender: self)
                                    }
                                    appconnecttoUDP = true
                                }
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
                }
            }
        }
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            self.web.sentlog(func_name: "BLE powered on", errorfromserverorlink: "", errorfromapp:"")
            if(countfromlink > 0)
            {
                if(sendrename_linkname == true)
                {
                    startScan()
                    self.web.sentlog(func_name: "startScan  ", errorfromserverorlink: "\(countfromlink)", errorfromapp:"")
                }
            }
            else{
                // Turned on
                startScan()
                self.web.sentlog(func_name: "startScan  ", errorfromserverorlink: "\(countfromlink)", errorfromapp:"")
                //central.scanForPeripherals(withServices: [CBUUID(string: "000000ff-0000-1000-8000-00805f9b34fb")], options: nil)
            }
        }
        else {
            print("Something wrong with BLE")
            self.web.sentlog(func_name: "Something wrong with BLE  ", errorfromserverorlink: "", errorfromapp:"")
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
                
                self.web.sentlog(func_name: "onFuelingScreen peripheral \(peripheral), RSSI \(RSSI)", errorfromserverorlink: "Peripheral name: \(String(describing: peripheral.name))", errorfromapp:"")
                
            }
            
            else{
                blePeripheral = peripheral
                self.peripherals.append(peripheral)
                self.RSSIs.append(RSSI)
                self.web.sentlog(func_name: "On FuelingScreen append the blePeripherals \(peripherals.count),RSSI \(RSSI)", errorfromserverorlink: "\(peripherals)", errorfromapp:"")
                peripheral.delegate = self
                
            }
        }
        if blePeripheral == nil {
            //            print("Found new pheripheral devices with services")
            //            print("Peripheral name: \(String(describing: peripheral.name))")
            //            print("**********************************")
            //            print ("Advertisement Data : \(advertisementData)")
            //self.web.sentlog(func_name: "Peripheral Data : \(blePeripheral)", errorfromserverorlink: "Peripheral name: \(peripheral))", errorfromapp:"")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print("Failed to connect to peripheral")
            return
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
        print("connected to \(peripheral)")
        //        peripheral.readRSSI()
        //        self.startReadRSSI()
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
        
        //        peripheral.readRSSI()
        //        self.startReadRSSI()
        //        print("Discovered Services: \(services)")
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (isviewdidDisappear == true)
        {
            disconnectFromDevice()
        }
        else{
            isBTlinkDisconnect = true
            self.isDisconnect_Peripheral = true
            if (at_fdcheckble == true)
            {
                FDcheckBLEtimer.invalidate()
            }
            else{
                if(self.IsStopbuttontappedBLE == false){
                    self.web.sentlog(func_name: " Reconnect to Link \(IsStopbuttontappedBLE)", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                    FDcheckBLEtimer.invalidate()
                    
                    
                    if(self.IsStopbuttontappedBLE == true)
                    {
                        self.web.sentlog(func_name: " Reconnect to Link \(self.IsStopbuttontappedBLE)", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                    }
                    else{
                        self.Reconnect.isHidden = false
                        ifSubscribed = false
                        self.Reconnect.text = "Reconnecting to pump."//NSLocalizedString("Reconnect" , comment:"")
                        //displaytime.textColor = UIColor.red
                        //                    if(Last_Count == nil){
                        //                        Last_Count = "0"
                        //                    }else{
                        self.appdisconnects_automatically = true
                        self.web.LINKDisconnectionError()
                        self.connectToDevice()
                        iskBLE_Characteristic_uuid_Tx_upload_setnotifytrue = false
                        iskBLE_Characteristic_uuid_Tx_setnotifytrue = false
                        self.delay(1){
                            self.viewDidAppear(true)
                            self.isNotifyenable = false
                            //                        }
                        }
                    }
                }
                
                else if(self.IsStopbuttontappedBLE == true)
                {
                    FDcheckBLEtimer.invalidate()
                    print("Disconnected")
                    isDisconnect_Peripheral = true
                    
                    if(Last_Count == nil){
                        Last_Count = "0"
                        self.web.sentlog(func_name: " Last_Count \(Last_Count!) Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                        self.viewDidAppear(true)
                        
                    }
                    
                    if(Last_Count! == "0"){
                        do{
                            try self.stoprelay()
                            isdisconnected = true
                        }
                        catch let error as NSError {
                            print ("Error: \(error.domain)")
                        }
                        isdisconnected = true
                        //self.connectToDevice()
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
                        else
                        {
                            self.web.sentlog(func_name: "Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp:"\(error)")
                        }
                    }
                }
            }
        }
    }
    
    func disconnectFromDevice()
    {
        if blePeripheral != nil {
            //            self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic),\(blePeripheral)", errorfromserverorlink: "", errorfromapp:"")
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
                    //                    self.renamelink(SSID:trimmedString)
                    //                    self.web.SetHoseNameReplacedFlag()
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
            
            self.web.sentlog(func_name: "Disconnecting Device from link \(Vehicaldetails.sharedInstance.SSId)", errorfromserverorlink: "", errorfromapp:"")
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
                                self.unsync.unsyncTransaction()
                                self.unsync.unsyncP_typestatus()
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
                }
            }
            else
            {
                do{
                    
                    try self.stoprelay()
                    self.web.sentlog(func_name: "TXTN \(Vehicaldetails.sharedInstance.TransactionId) finished, back to home screen.", errorfromserverorlink: "", errorfromapp: "")
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
            self.web.sentlog(func_name: "connecting to BT link Device \(blePeripheral!)", errorfromserverorlink:"", errorfromapp: "")
            AppconnectedtoBLE = true
            //            getBLEInfo()
        }
    }
    
    func connectToBLE()
    {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func Alert(message: String)
    {
        
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
                let appDel = UIApplication.shared.delegate! as! AppDelegate
                appDel.start()
                self.stoptimer_gotostart.invalidate()
                self.stoptimergotostart.invalidate()
                self.timerview.invalidate()
//                let storyboard = UIStoryboard(name: "PreauthStoryboard", bundle: nil)
//                Vehicaldetails.sharedInstance.AppType = "preAuthTransaction"
//                let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
//                controller.modalPresentationStyle = .fullScreen
//                self.present(controller, animated: true, completion: nil)
//                self.web.sentlog(func_name: "Starts preAuthTransaction", errorfromserverorlink: "", errorfromapp: "")
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - write the data
    // Write functions
    
    
    
}

//Mark:CallObserver

//extension FuelquantityVC: CXCallObserverDelegate
//{
//    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
//
//       if call.hasEnded == true {
//           print("CXCallState: Disconnected")
//       }
//
//       if call.isOutgoing == true && call.hasConnected == false {
//           print("CXCallState: Dialing")
//       }
//
//       if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
//           print("CXCallState: Incoming")
//       }
//
//       if call.hasConnected == true && call.hasEnded == false {
//           print("CXCallState: Connected")
//        self.web.sentlog(func_name: " User Connected the call.", errorfromserverorlink:"", errorfromapp: "")
//            stopButtontapped()
//       }
//    }
//}



//    // MARK: - Peripheral Delegate
extension FuelquantityVC: CBPeripheralDelegate {
    
    
    
    /*
     *  Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    //    private func cleanup() {
    //        // Don't do anything if we're not connected
    //        guard let discoveredPeripheral = blePeripheral,
    //              case .connected = discoveredPeripheral.state else { return }
    //
    //        for service in (discoveredPeripheral.services ?? [] as [CBService]) {
    //            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
    //                if characteristic.uuid == txCharacteristicupload && characteristic.isNotifying {
    //                    // It is notifying, so unsubscribe
    //                    discoveredPeripheral.setNotifyValue(false, for: characteristic)
    //                }
    //            }
    //        }
    //
    //        // If we've gotten this far, we're connected, but we're not subscribed, so we just disconnect
    //        centralManager.cancelPeripheralConnection(discoveredPeripheral)
    //    }
    
    
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
            
            print(service)
            
            if service.uuid.isEqual(CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b9")){
                
                connectedservice = "725e0bc8-6f00-4d2d-a4af-96138ce599b9"
            }
            else if service.uuid.isEqual(CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b7")){
                connectedservice = "725e0bc8-6f00-4d2d-a4af-96138ce599b7"
            } else if service.uuid.isEqual(CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")){
                connectedservice = "725e0bc8-6f00-4d2d-a4af-96138ce599b6"
            }
        }
        
        peripheral.readRSSI()
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
                
                if(iskBLE_Characteristic_uuid_Tx_setnotifytrue == true){}
                else{
                    //Once found, subscribe to the this particular characteristic...
                    if(isNotifyenable == false){
                        peripheral.setNotifyValue(true, for: rxCharacteristic!)
                        iskBLE_Characteristic_uuid_Tx_setnotifytrue = true
                        // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
                        // didUpdateNotificationStateForCharacteristic method will be called automatically
                        peripheral.readValue(for: characteristic)
                        print("Rx Characteristic: \(characteristic.uuid)")
                    }
                }
            }
            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Tx)){
                txCharacteristic = characteristic
                print("Tx Characteristic: \(characteristic.uuid)")
            }
            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Tx_upload))  {
                rxCharacteristic = characteristic
                if(iskBLE_Characteristic_uuid_Tx_upload_setnotifytrue == true){}
                else{
                    //Once found, subscribe to the this particular characteristic...
                    if(isNotifyenable == false){
                        peripheral.setNotifyValue(true, for: rxCharacteristic!)
                        iskBLE_Characteristic_uuid_Tx_upload_setnotifytrue = true
                        // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
                        // didUpdateNotificationStateForCharacteristic method will be called automatically
                        peripheral.readValue(for: characteristic)
                        print("Rx Characteristic: \(characteristic.uuid)")
                    }
                }
            }
            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Tx_upload)){
                txCharacteristicupload = characteristic
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
        // BLE infor command response old link version
        characteristicASCIIValue = ASCIIstring as String
        print(characteristicASCIIValue)
        if((characteristicASCIIValue as String).contains("L10:"))
        {
            Last10transaction = (characteristicASCIIValue as String)
            self.web.sentlog(func_name: " Get response from info command to link \(characteristicASCIIValue)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
        }
        
        if((characteristicASCIIValue as String).contains("{\"relay\":\"ON\"}"))
        {
            self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
            isrelayon = true
        }
        if(characteristicASCIIValue == "Notify enabled..." || characteristicASCIIValue == "LinkBlue notify enabled..." || characteristicASCIIValue == "{\"notify\" : \"enabled\"}")
        {
            isNotifyenable = true
        }
        if("\(characteristicASCIIValue)".contains("{\"pulse\":"))
        {
            //            cf.delay(1){
            //sleep(1)
            self.parsepulsedata()
            //            }
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
                    //                    delay(1){
                    self.getPulserBLE(counts:"\(datacount)")
                    //                                            }
                    self.displaytime.text = ""
                    
                }
                
                else if(self.characteristicASCIIValue == "pulse: 0")
                {
                }
            }
        }
        
        
        
        
        //#2177
        print("Value Recieved: \((characteristicASCIIValue as String))")
        if("\(self.characteristicASCIIValue)".contains("{\"pulser_type\""))
        {
            self.web.sentlog(func_name: " BLE Response from link is \(self.characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
        }
        if("\(self.characteristicASCIIValue)".contains("{\"pulser_type\":1}$$"))
        {
            defaults.set("1", forKey: "UpdateSwitchTimeBounceForLink")
        }
        else if("\(self.characteristicASCIIValue)".contains("{\"pulser_type\":2}$$"))
        {
            defaults.set("2", forKey: "UpdateSwitchTimeBounceForLink")
        }
        else if("\(self.characteristicASCIIValue)".contains("{\"pulser_type\":3}$$"))
        {
            defaults.set("3", forKey: "UpdateSwitchTimeBounceForLink")
        }
        else if("\(self.characteristicASCIIValue)".contains("{\"pulser_type\":4}$$"))
        {
            defaults.set("4", forKey: "UpdateSwitchTimeBounceForLink")
        }
        
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
            //            sendData()//bin_data.append(characteristicData)
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
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral)
    {
        print(peripheral)
        
    }
    
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
                //                if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
                //                {
                //                    if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
                //                    {
                //                        if(isupload_file == true){}
                //                        else{
                //                            self.uploadbinfile()
                //
                ////                            _ = self.firmwareUpdateDemo()
                ////                            self.sendData()
                ////                            _ = self.web.UpgradeCurrentiotVersiontoserver()
                //                            self.web.sentlog(func_name: "Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                //                        }
                //
                //                    }
                //                    else
                //                    {
                //                        self.web.sentlog(func_name: " Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                //                        if(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())
                //                        {
                //                            self.tcpcon.getuser()
                //                        }
                //                    }
                //                    //                            Vehicaldetails.sharedInstance.IsUpgrade = "N"
                //                }
                //                else{
                //        delay(1){
                if(self.connectedservice == "725e0bc8-6f00-4d2d-a4af-96138ce599b9")
                {
                    self.consoleAsciiText = NSAttributedString(string: "")
                    self.newAsciiText = NSMutableAttributedString()
                    if(self.observationToken == nil){}
                    else{
                        NotificationCenter.default.removeObserver(self.observationToken!)
                    }
                    self.newAsciiText.mutableString.replaceOccurrences(of: "\n\n", with: "\n", options: [], range: NSMakeRange(0, self.newAsciiText.length))
                    if(self.gotLinkVersion == true){}
                    else{
                        self.outgoingData(inputText: "LK_COMM=info")
                        //                        self.cf.delay(1){
                        
                        //                                        self.cf.delay(0.5){
                        self.updateIncomingData()
                        NotificationCenter.default.removeObserver(self)
                        //                    }
                        //            self.updateIncomingData()
                        //
                        //            NotificationCenter.default.removeObserver(self)
                        //                                    }
                        
                        // self.web.sentlog(func_name: " Send info command to link", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
                        //                        }
                    }
                }
                else
                {
                    getBLEInfo()
                }
                //move to on stop button tapped event
                //                print(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce)
                //                if(Vehicaldetails.sharedInstance.IsResetSwitchTimeBounce == "1")
                //                {
                //
                //                    self.sendpulsar_type()
                //                }
                //                outgoingData(inputText: "LK_COMM=p_type?")
                //                updateIncomingData()
                
                delay(1){
                    self.getlast10transaction()
                    if(self.BTMacAddress == false)
                    {
                        
                        self.start.isEnabled = true
                        self.start.isHidden = false
                        self.cancel.isHidden = false
                        self.Pwait.isHidden = true
                        self.Activity.stopAnimating()
                        self.displaytime.text = NSLocalizedString("MessageFueling", comment:"")
                    }
                    else if(self.BTMacAddress == true)
                    {
                        self.showAlert(message: "There is a MAC address error. Please contact Support")
                        self.cf.delay(6)
                        {
                            // self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                            //  self.updateIncomingData()
                            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
                            self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6")
                            self.disconnectFromDevice()
                            self.goto_Start()
                        }
                        //self.showAlert(message: "Macaddress is not matched \(Vehicaldetails.sharedInstance.BTMacAddress)" )
                    }
                }
                
            }
            //#2350 allow BLE transaction with out click start button
            if(self.defaults.string(forKey: "Companyname") == "Company2")
            {
                //#2437
                if(Vehicaldetails.sharedInstance.selectedCompanybyGA.contains("Demo-") || Vehicaldetails.sharedInstance.GACompany.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == Vehicaldetails.sharedInstance.selectedCompanybyGA.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                {}
                else{
                    if(self.AppconnectedtoBLE == true){
                        // #2403
                        self.stoptimergotostart.invalidate()
                        self.stoptimer_gotostart.invalidate()
                        self.getlast10transaction()
                        self.BLErescount = 0
                        self.baseTextView = ""
                        
                        self.updateIncomingData()
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
                            self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.fdCheckBLE), userInfo: nil, repeats: true)
                        }
                    }
                }
            }
            //if(self.appdisconnects_automatically == true)//#2344
            
            if(self.appdisconnects_automatically == true && IsStartbuttontapped == true)
            {
                self.web.sentlog(func_name: " appdisconnects_automatically \(appdisconnects_automatically)", errorfromserverorlink: "IsStartbuttontapped \(IsStartbuttontapped)", errorfromapp: "")
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
                        self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.fdCheckBLE), userInfo: nil, repeats: true)
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
        print("Message sent\(CBCharacteristic.self)")
    }
    
    
    // Stub to stop run-time warning
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
    }
    
    /*
     *  This is called when peripheral is ready to accept more data when using write without response
     */
    
    //    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral)
    //    {
    //        self.sendData()
    //    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        self.RSSIholder = Int(truncating: RSSI) as NSNumber
        print(RSSIholder,RSSI)
        self.web.sentlog(func_name: " RSSI \(RSSI),\(RSSIholder)", errorfromserverorlink: "", errorfromapp:"")
    }
    
    @objc func readRSSI(){
        if (self.peripheral != nil){
            self.peripheral.delegate = self
            self.peripheral.readRSSI()
        } else {
            print("peripheral = nil")
        }
        if (Int(truncating: self.RSSIholder) < -90) {
            //let openValue = "1".dataUsingEncoding(NSUTF8StringEncoding)!
            print(RSSIholder)
            self.web.sentlog(func_name: " RSSI value \(RSSIholder) < -90 this signal is extremely weak.", errorfromserverorlink: "", errorfromapp:"")
            
        }
    }
    
   
   
}



