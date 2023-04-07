////
////  InterfaceControllerWifi.swift
////  FluidSecureWatchOS Extension
////
////  Created by apple on 10/04/21.
////  Copyright © 2021 VASP. All rights reserved.
////
//
//
//import WatchKit
//import Foundation
//import CoreBluetooth
//import CoreLocation
//import Network
//import NetworkExtension
//
//
//class InterfaceControllerWifi: WKInterfaceController {
//
//    var inStream : InputStream?
//    var outStream: OutputStream?
//    let addr = "192.168.4.1"
//    let port = 80
//    var buffer = [UInt8](repeating: 0, count:4096)
//    var stringbuffer:String = ""
//    var status :String = ""
//
//    var sysdata1:NSDictionary!
//    var bindata:NSData!
//    var tlddatafromlink:String!
//    var reply :String!
//    var reply1 :String!
//    let defaults = UserDefaults.standard
//    var replydata:NSData!
//
//    var pulsardata:String!
//    var sysdataLast10trans:NSDictionary!
//
//    var IsStartbuttontapped : Bool = false
//    var IsStopbuttontapped:Bool = false
//    var Ispulsarcountsame :Bool = false
//    var Cancel_Button_tapped :Bool = false
//    var stopdelaytime:Bool = false
//
//    var sysdata:NSDictionary!
//
//    var quantity = [String]()
//    var counts:String!
//    var reply_server:String = ""
//
//    var timerFDCheck:Timer = Timer()
//    var timer:Timer = Timer()    // #selector(self.GetPulser) call the Getpulsar function.
//    var timerview:Timer = Timer()  // #selector(ViewController.viewDidAppear(_:)) call viewController timerview
//    var isUDPConnectstoptimer:Timer = Timer()  // Add timer to send UDP Connection function after connect the Link. and stops time after get the valid output.
//    var stoptimergotostart:Timer = Timer() ///#selector(call gotostart function)
//    var stoptimer_gotostart:Timer = Timer() ///#selector(gotostart from viewWillapeared)
//    var stoptimerIspulsarcountsame:Timer = Timer()  ///call stopIspulsarcountsame for
//    // var timer_noConnection_withlink = Timer()
//    var timer_quantityless_thanprevious = Timer()  ///#selector(FuelquantityVC.stoprelay) to stop the app
//
//    var y :CGFloat = CGFloat()
//
//    var fuelquantity:Double!
//
//
//    var string:String = ""
//
//    var emptypulsar_count:Int = 0
//    var total_count:Int = 0
//    var Last_Count:String!
//    var Samecount:String!
//    var renameconnectedwifi:Bool = false
//    var connectedwifi:String!
//    var InterruptedTransactionFlag = true
//    var showstart = ""
//    var countfailConn:Int = 0
//    var countfailUDPConn:Int = 0
//
//    //    UDP
//    var connection: NWConnection?
//    var hostUDP: NWEndpoint.Host = "192.168.4.1"
//    var portUDP: NWEndpoint.Port = 8080
//
//    var backToString = ""
//    var pulsedata = ""
//    var IFUDPConnectedGetinfo = false
//    var IFUDPSendtxtid = false
//    var IFUDPConnected = false
//    var Last10transaction = ""
////    var sysdata:NSDictionary!
//    let kBLEService_UUID = "4c425346-0000-1000-8000-00805f9b34fb"
//
//    let kBLE_Characteristic_uuid_Tx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
//
//    let kBLE_Characteristic_uuid_Rx = "e49227e8-659f-4d7e-8e23-8c6eea5b9173"
//
//    var txCharacteristic : CBCharacteristic?
//    var rxCharacteristic : CBCharacteristic?
//    var blePeripheral : CBPeripheral?
//    var characteristicASCIIValue = ""
//    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
//    var BLErescount = 0
//    var centralManager: CBCentralManager!
//    var myPeripheral: CBPeripheral!
//    var peripheral: CBPeripheral!
//    var RSSIs = [NSNumber]()
//    var data = NSMutableData()
//    var peripherals: [CBPeripheral] = []
//    var ifSubscribed = false
//    var isdisconnected = false
//    var FDcheckBLEtimer:Timer = Timer()
//    var Count_Fdcheck = 0
//    var countwififailConn:Int = 0
////    var Last10transaction = ""
//    var iflinkison = false
////    var Last_Count:String!
////    var Samecount:String!
////    var counts:String!
////    var quantity = [String]()
////    var total_count:Int = 0
////    var fuelquantity:Double!
//    var ifstartbuttontapped = false
//
//    var  serverURL = "https://www.fluidsecure.net/"//"http://sierravistatest.cloudapp.net/"
//
//    @IBOutlet weak var TPulse: WKInterfaceLabel!
//    @IBOutlet weak var GObutton: WKInterfaceButton!
//    @IBOutlet weak var startbutton: WKInterfaceButton!
//    @IBOutlet weak var labelres: WKInterfaceLabel!
//
//    @IBOutlet weak var TQuantity: WKInterfaceLabel!
//
//    override func awake(withContext context: Any?) {
//       // let checkaprovedata = checkApprove(uuid:uuid ,lat:"\(18.479963)",long:"\(73.821659)") //
////        var info = Getinfo()
//       // print(checkaprovedata)
//        let info = getinfo()
//        print(info)
//       // wifi_settings_check(pagename: "iWatch")
////        if(info == "false")
////        {
////             info = Getinfo()
////        }
////        self.connectToUDP(self.hostUDP,self.portUDP)
////        if( ifSubscribed == false){
//
//
////        }
//        // Configure interface objects here.
//    }
//
//    override func willActivate() {
//
//        // This method is called when watch view controller is about to be visible to user
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//    }
//
//
//
//    @IBAction func Startbuttontapped() {
//        let goto = getrelay()
//        setpulsaroffTime()
//       let st = setSamplingtime()
//       print(goto,st)
//       pulsarlastquantity()
//       cmtxtnid10()
//        settransaction_IDtoFS()
//       let data = setralaytcp()
////        print(data)
//       // sleep(1)
//       // setdefault()
//        btnBeginFueling()
//
////        labelres.setText("Start button Tapped")
////        self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
////        self.updateIncomingData ()
////        self.FDcheckBLEtimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDcheckBLE), userInfo: nil, repeats: true)
////        //startbutton.setTitle("Stop")
////        startbutton.setEnabled(false)
////        ifstartbuttontapped = true
////        if (ifstartbuttontapped == true)
////        {
////            stopButtontapped()
////            ifstartbuttontapped = false
////            startbutton.setTitle("Start")
////
////        }
////        let messageToUDP = "LK_COMM=relay:12345=ON"
////
////        sendUDP(messageToUDP)
////        self.receiveUDP()
//    }
//
//    @IBAction func stopButtontapped() {
//        stop()
////        let MessageuDP = "LK_COMM=relay:12345=OFF"
////            self.sendUDP(MessageuDP)
////
////            self.receiveUDP()
//    }
//
//
//    func stop()
//    {
//
//        self.timer.invalidate()
//        self.timerview.invalidate()
//        self.stoptimerIspulsarcountsame.invalidate()
//
//
//        string = ""
//
//            self.timer.invalidate()
//            self.timerview.invalidate()
//
//
//
//        let setrelayd = self.setralay0tcp()
//      //  sleep(1)
//
//
//
//
//                    if(setrelayd == ""){
//
//
//
//
//
//                        let Split = setrelayd.components(separatedBy: "{")
//                        if(Split.count < 3){
//                            // _ = self.tcpcon.setralay0tcp()
//                            // _ = self.tcpcon.setpulsar0tcp()
//
//
//                        }
//                        else {
//
//                            let reply = Split[1]
//                            let setrelay = Split[2]
//                            let Split1 = setrelay.components(separatedBy: "}")
//                            let setrelay1 = Split1[0]
//                            let outputdata = "{" +  reply + "{" + setrelay1 + "}" + "}"
//                            let data1 = outputdata.data(using: String.Encoding.utf8)!
//                            do{
//                                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                            }
//                            catch let error as NSError {
//                                print ("Error: \(error.domain)")
//                                //self.web.sentlog(func_name: "stopButtontapped", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
//                            }
//
//                            print(setrelayd)
//
//
//
//
//                        }
//
//                        }
//    }
//
//
//    @IBAction func Gobuttontapped() {
//
//
//
////        labelres.setText("Sendinfo command")
////        outgoingData(inputText: "LK_COMM=info")
////        self.updateIncomingData ()
//        Getinfo()
//
//
//        setpulsaroffTime()
//       let st = setSamplingtime()
//       print(st)
//       pulsarlastquantity()
//       cmtxtnid10()
//        settransaction_IDtoFS()
//        let goto = getrelay()
//       let data = setralaytcp()
//        print(goto,data)
////
//    }
//
//    func wifi_settings_check(pagename:String)
//    {
//        print("FS-VASP-008")
//        let hotspotConfig = NEHotspotConfiguration(ssid: "FS-VASP-008", passphrase: "123456789", isWEP: false)
//        hotspotConfig.joinOnce = true
//
//        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {(error) in
//
//            if let error = error
//            {
//              print("Error\(error)")
//            }
//            else {
//               // self.sentlog(func_name: "Go button Tapped user Joins \(Vehicaldetails.sharedInstance.SSId) wifi Automatically from \(pagename) Page", errorfromserverorlink: " \(Vehicaldetails.sharedInstance.SSId == self.cf.getSSID())",errorfromapp: " Selected Hose: \(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                    print("Connected")
//
//            }
//        }
//
//
//    }
//
//   // MARK: - //UDP
////    func btnBeginFueling()
////    {
//////        print("before GetPulser" + cf.dateUpdated)
////
////        self.quantity = []
////        self.countfailConn = 0
//////        print("Get Pulsar1" + self.cf.dateUpdated)
////        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
////        self.timerFDCheck = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDCheck), userInfo: nil, repeats: true)
////        //print("after GetPulser" + self.cf.dateUpdated)
////        print(self.timer)
////    }
////
////    @objc func FDCheck()
////    {
////        let MessageuDP = "LK_COMM=FD_check"
////            self.sendUDP(MessageuDP)
////        //self.web.sentlog(func_name: "UDP Function ", errorfromserverorlink: "Send FD check",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
////       self.receiveUDP()
////    }
////
//    func calculate_fuelquantity(quantitycount: Int)-> Double
//    {
//        if(quantitycount == 0)
//        {
//            fuelquantity = 0
//        }
//        else{
//            //Vehicaldetails.sharedInstance.pulsarCount = "\(quantitycount)"
//            let PulseRatio = Vehicaldetails.sharedInstance.PulseRatio
//            fuelquantity = (Double(quantitycount))/(PulseRatio as NSString).doubleValue
//        }
//        return fuelquantity
//    }
////
////
////
////
////    @IBAction func stopButtonTapped() {
//////        let MessageuDP = "LK_COMM=relay:12345=OFF"
//////            self.sendUDP(MessageuDP)
////        //self.web.sentlog(func_name: " Send Relay OFF Command to link \(MessageuDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//////            self.receiveUDP()
////    }
////
//////    @objc func connectUDPlink()
//////    {
//////
//////                            if(self.IFUDPConnected == false)
//////                            {
//////
//////
//////                                    self.connectToUDP(self.hostUDP,self.portUDP)
//////
//////                            }
//////                            else if(self.IFUDPConnected == true)
//////                            {
//////                               // isUDPConnectstoptimer.invalidate()
//////                            }
//////
//////                            if(self.IFUDPConnectedGetinfo == false)
//////                            {
//////                                if("UDP" == "UDP")
//////                                {
//////
//////
//////                                        self.connectToUDP(self.hostUDP,self.portUDP)
//////                                        self.countfailUDPConn = self.countfailUDPConn + 1
//////                                        if (self.countfailUDPConn == 10)
//////                                        {
//////                                            print("No response from the link please try again later.")
//////                                           // self.isUDPConnectstoptimer.invalidate()
////////                                            self.showAlert(message: "No response from the link please try again later." )
////////                                            self.delay(2)
////////                                                {
//////                                                //self.web.sentlog(func_name:"No response from the link Fueling_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
////////                                                let appDel = UIApplication.shared.delegate! as! AppDelegate
////////                                                appDel.start()
////////                                                self.connection?.cancel()
////////                                                self.stoptimerIspulsarcountsame.invalidate()
////////                                                self.timerview.invalidate()
////////                                                self.timer.invalidate()
////////                                                self.timerFDCheck.invalidate()
////////                                                self.timer_quantityless_thanprevious.invalidate()
////////                                                self.stoptimergotostart.invalidate()
////////                                                self.stoptimer_gotostart.invalidate()
//////////                                            }
//////                                        }
//////
//////
//////                                }
//////                            }
//////                            else if(self.IFUDPConnectedGetinfo == true)
//////                            {
//////                               // isUDPConnectstoptimer.invalidate()
//////                            }
////////                        } else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
////////            {
////////                    web.wifi_settings_check(pagename: "UDP")
////////                    self.web.sentlog(func_name:" Connect UDP Link ", errorfromserverorlink: "", errorfromapp: "")
////////
////////                print("Link not connected ")
////////            }
//////    }
////    //    UDP Connect
////    //    @available(iOS 12.0, *)
////    @available(iOS 12.0, *)
//////    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
//////        // Transmited message:
//////        let messageToUDP = "LK_COMM=info"
//////
//////        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
//////
//////        self.connection?.stateUpdateHandler = { (newState) in
//////            print("This is stateUpdateHandler:")
//////            switch (newState) {
//////            case .ready:
//////                print("State: Ready\n")
//////
//////                self.sendUDP(messageToUDP)
//////
//////                self.receiveUDP()
//////                self.IFUDPConnected = true
//////
//////            case .setup:
//////                print("State: Setup\n")
//////                //self.web.sentlog(func_name: " State: Setup\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//////            case .cancelled:
//////                print("State: Cancelled\n")
//////               // self.web.sentlog(func_name: " State: Cancelled\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//////            case .preparing:
//////                print("State: Preparing\n")
//////                //self.web.sentlog(func_name: " State: Preparing\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//////            default:
//////                print("ERROR! State not defined!\n")
//////                //self.web.sentlog(func_name: " ERROR! State not defined!\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//////            }
//////        }
//////
//////        self.connection?.start(queue: .global())
//////    }
////
////
////
////
////
////
////    @available(iOS 12.0, *)
////    @IBAction func sendinfocommand(_ sender: Any) {}
////
////
////    func renamelink(SSID:String)
////    {
////        let MessageuDP = "LK_COMM=name:\(SSID)"
////        sendUDP(MessageuDP)
////        self.receiveUDP()
////    }
////
////    //Send the request data to UDP link
////    @available(iOS 12.0, *)
////    func sendUDP(_ content: String) {
////        let contentToSendUDP = content.data(using: String.Encoding.utf8)
////        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
////            if (NWError == nil) {
////                print("Data was sent to UDP")
////            } else {
////                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
////            }
////        })))
////    }
////
////    ///Receive the reponse from UDP
////    func receiveUDP() {
////
////        var backToString = ""
////
////        self.connection?.receiveMessage { (data, context, isComplete, error) in
////            if (isComplete) {
////
////                print("Receive is complete")
////                if (data != nil) {
////                    backToString = String(decoding: data!, as: UTF8.self)
////                    print("Received message: \(backToString)")
////                    //self.web.sentlog(func_name:" Received message: \(backToString) from UDP link", errorfromserverorlink: "", errorfromapp: "")
////                    if(backToString.contains("HO"))
////                    {
////
////                    }
////                    else if(backToString.contains("DN"))
////                    {
////                        //self.gotostartUDP_resDN()
////                    }
////                    if(backToString.contains("L10:"))
////                    {
////                        self.Last10transaction = backToString
////                        //self.web.sentlog(func_name: " Get response from info command to link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
////                        self.IFUDPConnectedGetinfo = true
////                        //self.viewDidAppear(true)
////                    }
////                    if(backToString.contains("pulse:"))
////                    {
////                       // self.web.sentlog(func_name: " Get response from relay on getting pulses from link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
////                        let Split = backToString.components(separatedBy: ":")
////                        self.pulsedata = Split[1]
////                        print(self.pulsedata)
////                        self.pulsedata = (self.pulsedata.trimmingCharacters(in: .whitespacesAndNewlines) as NSString) as String
////                    }
////                }
////            }
////        }
////    }
//////    func showAlert(message: String,title:String)
//////    {
//////
//////        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
//////        // Background color.
//////        let backView = alertController.view.subviews.last?.subviews.last
//////        backView?.layer.cornerRadius = 10.0
//////        backView?.backgroundColor = UIColor.white
//////
//////        // Change Message With Color and Font
//////        let message  = message
//////        var messageMutableString = NSMutableAttributedString()
//////        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
//////        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
//////        alertController.setValue(messageMutableString, forKey: "attributedMessage")
//////
//////        // Action.
//////        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default, handler: nil)
//////        alertController.addAction(action)
//////        self.present(alertController, animated: true, completion: nil)
//////    }
////    @objc func stoprelay() throws  {
////        if(Last_Count == nil){
////            Last_Count = "0.0"
////        }
////
////        labelres.setText("RelayStop")
////
////    }
////
////
//////
//    @objc func stopIspulsarcountsame(){
//        if(self.IsStopbuttontapped == true){
//
//        }
//        else {
//            if(self.Ispulsarcountsame == true){
//                if(Last_Count == nil){
//                    Last_Count = "0.0"
//                }
//                if(Last_Count == "0.0" || Last_Count == "0")
//                {
//
//
//                    Last_Count = "0.0"
//                }
//                //print(Last_Count,Samecount)
//                if(Samecount == Last_Count){}
//            }
//        }
//    }
//
//
//
//
////  MARK: -//BLE
//
////    @objc func FDcheckBLE()
////    {
////        var lastcount = ""
////        if(Last_Count == nil){
////
////            self.outgoingData(inputText: "LK_COMM=FD_check")
////            Last_Count = "0"
////
////        }
////        else
////        if(Last_Count == "0.0")
////        {
////            lastcount = Last_Count
////            lastcount = "0"
////        }else
////        {
////            lastcount = Last_Count
////        }
////
////        print(lastcount)
////        if (Int(lastcount)! > 0){
////
////
////            self.outgoingData(inputText: "LK_COMM=FD_check")
////            //self.AppconnectedtoBLE = true
////        }
////        else
////        {
////            if(iflinkison == false){
////
////
////                    self.outgoingData(inputText: "LK_COMM=relay:12345=ON")
////                    self.updateIncomingData()
////
////            }
////        }
////    }
////
////
////
////
////    func startScan() {
////
////        self.peripherals = []
////        let BLEService_UUID = CBUUID(string: kBLEService_UUID)
////        print("Now Scanning...")
////
////        centralManager.scanForPeripherals(withServices: [BLEService_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: true as Bool)])
////
////        Timer.scheduledTimer(withTimeInterval: 17, repeats: false) {_ in
////
////            self.cancelScan()
////
////        }
////    }
//////
//////    /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
////    func cancelScan() {
////        self.centralManager?.stopScan()
////
////
////        if (peripherals.count == 0){
////
////
////                }
////                else{
////                    if(self.ifSubscribed == true){}
////                    else{
////                        labelres.setText("BT link not found. please try again later.")
////                        self.startScan()
////                    }
////                }
////        //labelres.setText( "BT link not found. please try again later.")
////                // AppconnectedtoBLE = false
////
////
////
////
////
////                for i in 0  ..< peripherals.count
////                {
////                    print(peripherals,peripherals.count)
////                    if(peripherals.count == 0)
////                    {
////                        print(peripherals,peripherals.count)
////                    }
////                    else{
////                        _ = self.peripherals[i]
////
////
////                            blePeripheral = self.peripherals[i]
////
////                            connectToDevice()
////
////                            break
////                        }
////                    }
////
////
////    }
////
////    /*
////     Called when the central manager discovers a peripheral while scanning. Also, once peripheral is connected, cancel scanning.
////     */
//////    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
//////
//////        blePeripheral = peripheral
//////        self.peripherals.append(peripheral)
//////        self.RSSIs.append(RSSI)
//////        peripheral.delegate = self
//////        //self.baseTableView.reloadData()
//////        if blePeripheral == nil {
//////            print("Found new pheripheral devices with services")
//////            print("Peripheral name: \(String(describing: peripheral.name))")
//////            print("**********************************")
//////            print ("Advertisement Data : \(advertisementData)")
//////        }
//////
//////    }
//////
////
//////    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//////
//////        if central.state == CBManagerState.poweredOn {
//////            print("BLE powered on")
//////            // Turned on
//////            startScan()
//////            //central.scanForPeripherals(withServices: [CBUUID(string: "000000ff-0000-1000-8000-00805f9b34fb")], options: nil)
//////        }
//////        else {
//////            print("Something wrong with BLE")
//////            // Not on, but can have different issues
//////        }
//////    }
////
////
////    /*
////     Invoked when a connection is successfully created with a peripheral.
////     This method is invoked when a call to connect(_:options:) is successful. You typically implement this method to set the peripheral’s delegate and to discover its services.
////     */
////    //-Connected
//////    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//////        //let BLEService_UUID = CBUUID(string: kBLEService_UUID)
//////        print("*****************************")
//////        print("Connection complete")
//////        print("Peripheral info: \(String(describing: blePeripheral))")
//////
//////        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
//////        centralManager?.stopScan()
//////        print("Scan Stopped")
//////
//////        //Erase data that we might have
//////        data.length = 0
//////
//////        //Discovery callback
//////        peripheral.delegate = self
//////        //Only look for services that matches transmit uuid
//////        peripheral.discoverServices([CBUUID(string:"725e0bc8-6f00-4d2d-a4af-96138ce599b6")])
//////
//////        //Once connected, move to new view controller to manager incoming and outgoing data
//////        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//////
//////        //           let uartViewController = storyboard.instantiateViewController(withIdentifier: "UartModuleViewController") as! FuelquantityVC
//////        //
//////        //           uartViewController.peripheral = peripheral
//////        //
//////        //           navigationController?.pushViewController(uartViewController, animated: true)
//////    }
//////
////    /*
////     Invoked when you discover the peripheral’s available services.
////     This method is invoked when your app calls the discoverServices(_:) method. If the services of the peripheral are successfully discovered, you can access them through the peripheral’s services property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
////     */
//////    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//////        print("*******************************************************")
//////
//////        if ((error) != nil) {
//////            print("Error discovering services: \(error!.localizedDescription)")
//////            return
//////        }
//////
//////        guard let services = peripheral.services else {
//////            return
//////        }
//////        //We need to discover the all characteristic
//////        print(services)
//////        for service in services {
//////
//////            peripheral.discoverCharacteristics(nil, for: service)
//////            // bleService = service
//////            print(service)
//////        }
//////        print("Discovered Services: \(services)")
//////    }
////
////    /*
////     Invoked when you discover the characteristics of a specified service.
////     This method is invoked when your app calls the discoverCharacteristics(_:for:) method. If the characteristics of the specified service are successfully discovered, you can access them through the service's characteristics property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
////     */
////
//////    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//////
//////        print("*******************************************************")
//////
//////        if ((error) != nil) {
//////            print("Error discovering services: \(error!.localizedDescription)")
//////            return
//////        }
//////
//////        guard let characteristics = service.characteristics else {
//////            return
//////        }
//////
//////        print("Found \(characteristics.count) characteristics!")
//////
//////        for characteristic in characteristics {
//////            //looks for the right characteristic
//////
//////            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Rx))  {
//////                rxCharacteristic = characteristic
//////
//////                //Once found, subscribe to the this particular characteristic...
//////                peripheral.setNotifyValue(true, for: rxCharacteristic!)
//////
//////                // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
//////                // didUpdateNotificationStateForCharacteristic method will be called automatically
//////                peripheral.readValue(for: characteristic)
//////                print("Rx Characteristic: \(characteristic.uuid)")
//////            }
//////            if characteristic.uuid.isEqual(CBUUID(string:kBLE_Characteristic_uuid_Tx)){
//////                txCharacteristic = characteristic
//////                print("Tx Characteristic: \(characteristic.uuid)")
//////            }
//////            peripheral.discoverDescriptors(for: characteristic)
//////        }
//////    }
////
////    // MARK: - Getting Values From Characteristic
////
////    /** After you've found a characteristic of a service that you are interested in, you can read the characteristic's value by calling the peripheral "readValueForCharacteristic" method within the "didDiscoverCharacteristicsFor service" delegate.
////     */
//////    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//////        guard characteristic == rxCharacteristic,
//////              let characteristicValue = characteristic.value,
//////              let ASCIIstring = NSString(data: characteristicValue,
//////                                         encoding: String.Encoding.utf8.rawValue)
//////        else { return }
//////
//////        characteristicASCIIValue = ASCIIstring as String
//////        if((characteristicASCIIValue as String).contains("L10:"))
//////        {
//////            Last10transaction = (characteristicASCIIValue as String)
//////
//////        }
//////        print("Value Recieved: \((characteristicASCIIValue as String))")
//////        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
//////
//////    }
////
////
//////    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//////        print("*******************************************************")
//////
//////        if error != nil {
//////            print("\(error.debugDescription)")
//////            return
//////        }
//////        guard let descriptors = characteristic.descriptors else { return }
//////
//////        descriptors.forEach { descript in
//////            print("function name: DidDiscoverDescriptorForChar \(String(describing: descript.description))")
//////            print("Rx Value \(String(describing: rxCharacteristic?.value))")
//////            print("Tx Value \(String(describing: txCharacteristic?.value))")
//////            //if it is subscribed the Notification has begun for: E49227E8-659F-4D7E-8E23-8C6EEA5B9173
//////        }
//////    }
////
////
//////    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//////        print("*******************************************************")
//////
//////        if (error != nil) {
//////            print("Error changing notification state:\(String(describing: error?.localizedDescription))")
//////            ifSubscribed = false
//////
//////        } else {
//////            print("Characteristic's value subscribed")
//////        }
//////
//////        if (characteristic.isNotifying) {
//////            ifSubscribed = true
//////            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
//////        }
//////        else
//////        {
//////            ifSubscribed = false
//////        }
//////    }
//////
////
////
//////    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//////        print("Disconnected")
//////
//////        if(Last_Count == nil){
//////            Last_Count = "0"
//////
//////        }
//////
//////        if(Last_Count! == "0"){
//////            self.connectToDevice()
//////        }
//////        else{
//////
//////                if(Last_Count! == "0.0"){
//////                    disconnectFromDevice()
//////                }
//////                else{
//////                    disconnectFromDevice()
//////                }
//////
//////        }
//////    }
////
//////    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//////        if error != nil {
//////            print("Failed to connect to peripheral")
//////            return
//////        }
//////    }
//////
//////    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//////        guard error == nil else {
//////            print("Error discovering services: error")
//////            return
//////        }
//////        print("Message sent")
//////    }
//////
//////    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//////        guard error == nil else {
//////            print("Error discovering services: error")
//////            return
//////        }
//////        print("Succeeded!")
//////    }
////
////    //-Terminate all Peripheral Connection
////    /*
////     Call this when things either go wrong, or you're done with the connection.
////     This cancels any subscriptions if there are any, or straight disconnects if not.
////     (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
////     */
//    func disconnectFromDevice() {
//        if blePeripheral != nil {
//            //self.web.sentlog(func_name: "disconnectFromDevice \(rxCharacteristic!),\(blePeripheral!)", errorfromserverorlink: "", errorfromapp:"")
//            // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
//            // Therefore, we will just disconnect from the peripheral
//            // print(rxCharacteristic!)
//            if(rxCharacteristic == nil){}
//            else{
//                blePeripheral!.setNotifyValue(false, for: rxCharacteristic!)
//
//            }
//
//            centralManager.cancelPeripheralConnection(blePeripheral!)
//            centralManager.cancelPeripheralConnection(blePeripheral!)
//
//        }
//    }
////
////    //Peripheral Connections: Connecting, Connected, Disconnected
////
////    //-Connection
//    func connectToDevice() {
//
//        if(blePeripheral == nil)
//        {}
//        else{
//            centralManager?.connect(blePeripheral!, options: nil)
//        }
//    }
//    // MARK: - write the data
//    // Write functions
//    func writeValue(data: String){
//        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
//        //change the "data" to valueString
//        if let blePeripheral = blePeripheral{
//            if let txCharacteristic = txCharacteristic
//            {
//                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
//            }
//        }
//    }
//
//    func writeCharacteristic(val: Int8){
//        var val = val
//        let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
//        blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withResponse)
//    }
//    func outgoingData (inputText:String) {
//        let appendString = "\n"
//
//        let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
//        let myAttributes1 = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.blue]
//
//        writeValue(data: inputText)
//
//        let attribString = NSAttributedString(string: "[Outgoing]: " + inputText + appendString, attributes: convertToOptionalNSAttributedStringKeyDictionary(myAttributes1))
//        let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
//        newAsciiText.append(attribString)
//        consoleAsciiText = newAsciiText
//    }
////
////
//    func updateIncomingData() {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){ [self]
//            notification in
//            let appendString = "\n"
//
//            let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
//            let myAttributes2 = [self.convertFromNSAttributedStringKey(NSAttributedString.Key.font): myFont!, self.convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.red]
//            let attribString = NSAttributedString(string: "[Incoming]: " + (self.characteristicASCIIValue as String) + appendString, attributes: self.convertToOptionalNSAttributedStringKeyDictionary(myAttributes2))
//            let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
//
//            newAsciiText.append(attribString)
//
//            self.consoleAsciiText = newAsciiText
//
//
//            let Split = self.characteristicASCIIValue.components(separatedBy: ":")
//            if(Split.count == 2){
//                let reply1 = Split[0]
//                let count = Split[1]
//                let dc = count.trimmingCharacters(in: .whitespaces)
//                let datacount =  Int(dc as String)!
//
//                if(reply1 == "pulse" ){
//                    print("\(characteristicASCIIValue)")
//
//                    labelres.setText("\(datacount)")
//                    self.GetPulserBLE(counts:"\(datacount)")
//
//
//                }
//
//                else if(self.characteristicASCIIValue == "pulse: 0")
//                {
//                }
//            }
//            print(self.characteristicASCIIValue)
//
//            if(self.characteristicASCIIValue == "ON")
//            {
//                iflinkison = true
//            }
//            if(characteristicASCIIValue == "HO")
//            {
//
//                Count_Fdcheck = 0
//            }
//            else if(characteristicASCIIValue == "DN")
//            {
//
//
//            }
//            else if(characteristicASCIIValue == "")
//            {
//                // self.web.sentlog(func_name: " BLE Response from link is \(characteristicASCIIValue)", errorfromserverorlink:"", errorfromapp: "")
//
//            }
//
//            if(self.characteristicASCIIValue == "OFF")
//            {
//                if (isdisconnected == true){}
//                else{
//
//                    self.disconnectFromDevice()
//
//                }
//            }
//        }
//    }
//
//    // Helper function inserted by Swift 4.2 migrator.
//    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
//        return input.rawValue
//    }
//
//    // Helper function inserted by Swift 4.2 migrator.
//    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
//        guard let input = input else { return nil }
//        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
//    }
////
////
////
//    func GetPulserBLE(counts:String) {
//
////        let dateFormatter = DateFormatter()
////        Warning.text = NSLocalizedString("Warningfueling", comment:"")
////        Warning.isHidden = false
////        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
////        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
////        let defaultTimeZoneStr = dateFormatter.string(from: Date());
////
////        print("before GetPulser" + defaultTimeZoneStr)
////
////        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////        print("before send GetPulser" + defaultTimeZoneStr1)
////
//        print(characteristicASCIIValue)
//
//        if(self.counts == " 0" || self.counts == "0")
//        {
//
//        }
//        else{
//            if (counts == ""){
////                self.emptypulsar_count += 1
////                if(self.emptypulsar_count == 3){
////                    Vehicaldetails.sharedInstance.gohome = true
////                    self.timerview.invalidate()
////                    do
////                    {
////                        try self.stoprelay()
////                    }
////                    catch{}
////                    let appDel = UIApplication.shared.delegate! as! AppDelegate
////                    self.web.sentlog(func_name: "get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
////                    appDel.start()
////                }
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
////                            Ispulsarcountsame = true
////                            stoptimerIspulsarcountsame.invalidate()
//                            Samecount = Last_Count
//
//                           // self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpon_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                            //self.web.sentlog(func_name: "get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                        }
//                    }
//                }
//            }
//            else
//            {
//               // self.emptypulsar_count = 0
//                if (counts != "0"){
//
////                    self.start.isHidden = true
////                    self.cancel.isHidden = true
//                    // stoptimerIspulsarcountsame.invalidate()
//                    //transaction Status send only one time.
//                    //let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
////                    if(reply_server == "")
////                    {
////                        self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
////                        reply_server = "Sendtransaction"
////                    }
////                    print(self.tpulse.text!, counts)
//
////                    if (self.tpulse.text! == (counts as String) as String){
////
////                    }
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//
//                    if((counts as NSString).doubleValue >= (Last_Count as NSString).doubleValue)
//                    {
//                        if((counts as NSString).doubleValue > (Last_Count as NSString).doubleValue){
////                            Ispulsarcountsame = false
////                            stoptimerIspulsarcountsame.invalidate()
//                        }
////                        timer_quantityless_thanprevious.invalidate()
//                        self.Last_Count = counts as String?
//                        let v = self.quantity.count
//                        let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                        let y = Double(round(100*FuelQuan)/100)
////                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
////                            let y = Double(round(100*FuelQuan)/100)
////                            self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
////                            print(self.tquantity.text!)
////                        }
//                        //else {
////                            let y = Double(round(100*FuelQuan)/100)
////                            self.tquantity.text = "\(y) "
//                      //  }
//                        self.TQuantity.setText("Total Quantity : \(y)")
//                        self.TPulse.setText("Pulse :  \(counts as String)" as String)
//                        self.quantity.append("\(y) ")
//
////                        print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
////                        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////                        print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                        if(v >= 2){
//                            print(self.quantity[v-1],self.quantity[v-2])
//                            if(self.quantity[v-1] == self.quantity[v-2]){
//                                self.total_count += 1
//                                if(self.total_count == 3){
////                                    Ispulsarcountsame = true
////                                    stoptimerIspulsarcountsame.invalidate()
//                                    Samecount = Last_Count
//                                   // self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                                    //self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                }
//                            }
//                            else
//                            {
//                                total_count = 0
//                               // if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
//                               // else{
//
////                                    if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
////
////                                        _ = self.web.SetPulser0()
////                                        print(Vehicaldetails.sharedInstance.MinLimit)
////                                        self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
////                                        self.stopButtontapped()
////                                    }
////                                }
//                            }
//                        }
//                    }
////                    else{
////                        timer_quantityless_thanprevious.invalidate()
////                        timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
////                        self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
////                        print("lower qty. than the prior one.")
////                    }
//                }
//                else{
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//                    let v = self.quantity.count
//                    let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                    let y = Double(round(100*FuelQuan)/100)
//
//                    self.quantity.append("\(y) ")
//
////                    print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
////                    let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////                    print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                    if(v >= 2){
//                        if(self.self.quantity[v-1] == self.quantity[v-2]){
//                            self.total_count += 1
//                            if(self.total_count == 3){
////                                Ispulsarcountsame = true
////                                Samecount = Last_Count
////                                stoptimerIspulsarcountsame.invalidate()
////
////                                self.web.sentlog(func_name: "get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//
////                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: (Vehicaldetails.sharedInstance.pumpoff_time as NSString).doubleValue, target: self, selector: #selector(FuelquantityVC.stopIspulsarcountsame), userInfo: nil, repeats: false)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//
//    //MARK: -  Wifi
//    func checkApprove(uuid:String,lat:String!,long:String!)->String {
//
////        if(Vehicaldetails.sharedInstance.Language == ""){
////            ///Vehicaldetails.sharedInstance.Language = "en-ES"
////        }
//        defaults.set("", forKey: "address")
//        let Url:String = serverURL + "HandlerTrak.ashx"
//        var Email :String
//        if(defaults.string(forKey: "address") == nil){
//            Email = ""
//        }else {
//            Email = defaults.string(forKey: "address")!
//        }
//        let string = uuid + ":" + Email + ":" + "Other" + ":" + "es-ES"
//        let Base64 = convertStringToBase64(string)
//        print(Base64)
//        //self.sentlog(func_name: "checkApprove command sent to server from select hose page", errorfromserverorlink: "", errorfromapp: "")
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
//        request.httpMethod = "POST"
//        request.setValue("Basic " + "\(Base64)" , forHTTPHeaderField: "Authorization")
//        //request.timeoutInterval = 10
//        let bodyData = "Authenticate:I:" + "\(lat!),\(long!)"//,versionno.1.15.17,Device Type:\(UIDevice().type),iOS: \(UIDevice.current.systemVersion)"
//        // print(bodyData)
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//
//        var TransactionId = 0;
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//               // print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.utf8.rawValue)!as String
//                // print(self.reply)
//                let text = self.reply
//                if text!.contains("ResponceMessage"){
//
//                }else{
//                    self.reply = "-1"
//                }
//                //                var check = String((text?.{ !"ResponceMessage".contains($0)})!)
//
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                //print(newString)
//                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "")
//                //self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),uuid(\(uuid)),iOS_version:\(UIDevice.current.systemVersion) , App_version \(Version)", errorfromserverorlink: " ",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//
//            } else {
//                print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                //print(newString)
//               // self.sentlog(func_name: "Check Approve Function with command:Authenticate:I: \(lat!),\(long!),Devicetype:\(UIDevice().type),iOS_version:\(UIDevice.current.systemVersion), App_version \(Version)", errorfromserverorlink:" Response from Server $$\(newString)!!", errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        return reply
//    }
//
//    func convertStringToBase64(_ string: String) -> String
//    {
//        let plainData = string.data(using: String.Encoding.utf8)
//        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        return base64String!
//    }
//
//    func getinfo() {
//
//        let Url:String = "http://192.168.4.1:80/client?command=info"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        //request.timeoutInterval = 10
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task =  URLSession.shared.dataTask(with: request as URLRequest) {  data, response, error in
//            if let data = data {
//                //                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply =  NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//
//                print(self.reply!)
//                let text = self.reply!
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                self.labelres.setText(newString)
//                if(newString.contains("iot_version"))
//                {
//
//                }else{
//
//                    let data1:Data = self.reply.data(using: String.Encoding.utf8)!
//                    do{
//                        //  print(self.sysdata)
//                        self.sysdata = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                        let Version = self.sysdata.value(forKey: "Version") as! NSDictionary
//
////                        let iot_version = Version.value(forKey: "iot_version") as! NSString
////                        let mac_address = Version.value(forKey: "mac_address") as! NSString
////
//
//
//                    }
//                    catch let error as NSError {
//                        print ("Error: \(error.domain)")
//                        let text = error.localizedDescription //+ error.debugDescription
//                        let test = String((text.filter { !" \n".contains($0) }))
//                        let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                        print(newString)
//
//                    }}
//            } else {
//                print(error!)
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//
//
//                self.reply = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//
//
//    }
//
//    func btnBeginFueling() {
//
//       // print("before GetPulser" + cf.dateUpdated)
//
//           // self.GetPulser() ///
//            self.quantity = []
//            self.countfailConn = 0
//           // print("Get Pulsar1" + self.cf.dateUpdated)
//            //self.web.sentlog(func_name: " Send GetPulsar Request Function", errorfromserverorlink: "", errorfromapp: "")
//            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
//            //print("after GetPulser" + self.cf.dateUpdated)
//            print(self.timer)
//
//    }
//
//    @objc func GetPulser() {
//
////        let dateFormatter = DateFormatter()
////
////        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
////        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
////        let defaultTimeZoneStr = dateFormatter.string(from: Date());
////
////        print("before GetPulser" + defaultTimeZoneStr)
////        //cf.delay(0.5) {
////        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////        print("before send GetPulser" + defaultTimeZoneStr1)
//        //  self.web.sentlog(func_name: " Send GetPulsar Request Function", errorfromserverorlink: "", errorfromapp: "")
//
//        let replyGetpulsar1 = Getpulsar()
//
//        print(replyGetpulsar1)
//        let Split = replyGetpulsar1.components(separatedBy: "#")
//        reply1 = Split[0]
//        //let error = Split[1]
//        //  print(reply1)
//        if(self.reply1 == nil || self.reply1 == "-1")
//        {
//            let text = reply1//error.localizedDescription + error.debugDescription
//            let test = String((text?.filter { !" \n".contains($0) })!)
//            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            //self.web.sentlog(func_name: " GetPulsar Count", errorfromserverorlink: "\(Last_Count)", errorfromapp: "")
//
//            countfailConn += 1
//            print(countfailConn)
//            if(countfailConn < 2){
//                // if #available(iOS 11.0, *) {
//                // NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: SSID)
//               // self.web.wifisettings_check(pagename:"Getpulsar_fuelquantity")
//                // countfailConn = 0
//                //                } else {
//                //                    // Fallback on earlier versions
//                //                }
//
//            }else if(countfailConn > 2) {
//                do{
//                    //try self.stoprelay()
//                }
//                catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                  // self.web.sentlog(func_name: "stoprelay", errorfromserverorlink: "\(error)", errorfromapp:"Error: \(error.domain)")
//                }
//            }
//        }
//        else{
//            //timer_noConnection_withlink.invalidate()
//            let data1 = self.reply1.data(using: String.Encoding.utf8)!
//            do{
//                self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//            }catch let error as NSError {
//                let text = error.localizedDescription //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//               // self.web.sentlog(func_name: " GetPulsar Count ", errorfromserverorlink: "\(Last_Count!)", errorfromapp: "")
//                print ("Error: \(error.domain)")
//            }
//
//            if(self.sysdata1 == nil){}
//            else
//            {
//                // print(reply1)
//                let text = reply1
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//               // self.web.sentlog(func_name: " GetPulsar Count ", errorfromserverorlink: "Response from link $$ \(Last_Count)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//                //  print(sysdata1)
//                let objUserData = self.sysdata1.value(forKey: "pulsar_status") as! NSDictionary
//
//                let counts = objUserData.value(forKey: "counts") as! NSString
//                _ = objUserData.value(forKey: "pulsar_status") as! NSNumber
//                let pulsar_secure_status = objUserData.value(forKey: "pulsar_secure_status") as! NSNumber
//
//                self.Last_Count = counts as String?
//               // self.web.sentlog(func_name: " GetPulsar Count ", errorfromserverorlink: "Response from link $$ \(Last_Count!)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//
//                if (counts == ""){
////                    self.emptypulsar_count += 1
////                    if(self.emptypulsar_count == 3){
////                       // Vehicaldetails.sharedInstance.gohome = true
////                        self.timerview.invalidate()
////                        let appDel = UIApplication.shared.delegate! as! AppDelegate
////                        self.web.sentlog(func_name: " Get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())") //errorfromserverorlink: "", errorfromapp: "")
////                        appDel.start()
////                    }
//                }
//                else if (counts == "0")
//                {
//                    if(Last_Count == nil){
//                        Last_Count = "0.0"
//                    }
//                    let v = self.quantity.count
//                    self.quantity.append("0")
//                    if(v >= 2){
//                        print(self.quantity[v-1],self.quantity[v-2])
//                        if(self.quantity[v-1] == self.quantity[v-2]){
//                            self.total_count += 1
//                            if(self.total_count == 3){
//                                Ispulsarcountsame = true
//                                stoptimerIspulsarcountsame.invalidate()
//                                Samecount = Last_Count
//
//                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: ("10" as NSString).doubleValue, target: self, selector: #selector(stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                               // self.web.sentlog(func_name:"Get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())") //errorfromserverorlink: "", errorfromapp: "")
//                            }
//                        }
//                    }
//                }
//                else{
//
//                    self.emptypulsar_count = 0
//                    if (counts != "0"){
//
////                        self.start.isHidden = true
////                        self.cancel.isHidden = true
//                        // stoptimerIspulsarcountsame.invalidate()
//                        //transaction Status send only one time.
//                       // let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                        if(reply_server == "")
//                        {
//                        //    self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
//                        //   reply_server = "Sendtransaction"
//                        }
//                        //print(self.tpulse.text!, counts)
//
////                        if (self.tpulse.text! == (counts as String) as String){
////
////                        }
//                        if(Last_Count == nil){
//                            Last_Count = "0.0"
//                        }
//
//                        if(counts.doubleValue >= (Last_Count as NSString).doubleValue)
//                        {
//                            if(counts.doubleValue > (Last_Count as NSString).doubleValue){
//                                Ispulsarcountsame = false
//                                stoptimerIspulsarcountsame.invalidate()
//                            }
//                            timer_quantityless_thanprevious.invalidate()
//                            self.Last_Count = counts as String?
//                            let v = self.quantity.count
//                            let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                            let y = Double(round(100*FuelQuan)/100)
////                            if(Vehicaldetails.sharedInstance.Language == "es-ES"){
////                                let y = Double(round(100*FuelQuan)/100)
////                                self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
////                                print(self.tquantity.text!)
////                            }
////                            else {
//                               // let y = Double(round(100*FuelQuan)/100)
////                                self.tquantity.text = "\(y) "
////                            }
//
//                            self.TPulse.setText(counts as String)
//                            self.TQuantity.setText("\(y)")
//                            self.quantity.append("\(y) ")
//
//                            //print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
////                            let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////                            print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                            if(v >= 2){
//                                print(self.quantity[v-1],self.quantity[v-2])
//                                if(self.quantity[v-1] == self.quantity[v-2]){
//                                    self.total_count += 1
//                                    if(self.total_count == 3){
//                                        Ispulsarcountsame = true
//                                        stoptimerIspulsarcountsame.invalidate()
//                                        Samecount = Last_Count
//                                        self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: ("10" as NSString).doubleValue, target: self, selector: #selector(stopIspulsarcountsame), userInfo: nil, repeats: false)
//
//                                        //self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                    }
//                                }
////                                else {
////                                    self.total_count = 0
////
////                                    if(pulsar_secure_status == 0){
////
////                                    }
////                                    else if(pulsar_secure_status == 1)
////                                    {
////                                        self.displaytime.text = "5"
////                                    }
////
////                                    else if(pulsar_secure_status == 2)
////                                    {
////                                        self.displaytime.text = "4"
////                                    }
////
////                                    else if(pulsar_secure_status == 3)
////                                    {
////                                        self.displaytime.text = "3"
////                                    }
////
////                                    else if(pulsar_secure_status == 4)
////                                    {
////                                        self.displaytime.text = "2"
////                                    }
////
////                                    else if(pulsar_secure_status == 5)
////                                    {
////                                        self.displaytime.text = "1 \n \n " + NSLocalizedString("Pulsardisconnected", comment: "")
////                                        self.stopButtontapped()
////                                    }
////
////                                    if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
////                                    else{
////
////                                        if(Int(Vehicaldetails.sharedInstance.MinLimit)! <= Int(FuelQuan)){
////
////                                            _ = self.web.SetPulser0()
////                                            print(Vehicaldetails.sharedInstance.MinLimit)
////                                            if(Vehicaldetails.sharedInstance.LimitReachedMessage != ""){
////                                            self.showAlert(message:"\(Vehicaldetails.sharedInstance.LimitReachedMessage)" )
////                                            }
////                                            //self.showAlert(message: NSLocalizedString("Fueldaylimit", comment:"") )//"You are fuel day limit reached.")
////                                            self.stopButtontapped()
////                                        }
////                                    }
////                                }
//                            }
//                        }
////                        else{
////                            timer_quantityless_thanprevious.invalidate()
////                            timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(FuelquantityVC.stoprelay), userInfo: nil, repeats: false)
////                            self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
////                            print("lower qty. than the prior one.")
////                        }
//                    }
//                    else{
//                        if(Last_Count == nil){
//                            Last_Count = "0.0"
//                        }
//                        let v = self.quantity.count
//                        let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                        let y = Double(round(100*FuelQuan)/100)
//
//                        self.quantity.append("\(y) ")
//
//                        //print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y,Vehicaldetails.sharedInstance.pumpoff_time)
////                        let defaultTimeZoneStr1 = dateFormatter.string(from: Date());
////                        print("Inside loop GetPulser" + defaultTimeZoneStr1)
//                        if(v >= 2){
//                            if(self.self.quantity[v-1] == self.quantity[v-2]){
//                                self.total_count += 1
//                                if(self.total_count == 3){
//                                    Ispulsarcountsame = true
//                                    Samecount = Last_Count
//                                    stoptimerIspulsarcountsame.invalidate()
//
//                                   // self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())") //errorfromserverorlink: "", errorfromapp: "")
//
//                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: ("10" as NSString).doubleValue, target: self, selector: #selector(stopIspulsarcountsame), userInfo: nil, repeats: false)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//
//     func Get_Pulser()->String {
//
////        NetworkEnable()
////        //"http://192.168.4.1:80/client?command=info"
////        let datastring = "GET /client?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
////
////
////        let data = datastring.data(using: String.Encoding.utf8)!
////
////        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////        var outputdata :String = self.stringbuffer
////        Thread.sleep(forTimeInterval:1)
////        print(outputdata)
////        let text = self.stringbuffer
////
//////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
////        let test = String((text.filter { !" \n".contains($0) }))
////        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
////        print(newString)
////        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
////        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
////        print(newString)
////        labelres.setText(newString1)
////
////
////        if(self.stringbuffer == ""){}
////        else{
////            if(outputdata.contains("{"))
////            {
////            let Split = outputdata.components(separatedBy: "{")
////            _ = Split[0]
////            let setrelay = Split[1]
////            let setrelaystatus = Split[2]
////            outputdata = setrelay + "{" + setrelaystatus
////            }
////        }
////        return outputdata
//        let Url:String = "http://192.168.4.1:80/client?command=pulsar"
//        var replygetpulsar = ""
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string:Url)!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 5 //////timeout interval should be increased it is 4 earlier now i am convert it to 10
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                // DispatchQueue.main.async{
//                replygetpulsar = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                // print(self.replygetpulsar)
//
//
//
//            } else {
//                print(error!)
//
//                let text = (error?.localizedDescription)! //+ error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//               // self.sentlog(func_name: "GetPulser Service Function", errorfromserverorlink: " Response from Link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                //self.replygetpulsar = "-1" + "#" + "\(error!)"
//            }
//            semaphore.signal()
//
//        }
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//
//        return replygetpulsar + "#" + ""
//    }
//
////        func upgrade() {
////            //upgrade link with new firmware
////            NetworkEnable()
////            let datastring = "POST /upgrade?command=start HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
////            let data : Data = datastring.data(using: String.Encoding.utf8)!
////            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////            let outputdata :String = stringbuffer
////            if(stringbuffer == ""){}
////            else{
////                print( stringbuffer)
////            }
////            print(outputdata)
////            self.uploadbinfile()
////           sleep(2)
////                self.resetdata()
////
////        }
//
////        func resetdata()  {
////            NetworkEnable()
////            let datastring = "POST /upgrade?command=reset HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
////            let data : Data = datastring.data(using: String.Encoding.utf8)!
////            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////            let outputdata :String = stringbuffer
////            print( outputdata)
////        }
//
////        func uploadbinfile(){
////            //Download new link from Server using getbinfile and upload/Flash the file to FS link.
////            self.bindata = self.getbinfile()
////            let Url:String = "http://192.168.4.1:80"
////            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
////           // print(bindata)
////            request.setValue("\(self.bindata.length)", forHTTPHeaderField: "Content-Length")
////            request.httpMethod = "POST"
////            request.httpBody = (self.bindata! as Data)
////           // self.lable.text = "Start Upgrade...."
////            let session = Foundation.URLSession.shared
////            let semaphore = DispatchSemaphore(value: 0)
////            let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
////                if let data = data {
////                    print(String(data: data, encoding: String.Encoding.utf8)!)
////                    self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
////                   // print(self.reply)
////                }  else {
////                    print(error!)
////                    self.reply = "-1"
////                }
////                semaphore.signal()
////            }
////            task.resume()
////            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
////        }
//
////        func getbinfile() -> NSData
////        {
////            let Url:String = Vehicaldetails.sharedInstance.FilePath
////            let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string: Url)! as URL)
////            request.httpMethod = "GET"
////            //request.timeoutInterval = 150
////            let session = Foundation.URLSession.shared
////            let semaphore = DispatchSemaphore(value: 0)
////            let task =  session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
////                if let data = data {
////    //                print(data,String(data: data, encoding: String.Encoding.utf8)!)
////                    self.replydata = data as NSData
////                } else {
////                    print(error!)
////                }
////                semaphore.signal()
////            }
////            task.resume()
////            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
////            return replydata
////        }
//
////        func getuser(){
////            if(Vehicaldetails.sharedInstance.reachblevia == "cellular"){
////                NetworkEnable()
////                let datastring = "GET /upgrade?command=getuser HTTP/1.1\r\nHost: 192.168.4.1\r\n\r\n";
////                let data : Data = datastring.data(using: String.Encoding.utf8)!
////                outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
////                let outputdata = stringbuffer
////                print( outputdata)
////                self.upgrade()
////            }
////        }
//
//
//        //Network functions
//
////    func cleanup() {
////      guard discoveredPeripheral?.state != .disconnected,
////        let services = discoveredPeripheral?.services else {
////          centralManager.cancelPeripheralConnection(discoveredPeripheral!)
////          return
////      }
////      for service in services {
////        if let characteristics = service.characteristics {
////          for characteristic in characteristics {
////            if characteristic.uuid.isEqual(textCharacteristicUUID) {
////              if characteristic.isNotifying {
////                discoveredPeripheral?.setNotifyValue(false, for: characteristic)
////                return
////              }
////            }
////          }
////        }
////      }
////      centralManager.cancelPeripheralConnection(discoveredPeripheral!)
////    }
////
//    func pulsarlastquantity(){
//        let Url:String = "http://192.168.4.1:80/client?command=record10"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
//        request.httpMethod = "GET"
//
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                //  print(self.pulsardata)
//                let text = self.pulsardata
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//               // self.sentlog(func_name: "Fueling Page Get Pulsar_LastQuantity Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
//                do{
//                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                }catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                }
//                if(self.sysdata1 == nil){}
//                else{
//                    if(newString.contains("N/A"))
//                    {
//                        let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
//                        let counts_data = objUserData.value(forKey: "1:") as! NSString
//                        if(counts_data == "N/A"){}
//                        else{
//                            let t_count = Int(truncating: Int(counts_data as String)! as NSNumber)
//                        print(t_count)
//                       // Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//                        }
//
//                    }
//                    else{
//                    let objUserData = self.sysdata1.value(forKey: "quantity_10_record") as! NSDictionary
//                    let counts_data = objUserData.value(forKey: "1:") as! NSNumber
//
//                        let t_count = Int(truncating: counts_data)
//                    print(t_count)
//                    //Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//
//                    }
//                }
//            } else {
//                print(error as Any)
//                self.pulsardata = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//    }
//
//    func cmtxtnid10(){
//        //Vehicaldetails.sharedInstance.Last10transactions = []
//        let Url:String = "http://192.168.4.1:80/client?command=cmtxtnid10"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:NSURL(string:Url)! as URL)
//        request.httpMethod = "GET"
//
//        let session = Foundation.URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
//            if let data = data {
//                self.pulsardata = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                 // print(self.pulsardata)
//                let text = self.pulsardata
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                if(newString == ""){
//                    // Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
//                }
//               // self.sentlog(func_name: "Fueling Page Get cmtxtnid10 Function", errorfromserverorlink: " Response from link \(newString)",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                let data1:NSData = self.pulsardata.data(using: String.Encoding.utf8)! as NSData
//                do{
//                    self.sysdataLast10trans = try JSONSerialization.jsonObject(with: data1 as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                }catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                    self.sysdataLast10trans = nil
//                }
//                if(self.sysdataLast10trans == nil){
//                     //Vehicaldetails.sharedInstance.Last_transactionformLast10 = ""
//                }
//                else{
//
//                    if(newString.contains("TXTNINFO")){
//                        //  print(self.sysdataLast10trans)
//                        let objUserData = self.sysdataLast10trans.value(forKey: "cmtxtnid_10_record") as! NSDictionary
//                        let txtninfo1 = objUserData.value(forKey: "1:TXTNINFO:") as! String
//                        let txtninfo2 = objUserData.value(forKey: "2:TXTNINFO:") as! String
//                        let txtninfo3 = objUserData.value(forKey: "3:TXTNINFO:") as! String
//                        let txtninfo4 = objUserData.value(forKey: "4:TXTNINFO:") as! String
//                        let txtninfo5 = objUserData.value(forKey: "5:TXTNINFO:") as! String
//                        let txtninfo6 = objUserData.value(forKey: "6:TXTNINFO:") as! String
//                        let txtninfo7 = objUserData.value(forKey: "7:TXTNINFO:") as! String
//                        let txtninfo8 = objUserData.value(forKey: "8:TXTNINFO:") as! String
//                        let txtninfo9 = objUserData.value(forKey: "9:TXTNINFO:") as! String
//                        let txtninfo10 = objUserData.value(forKey: "10:TXTNINFO:") as! String
//
//                        self.Splitedata1(trans_info: txtninfo1)
//                        self.Splitedata(trans_info: txtninfo1)
//                        self.Splitedata(trans_info: txtninfo2)
//                        self.Splitedata(trans_info: txtninfo3)
//                        self.Splitedata(trans_info: txtninfo4)
//                        self.Splitedata(trans_info: txtninfo5)
//                        self.Splitedata(trans_info: txtninfo6)
//                        self.Splitedata(trans_info: txtninfo7)
//                        self.Splitedata(trans_info: txtninfo8)
//                        self.Splitedata(trans_info: txtninfo9)
//                        self.Splitedata(trans_info: txtninfo10)
//                    }
//                    else {
//
//                    //  print(self.sysdataLast10trans)
//                    let objUserData = self.sysdataLast10trans.value(forKey: "cmtxtnid_10_record") as! NSDictionary
//                    let txtninfo1 = objUserData.value(forKey:"1:") as! String
//                    let txtninfo2 = objUserData.value(forKey:"2:") as! String
//                    let txtninfo3 = objUserData.value(forKey:"3:") as! String
//                    let txtninfo4 = objUserData.value(forKey:"4:") as! String
//                    let txtninfo5 = objUserData.value(forKey:"5:") as! String
//                    let txtninfo6 = objUserData.value(forKey:"6:") as! String
//                    let txtninfo7 = objUserData.value(forKey:"7:") as! String
//                    let txtninfo8 = objUserData.value(forKey:"8:") as! String
//                    let txtninfo9 = objUserData.value(forKey:"9:") as! String
//                    let txtninfo10 = objUserData.value(forKey:"10:") as! String
//
//                    self.Splitedata1(trans_info: txtninfo1)
//                    self.Splitedata(trans_info: txtninfo1)
//                    self.Splitedata(trans_info: txtninfo2)
//                    self.Splitedata(trans_info: txtninfo3)
//                    self.Splitedata(trans_info: txtninfo4)
//                    self.Splitedata(trans_info: txtninfo5)
//                    self.Splitedata(trans_info: txtninfo6)
//                    self.Splitedata(trans_info: txtninfo7)
//                    self.Splitedata(trans_info: txtninfo8)
//                    self.Splitedata(trans_info: txtninfo9)
//                    self.Splitedata(trans_info: txtninfo10)
//
//                    }
//                    //                    let t_count = Int(truncating: counts)
//                    //                    print(t_count)
//                    //                    Vehicaldetails.sharedInstance.FinalQuantitycount = "\(t_count)"
//                }
//            } else {
//                print(error as Any)
//                self.pulsardata = "-1"
//            }
//            semaphore.signal()
//        }
//        task.resume()
//    }
//
//    func Splitedata1(trans_info:String){
//        let Split = trans_info.components(separatedBy: "-")
//
//        let transid = Split[0];
//        //let pulses = Split[1];
//
//        //Vehicaldetails.sharedInstance.Last_transactionformLast10 = transid
//
//
//    }
//
//    func Splitedata(trans_info:String){
//        let Split = trans_info.components(separatedBy: "-")
//
//        let transid = Split[0];
//        let pulses = Split[1];
//        if(pulses == "N/A"){}
//        else{
//        let quantity = self.calculate_fuelquantity(quantitycount: Int(pulses as String)!)
//       // let transaction_details = Last10Transactions(Transaction_id: transid, Pulses: pulses, FuelQuantity: "\(quantity)")
//        //Vehicaldetails.sharedInstance.Last10transactions.add(transaction_details)
//    }
//    }
//  }
//// MARK: - Stream delegate
//extension InterfaceControllerWifi: StreamDelegate
//{
//    //TCP Communication with the FS link using Follwing Method Functions.
//    func closestreams(){
//
//        if let inputStr = self.inStream{
//                        inputStr.close()
////            inputStr.remove(from: .main, forMode: RunLoop.Mode.tracking)
////            inputStr.remove(from: .main, forMode: RunLoop.Mode.common)
//            inputStr.remove(from: .main, forMode: RunLoop.Mode.default)
//        }
//        if let outputStr = self.outStream{
//                        outputStr.close()
//                        outputStr.remove(from: .main, forMode: RunLoop.Mode.default)
////            outputStr.remove(from: .main, forMode: RunLoop.Mode.tracking)
////            outputStr.remove(from: .main, forMode: RunLoop.Mode.common)
//        }
//        inStream?.remove(from: .init(), forMode: RunLoop.Mode.default)
//        outStream?.remove(from: .init(), forMode: RunLoop.Mode.default)
//        self.inStream?.close()
//        self.outStream?.close()
//        inStream?.delegate = nil
//        outStream?.delegate = nil
//
//
//    }
//
//    func setdefault(){
//        stringbuffer = ""
//        //buffer = []
//    }
//
//
//
//
//    func Getinfo()->String{
//        NetworkEnable()
//        //"http://192.168.4.1:80/client?command=info"
//        let datastring = "GET /client?command=info HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        //Thread.sleep(forTimeInterval:1)
//        if((outputdata.contains("iot_version")))
//        {
//            outputdata = "true"
//        }
//        else
//        {
//            outputdata = "false"
//        }
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//
//
////        if(self.stringbuffer == ""){}
////        else{
////            if(outputdata.contains("{"))
////            {
////            let Split = outputdata.components(separatedBy: "{")
////            _ = Split[0]
////            let setrelay = Split[1]
////            let setrelaystatus = Split[2]
////            outputdata = setrelay + "{" + setrelaystatus
////            }
////        }
//        return outputdata
//    }
//
//    func Getpulsar()->String{
//        NetworkEnable()
//        //"http://192.168.4.1:80/client?command=info"
//        let datastring = "GET /client?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        //Thread.sleep(forTimeInterval:1)
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//        //labelres.setText(newString1)
//
//
//        if(self.stringbuffer == ""){}
//        else{
//            if(outputdata.contains("{"))
//            {
//            let Split = outputdata.components(separatedBy: "{")
//            _ = Split[0]
//            let setrelay = Split[1]
//            let setrelaystatus = Split[2]
//            outputdata = setrelay + "{" + setrelaystatus
//            }
//        }
//        return outputdata
//    }
//
//    func Getrelay()->String{
//        NetworkEnable()
//        //"http://192.168.4.1:80/client?command=info"
//        let datastring = "GET /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//
//        let data = datastring.data(using: String.Encoding.utf8)!
//
//        self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//        var outputdata :String = self.stringbuffer
//        //Thread.sleep(forTimeInterval:1)
//        print(outputdata)
//        let text = self.stringbuffer
//
////        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//        let test = String((text.filter { !" \n".contains($0) }))
//        let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//        print(newString)
//        let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//        let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//        print(newString)
//        labelres.setText(newString1)
//
//
//        if(self.stringbuffer == ""){}
//        else{
//            if(outputdata.contains("{"))
//            {
//            let Split = outputdata.components(separatedBy: "{")
//            _ = Split[0]
//            let setrelay = Split[1]
//            let setrelaystatus = Split[2]
//            outputdata = setrelay + "{" + setrelaystatus
//            }
//        }
//        return outputdata
//    }
//
//    func getrelay() -> String {
//        let Url:String = "http://192.168.4.1:80/config?command=relay"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: Url)!)
//        request.timeoutInterval = 20
//
//        request.httpMethod = "GET"
//
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//                self.reply = NSString(data: data, encoding:String.Encoding.ascii.rawValue)! as String
//                let text = self.reply
//                let test = String((text?.filter { !" \n".contains($0) })!)
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//                //self.sentlog(func_name: "Start Button Tapped GetRelay Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//
//            } else {
//                print(error!)
//                let text = (error?.localizedDescription)!// + error.debugDescription
//                let test = String((text.filter { !" \n".contains($0) }))
//                let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//                print(newString)
//               // self.sentlog(func_name: "Start Button Tapped GetRelay Function", errorfromserverorlink: " Response from link $$ \(newString)!!",errorfromapp: " Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + " Connected link : \(self.cf.getSSID())")
//                self.reply = "-1" + "#" + "\(error!)"
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//
//        return reply + "#" + ""
//    }
//
//        func setralaytcp()->String{
//            NetworkEnable()
//
//            let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
//            print(s.count)
//            let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":1}}"
//
//            let data = datastring.data(using: String.Encoding.utf8)!
//
//            self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            var outputdata :String = self.stringbuffer
//            //Thread.sleep(forTimeInterval:1)
//            print(outputdata)
//            let text = self.stringbuffer
//
//    //        Get the output from the link in JSON Format remove the New line, spaces and null characters and then send log to server using sendlog function.
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"" , with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//            print(newString)
//            labelres.setText(newString1)
//
//
//            if(self.stringbuffer == ""){}
//            else{
//                if(outputdata.contains("{"))
//                {
//                let Split = outputdata.components(separatedBy: "{")
//                _ = Split[0]
//                let setrelay = Split[1]
//                let setrelaystatus = Split[2]
//                outputdata = setrelay + "{" + setrelaystatus
//                }
//            }
//            return outputdata
//        }
//
//
//
//            func preauthsetSamplingtime()->String{
//
//                NetworkEnable()
//                let PulserTimingAdjust = "20"
//                let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(PulserTimingAdjust)!)}}"
//                print(s.count)
//                let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(PulserTimingAdjust)!)}}"
//                let data : Data = datastring.data(using: String.Encoding.utf8)!
//                outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//                let outputdata = stringbuffer
//                return outputdata
//            }
//
//
//        func setSamplingtime()->String{
//
//            NetworkEnable()
//            let PulserTimingAdjust = "10"
//            let s:String = "{\"pulsar_status\":{\"sampling_time_ms\":\(Int(PulserTimingAdjust)!)}}"
//            print(s.count)
//            let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count))\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"sampling_time_ms\":\(Int(PulserTimingAdjust)!)}}"
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            let outputdata = stringbuffer
//            let text = self.stringbuffer
//            let test = String((text.filter { !" \n".contains($0) }))
//            let responsestring = test.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString = responsestring.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            labelres.setText(newString)
//
//            return outputdata
//        }
//
//        func setralay0tcp()->String{
//            NetworkEnable()
//            let s:String = "{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
//            print(s.count)
//            let datastring = "POST /config?command=relay HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: 52\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"relay_request\":{\"Password\":\"12345678\",\"Status\":0}}"
//
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            self.outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//            let outputdata = stringbuffer
//            let text = self.stringbuffer
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//            labelres.setText(newString)
//            return outputdata
//        }
//
//
//
//        func tlddata() {
//            NetworkEnable()
//
//            let datastring = "GET /tld?level=info HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n"
//
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//            let outputdata = stringbuffer
//            let text = stringbuffer
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//            labelres.setText(newString1)
//
//            print(outputdata)
//            print(datastring)
//
//                let Split = outputdata.components(separatedBy: "{")
//                if(Split.count < 3){
//                    _ = self.setralay0tcp()
//
//                }    // got invalid respose do nothing
//                else{
//                    let reply = Split[1]
//                    let setrelay = Split[2]
//                    let Split1 = setrelay.components(separatedBy: "}")
//                    let setrelay1 = Split1[0]
//                    self.tlddatafromlink = "{" +  reply + "{" + setrelay1 + "}" + "}"
//                    self.sendtld(replytld: self.tlddatafromlink)
//                }
//
//        }
//
//        func sendtld(replytld: String)
//        {
//            print(replytld);
//            if(replytld == "nil" || replytld == "-1")
//            {
//            }
//            else{
//                let data1 = replytld.data(using: String.Encoding.utf8)!
//                do{
//                    self.sysdata1 = try JSONSerialization.jsonObject(with: data1, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                }catch let error as NSError {
//                    print ("Error: \(error.domain)")
//                }
//
//                if(self.sysdata1 == nil){}
//                else
//                {
//                    let objUserData = self.sysdata1.value(forKey: "tld") as! NSDictionary
//                    let Response_code = objUserData.value(forKey: "Response_code") as! NSNumber
//                    let checksum = objUserData.value(forKey: "Checksum") as! NSNumber
//                    let LSB = objUserData.value(forKey: "LSB") as! NSNumber
//                    let MSB = objUserData.value(forKey: "MSB") as! NSNumber
//                    let Mac_address = objUserData.value(forKey: "Mac_address") as! NSString
//                    let TLDTemperature = objUserData.value(forKey: "Tem_data") as! NSNumber
//                    print(LSB,MSB,Mac_address)
//                    // let probereading = self.GetProbeReading(LSB:Int(LSB),MSB:Int(MSB))
//                    let uuid = self.defaults.string(forKey: "uuid")
//                    let siteid = "1"//""Vehicaldetails.sharedInstance.siteID
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a" //9/25/2017 10:21:41 AM"
//                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//                    let dtt: String = dateFormatter.string(from: NSDate() as Date)
//
//                     let bodyData = try! JSONSerialization.data(withJSONObject: ["FromSiteId":siteid,"IMEI_UDID":uuid!,"LSB":LSB,"MSB":MSB,"TLDTemperature":TLDTemperature,"ReadingDateTime":dtt,"TLD":Mac_address,"Response_code":Response_code,"Checksum":checksum], options: [])
//                   // let bodyData = "{\"FromSiteId\":\(siteid),\"IMEI_UDID\":\"\((uuid!))\",\"LSB\":\"\(LSB)\",\"MSB\":\"\(MSB)\",\"TLDTemperature\":\"\(TLDTemperature)\",\"ReadingDateTime\":\"\(dtt)\",\"TLD\":\"\(Mac_address)\"}"
//
////                    let reply = self.web.tldsendserver(bodyData: bodyData)
////                    print(reply)
////                    if (reply == "-1")
////                    {
////                        //let unsycnfileName =  dtt + "#" + "\(probereading)" + "#" + "\(siteid)"// + "#" + "SaveTankMonitorReading" //
////    //                    if(bodyData != ""){
////    //                        //  cf.SaveTextFile(fileName: unsycnfileName, writeText: bodyData)
////    //                    }
////                    }
//                }
//            }
//        }
//
//
//        func changessidname(wifissid:String) {
//            NetworkEnable()
//            let password = "123456789" //Vehicaldetails.sharedInstance.password
//            let s:String = "{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
//            print(s.count)
//            let datastring = "POST /config?command=wifi HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"Request\":{\"Softap\":{\"Connect_Softap\":{\"authmode\":\"WPAPSK/WPA2PSK\",\"channel\":6,\"ssid\":\"\(wifissid)\",\"password\":\"\(password)\"}}}}"
//
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//            let outputdata = stringbuffer
//            let text = stringbuffer
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//
//            labelres.setText(newString1)
//            print(outputdata)
//            print(datastring)
//
//        }
//
//
//        ///set PulsarStoptime to hose.
//
//        func setpulsaroffTime(){
//
//                let PulserStopTime = "25"
//
//
//            let time:Int = (Int(PulserStopTime)!+3) * 1000
//            print(time)
//            NetworkEnable()
//            let s:String = "{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
//            print(s.count)
//            let datastring = "POST /config?command=pulsar HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"pulsar_status\":{\"pulsar_off_time\":\(time)}}"
//
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//            let outputdata = stringbuffer
//            let text = stringbuffer
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//
//            labelres.setText(newString1)
//
//            print(datastring)
//
//
//        }
//
//
//        func settransaction_IDtoFS(){
//            let count:Int = "\(22)".count
//            var format = "0000000000"
//
//            let range = format.index(format.endIndex, offsetBy: -count)..<format.endIndex
//            format.removeSubrange(range)
//            print(format)
//            let txtnid:String = format + "\(22)"
//            print(txtnid)
//            NetworkEnable()
//            let s:String = "{\"txtnid\":\(txtnid)}"
//            print(s.count)
//            let datastring = "POST /config?command=txtnid HTTP/1.1\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: \(s.count)\r\nHost: 192.168.4.1\r\nConnection: Keep-Alive\r\nAccept-Encoding: gzip\r\nUser-Agent: okhttp/3.6.0\r\n\r\n{\"txtnid\":\(txtnid)}"
//
//            let data : Data = datastring.data(using: String.Encoding.utf8)!
//            outStream?.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
//
//            let outputdata = stringbuffer
//            let text = self.stringbuffer
//            let test = String((text.filter { !" \n".contains($0) }))
//            let newString = test.replacingOccurrences(of: "\"", with: " ", options: .literal, range: nil)
//            print(newString)
//            let responsestring = newString.replacingOccurrences(of: "\0" , with: " ", options: .literal, range: nil)
//            let newString1 =  String((responsestring.filter { !" \n".contains($0) }))
//
//            labelres.setText(newString1)
//            print(outputdata)
//            print(datastring)
//        }
//
//
//    func NetworkEnable() {
//
//        print("NetworkEnable")
//
//
//        Stream.getBoundStreams(withBufferSize: 4096, inputStream: &inStream, outputStream: &outStream) //getStreamsToHost(withName: addr, port: port, inputStream: &inStream, outputStream: &outStream)
//
//        inStream?.delegate = self
//        outStream?.delegate = self
//
//        inStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
//        outStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
//
//        inStream?.open()
//        outStream?.open()
//
//
//
//    }
//
//    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
//        var buffer = [UInt8](repeating: 0, count: 4096)
//        switch eventCode {
//
//        case Stream.Event.endEncountered:
//            print("EndEncountered")
//
//            inStream?.close()
//            inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)//RunLoopMode.defaultRunLoopMode
//            outStream?.close()
//            print("Stop outStream currentRunLoop")
//            outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//
//        case Stream.Event.errorOccurred:
//            print("ErrorOccurred")
//            inStream?.close()
//            inStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//            outStream?.close()
//            outStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//            print("Close")
//
//        case Stream.Event.hasBytesAvailable:
//            print("HasBytesAvailable")
//            status = "HasBytesAvailable"
//            if aStream == inStream {
//                inStream!.read(&buffer, maxLength: buffer.count)
//                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
//                stringbuffer += bufferStr! as String
//                print(bufferStr!)
//            }
//            break
//
//        case Stream.Event.hasSpaceAvailable:
//            print("HasSpaceAvailable")
//
//        case Stream.Event():
//            print("None")
//
//        case Stream.Event.openCompleted:
//            print("OpenCompleted")
//
//        default:
//            print("Unknown")
//        }
//    }
//}
