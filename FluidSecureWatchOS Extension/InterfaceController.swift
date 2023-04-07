//
//  InterfaceController.swift
//  FluidSecureWatchOS Extension
//
//  Created by apple on 01/04/21.
//  Copyright © 2021 VASP. All rights reserved.
//

import WatchKit
import Foundation
import CoreBluetooth
import CoreLocation
import Network


class InterfaceController: WKInterfaceController {

      var reply :String!
      //var  URL = "http://sierravistatest.cloudapp.net/"
//    var reply1 :String!
    let defaults = UserDefaults.standard
//    var replydata:NSData!
    var web = Webservice()
    var pulsardata:String!
    var sysdataLast10trans:NSDictionary!
    
    var IsStartbuttontapped : Bool = false
    var IsStopbuttontapped:Bool = false
    var Ispulsarcountsame :Bool = false
    var Cancel_Button_tapped :Bool = false
    var stopdelaytime:Bool = false
    
    var sysdata:NSDictionary!
    
    var quantity = [String]()
    var counts:String!
    var reply_server:String = ""

    var timerFDCheck:Timer = Timer()
    var timer:Timer = Timer()    // #selector(self.GetPulser) call the Getpulsar function.
    var timerview:Timer = Timer()  // #selector(ViewController.viewDidAppear(_:)) call viewController timerview
    var isUDPConnectstoptimer:Timer = Timer()  // Add timer to send UDP Connection function after connect the Link. and stops time after get the valid output.
    var stoptimergotostart:Timer = Timer() ///#selector(call gotostart function)
    var stoptimer_gotostart:Timer = Timer() ///#selector(gotostart from viewWillapeared)
    var stoptimerIspulsarcountsame:Timer = Timer()  ///call stopIspulsarcountsame for
    // var timer_noConnection_withlink = Timer()
    var timer_quantityless_thanprevious = Timer()  ///#selector(FuelquantityVC.stoprelay) to stop the app
    
    var y :CGFloat = CGFloat()
    
    var fuelquantity:Double!
   
    
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
    var countfailUDPConn:Int = 0
    var countfromlink = 0
    
    //    UDP
    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host = "192.168.4.1"
    var portUDP: NWEndpoint.Port = 8080
   
    var backToString = ""
    var pulsedata = ""
    var IFUDPConnectedGetinfo = false
    var IFUDPSendtxtid = false
    var IFUDPConnected = false
    var Last10transaction = ""
//    var sysdata:NSDictionary!
    let kBLEService_UUID = "4c425346-0000-1000-8000-00805f9b34fb"
    
    let kBLE_Characteristic_uuid_Tx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    
    let kBLE_Characteristic_uuid_Rx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
    
    var txCharacteristic : CBCharacteristic?
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
    var ifSubscribed = false
    var isdisconnected = false
    var FDcheckBLEtimer:Timer = Timer()
    var Count_Fdcheck = 0
    var countwififailConn:Int = 0
    var isDisconnect_Peripheral = false
    var onFuelingScreen = false
    var IsStopbuttontappedBLE:Bool = false
    var isviewdidDisappear = false
    var appdisconnects_automatically = false
    var AppconnectedtoBLE = true
    var sendrename_linkname = false
    var appconnecttoUDP = false
//    var Last10transaction = ""
    var iflinkison = false
//    var Last_Count:String!
//    var Samecount:String!
//    var counts:String!
//    var quantity = [String]()
//    var total_count:Int = 0
//    var fuelquantity:Double!
    var ifstartbuttontapped = false
    var connectedperipheral = ""
  
    var countfailBLEConn:Int = 0
  
    
    @IBOutlet weak var OKButton: WKInterfaceButton!
    @IBOutlet weak var stopbutton: WKInterfaceButton!
    @IBOutlet weak var TPulse: WKInterfaceLabel!
    @IBOutlet weak var GObutton: WKInterfaceButton!
    @IBOutlet weak var startbutton: WKInterfaceButton!
    @IBOutlet weak var labelres: WKInterfaceLabel!
   
    @IBOutlet weak var causionmessage: WKInterfaceLabel!
    @IBOutlet weak var TQuantity: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        OKButton.setHidden(true)
        setTitle("\(Vehicaldetails.sharedInstance.SSId)")
        startbutton.setHidden(true)
        stopbutton.setHidden(true)
        onFuelingScreen = true
//        let checkaprovedata = checkApprove(uuid: "6F90251E-71F2-449D-A721-31C1D1669E24" as String,lat:"\(18.479963)",long:"\(73.821659)")
////        var info = Getinfo()
//        print(checkaprovedata)
//        if(info == "false")
//        {
//             info = Getinfo()
//        }
//        self.connectToUDP(self.hostUDP,self.portUDP)
//        if( ifSubscribed == false){
        
