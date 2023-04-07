////
////  InterfaceControllerUDP.swift
////  FluidSecureWatchOS Extension
////
////  Created by apple on 05/04/21.
////  Copyright © 2021 VASP. All rights reserved.
////
//import WatchKit
//import Foundation
//import Network
//import UIKit
//import CoreLocation
//import CoreBluetooth
//
//class InterfaceControllerUDP: WKInterfaceController {
//    
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
//    
//   // private let SSID = "\(Vehicaldetails.sharedInstance.SSId)"
//
//    @IBOutlet weak var Labelresponse: WKInterfaceLabel!
//    @IBOutlet weak var Quantitylbl: WKInterfaceLabel!
//    @IBOutlet weak var Pulselbl: WKInterfaceLabel!
//    
//override func awake(withContext context: Any?) {
//    self.connectToUDP(self.hostUDP,self.portUDP)
////        if( ifSubscribed == false){
////        centralManager = CBCentralManager(delegate: self, queue: nil)
////        }
//    // Configure interface objects here.
//}
//
//override func willActivate() {
//    
//    // This method is called when watch view controller is about to be visible to user
//}
//
//override func didDeactivate() {
//    // This method is called when watch view controller is no longer visible
//}
//    @IBAction func Infobuttontapped() {
//        self.connectToUDP(self.hostUDP,self.portUDP)
//    }
//    @IBAction func startButtonTapped() {
//        let messageToUDP = "LK_COMM=relay:12345=ON"
////        self.web.sentlog(func_name: " Send Relay On Command to link \(messageToUDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//        sendUDP(messageToUDP)
//        self.receiveUDP()
//    }
//    
//    func btnBeginFueling()
//    {
////        print("before GetPulser" + cf.dateUpdated)
//      
//        self.quantity = []
//        self.countfailConn = 0
////        print("Get Pulsar1" + self.cf.dateUpdated)
//        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.GetPulser), userInfo: nil, repeats: true)
//        self.timerFDCheck = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.FDCheck), userInfo: nil, repeats: true)
//        //print("after GetPulser" + self.cf.dateUpdated)
//        print(self.timer)
//    }
//    
//    @objc func FDCheck()
//    {
//        let MessageuDP = "LK_COMM=FD_check"
//            self.sendUDP(MessageuDP)
//        //self.web.sentlog(func_name: "UDP Function ", errorfromserverorlink: "Send FD check",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//       self.receiveUDP()
//    }
//    
//    func calculate_fuelquantity(quantitycount: Int)-> Double
//    {
//        if(quantitycount == 0)
//        {
//            fuelquantity = 0
//        }
//        else{
//            //Vehicaldetails.sharedInstance.pulsarCount = "\(quantitycount)"
//            let PulseRatio = "10"//Vehicaldetails.sharedInstance.PulseRatio
//            fuelquantity = (Double(quantitycount))/(PulseRatio as NSString).doubleValue
//        }
//        return fuelquantity
//    }
//    
//    @available(iOS 12.0, *)
//    @objc func GetPulser()
//    {
//        self.receiveUDP()
//               
//        if(self.pulsedata == "")
//        {
//            let messageToUDP = "LK_COMM=relay:12345=ON"
//          //  self.web.sentlog(func_name: " Send Relay On Command to link \(messageToUDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//
//                self.sendUDP(messageToUDP)
//
//          self.receiveUDP()
//        }
//        else if(self.pulsedata != ""){
//            print(self.pulsedata)
//            
//            let counts = self.pulsedata.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
//            //self.web.sentlog(func_name: "UDP Function ", errorfromserverorlink: "Count from link $$ \(counts)!!",errorfromapp: "Selected Hose :\(Vehicaldetails.sharedInstance.SSId)" + "Connected link : \(self.cf.getSSID())")
//            
//            if (counts == ""){
//                self.emptypulsar_count += 1
//                if(self.emptypulsar_count == 3){
//                   // Vehicaldetails.sharedInstance.gohome = true
////                    self.timerview.invalidate()
////                    let appDel = UIApplication.shared.delegate! as! AppDelegate
////                    self.web.sentlog(func_name: " Get emptypulsar_count function (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
////
////                    appDel.start()
////                    self.connection?.cancel()
//                }
//            }
//            else if (counts == "0")
//            {
//                if(self.Last_Count == nil){
//                    self.Last_Count = "0.0"
//                }
//                let v = self.quantity.count
//                self.quantity.append("0")
//                if(v >= 2){
//                    print(self.quantity[v-1],self.quantity[v-2])
//                    if(self.quantity[v-1] == self.quantity[v-2]){
//                        self.total_count += 1
//                        if(self.total_count == 3){
//                            self.Ispulsarcountsame = true
//                            self.stoptimerIspulsarcountsame.invalidate()
//                            self.Samecount = self.Last_Count
//                                                        
//                            self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: ("10" as NSString).doubleValue, target: self, selector: #selector(stopIspulsarcountsame), userInfo: nil, repeats: false)
//                            
//                           // self.web.sentlog(func_name:"Get pulse count was the same while fueling function pump on time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//                        }}}
//            }
//            else{
//                
//                self.emptypulsar_count = 0
//                if (counts != "0"){
//                
//                   // self.start.isHidden = true
//                    //
//                    //transaction Status send only one time.
//                    //let Transaction_id = Vehicaldetails.sharedInstance.TransactionId
//                    if(self.reply_server == "")
//                    {
//                        //self.web.UpgradeTransactionStatus(Transaction_id:"\(Transaction_id)", Status: "8")
//                        self.reply_server = "Sendtransaction"
//                    }
//                   // print(self.tpulse.text!, self.pulsedata)
//                                        
//                   
//                    if(self.Last_Count == nil){
//                        self.Last_Count = "0.0"
//                    }
//                    
//                    if(counts.doubleValue >= (self.Last_Count as NSString).doubleValue)
//                    {
//                        if(counts.doubleValue > (self.Last_Count as NSString).doubleValue){
//                            self.Ispulsarcountsame = false
//                            self.stoptimerIspulsarcountsame.invalidate()
//                        }
//                        self.timer_quantityless_thanprevious.invalidate()
//                        self.Last_Count = counts as String?
//                        let v = self.quantity.count
//                        let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                        let y = Double(round(100*FuelQuan)/100)
////                        if(Vehicaldetails.sharedInstance.Language == "es-ES"){
////                            let y = Double(round(100*FuelQuan)/100)
////                            self.tquantity.text = "\(y) ".replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
////                            print(self.tquantity.text!)
////                        }
////                        else {
////                            let y = Double(round(100*FuelQuan)/100)
////                            self.tquantity.text = "\(y) "
////                        }
//                        
//                        self.Pulselbl.setText((counts as String) as String)
//                        self.quantity.append("\(y) ")
//                        
//                       // print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y)
//                        
//                        if(v >= 2){
//                            print(self.quantity[v-1],self.quantity[v-2])
//                            if(self.quantity[v-1] == self.quantity[v-2]){
//                                self.total_count += 1
//                                if(self.total_count == 3){
//                                    self.Ispulsarcountsame = true
//                                    self.stoptimerIspulsarcountsame.invalidate()
//                                    self.Samecount = self.Last_Count
//                                    self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: ("10" as NSString).doubleValue, target: self, selector: #selector(stopIspulsarcountsame), userInfo: nil, repeats: false)
//                                    
//                                    //self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)", errorfromserverorlink: "", errorfromapp: "")
//                                }
//                            }
//                            else {
//                                self.total_count = 0
//                                
//                                
//                                
////                                if(Int(Vehicaldetails.sharedInstance.MinLimit) == 0){}
////                                else{
////
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
//                    else{
//                        self.timer_quantityless_thanprevious.invalidate()
//                        self.timer_quantityless_thanprevious = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(stoprelay), userInfo: nil, repeats: false)
//                        //self.web.sentlog(func_name: "Get Pulsar", errorfromserverorlink: "\("lower qty. than the prior one.")", errorfromapp: "")
//                        print("lower qty. than the prior one.")
//                    }
//                }
//                else{
//                    if(self.Last_Count == nil){
//                        self.Last_Count = "0.0"
//                    }
//                    let v = self.quantity.count
//                    let FuelQuan = self.calculate_fuelquantity(quantitycount: Int(counts as String)!)
//                    let y = Double(round(100*FuelQuan)/100)
//                    
//                    self.quantity.append("\(y) ")
//                    
//                    //print(self.tquantity.text!, "\(y)" ,self.tquantity.text!,y)
//                    
//                    if(v >= 2){
//                        if(self.self.quantity[v-1] == self.quantity[v-2]){
//                            self.total_count += 1
//                            if(self.total_count == 3){
//                                self.Ispulsarcountsame = true
//                                self.Samecount = self.Last_Count
//                                self.stoptimerIspulsarcountsame.invalidate()
//                                
//                                //self.web.sentlog(func_name: "Get pulse count was the same while fueling function pump off time - \(Vehicaldetails.sharedInstance.pumpoff_time),Device type - (\(UIDevice().type),iOS \(UIDevice.current.systemVersion)",errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//                                
//                                self.stoptimerIspulsarcountsame = Timer.scheduledTimer(timeInterval: ( "10" as NSString).doubleValue, target: self, selector: #selector(stopIspulsarcountsame), userInfo: nil, repeats: false)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    @IBAction func stopButtonTapped() {
//        let MessageuDP = "LK_COMM=relay:12345=OFF"
//            self.sendUDP(MessageuDP)
//        //self.web.sentlog(func_name: " Send Relay OFF Command to link \(MessageuDP)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//            self.receiveUDP()
//    }
//    
//    @objc func connectUDPlink()
//    {
//           
//                            if(self.IFUDPConnected == false)
//                            {
//                              
//                                    
//                                    self.connectToUDP(self.hostUDP,self.portUDP)
//                               
//                            }
//                            else if(self.IFUDPConnected == true)
//                            {
//                               // isUDPConnectstoptimer.invalidate()
//                            }
//                            
//                            if(self.IFUDPConnectedGetinfo == false)
//                            {
//                                if("UDP" == "UDP")
//                                {
//                                   
//                                        
//                                        self.connectToUDP(self.hostUDP,self.portUDP)
//                                        self.countfailUDPConn = self.countfailUDPConn + 1
//                                        if (self.countfailUDPConn == 10)
//                                        {
//                                            print("No response from the link please try again later.")
//                                           // self.isUDPConnectstoptimer.invalidate()
////                                            self.showAlert(message: "No response from the link please try again later." )
////                                            self.delay(2)
////                                                {
//                                                //self.web.sentlog(func_name:"No response from the link Fueling_screen_timeout", errorfromserverorlink: "", errorfromapp: "")
////                                                let appDel = UIApplication.shared.delegate! as! AppDelegate
////                                                appDel.start()
////                                                self.connection?.cancel()
////                                                self.stoptimerIspulsarcountsame.invalidate()
////                                                self.timerview.invalidate()
////                                                self.timer.invalidate()
////                                                self.timerFDCheck.invalidate()
////                                                self.timer_quantityless_thanprevious.invalidate()
////                                                self.stoptimergotostart.invalidate()
////                                                self.stoptimer_gotostart.invalidate()
//////                                            }
//                                        }
//                                   
//                                    
//                                }
//                            }
//                            else if(self.IFUDPConnectedGetinfo == true)
//                            {
//                               // isUDPConnectstoptimer.invalidate()
//                            }
////                        } else if(Vehicaldetails.sharedInstance.SSId != self.cf.getSSID())
////            {
////                    web.wifi_settings_check(pagename: "UDP")
////                    self.web.sentlog(func_name:" Connect UDP Link ", errorfromserverorlink: "", errorfromapp: "")
////
////                print("Link not connected ")
////            }
//    }
//    //    UDP Connect
//    //    @available(iOS 12.0, *)
//    @available(iOS 12.0, *)
//    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
//        // Transmited message:
//        let messageToUDP = "LK_COMM=info"
//        
//        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
//        
//        self.connection?.stateUpdateHandler = { (newState) in
//            print("This is stateUpdateHandler:")
//            switch (newState) {
//            case .ready:
//                print("State: Ready\n")
//                
//                self.sendUDP(messageToUDP)
//             
//                self.receiveUDP()
//                self.IFUDPConnected = true
//            
//            case .setup:
//                print("State: Setup\n")
//                //self.web.sentlog(func_name: " State: Setup\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//            case .cancelled:
//                print("State: Cancelled\n")
//               // self.web.sentlog(func_name: " State: Cancelled\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//            case .preparing:
//                print("State: Preparing\n")
//                //self.web.sentlog(func_name: " State: Preparing\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//            default:
//                print("ERROR! State not defined!\n")
//                //self.web.sentlog(func_name: " ERROR! State not defined!\n", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"Connetced link \( self.cf.getSSID())")
//            }
//        }
//        
//        self.connection?.start(queue: .global())
//    }
//    
//    
//   
//    
//    
//    
//    @available(iOS 12.0, *)
//    @IBAction func sendinfocommand(_ sender: Any) {}
//    
//    
//    func renamelink(SSID:String)
//    {
//        let MessageuDP = "LK_COMM=name:\(SSID)"
//        sendUDP(MessageuDP)
//        self.receiveUDP()
//    }
//    
//    //Send the request data to UDP link
//    @available(iOS 12.0, *)
//    func sendUDP(_ content: String) {
//        let contentToSendUDP = content.data(using: String.Encoding.utf8)
//        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
//            if (NWError == nil) {
//                print("Data was sent to UDP")
//            } else {
//                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
//            }
//        })))
//    }
//    
//    ///Receive the reponse from UDP
//    func receiveUDP() {
//              
//        var backToString = ""
//        
//        self.connection?.receiveMessage { (data, context, isComplete, error) in
//            if (isComplete) {
//                
//                print("Receive is complete")
//                if (data != nil) {
//                    backToString = String(decoding: data!, as: UTF8.self)
//                    print("Received message: \(backToString)")
//                    //self.web.sentlog(func_name:" Received message: \(backToString) from UDP link", errorfromserverorlink: "", errorfromapp: "")
//                    if(backToString.contains("HO"))
//                    {
//                        
//                    }
//                    else if(backToString.contains("DN"))
//                    {
//                        //self.gotostartUDP_resDN()
//                    }
//                    if(backToString.contains("L10:"))
//                    {
//                        self.Last10transaction = backToString
//                        //self.web.sentlog(func_name: " Get response from info command to link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//                        self.IFUDPConnectedGetinfo = true
//                        //self.viewDidAppear(true)
//                    }
//                    if(backToString.contains("pulse:"))
//                    {
//                       // self.web.sentlog(func_name: " Get response from relay on getting pulses from link \(backToString)", errorfromserverorlink: "Selected Hose \(Vehicaldetails.sharedInstance.SSId)" , errorfromapp:"")
//                        let Split = backToString.components(separatedBy: ":")
//                        self.pulsedata = Split[1]
//                        print(self.pulsedata)
//                        self.pulsedata = (self.pulsedata.trimmingCharacters(in: .whitespacesAndNewlines) as NSString) as String
//                    }
//                }
//            }
//        }
//    }
////    func showAlert(message: String,title:String)
////    {
////
////        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
////        // Background color.
////        let backView = alertController.view.subviews.last?.subviews.last
////        backView?.layer.cornerRadius = 10.0
////        backView?.backgroundColor = UIColor.white
////
////        // Change Message With Color and Font
////        let message  = message
////        var messageMutableString = NSMutableAttributedString()
////        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25.0)!])
////        //messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location:0,length:message.count))
////        alertController.setValue(messageMutableString, forKey: "attributedMessage")
////
////        // Action.
////        let action = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertAction.Style.default, handler: nil)
////        alertController.addAction(action)
////        self.present(alertController, animated: true, completion: nil)
////    }
//    @objc func stoprelay() throws  {
//        if(Last_Count == nil){
//            Last_Count = "0.0"
//        }
//
//        Labelresponse.setText("RelayStop")
//       
//    }
//        
//        
//    
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
//}
//