        if(self.appdisconnects_automatically == true)
        {
            //ConnecttoBLE()
            if(self.AppconnectedtoBLE == true)
            {
                //self.getlast10transaction()
                self.BLErescount = 0
                self.web.sentlog(func_name: "Send Relay On Command to BT link LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                self.updateIncomingData ()
                
                startbutton.setHidden(true)
                stopbutton.setHidden(false)
                //self.cf.delay(0.1){
//                    self.start.isHidden = true
//                    self.cancel.isHidden = true
//                    self.Stop.isHidden = false
//                    self.displaytime.text = NSLocalizedString("Fueling", comment:"")
                    //self.displaytime.textColor = UIColor.black
//                    self.FDcheckBLEtimer.invalidate()
//                    self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
//                }
            }
        }
        
        else{
        
        if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
        {
            self.cancelScan()
            if(Vehicaldetails.sharedInstance.peripherals.count == 0){
                centralManager = CBCentralManager(delegate: self, queue: nil)
//                    cf.delay(0.1){
//                        self.viewDidAppear(true)
//                    }
            }
            else
            {
                //self.cancelScan()
            }
        }
        else{
        centralManager = CBCentralManager(delegate: self, queue: nil)
        }
        // Configure interface objects here.
        }
    }
    
    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        print("WillActivate function called")
        
    }
    
    override func didDeactivate()
    {
        print("didDeactivate function called")
        // This method is called when watch view controller is no longer visible
    }
    
    let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.default)
    {
            print("Ok")
    }
    
    @IBAction func Startbuttontapped()
    {

        causionmessage.setHidden(false)
        stopbutton.setHidden(false)
        OKButton.setHidden(true)
        
//        UIApplication.shared.isIdleTimerDisabled = true
        labelres.setText("Start button Tapped. \n Fueling ....")
        web.sentlog(func_name: "Start Button tapped", errorfromserverorlink: "", errorfromapp: "")
        self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
        self.updateIncomingData ()
        self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
        startbutton.setHidden(true)
//        //startbutton.setTitle("Stop")
//        startbutton.setEnabled(false)
//        ifstartbuttontapped = true
//        if (ifstartbuttontapped == true)
//        {
//            stopButtontapped()
//            ifstartbuttontapped = false
//            startbutton.setTitle("Start")
//
//        }
//        let messageToUDP = "LK_COMM=relay:12345=ON"
//
//        sendUDP(messageToUDP)
//        self.receiveUDP()
    }
    
    @IBAction func stopButtontapped() {
        labelres.setText("Stop Button Tapped")
        stop_Buttontapped()
        FDcheckBLEtimer.invalidate()
        
        //stop()
//        let MessageuDP = "LK_COMM=relay:12345=OFF"
//            self.sendUDP(MessageuDP)
//
//            self.receiveUDP()
        causionmessage.setHidden(true)
        labelres.setHidden(false)
        GObutton.setHidden(true)
        OKButton.setHidden(false)
        startbutton.setHidden(true)
        stopbutton.setHidden(true)
        sleep(10)
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
    func stop_Buttontapped()
    {
        web.sentlog(func_name: "Stop Button tapped", errorfromserverorlink: "", errorfromapp: "")
            self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
            self.updateIncomingData()
        self.IsStopbuttontappedBLE = true
//        UIApplication.shared.isIdleTimerDisabled = false
    }
    

        
   
    @IBAction func Gobuttontapped() {
      
        labelres.setText("Sendinfo command")
        outgoingData(inputText: "LK_COMM=info")
        self.updateIncomingData ()
        GObutton.setHidden(true)
        stopbutton.setHidden(true)
        sleep(1)
        labelres.setText("Please insert the nozzle into the tank \n Then tap start.")
      
    }

    @IBAction func OKButtontapped() {
        WKInterfaceController.reloadRootPageControllers(withNames: ["Hose"], contexts: ["Hose"], orientation: WKPageOrientation.horizontal, pageIndex: 0)
        //web.sentlogFile()
        stopbutton.setHidden(true)
    }
    
    func calculate_fuelquantity(quantitycount: Int)-> Double
    {
        if(quantitycount == 0)
        {
            fuelquantity = 0
        }
        else{
            //Vehicaldetails.sharedInstance.pulsarCount = "\(quantitycount)"
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            fuelquantity = (Double(quantitycount))/(PulseRatio as NSString).doubleValue
        }
        return fuelquantity
    }

    
    
    
//  MARK: -//BLE
    
    func Stopconnection()
    {
        FDcheckBLEtimer.invalidate()
        //self.web.sentlog(func_name: " Stop button tapped BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
        
        self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
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
//            Stop.isEnabled = false
//            Stop.isHidden = true
//            wait.isHidden = false
//            waitactivity.isHidden = false
            FDcheckBLEtimer.invalidate()
        }
        //self.disconnectFromDevice()
//        isgotostartcalled = true
        self.timerview.invalidate()
        //stoprealy()  //we should add the stoprelay function if we get some quantity and the get the DN response from link//
        self.FDcheckBLEtimer.invalidate()
//        let appDel = UIApplication.shared.delegate! as! AppDelegate
//        appDel.start()
    }
    
    
    @objc func gotostartBLE()
    {
        self.web.sentlog(func_name: " BLE Auto stops response of FD check is empty", errorfromserverorlink:"", errorfromapp: "")
        if(AppconnectedtoBLE == true ){
            outgoingData(inputText: "LK_COMM=relay:12345=OFF")
           
            updateIncomingData ()
            self.IsStopbuttontappedBLE = true
//            Stop.isEnabled = false
//            Stop.isHidden = true
//            wait.isHidden = false
//            waitactivity.isHidden = false
            FDcheckBLEtimer.invalidate()
        }
        self.disconnectFromDevice()
//        isgotostartcalled = true
        self.timerview.invalidate()
    }
    
    
    @objc func FDcheckBLE()
    {
        var lastcount = ""
        if(Last_Count == nil){
            self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
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
            
            self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
            self.outgoingData(inputText: "LK_COMM=FD_check")
        }else{
        if (Int(lastcount)! >= 0){
        
            self.web.sentlog(func_name: " BLE sendFD check command to link", errorfromserverorlink:"", errorfromapp: "")
            self.outgoingData(inputText: "LK_COMM=FD_check")
           
            //self.AppconnectedtoBLE = true
           
        }
        else
        {
            if(iflinkison == false){
//                delay(0.2){
                    self.web.sentlog(func_name: "Send Relay On Command to BT link again from FD check function because we not receive quantity in first attempt. LK_COMM=relay:12345=ON" , errorfromserverorlink: "", errorfromapp: "")
                    self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
                    self.updateIncomingData()
                }
//            }
        }}
    }
    
    
//  func GetPulserBLE(counts:String) {
//        //counts = "0"
//
//        let dateFormatter = DateFormatter()
////        Warning.text = NSLocalizedString("Warningfueling", comment:"")
////        Warning.isHidden = false
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//        let defaultTimeZoneStr = dateFormatter.string(from: Date());
//
//        print("before GetPulser" + defaultTimeZoneStr)
//
//        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//        print("before send GetPulser" + defaultTimeZoneStr1)
//
//        print(characteristicASCIIValue)
//
//        if(self.counts == " 0" || self.counts == "0")
//        {
//
//        }
//        else{
//            if (counts == ""){
//                self.emptypulsar_count += 1
//                if(self.emptypulsar_count == 3){
//                    Vehicaldetails.sharedInstance.gohome = true
//                    self.timerview.invalidate()
//                    do
//                    {
//                        try self.stoprelay()
//                    }
//                    catch{}
//                    FDcheckBLEtimer.invalidate()
////                    let appDel = ExtensionDelegate.shared.delegate! as! AppDelegate
//                   // self.web.sentlog(func_name: "get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
////                    appDel.start()
//                    FDcheckBLEtimer.invalidate()
//                }
//            }
//            else if (counts == "0")
//            {
//                if(Last_Count == nil){
//                    Last_Count = "0.0"
//                }
//                let v = self.quantity.count
//                self.quantity.append("0")
//                if(v >= 2){
//                    print(self.quantity[v-1],self.quantity[v-2],total_count)
//                    if(self.quantity[v-1] == self.quantity[v-2]){
//                        self.total_count += 1
//                        if(self.total_count == 3){
//                            Ispulsarcountsame = true
//                            stoptimerIspulsarcountsame.invalidate()
//                            Samecount = Last_Count
//
//                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(InterfaceController.stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time)" , errorfromserverorlink: "", errorfromapp: "")
//                        }
//                    }
//                }
//            }
//            else
//            {
//                self.emptypulsar_count = 0
//                if (counts != "0"){
////                    Reconnect.isHidden = true
////                    self.start.isHidden = true
////                    self.cancel.isHidden = true
//                    // stoptimerIspulsarcountsame.invalidate()
//                    //transaction Status send only one time.
//                    let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                    if(reply_server == "")
//                    {
//                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
//                        reply_server = "Sendtransaction"
//                    }
//                    print(self.TPulse.text!, counts)
//
//                    if (self.TPulse.text! == (counts as String) as String){
//
//                    }
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//                    if(appdisconnects_automatically == true){
//
//                            if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
//                                Ispulsarcountsame = false
//                                stoptimerIspulsarcountsame.invalidate()
//                            }
//                        print(Last_Count)
//                        var pulsedata = defaults.string(forKey: "previouspulsedata")
//                        if(pulsedata == ""){}
//                        else{
//                        let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
//                        print(Last_Count,totalpulsecount,counts,pulsedata)
//                        if(totalpulsecount < Int(Last_Count as String)!)
//                        {
//                            defaults.setValue(Last_Count, forKey: "previouspulsedata")
//                            print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
//                            pulsedata = Last_Count
//////
//                        }else{
//
////                        if((counts as NSString).doubleValue > (pulsedata! as NSString).doubleValue)
////                        {
////                            print(Last_Count,totalpulsecount,counts,pulsedata)
////                            pulsedata = Last_Count
////                            self.tpulse.text = "\(counts)"
////                            self.quantity.append("\(y) ")
////                                timer_quantityless_thanprevious.invalidate()
////
////                                //self.Last_Count = "\(counts)" as String?
////                                let v = self.quantity.count
////                            let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts)!)
////                                let y = Double(round(100*FuelQuan)/100)
////                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
////                                    let y = Double(round(100*FuelQuan)/100)
////                                    self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
////                                    print(self.tquantity.text!,Last_Count)
////                                }
////                                else {
////                                    let y = Double(round(100*FuelQuan)/100)
////                                    self.tquantity.text = "\(y) "
////                                }
////
////                                    self.Last_Count = "\(counts)"
////    //                                let v = self.quantity.count
////    //                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
////    //                                let y = Double(round(100*FuelQuan)/100)
////                                    if(Vehicaldetails.sharedInstance.Language == "es-ES"){
////                                        let y = Double(round(100*FuelQuan)/100)
////                                        self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
////                                        print(self.tquantity.text!)
////                                    }
////                                    else {
////                                        let y = Double(round(100*FuelQuan)/100)
////                                        self.tquantity.text = "\(y) "
////                                    }
////                                    self.tpulse.text = "\(counts)"
////                                    self.quantity.append("\(y) ")
////
////
////                                print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
////                                let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////                                print("Inside loop GetPulser" + defaultTimeZoneStr1)
////                                if(v >= 2){
////                                    print(self.quantity[v-1],self.quantity[v-2])
////                                    if(self.quantity[v-1] == self.quantity[v-2]){
////                                        self.total_count += 1
////                                        if(self.total_count == 3){
////                                            Ispulsarcountsame = true
////                                            stoptimerIspulsarcountsame.invalidate()
////                                            Samecount = Last_Count
////                                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
////
////                                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
////                                        }
////                                    }
////                                    else
////                                    {
////                                        total_count = 0
////                                        if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
////                                        else{
////
////                                            if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
////
////                                                _ = self.web.SetPulser0()
////                                                print(Vehicaldetails.sharedInstance.MinLimit)
////                                                if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
////                                                self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
////                                                }
////                                                //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
////                                                self.stopButtontapped()
////                                            }
////                                        }
////                                    }
////                                }
////                        }
////                        else{
//
//
//                        let totalpulsecount = Int(pulsedata! as String)! + Int(counts as String)!
//                            if(totalpulsecount < Int(Last_Count as String)!)
//                             {
//                                defaults.setValue(Last_Count, forKey: "previouspulsedata")
//                                 print("pulsedata:\( pulsedata!),Counts: \(counts),LastCount: \( Last_Count)")
//                                 pulsedata = Last_Count
//                            //
//                            }else{
//                        self.tpulse.text = "\(totalpulsecount)"
//                        //self.quantity.append("\(y) ")
//                            timer_quantityless_thanprevious.invalidate()
//
//                            self.Last_Count = "\(totalpulsecount)" as String?
//                            let v = self.quantity.count
//                            let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(totalpulsecount))
//                            let y = Double(round(100*FuelQuan)/100)
//                            if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                                let y = Double(round(100*FuelQuan)/100)
//                                self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                                print(self.tquantity.text!)
//                            }
//                            else {
//                                let y = Double(round(100*FuelQuan)/100)
//                                self.tquantity.text = "\(y) "
//                            }
//
//                                self.Last_Count = "\(totalpulsecount)"
////                                let v = self.quantity.count
////                                let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
////                                let y = Double(round(100*FuelQuan)/100)
//                                if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                                    let y = Double(round(100*FuelQuan)/100)
//                                    self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                                    print(self.tquantity.text!)
//                                }
//                                else {
//                                    let y = Double(round(100*FuelQuan)/100)
//                                    self.tquantity.text = "\(y) "
//                                }
//                                self.tpulse.text = "\(totalpulsecount)"
//                                self.quantity.append("\(y) ")
//
//
//                            print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time,quantity)
//                            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                            print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                            if(v >= 2){
//                                print(self.quantity[v-1],self.quantity[v-2])
//                                if(self.quantity[v-1] == self.quantity[v-2]){
//                                    self.total_count += 1
//                                    if(self.total_count == 3){
//                                        Ispulsarcountsame = true
//                                        stoptimerIspulsarcountsame.invalidate()
//                                        Samecount = Last_Count
//                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                                        self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                    }
//                                }
//                                else
//                                {
//                                    total_count = 0
//                                    if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
//                                    else{
//
//                                        if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
//
//                                            _ = self.web.SetPulser0()
//                                            print(Vehicaldetails.sharedInstance.MinLimit)
//                                            if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
//                                            self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
//                                            }
//                                            //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
//                                            self.stopButtontapped()
//                                        }
//                                    }
//                                }
//                            }
////                            }
//
//                        }
//                        }
//                        }
//                    }
//                    else{
//
//                    if((counts as NSString).doubleValue >= (Last_Count as NSString).doubleValue)
//                    {
//                        if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
//                            Ispulsarcountsame = false
//                            stoptimerIspulsarcountsame.invalidate()
//                        }
//                        timer_quantityless_thanprevious.invalidate()
//                        self.Last_Count = counts as String?
//                        let v = self.quantity.count
//                        let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                        let y = Double(round(100*FuelQuan)/100)
//                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                            let y = Double(round(100*FuelQuan)/100)
//                            self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                            print(self.tquantity.text!)
//                        }
//                        else {
//                            let y = Double(round(100*FuelQuan)/100)
//                            self.tquantity.text = "\(y) "
//                        }
//
//                            self.tpulse.text = (counts as String) as String
//                            self.quantity.append("\(y) ")
//                        defaults.set(Last_Count, forKey: "previouspulsedata")
//
//                        print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                        print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                        if(v >= 2){
//                            print(self.quantity[v-1],self.quantity[v-2])
//                            if(self.quantity[v-1] == self.quantity[v-2]){
//                                self.total_count += 1
//                                if(self.total_count == 3){
//                                    Ispulsarcountsame = true
//                                    stoptimerIspulsarcountsame.invalidate()
//                                    Samecount = Last_Count
//                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                                    self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                }
//                            }
//                            else
//                            {
//                                total_count = 0
//                                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
//                                else{
//
//                                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
//
//                                        _ = self.web.SetPulser0()
//                                        print(Vehicaldetails.sharedInstance.MinLimit)
//                                        if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
//                                        self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
//                                        }
//                                        //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
//                                        self.stopButtontapped()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        timer_quantityless_thanprevious.invalidate()
//                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
//                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
//                        print("lower qty. than the prior one.")
//                    }
//                }
//                }
//                else{
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//                    let v = self.quantity.count
//                    let FuelQuan = self.cf.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                    let y = Double(round(100*FuelQuan)/100)
//
//                    self.quantity.append("\(y) ")
//
//                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                    if(v >= 2){
//                        if(self.self.quantity[v-1] == self.quantity[v-2]){
//                            self.total_count += 1
//                            if(self.total_count == 3){
//                                Ispulsarcountsame = true
//                                Samecount = Last_Count
//                                stoptimerIspulsarcountsame.invalidate()
//
//                                self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//
//                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    

//    @objc func FDcheckBLE()
//    {
//        var lastcount = ""
//        if(Last_Count == nil){
//
//            self.outgoingData(inputText: "LK_COMM=FD_check")
//            Last_Count = "0"
//
//        }
//        else
//        if(Last_Count == "0.0")
//        {
//            lastcount = Last_Count
//            lastcount = "0"
//        }else
//
//        {
//            lastcount = Last_Count
//        }
//
//        if(lastcount == "")
//        {
//            lastcount = Last_Count
//            lastcount = "0"
//        }
//
//        print(lastcount)
//        if (Int(lastcount)! > 0){
//
//
//            self.outgoingData(inputText: "LK_COMM=FD_check")
//            //self.AppconnectedtoBLE = true
//        }
//        else
//        {
//            if(iflinkison == false){
//
//
//                    self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
//                    self.updateIncomingData()
//
//            }
//        }
//    }
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
                }
                //print(Last_Count,Samecount)
                if(Samecount == Last_Count){
                    
                    self.timer.invalidate()
                    self.web.sentlog(func_name: "Stoprelay stopIspulsarcountsame", errorfromserverorlink: "", errorfromapp:"")
                    if(AppconnectedtoBLE == true ){
                 
                
                        self.IsStopbuttontappedBLE = true
                       
                        self.web.sentlog(func_name: " Stop relay pulsarcount is same BLE Relay OFF command to link", errorfromserverorlink:"", errorfromapp: "")
                        self.outgoingData(inputText: "LK_COMM=relay:12345=OFF")
                        self.updateIncomingData()
                        sleep(10)
                        do{
                            if(self.isDisconnect_Peripheral == true ){
                                try self.stoprelay()
                                
                            }
                        }
                        
                        catch let error as NSError {
                            print ("Error: \(error.domain)")
                        }
                        
                        self.FDcheckBLEtimer.invalidate()
                    }
                  
                   // self.displaytime.text = NSLocalizedString("autostop", comment:"")//"app autostop because pulsecount getting is same."
                    //self.Stop.isHidden = true
                }
            }
        }
    }



    func startScan()
    {
        print(countfromlink)
        //            if(countfromlink > 0)
        //            {}
        //            else{
        self.web.sentlog(func_name: "Start BT Scan...for \(kBLEService_UUID)", errorfromserverorlink:"", errorfromapp: "\(peripherals)")
        self.peripherals = []
        let BLEService_UUID = CBUUID(string: kBLEService_UUID)
        print("Now Scanning...")
        //self.GetPulsarstartimer.invalidate()
        centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        
        Timer.scheduledTimer(withTimeInterval: 8, repeats: false) {_ in
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
//    {
//
//        self.peripherals = []
//        let BLEService_UUID = CBUUID(string: kBLEService_UUID)
//        if(countfailBLEConn >= 1){}
//        else{
//        labelres.setText("Please wait... Scanning ")
//        }
//        print("Now Scanning...")
//
//        centralManager.scanForPeripherals(withServices: [BLEService_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: true as Bool)])
//
//        Timer.scheduledTimer(withTimeInterval: 17, repeats: false) {_ in
//
//            self.cancelScan()
//
//        }
//    }
//
//    /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
    func cancelScan()
    {
        self.centralManager?.stopScan()
  
        self.web.sentlog(func_name: "Scan Stopped", errorfromserverorlink: "Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(peripherals)")
        Vehicaldetails.sharedInstance.peripherals = self.peripherals
        if (peripherals.count == 0){
            if(IsStartbuttontapped == true){}
            else{
                self.countfailBLEConn = self.countfailBLEConn + 1
                if (self.countfailBLEConn > 3){
                    
                    self.web.sentlog(func_name: "App Not able to Connect and Subscribed peripheral Connection. Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
//                    Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
//                    self.performSegue(withIdentifier: "GoUDP", sender: self)
//                    appconnecttoUDP = true
               
                }
                else{
                    if(ifSubscribed == true){}
                    else{
                        self.web.sentlog(func_name: "Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
                        self.startScan()
//                        if(onFuelingScreen == true){
//                            if(peripherals.count == 0)
//                            {
//
//                            }
//                            else
//                            {
//                                viewDidAppear(true)
//                            }
//                    }
                    }
                }
                if(self.ifSubscribed == true)
                {
                    
                }
                                    else{
                                        labelres.setText("Please wait... Scanning ")
                                        //labelres.setText("BT link not found. please try again later.")
                                        self.startScan()
                                    }
//                displaytime.text = "BT link not found. please try again later."
                Vehicaldetails.sharedInstance.peripherals = self.peripherals
                // AppconnectedtoBLE = false
//                cancel.isHidden = false
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
                      
                        if( Vehicaldetails.sharedInstance.SSId == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines))
                        {
                            blePeripheral = self.peripherals[i]
                            connectedperipheral = (blePeripheral?.name)!
                            connectToDevice()
                            
                            break
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
                           // self.performSegue(withIdentifier: "GoUDP", sender: self)
                       
                        }
                        else{
                            if(ifSubscribed == true){}
                            else{
                                self.web.sentlog(func_name: "Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
                                self.startScan()
                            }
                        }
                    }
                }
                //self.viewDidAppear(true)
            }
        }
    }
//    {
//        self.centralManager?.stopScan()
//
//        self.web.sentlog(func_name: "Scan Stopped", errorfromserverorlink: "Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(peripherals)")
//        if (peripherals.count == 0){
//            if(IsStartbuttontapped == true){}
//            else{
////                self.countfailBLEConn = self.countfailBLEConn + 1
////                if (self.countfailBLEConn == 3){
////
////                    //self.web.sentlog(func_name: "App Not able to Connect and Subscribed peripheral Connection. Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
////                    Vehicaldetails.sharedInstance.HubLinkCommunication = "UDP"
////                   // self.performSegue(withIdentifier: "GoUDP", sender: self)
////
////                }
////                else{
//                    if(self.ifSubscribed == true){}
//                    else{
//                        self.web.sentlog(func_name: "Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
//                        self.startScan()
//                    }
////                }
//                labelres.setText( "BT link not found. please try again later.")
//                causionmessage.setHidden(true)
//                OKButton.setHidden(false)
//                // AppconnectedtoBLE = false
//                //cancel.isHidden = false
//            }
//        }
//        else
//        {
//            if(peripherals.count == 0)
//            {
//                print(peripherals,peripherals.count)
//            }
//            else{
//                print(peripherals,peripherals.count)
//                for i in 0  ..< peripherals.count
//                {
//                    print(peripherals,peripherals.count)
//                    if(peripherals.count == 0)
//                    {
//                        print(peripherals,peripherals.count)
//                    }
//                    else{
//                        let peripheral = self.peripherals[i]
//
//                        if( Vehicaldetails.sharedInstance.SSId == peripheral.name!.trimmingCharacters(in: .whitespacesAndNewlines))
//                        {
//                            blePeripheral = self.peripherals[i]
//                            connectedperipheral = (blePeripheral?.name)!
//                            connectToDevice()
//
//                            break
//                        }
//                    }
//                }
//                if(self.connectedperipheral == "")
//                {
//                    labelres.setText( "BT link not found. please try again later.")
//                    causionmessage.setHidden(true)
//                    OKButton.setHidden(false)
//
//                    if(IsStartbuttontapped == true){}
//                    else{
//                        self.countfailBLEConn = self.countfailBLEConn + 1
//
//                        //self.web.sentlog(func_name: "Attempt \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
//
//                        if (self.countfailBLEConn == 5){
//
//                           // self.web.sentlog(func_name: "App Not able to Connect BT Link and Subscribed peripheral Connection. Attempt  \(countfailBLEConn)", errorfromserverorlink: "", errorfromapp: "")
//
//                           // self.web.sentlog(func_name: "App Switches BT to UDP...", errorfromserverorlink: "", errorfromapp: "")
//                          //  self.performSegue(withIdentifier: "GoUDP", sender: self)
//
//                        }
//                        else{
//                            if(self.ifSubscribed == true){}
//                            else{
//                               // self.web.sentlog(func_name: "Peripherals Found restart Scan...", errorfromserverorlink:"Number of Peripherals Found: \(peripherals.count)", errorfromapp: "\(self.peripherals)")
//                                self.startScan()
//                            }
//                        }
//                    }
//                }
//                //self.viewDidAppear(true)
//            }
//        }
//    }
//    {
//        self.centralManager?.stopScan()
//
//
//        if (peripherals.count == 0){
//
//
//                }
//                else{
//                    if(self.ifSubscribed == true){}
//                    else{
//                        labelres.setText("BT link not found. please try again later.")
//                        self.startScan()
//                    }
//                }
//        //labelres.setText( "BT link not found. please try again later.")
//                // AppconnectedtoBLE = false
//
//
//
//
//
//                for i in 0  ..< peripherals.count
//                {
//                    print(peripherals,peripherals.count)
//                    if(peripherals.count == 0)
//                    {
//                        print(peripherals,peripherals.count)
//                    }
//                    else{
//                        _ = self.peripherals[i]
//
//
//                            blePeripheral = self.peripherals[i]
//
//                            connectToDevice()
//
//                            break
//                        }
//                    }
//
//
//    }

//
//    //-Terminate all Peripheral Connection
//    /*
//     Call this when things either go wrong, or you're done with the connection.
//     This cancels any subscriptions if there are any, or straight disconnects if not.
//     (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
//     */
    func disconnectFromDevice() {
        if blePeripheral != nil {
            self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic!),\(blePeripheral!)", errorfromserverorlink: "", errorfromapp:"")
            // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
            // Therefore, we will just disconnect from the peripheral
            // print(rxCharacteristic!)
            if(rxCharacteristic == nil){}
            else{
                blePeripheral!.setNotifyValue(false, for: rxCharacteristic!)

            }

            centralManager.cancelPeripheralConnection(blePeripheral!)
            centralManager.cancelPeripheralConnection(blePeripheral!)
            do{
                try self.stoprelay()
                isdisconnected = true
            }
            catch let error as NSError {
                print ("Error: \(error.domain)")
            }
        }
    }
    
    @objc func stoprelay() throws  {
        if(Last_Count == nil){
            Last_Count = "0.0"
        }

        FDcheckBLEtimer.invalidate()
        //check here if it is connected to BLE or Link.
        
        if(self.ifSubscribed == true){}
        
        self.stoptimerIspulsarcountsame.invalidate()
        self.timerview.invalidate()
        self.timer.invalidate()
       // stop .isHidden = true
        //timer_noConnection_withlink.invalidate()
        timer_quantityless_thanprevious.invalidate()
        stoptimergotostart.invalidate()
        stoptimer_gotostart.invalidate()
        
       
        print(Vehicaldetails.sharedInstance.SSId)
        print(Vehicaldetails.sharedInstance.IsHoseNameReplaced)
        pushController(withName: "go", context: nil)
//        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N")
//        {
//            let trimmedString = Vehicaldetails.sharedInstance.ReplaceableHoseName.trimmingCharacters(in: .whitespacesAndNewlines)
//            tcpcon.changessidname(wifissid: trimmedString)
//        }
//        if(self.InterruptedTransactionFlag == true)
//        {
//            self.web.UpdateInterruptedTransactionFlag() /// 1168 if relay off is not working then app sends to server Transaction id.
//        }
        
//        if(Vehicaldetails.sharedInstance.IsHoseNameReplaced == "N"){
//            _ = self.web.SetHoseNameReplacedFlag()
//        }
//        if(Vehicaldetails.sharedInstance.PulseRatio == "" || Vehicaldetails.sharedInstance.pulsarCount == "" ){
//            //self.web.sentlog(func_name: " PulsarCount,PulseRatio is null or nil" , errorfromserverorlink: self.cf.getSSID(), errorfromapp:"\(Vehicaldetails.sharedInstance.SSId)" )
//
////            let appDel = UIApplication.shared.delegate! as! AppDelegate
////            appDel.start()
////            self.stoptimerIspulsarcountsame.invalidate()
////            self.timerview.invalidate()
////            self.timer.invalidate()
////            timer_quantityless_thanprevious.invalidate()
////            stoptimergotostart.invalidate()
////            stoptimer_gotostart.invalidate()
//            self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
//        } else{
            let quantitycount = self.Last_Count! //Vehicaldetails.sharedInstance.pulsarCount
            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
            self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
            
//            if( Vehicaldetails.sharedInstance.SSId == SSID)
//            {
//                SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
//            }
//            else {
                SenddataTransaction(quantitycount:quantitycount,PulseRatio:PulseRatio)
//            }
//        }
    }
    
    
    func SenddataTransaction(quantitycount:String,PulseRatio:String){
            // takes a Double value for the delay in seconds
            // put the delayed action/function here
            
//            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y"){
//                self.web.sentlog(func_name: " StopButtonTapped Start Upgrade Function", errorfromserverorlink: "", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                self.tcpcon.getuser()
//            }else{}
//            self.cf.delay(1){
                self.fuelquantity = (Double(quantitycount))!/(PulseRatio as NSString).doubleValue
                if(self.fuelquantity == nil){
                    
                    self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                }
                else{
                    print(self.fuelquantity!)
                    if(self.fuelquantity > 0){
                        
                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
                            self.TQuantity.setText("\(String(format: "%.2f", self.fuelquantity))".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil))
                        }
                        else {
                            TQuantity.setText( "Quantity : \(String(format: "%.2f", self.fuelquantity))")
                        }
                        
                        self.TPulse.setText( "Pulse : \(self.Last_Count!)")
                        // print(self.Last_Count)
                        self.labelres.setText( NSLocalizedString("Thank you for using \nFluidSecure.", comment:""))//"Thank you for using \nFluidSecure!"
                        stopbutton.setHidden(true)
//                        self.cf.delay(0.5){
                        self.Transaction(fuelQuantity: self.fuelquantity)
                        OKButton.setHidden(false)
//                            self.tcpcon.setdefault()
//
//                            if(Vehicaldetails.sharedInstance.HubLinkCommunication == "BT")
//                            {
//                            }
//                            else {
//                                // let replytld = self.tcpcon.tlddata()
//                                //                            if(Vehicaldetails.sharedInstance.IsTLDdata == "True")
//                                //                            {
//                                //                                let replytld = self.web.tldlevel()
//                                //                                if(replytld == "" || replytld == "nil"){}
//                                //                                else{
//                                //                                    self.tcpcon.sendtld(replytld: replytld)
//                                //                                }
//                                //                            }
//                            }
//                            self.wait.isHidden = true
//                            self.waitactivity.isHidden = true
//                            self.waitactivity.stopAnimating()
//                            self.UsageInfoview.isHidden = false
//                            self.Warning.isHidden = true
//                        }
//                        self.cf.delay(10){
//                            if(Vehicaldetails.sharedInstance.IsUpgrade == "Y")
//                            {
//                                _ = self.tcpcon.Getinfo()//self.web.getinfo()
//                                if(Vehicaldetails.sharedInstance.IsFirmwareUpdate == false) {
//                                    _ = self.web.UpgradeCurrentVersiontoserver()
//                                }
//                                Vehicaldetails.sharedInstance.IsUpgrade = "N"
//
//                                self.cf.delay(30){
//                                    Vehicaldetails.sharedInstance.gohome = true
//                                    self.timerview.invalidate()
//                                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                    self.web.sentlog(func_name: "stoprelay function 30 delay ", errorfromserverorlink: "", errorfromapp: "")
//                                    appDel.start()
//                                }
//                            }
//                            if (self.stopdelaytime == true){}
//                            else{
//                                Vehicaldetails.sharedInstance.gohome = true
//                                self.timerview.invalidate()
//                                let appDel = UIApplication.shared.delegate! as! AppDelegate
//                                self.web.sentlog(func_name: "stoprelay function ", errorfromserverorlink: "", errorfromapp: "")
//                                appDel.start()
//                            }
//                            self.wait.isHidden = true
//                            self.waitactivity.isHidden = true
//                            self.waitactivity.stopAnimating()
//                            self.UsageInfoview.isHidden = false
//                            self.Warning.isHidden = true
//                        }
                    }
                    else
                    {
                        self.error400(message: NSLocalizedString("NoQuantity", comment:""))//"No Quantity received. Transaction ended.")
                    }
                }
//            }
      
    }
    
    func error400(message: String)
    {
        self.timerview.invalidate()
        
        //        if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
        //        {
        if(Last_Count == "0.0" || Last_Count == nil){
            let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
            UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "6") //unable to start (start never appeared): Potential Wifi Connection Issue
         
        }
        
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
        let bodyData = "{\"TransactionId\":\(TransactionId),\"FuelQuantity\":\((fuelQuantity)),\"Pulses\":\(pusercount),\"TransactionFrom\":\"I\",\"versionno\":\"1\",\"Device Type\":\"Apple Watch\",\"iOS\": \"7\",\"Transaction\":\"Current_Transaction\"}"
        
        let reply = web.Transaction_details(bodyData: bodyData)
        if (reply == "-1")
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyyhhmmss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let dtt1: String = dateFormatter.string(from: NSDate() as Date)
            
            let unsycnfileName =  dtt1 + "#" + "\(TransactionId)" + "#" + "\(fuelQuantity)" + "#" + Vehicaldetails.sharedInstance.SSId //
            if(bodyData != ""){
                //cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
                self.characteristicASCIIValue = ""
                
                self.web.sentlog(func_name: " Saved Current Transaction to Phone, Date\(dtt1) TransactionId:\(TransactionId),FuelQuantity:\((fuelQuantity)),Pulses:\(pusercount)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
            }
        }
        else{
           // Warning.isHidden = true
            let data1:NSData = reply.data(using: String.Encoding.utf8)! as NSData
            do{
                sysdata = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            }catch let error as NSError {
                print ("Error: \(error.domain)")
            }
              print(sysdata)
           // self.notify(site: Vehicaldetails.sharedInstance.SSId)
        }
    }
  
    func UpgradeTransactionStatus(Transaction_id:String,Status:String)
    {
       var FSURL = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"

        let TransactionId = Vehicaldetails.sharedInstance.TransactionId
        if(TransactionId == 0){}
        else{

            let Url:String = FSURL
            let Email = defaults.string(forKey: "address")
            let uuid = defaults.string(forKey: "uuid")
            let string = uuid! + ":" + Email! + ":" + "UpgradeTransactionStatus"
            let Base64 = convertStringToBase64(string)
            let request: NSMutableURLRequest = NSMutableURLRequest(url:Foundation.URL(string: Url)!)
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
//                    self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
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
                               // self.cf.SaveTransactionstatus(fileName: unsycnfileName, writeText: jsonstring)
                            }

                        }
                        let text = (error?.localizedDescription)! //+ error.debugDescription
                        let test = String((text.filter { !" \n".contains($0) }))
                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                        //  print(newString)
                       // self.sentlog(func_name: "UpgradeTransactionStatus UpgradeTransactionStatus Service Function", errorfromserverorlink: " Response from Server $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                    }
                }
            }
            task.resume()
        }
    }
    
    func convertStringToBase64(_ string: String) -> String
    {
        let plainData = string.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func checkApprove(uuid:String,lat:String!,long:String!)->String {
//        if(Vehicaldetails.sharedInstance.Language == ""){
//            ///Vehicaldetails.sharedInstance.Language = "en-ES"
//        }
        defaults.set("", forKey: "address")
        let Url:String = Vehicaldetails.sharedInstance.URL + "HandlerTrak.ashx"
        var Email :String
        if(defaults.string(forKey: "address") == nil){
            Email = ""
        }else {
            Email = defaults.string(forKey: "address")!
        }
        let string = uuid + ":" + Email + ":" + "Other" + ":" + "es-ES"
        let Base64 = convertStringToBase64(string)
        print(Base64)
        //self.sentlog(func_name: "checkApprove command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
        //request.timeoutInterval = 10
        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
        // print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        var TransactionId = 0;
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if let data = data {
               // print(String(data: data, encoding: String.Encoding.utf8)!)
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
                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "")
                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                
            } else {
                print(error!)
                let text = (error?.localizedDescription)! //+ error.debugDescription
                let test = String((text.filter { !" \n".contains($0) }))
                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
                //print(newString)
               // self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
                self.reply = "-1"
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return reply
    }
//
//    //Peripheral Connections: Connecting, Connected, Disconnected
//
//    //-Connection
    func connectToDevice() {

        if(blePeripheral == nil)
        {}
        else{
            print("connectToDevice")
            centralManager?.connect(blePeripheral!, options: nil)
            self.web.sentlog(func_name: "connect To BT link Device \(blePeripheral!)", errorfromserverorlink:"", errorfromapp: "")
            AppconnectedtoBLE = true
        }
    }
    // MARK: - write the data
    // Write functions
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
    func outgoingData(inputText:String) {
        print("outgoingData\(inputText)")
        let appendString = "\n"

        let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
        let myAttributes1 = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.blue]

        writeValue(data: inputText)

        let attribString = NSAttributedString(string: "[Outgoing]: " + inputText + appendString, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributes1))
        let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
        newAsciiText.append(attribString)
        consoleAsciiText = newAsciiText
    }
//
//
    func updateIncomingData() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){ [self]
            notification in
            print("updateIncomingData")
            let appendString = "\n"

            let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
            let myAttributes2 = [self.convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, self.convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red]
            let attribString = NSAttributedString(string: "[Incoming]: " + (self.characteristicASCIIValue as String) + appendString, attributes: self.convertToOptionalNSAttributedStringKeyDictionary(myAttributes2))
            let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)

            newAsciiText.append(attribString)

            self.consoleAsciiText = newAsciiText


            let Split = self.characteristicASCIIValue.components(separatedBy: ":")
            if(Split.count == 2){
                let reply1 = Split[0]
                let count = Split[1]
                let dc = count.trimmingCharacters(in: .whitespaces)
                let datacount =  Int(dc as String)!

                if(reply1 == "pulse" ){
                    print("\(characteristicASCIIValue)")

                    countfromlink = datacount
                    self.GetPulserBLE(counts:"\(datacount)")
                    self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")

                }

                else if(self.characteristicASCIIValue == "pulse: 0")
                {
                }
            }
            print(self.characteristicASCIIValue)

            if(self.characteristicASCIIValue == "ON")
            {
                iflinkison = true
            }
            if(characteristicASCIIValue == "HO")
            {

                Count_Fdcheck = 0
            }
            else if(characteristicASCIIValue == "DN")
            {


            }
            else if(characteristicASCIIValue == "")
            {
                // self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")

            }

            if(self.characteristicASCIIValue == "OFF")
            {
                if (isdisconnected == true){}
                else{

                    self.disconnectFromDevice()

                }
            }
        }
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
    
    func ConnecttoBLE()
    {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }




    func GetPulserBLE(counts:String) {

//        let dateFormatter = DateFormatter()
//        Warning.text = NSLocalizedString("Warningfueling", comment:"")
//        Warning.isHidden = false
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//        let defaultTimeZoneStr = dateFormatter.string(from: Date());
//
//        print("before GetPulser" + defaultTimeZoneStr)
//
//        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//        print("before send GetPulser" + defaultTimeZoneStr1)
//
        print(characteristicASCIIValue)

        if(self.counts == " 0" || self.counts == "0")
        {

        }
        else{
            if (counts == ""){
//                self.emptypulsar_count += 1
//                if(self.emptypulsar_count == 3){
//                    Vehicaldetails.sharedInstance.gohome = true
//                    self.timerview.invalidate()
//                    do
//                    {
//                        try self.stoprelay()
//                    }
//                    catch{}
//                    let appDel = UIApplication.shared.delegate! as! AppDelegate
//                    self.web.sentlog(func_name: "get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                    appDel.start()
//                }
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
//                            Ispulsarcountsame = true
//                            stoptimerIspulsarcountsame.invalidate()
                            Samecount = Last_Count

                           // self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)

                            self.web.sentlog(func_name: "get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time)", errorfromserverorlink: "", errorfromapp: "")
                        }
                    }
                }
            }
            else
            {
               // self.emptypulsar_count = 0
                if (counts != "0"){
                    causionmessage.setHidden(false)
                    causionmessage.setText("Caution: Do NOT leave this screen while fueling. Pump may TURN OFF!")
                    labelres.setHidden(true)
//                    self.start.isHidden = true
//                    self.cancel.isHidden = true
                    // stoptimerIspulsarcountsame.invalidate()
                    //transaction Status send only one time.
                    //let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                    if(reply_server == "")
//                    {
//                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
//                        reply_server = "Sendtransaction"
//                    }
//                    print(self.tpulse.text!, counts)

//                    if (self.tpulse.text! == (counts as String) as String){
//
//                    }
                    if(Last_Count == nil){
                        Last_Count = "0.0"
                    }

                    if((counts as NSString).doubleValue >= (Last_Count as NSString).doubleValue)
                    {
                        if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
//                            Ispulsarcountsame = false
//                            stoptimerIspulsarcountsame.invalidate()
                        }
//                        timer_quantityless_thanprevious.invalidate()
                        self.Last_Count = counts as String?
                        let v = self.quantity.count
                        let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                        let y = Double(round(100*FuelQuan)/100)
//                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
//                            let y = Double(round(100*FuelQuan)/100)
//                            self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
//                            print(self.tquantity.text!)
//                        }
                        //else {
//                            let y = Double(round(100*FuelQuan)/100)
//                            self.tquantity.text = "\(y) "
                      //  }
                        self.TQuantity.setText("Total Quantity : \(y)")
                        self.TPulse.setText("Pulse :  \(counts as String)" as String)
                        self.quantity.append("\(y) ")

//                        print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                        print("Inside loop GetPulser" + defaultTimeZoneStr1)
                        if(v >= 2){
                            print(self.quantity[v-1],self.quantity[v-2])
                            if(self.quantity[v-1] == self.quantity[v-2]){
                                self.total_count += 1
                                if(self.total_count == 3){
//                                    Ispulsarcountsame = true
//                                    stoptimerIspulsarcountsame.invalidate()
                                    Samecount = Last_Count
                                   // self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)

                                    self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time)", errorfromserverorlink: "", errorfromapp: "")
                                }
                            }
                            else
                            {
                                total_count = 0
                                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
                                else{

                                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){

                                        //_ = self.web.SetPulser0()
                                        print(Vehicaldetails.sharedInstance.MinLimit)
                                        presentAlert(withTitle: "", message:NSLocalizedString("Fueldaylimit", comment:""), preferredStyle: WKAlertControllerStyle.alert, actions:[action])

                                        self.stopButtontapped()
                                    }
                                }
                            }
                        }
                    }
//                    else{
//                        timer_quantityless_thanprevious.invalidate()
//                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
//                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
//                        print("lower qty. than the prior one.")
//                    }
                }
                else{
                    if(Last_Count == nil){
                        Last_Count = "0.0"
                    }
                    let v = self.quantity.count
                    let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
                    let y = Double(round(100*FuelQuan)/100)

                    self.quantity.append("\(y) ")

//                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
//                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
//                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
                    if(v >= 2){
                        if(self.self.quantity[v-1] == self.quantity[v-2]){
                            self.total_count += 1
                            if(self.total_count == 3){
//                                Ispulsarcountsame = true
//                                Samecount = Last_Count
//                                stoptimerIspulsarcountsame.invalidate()
//
                                self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),WatchOS ", errorfromserverorlink: "", errorfromapp: "")

//                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
  
}
// MARK: - Central Manager delegate
extension InterfaceController: CBCentralManagerDelegate {

    /*
     Called when the central manager discovers a peripheral while scanning. Also, once peripheral is connected, cancel scanning.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {

        blePeripheral = peripheral
        self.peripherals.append(peripheral)
        self.RSSIs.append(RSSI)
        peripheral.delegate = self
        //self.baseTableView.reloadData()
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

//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        //let BLEService_UUID = CBUUID(string: kBLEService_UUID)
//        print("*****************************")
//        print("Connection complete")
//        print("Peripheral info: \(String(describing: blePeripheral))")
//
//        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
//        centralManager?.stopScan()
//        print("Scan Stopped")
//
//        //Erase data that we might have
//        data.length = 0
//
//        //Discovery callback
//        peripheral.delegate = self
//        //Only look for services that matches transmit uuid
//        peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")])
//
//        //Once connected, move to new view controller to manager incoming and outgoing data
//        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        //           let uartViewController = storyboard.instantiateViewController(withIdentifier: "UartModuleViewController") as! FuelquantityVC
//        //
//        //           uartViewController.peripheral = peripheral
//        //
//        //           navigationController?.pushViewController(uartViewController, animated: true)
//    }
//
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        if (isviewdidDisappear == true)
//        {
//            disconnectFromDevice()
//        }
//        else
//        {
        print("didDisconnectPeripheral \(CBCentralManager.self) \(Error.self)")
        self.isDisconnect_Peripheral = true
        if(self.IsStopbuttontappedBLE == false){
            self.web.sentlog(func_name: " Reconnect to Link \(IsStopbuttontappedBLE)", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
            //FDcheckBLEtimer.invalidate()
            iflinkison = false
                if(self.IsStopbuttontappedBLE == true)
                {
                    self.web.sentlog(func_name: " Reconnect to Link \(self.IsStopbuttontappedBLE)", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
                }
                else{
                   // self.Reconnect.isHidden = false
                  //  self.Reconnect.text = "Reconnecting to pump."//NSLocalizedString("Reconnect" , comment:"")
            //displaytime.textColor = UIColor.red
                    self.appdisconnects_automatically = true
                    self.connectToDevice()
                    //self.delay(0.2){
                    awake(withContext: Any?.self)//self.viewDidAppear(true)
             
                //    }
                    
                }
            
            
        }
        else if(self.IsStopbuttontappedBLE == true)
        {
            FDcheckBLEtimer.invalidate()
        print("Disconnected")
        self.web.sentlog(func_name: "Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp:"\(error)")
        if(Last_Count == nil){
            Last_Count = "0"
            self.web.sentlog(func_name: " Last_Count \(Last_Count!) Disconnected", errorfromserverorlink: "\(CBCentralManager.self)", errorfromapp: "")
            awake(withContext: Any?.self)// self.viewDidAppear(true)
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
                    disconnectFromDevice()
                }
            }
            }
        }
            
//        }
    }


    func renamelink(SSID:String)
    {
        sendrename_linkname = true
        let MessageuDP = "LK_COMM=name:\(SSID)"
        self.outgoingData(inputText:MessageuDP)
        self.updateIncomingData()
        self.web.sentlog(func_name: "Sent LK_COMM=name:\(SSID) command to link", errorfromserverorlink: "", errorfromapp: " Hose :\(Vehicaldetails.sharedInstance.SSId)")
       
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

//  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//    blePeripheral = peripheral
//            self.peripherals.append(peripheral)
//            self.RSSIs.append(RSSI)
//            peripheral.delegate = self
//         //  connectToDevice()
//            if blePeripheral == nil {
//                print("Found new pheripheral devices with services")
//                print("Peripheral name: \(String(describing: peripheral.name))")
//                print("**********************************")
//                print ("Advertisement Data : \(advertisementData)")
//            }
////    guard RSSI_range.contains(RSSI.intValue) && discoveredPeripheral != peripheral else { return }
////    statusLabel.setText("discovered peripheral")
////    discoveredPeripheral = peripheral
////    central.connect(peripheral, options: [:])
//  }
//
//  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//    if let error = error { print(error.localizedDescription) }
//    //cleanup()
//  }
//
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

    if( ifSubscribed == true)
    {

    }
    else{
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
            peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")])

            //Once connected, move to new view controller to manager incoming and outgoing data
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            labelres.setText("connected to peripheral")
        //labelres.setText("Sendinfo command")
        outgoingData(inputText: "LK_COMM=info")
        self.updateIncomingData ()
        //GObutton.setHidden(true)
        sleep(1)
        startbutton.setHidden(false)
        stopbutton.setHidden(true)
        causionmessage.setHidden(true)
        labelres.setText("Please insert the nozzle into the tank \n Then tap start.")
        self.TQuantity.setText("Total Quantity : 0")
        self.TPulse.setText("Pulse : 0")

    }
  }
//
//  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//            print("Disconnected")
//
//            if(Last_Count == nil){
//                Last_Count = "0"
//
//            }
//
//            if(Last_Count! == "0"){
//                self.connectToDevice()
//            }
//            else{
//
//                    if(Last_Count! == "0.0"){
//                        disconnectFromDevice()
//                    }
//                    else{
//                        disconnectFromDevice()
//                    }
//
//            }
////    if (peripheral == discoveredPeripheral) {
////      cleanup()
////    }
////    scan()
//  }

}

// MARK: - Peripheral Delegate
extension InterfaceController: CBPeripheralDelegate {

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
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
                // bleService = service
                print(service)
            }
            print("Discovered Services: \(services)")
//    if let error = error {
//      print(error.localizedDescription)
//      //cleanup()
//      return
//    }
//
//    guard let services = peripheral.services else { return }
//    for service in services {
//      labelres.setText("discovered service")
//        peripheral.discoverCharacteristics(nil, for: service)
//      //peripheral.discoverCharacteristics([textCharacteristicUUID, mapCharacteristicUUID], for: service)
//    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    
    
   //
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
    
    
//    if let error = error {
//      print(error.localizedDescription)
//      cleanup()
//      return
//    }
//
//    guard let characteristics = service.characteristics else { return }
//    for characteristic in characteristics {
//      if characteristic.uuid == CBUUID(string:kBLE_Characteristic_uuid_Rx) {
//        labelres.setText("discovered textCharacteristic")
//        textCharacteristic = characteristic
//      } else if characteristic.uuid == mapCharacteristicUUID {
//        labelres.setText("discovered mapCharacteristic")
//        mapCharacteristic = characteristic
//      }
//    }
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
    
            }
            print("Value Recieved: \((characteristicASCIIValue as String))")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
//    if let error = error {
//      print(error.localizedDescription)
//      return
//    }
//
//    if characteristic == textCharacteristic {
//      guard let newData = characteristic.value else { return }
//      let stringFromData = String(data: newData, encoding: .utf8)
//      statusLabel.setText("received \(stringFromData ?? "nothing")")
//
//      if stringFromData == "EOM" {
//        statusLabel.setHidden(true)
//        textLabel.setText(String(data: data, encoding: .utf8))
//        data.removeAll()
//      } else {
//        data.append(newData)
//      }
//    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
            if (error != nil) {
                print("Error changing notification state:\(String(describing: error?.localizedDescription))")
                ifSubscribed = false
    
            } else {
                print("Characteristic's value subscribed")
            }
    
            if (characteristic.isNotifying) {
                ifSubscribed = true
                print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
            }
            else
            {
                ifSubscribed = false
            }
    
//    if let error = error { print(error.localizedDescription) }
//    guard characteristic.uuid == textCharacteristicUUID else { return }
//    if characteristic.isNotifying {
//      print("Notification began on \(characteristic)")
//    } else {
//      print("Notification stopped on \(characteristic). Disconnecting...")
//    }
  }

  // Stub to stop run-time warning
  func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {}

}








